import 'package:muteable_notifiers/muteable_notifiers.dart';

/// Extend MuteableChangeNotifier, then use `addListener` as per [ChangeNotifier].
class MyChangeNotifier extends MuteableChangeNotifier {
  String _field;
  String get field => _field;

  MyChangeNotifier(String initialValue) : _field = initialValue;

  void setField(String newValue) {
    if (newValue == _field) {
      return;
    }
    _field = newValue;
    notifyListeners();
  }
}

/// Extend MuteableValueNotifier, then use `addListener` as per [ValueNotifier].
class MyStringValueNotifier extends MuteableValueNotifier<String> {
  MyStringValueNotifier(String value) : super(value);
}
