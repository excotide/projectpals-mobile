class Result<T> {
  const Result._({this.data, this.error});

  final T? data;
  final String? error;

  bool get isSuccess => error == null;

  static Result<T> success<T>(T value) {
    return Result<T>._(data: value);
  }

  static Result<T> failure<T>(String message) {
    return Result<T>._(error: message);
  }
}
