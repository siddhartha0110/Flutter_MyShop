class ExceptionHandler implements Exception {
  final String message;
  ExceptionHandler(this.message);

  @override
  String toString() {
    //return super.toString();
    return message;
  }
}
