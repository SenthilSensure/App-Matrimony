// Stub implementation for non-web platforms
// This provides the necessary HTML interfaces when dart:html is not available

// Window stub
class Window {
  final Location location = Location();
  final History history = History();

  // Stub for onPopState - returns an empty stream
  Stream<dynamic> get onPopState => Stream<dynamic>.empty();
}

// Location stub
class Location {
  String? get pathname => '/';
  String? get search => '';
  String? get hash => '';
}

// History stub
class History {
  void pushState(dynamic data, String title, String url) {
    // No-op for non-web platforms
  }

  void replaceState(dynamic data, String title, String url) {
    // No-op for non-web platforms
  }
}

// Document stub
class Document {
  Stream<dynamic> get onContextMenu => Stream<dynamic>.empty();
  Stream<KeyboardEvent> get onKeyDown => Stream<KeyboardEvent>.empty();
}

// KeyboardEvent stub
class KeyboardEvent {
  final int keyCode;
  final bool ctrlKey;
  final bool shiftKey;

  KeyboardEvent({
    this.keyCode = 0,
    this.ctrlKey = false,
    this.shiftKey = false,
  });

  void preventDefault() {
    // No-op for non-web platforms
  }
}

// Event stub
class Event {
  void preventDefault() {
    // No-op for non-web platforms
  }
}

// Global stubs
final Window window = Window();
final Document document = Document();
