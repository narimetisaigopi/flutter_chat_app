class Utilities {
  static String displayTimeAgoFromTimestamp(String dateString,
      {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour' : 'An hour';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} min';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 min' : 'min';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} sec ';
    } else {
      return 'Just now';
    }
  }
}
