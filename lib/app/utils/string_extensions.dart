extension StringCapitalization on String {
  /// Capitalizes the first letter of the string and makes the rest lowercase
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Capitalizes the first letter of each word (Title Case)
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => 
        word.isNotEmpty 
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word
    ).join(' ');
  }

  /// Capitalizes the first letter while keeping the rest unchanged
  String capitalizeFirstOnly() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}