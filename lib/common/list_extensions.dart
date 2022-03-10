extension ListNextItem on List {
  T elementAfterOrNull<T>(int index) =>
      index < this.length - 1 ? this[index + 1] : null;
}