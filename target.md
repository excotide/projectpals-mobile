# ProjectPals Mobile — Target & Progress (penerapan flutter-docs)

> File ini melacak penerapan aturan & flow dari `flutter-docs/` (CLAUDE.md, FLOWS.md, API.md)
> ke project. Diperbarui setiap menyelesaikan satu slice. Dibuat: 2026-06-03.

## Protokol berhenti rapi (PENTING)
Kalau sesi harus berhenti (mis. token Claude hampir habis):
1. Pastikan project tetap **compile**: `flutter analyze` tanpa error.
2. Jangan tinggalkan file setengah jadi (dependency ditambah tapi `pub get` belum jalan, dst).
3. Update bagian **Session Log** + centang checkbox yang sudah selesai di bawah.
4. Tulis 1–2 kalimat "Next step" agar sesi berikutnya bisa langsung lanjut.

## Audit: kondisi project vs flutter-docs
| Aturan (CLAUDE/FLOWS) | Status saat ini | Tindakan |
|---|---|---|
| §Stack: token di `flutter_secure_storage` | ✅ DONE — `TokenStorage` pakai secure storage | — |
| §Rule 3: `401` → hapus token + ke `/login` | ✅ DONE — interceptor `ApiClient` + `navigatorKey` | — |
| README step 1: CLAUDE.md & FLOWS.md di root repo | ✅ DONE — sudah di root (+ catatan struktur aktual) | — |
| §Rule 1: unwrap `data` terpusat di ApiClient | ⚠️ tiap datasource manual `response.data['data']` | (Opsional) sentralisasi nanti |
| §Stack: state management BLoC, dio, clean arch | ✅ sudah sesuai (feature-first clean architecture) | — |
| FLOWS §5: join kirim `backup_roles[]` + `environments[]` | ✅ sudah (slice sebelumnya) | — |
| FLOWS §2: room detail router owner/member/ongoing | ⚠️ DIVERGEN (lihat catatan item 5) | Refactor (feature-size) |
| Matching: owner bisa Start Matching dari detail room → API | ✅ DONE — `POST /rooms/{code}/match` ter-wire | — |
| FLOWS §1.1: syarat matching divalidasi/ditampilkan di UI | ⚠️ pakai validasi backend (422 ditampilkan); pre-validasi klien belum | Enhancement opsional |

## Backlog (urut prioritas — vertical slice)
- [x] **1. Install context files di root** — copy `CLAUDE.md` + `FLOWS.md` ke root, sesuaikan bagian struktur folder ke layout aktual.
- [x] **2. Token storage → `flutter_secure_storage`** — tambah dependency, rewrite `TokenStorage`, `flutter analyze`.
- [x] **3. Penanganan `401` di `ApiClient`** — hapus token saat 401 + redirect `/login` via `navigatorKey`.
- [ ] 4. Sentralisasi unwrap `data` di `ApiClient` (sesuai §Rule 1) — opsional, hati-hati login/register tak terbungkus.
- [~] 5. Room detail router vs FLOWS §2 — **AUDIT SELESAI, implementasi belum**.
  - Temuan: `room_detail_screen.dart` menentukan owner client-side (`_isOwner` = `createdBy == user.id`, baris 39) lalu cabang di baris 176. **Tidak** memakai `access.is_owner/is_member` dari `GET /rooms/{code}`, dan **tidak** ada redirect "member + status `ongoing` → tampilan team/matched".
  - Sesuai FLOWS §2 seharusnya: `GET /rooms/{code}` → kalau `is_owner` = panel owner; else kalau `status==ongoing` = ke MatchedRoomOverview (team); else = DetailMemberRoom.
  - Ukuran: feature (butuh layar MatchedRoomOverview/team + pakai `getRoomDetail` yang sudah ada di datasource). Kerjakan sebagai slice tersendiri.
- [x] **Matching (owner)** — tombol **Start Matching** di detail room (owner & status `open`) → `POST /rooms/{code}/match`. Chain: `api_constants.matchRoom` → datasource `startMatching` → repo → `StartMatchingUseCase` → `RoomBloc` (`RoomMatchRequested`/`RoomMatched`) → UI. Sukses → status lokal jadi `ongoing` (tombol hilang) + snackbar; gagal (422) → pesan backend.
- [ ] 6. (Opsional) Pre-validasi syarat matching di klien (FLOWS §1.1) sebelum tekan tombol.
- [x] 7. Wire tombol "Start Matching" di `room_information_screen.dart` (`_SmartMatchingCard`) → `RoomMatchRequested`/`RoomMatched` + spinner + snackbar sukses/gagal. Kartu hanya tampil saat owner & status `open`.

