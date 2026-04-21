import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────────────────────────────────────
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  // ── Tema ──────────────────────────────────────────────────────────────────
  final Color primaryCyan = const Color(0xFF3CD7FF);
  final Color darkBlueBg = const Color(0xFF041329);
  final Color cardBg = const Color(0xFF0A1F35);
  final Color mintGreen = const Color(0xFF42E38D);
  final Color textGrey = const Color(0xFFC5C6CD);
  final Color inputBg = const Color(0xFF0D2137);
  final Color borderColor = const Color(0xFF1A3A55);

  // ── State ─────────────────────────────────────────────────────────────────
  int _currentStep = 0; // 0..3
  final int _totalSteps = 4;

  // Step 1 — Define the Core Pulse
  final TextEditingController _roomNameCtrl = TextEditingController();

  // Step 2 — Role Definition
  final TextEditingController _roleCtrl = TextEditingController();
  final List<String> _roles = ['Back-end Developer', 'UI/UX Designer'];

  // Step 3 — Tags (opsional, bisa dikembangkan)
  final TextEditingController _tagCtrl = TextEditingController();
  final List<String> _tags = [];

  // Step 4 — Finalize
  int _maxPeoplePerGroup = 5;
  int _numberOfGroups = 12;

  bool _isLoading = false;

  // ── Helpers ───────────────────────────────────────────────────────────────
  double get _progress => (_currentStep + 1) / _totalSteps;
  String get _progressLabel =>
      '${((_progress) * 100).round()}% Complete';

  String get _stepLabel =>
      'STEP ${(_currentStep + 1).toString().padLeft(2, '0')} / ${_totalSteps.toString().padLeft(2, '0')}';

  bool get _canNext {
    switch (_currentStep) {
      case 0:
        return _roomNameCtrl.text.trim().isNotEmpty;
      case 1:
        return _roles.length >= 2;
      case 2:
        return true; // tags optional
      default:
        return true;
    }
  }

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _createRoom();
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _createRoom() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _isLoading = false);

    if (!mounted) return;
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (_) => _SuccessDialog(
        mintGreen: mintGreen,
        darkBlueBg: darkBlueBg,
        onOk: () {
          Navigator.of(context).pop();
          _showRoomInfoSheet();
        },
      ),
    );
  }

  void _showRoomInfoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RoomInfoSheet(
        roomName: _roomNameCtrl.text.trim(),
        memberPerGroup: _maxPeoplePerGroup,
        groups: _numberOfGroups,
        roomCode: '555678',
        primaryCyan: primaryCyan,
        darkBlueBg: darkBlueBg,
        cardBg: cardBg,
        textGrey: textGrey,
        borderColor: borderColor,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueBg,
      appBar: AppBar(
        backgroundColor: primaryCyan,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Create Room',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // ── Progress Bar ───────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _stepLabel,
                        style: TextStyle(
                          color: primaryCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        _progressLabel,
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: borderColor,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(primaryCyan),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),

            // ── Step Content ───────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_currentStep),
                  child: _buildStepContent(),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation ──────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          top: 16,
        ),
        decoration: BoxDecoration(
          color: darkBlueBg,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _back,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: textGrey, size: 20),
                  Text('Back',
                      style: TextStyle(color: textGrey, fontSize: 12)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: (_canNext && !_isLoading) ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryCyan,
                  foregroundColor: Colors.black87,
                  disabledBackgroundColor:
                      primaryCyan.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  elevation: 0,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(darkBlueBg),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentStep == _totalSteps - 1
                                ? 'Create Room'
                                : 'Next',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            _currentStep == _totalSteps - 1
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step Content Router ──────────────────────────────────────────────────
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _StepDefineCorePulse(
          controller: _roomNameCtrl,
          primaryCyan: primaryCyan,
          textGrey: textGrey,
          inputBg: inputBg,
          borderColor: borderColor,
          onChanged: (_) => setState(() {}),
        );
      case 1:
        return _StepRoleDefinition(
          roleController: _roleCtrl,
          roles: _roles,
          primaryCyan: primaryCyan,
          darkBlueBg: darkBlueBg,
          textGrey: textGrey,
          inputBg: inputBg,
          borderColor: borderColor,
          onRolesChanged: () => setState(() {}),
        );
      case 2:
        return _StepTags(
          tagController: _tagCtrl,
          tags: _tags,
          primaryCyan: primaryCyan,
          textGrey: textGrey,
          inputBg: inputBg,
          borderColor: borderColor,
          onTagsChanged: () => setState(() {}),
        );
      case 3:
        return _StepFinalize(
          maxPeoplePerGroup: _maxPeoplePerGroup,
          numberOfGroups: _numberOfGroups,
          primaryCyan: primaryCyan,
          textGrey: textGrey,
          cardBg: cardBg,
          borderColor: borderColor,
          onPeopleChanged: (v) =>
              setState(() => _maxPeoplePerGroup = v),
          onGroupsChanged: (v) =>
              setState(() => _numberOfGroups = v),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _roomNameCtrl.dispose();
    _roleCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Define the Core Pulse
// ─────────────────────────────────────────────────────────────────────────────
class _StepDefineCorePulse extends StatelessWidget {
  final TextEditingController controller;
  final Color primaryCyan, textGrey, inputBg, borderColor;
  final ValueChanged<String> onChanged;

  const _StepDefineCorePulse({
    required this.controller,
    required this.primaryCyan,
    required this.textGrey,
    required this.inputBg,
    required this.borderColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Define the Core Pulse',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Establish the fundamental frequency of your project. This identity will resonate through every subsequent layer of development.',
            style: TextStyle(color: textGrey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          Text(
            'ROOM NAME',
            style: TextStyle(
              color: primaryCyan,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          _InputField(
            controller: controller,
            hint: 'Required',
            primaryCyan: primaryCyan,
            textGrey: textGrey,
            inputBg: inputBg,
            borderColor: borderColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 — Role Definition
// ─────────────────────────────────────────────────────────────────────────────
class _StepRoleDefinition extends StatelessWidget {
  final TextEditingController roleController;
  final List<String> roles;
  final Color primaryCyan, darkBlueBg, textGrey, inputBg, borderColor;
  final VoidCallback onRolesChanged;

  const _StepRoleDefinition({
    required this.roleController,
    required this.roles,
    required this.primaryCyan,
    required this.darkBlueBg,
    required this.textGrey,
    required this.inputBg,
    required this.borderColor,
    required this.onRolesChanged,
  });

  void _addRole() {
    final role = roleController.text.trim();
    if (role.isNotEmpty && !roles.contains(role)) {
      roles.add(role);
      roleController.clear();
      onRolesChanged();
    }
  }

  void _removeRole(int index) {
    roles.removeAt(index);
    onRolesChanged();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Role Definition',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Establish the architectural pillars of your project by defining core technical roles.',
            style: TextStyle(color: textGrey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          Text(
            'NEW ROLE TITLE',
            style: TextStyle(
              color: primaryCyan,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InputField(
                  controller: roleController,
                  hint: 'Required (Min. 2)',
                  primaryCyan: primaryCyan,
                  textGrey: textGrey,
                  inputBg: inputBg,
                  borderColor: borderColor,
                  onChanged: (_) {},
                  onSubmitted: (_) => _addRole(),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _addRole,
                child: Container(
                  width: 48,
                  height: 54,
                  decoration: BoxDecoration(
                    color: primaryCyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.black87, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(roles.length, (i) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: primaryCyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      roles[i],
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _removeRole(i),
                    child: Icon(Icons.delete_outline,
                        color: textGrey, size: 18),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 — Tags / Tech Stack (extra step)
// ─────────────────────────────────────────────────────────────────────────────
class _StepTags extends StatelessWidget {
  final TextEditingController tagController;
  final List<String> tags;
  final Color primaryCyan, textGrey, inputBg, borderColor;
  final VoidCallback onTagsChanged;

  const _StepTags({
    required this.tagController,
    required this.tags,
    required this.primaryCyan,
    required this.textGrey,
    required this.inputBg,
    required this.borderColor,
    required this.onTagsChanged,
  });

  void _addTag() {
    final tag = tagController.text.trim();
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
      tagController.clear();
      onTagsChanged();
    }
  }

  void _removeTag(int index) {
    tags.removeAt(index);
    onTagsChanged();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tech Signature',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tag your project with the technologies and skills required. This helps members find the right room. (Optional)',
            style: TextStyle(color: textGrey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          Text(
            'ADD TAG',
            style: TextStyle(
              color: primaryCyan,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InputField(
                  controller: tagController,
                  hint: 'e.g. Flutter, Laravel',
                  primaryCyan: primaryCyan,
                  textGrey: textGrey,
                  inputBg: inputBg,
                  borderColor: borderColor,
                  onChanged: (_) {},
                  onSubmitted: (_) => _addTag(),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _addTag,
                child: Container(
                  width: 48,
                  height: 54,
                  decoration: BoxDecoration(
                    color: primaryCyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.black87, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(tags.length, (i) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryCyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: primaryCyan.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tags[i],
                        style: TextStyle(
                            color: primaryCyan, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _removeTag(i),
                        child: Icon(Icons.close,
                            color: primaryCyan, size: 14),
                      ),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 4 — Finalize
// ─────────────────────────────────────────────────────────────────────────────
class _StepFinalize extends StatelessWidget {
  final int maxPeoplePerGroup;
  final int numberOfGroups;
  final Color primaryCyan, textGrey, cardBg, borderColor;
  final ValueChanged<int> onPeopleChanged;
  final ValueChanged<int> onGroupsChanged;

  const _StepFinalize({
    required this.maxPeoplePerGroup,
    required this.numberOfGroups,
    required this.primaryCyan,
    required this.textGrey,
    required this.cardBg,
    required this.borderColor,
    required this.onPeopleChanged,
    required this.onGroupsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Finalize',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Set group limits before launching the room.',
            style: TextStyle(color: textGrey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          Text(
            'CAPACITY PARAMETERS',
            style: TextStyle(
              color: primaryCyan,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          _CounterCard(
            label: 'Max People Per Group',
            sublabel: 'Min. 2',
            value: maxPeoplePerGroup,
            min: 2,
            primaryCyan: primaryCyan,
            textGrey: textGrey,
            cardBg: cardBg,
            borderColor: borderColor,
            onChanged: onPeopleChanged,
          ),
          const SizedBox(height: 12),
          _CounterCard(
            label: 'Number of Groups',
            sublabel: 'Min. 2',
            value: numberOfGroups,
            min: 2,
            primaryCyan: primaryCyan,
            textGrey: textGrey,
            cardBg: cardBg,
            borderColor: borderColor,
            onChanged: onGroupsChanged,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Counter Card Widget
// ─────────────────────────────────────────────────────────────────────────────
class _CounterCard extends StatelessWidget {
  final String label, sublabel;
  final int value, min;
  final Color primaryCyan, textGrey, cardBg, borderColor;
  final ValueChanged<int> onChanged;

  const _CounterCard({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.min,
    required this.primaryCyan,
    required this.textGrey,
    required this.cardBg,
    required this.borderColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(sublabel,
                    style: TextStyle(color: textGrey, fontSize: 11)),
              ],
            ),
          ),
          Row(
            children: [
              _CircleButton(
                icon: Icons.remove,
                color: primaryCyan,
                onTap: value > min ? () => onChanged(value - 1) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _CircleButton(
                icon: Icons.add,
                color: primaryCyan,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _CircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDisabled
                ? color.withValues(alpha: 0.2)
                : color.withValues(alpha: 0.6),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDisabled
              ? color.withValues(alpha: 0.3)
              : color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Input Field
// ─────────────────────────────────────────────────────────────────────────────
class _InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Color primaryCyan, textGrey, inputBg, borderColor;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.primaryCyan,
    required this.textGrey,
    required this.inputBg,
    required this.borderColor,
    required this.onChanged,
    this.onSubmitted,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focus.hasFocus ? widget.primaryCyan : widget.borderColor,
          width: _focus.hasFocus ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: widget.textGrey.withValues(alpha: 0.4),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success Dialog
// ─────────────────────────────────────────────────────────────────────────────
class _SuccessDialog extends StatefulWidget {
  final Color mintGreen, darkBlueBg;
  final VoidCallback onOk;

  const _SuccessDialog({
    required this.mintGreen,
    required this.darkBlueBg,
    required this.onOk,
  });

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _scale =
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _glow = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: widget.darkBlueBg,
          borderRadius: BorderRadius.circular(24),
        ),
        padding:
            const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, child) => Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: widget.mintGreen
                            .withValues(alpha: 0.5 * _glow.value),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(Icons.check_rounded,
                      color: widget.mintGreen, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Success',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: widget.onOk,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.mintGreen.withValues(alpha: 0.15),
                  foregroundColor: widget.mintGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: widget.mintGreen.withValues(alpha: 0.3)),
                  ),
                  elevation: 0,
                ),
                child: const Text('OK',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Room Info Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _RoomInfoSheet extends StatelessWidget {
  final String roomName, roomCode;
  final int memberPerGroup, groups;
  final Color primaryCyan, darkBlueBg, cardBg, textGrey, borderColor;

  const _RoomInfoSheet({
    required this.roomName,
    required this.roomCode,
    required this.memberPerGroup,
    required this.groups,
    required this.primaryCyan,
    required this.darkBlueBg,
    required this.cardBg,
    required this.textGrey,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkBlueBg,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Room Created',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review your room and share the code with your friends',
                      style: TextStyle(color: textGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close, color: textGrey),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Room detail card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ROOM NAME',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  roomName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        value: '$memberPerGroup',
                        label: 'Member/\nGroup',
                        darkBlueBg: darkBlueBg,
                        textGrey: textGrey,
                        borderColor: borderColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        value: '$groups',
                        label: 'Groups',
                        darkBlueBg: darkBlueBg,
                        textGrey: textGrey,
                        borderColor: borderColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Room Code card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Room Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.share_outlined, color: textGrey, size: 20),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: darkBlueBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        roomCode,
                        style: TextStyle(
                          color: primaryCyan,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: roomCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Code copied!'),
                              backgroundColor:
                                  primaryCyan.withValues(alpha: 0.9),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryCyan.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color:
                                    primaryCyan.withValues(alpha: 0.2)),
                          ),
                          child: Icon(Icons.copy_rounded,
                              color: primaryCyan, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  final Color darkBlueBg, textGrey, borderColor;

  const _StatBox({
    required this.value,
    required this.label,
    required this.darkBlueBg,
    required this.textGrey,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: darkBlueBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                color: textGrey, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }
}