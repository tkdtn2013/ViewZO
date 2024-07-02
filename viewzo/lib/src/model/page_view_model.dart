/// A model class representing an item in a PageView, which contains a URL and an optional page index.
class PageViewItem {
  /// The URL of the content to display.
  final String url;

  /// The index of the page to display if the content is a multi-page document.
  /// Defaults to 0 if not specified.
  final int pageIndex;

  /// Creates a [PageViewItem] with the given [url] and optional [pageIndex].
  PageViewItem({required this.url, this.pageIndex = 0});
}