## Session Log
### 2026-06-03 — sesi awal
- Membaca `flutter-docs/` (CLAUDE.md, FLOWS.md, README.md) + audit kode.
- Temuan utama: token di SharedPreferences, tidak ada handling 401, context files belum di root.
- **Selesai item 1**: copy `CLAUDE.md` + `FLOWS.md` ke root; tambah section "Penyesuaian struktur repo (AKTUAL)" di root `CLAUDE.md`.
- **Selesai item 2**: `flutter pub add flutter_secure_storage`; `TokenStorage` ditulis ulang ke secure storage (API statis sama, caller tak berubah). `shared_preferences` dibiarkan (mungkin dipakai non-token).
- **Selesai item 3**: `ApiClient` punya `navigatorKey` (dipasang di `MaterialApp`), interceptor `onError` hapus token + `pushNamedAndRemoveUntil('/login')` saat 401.
- `flutter analyze` → No issues found.
- **Audit item 5 selesai** (lihat backlog #5): room detail belum mengikuti FLOWS §2 (owner via backend `access`, member-ongoing → team view). Implementasi ditunda — feature-size.
- **Selesai: Start Matching (owner)** — detail room kini punya tombol Start Matching untuk owner saat status `open`, ter-hubung ke `POST /rooms/{code}/match`. Wiring penuh data→domain→bloc→UI; `flutter analyze` bersih. `RoomEntity.copyWith(status:)` ditambah untuk update status lokal pasca-match.
- **Next step**: item 5 (router FLOWS §2 + layar team/matched untuk melihat hasil match) atau item 6 (pre-validasi §1.1). Item 4 opsional & berisiko.

### 2026-06-04 — ganti layar detail room
- **Layar detail room diganti** ke `room_information_screen.dart` (desain Room Information + Smart Matching). Ketiga entry-point (`room_screen`, `create_screen`, `join_screen2`) kini push `RoomInformationScreen`; `room_detail_screen.dart` (lama) dihapus.
- **Selesai item 7**: tombol Start Matching di `_SmartMatchingCard` di-wire ke `RoomBloc` (`RoomMatchRequested`), spinner saat loading, snackbar sukses/gagal (422). Kartu hanya tampil untuk owner saat status `open`.
- Aksi **Hapus Room** (owner) & **Keluar Room** (member) di options sheet di-wire ke `RoomDeleteRequested`/`RoomLeaveRequested` + dialog konfirmasi; listener pop saat `RoomDeleted`/`RoomLeft`.
- Catatan: tombol hapus (trash) per-member masih placeholder — belum ada event/usecase kick di `RoomBloc`.
- **Fix `room_edit_screen.dart` (layar member non-owner)**: selektor "PILIH PERAN KAMU" & "LINGKUNGAN KERJA" kini disembunyikan default, muncul hanya saat tombol "Edit Role & Environment" ditekan (toggle), lalu tombol "Simpan Perubahan". Bug double-pop saat simpan diperbaiki (pop dini dihapus; sukses → editor menutup di tempat + snackbar, listener update `_room`).
- `flutter analyze` → No issues found.

### 2026-06-04 — rename member screen + routing per kepemilikan (FLOWS §2 parsial)
- **Rename** `room_edit_screen.dart` → `room_member_screen.dart` (`RoomEditScreen` → `RoomMemberScreen`) via `git mv`. Nama lama menyesatkan — isinya layar detail member non-owner, bukan layar edit.
- **Routing per kepemilikan** di `RoomInformationScreen`: di `build`, `if (!_isOwner) return RoomMemberScreen(room)`. `initState` hanya load member saat owner. Owner tetap di panel `RoomInformationScreen`; member non-owner → `RoomMemberScreen`. (Member + `ongoing` → team view masih item 5.)
- **Layar edit owner baru** `room_owner_edit_screen.dart` (`RoomOwnerEditScreen`): edit project_theme, status, roles (min 2), max_per_group, number_of_groups → `RoomUpdateRequested`. Mengganti `_EditRoomSheet` lama yang ikut terhapus. Tombol EDIT (kartu Room Information, kini di-gate `isOwner`) & opsi "Edit Room" mengarah ke sini, bukan lagi ke layar member.
- `flutter analyze` → No issues found.
