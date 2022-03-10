extension ListNextItem on List {
  T elementAfterOrNull<T>(int index) =>
      index < this.length - 1 ? this[index + 1] : null;
}

extension DoubleExtension on double {
  String removeDecimalZeroFormat() {
    return this.toStringAsFixed(this.truncateToDouble() == this ? 0 : 1);
  }
}