# muteable_notifier

Extensions of ChangeNotifier and ValueNotifier that allow for temporarily muting the notifier in question.

`MuteableChangeNotifier/MuteableValueNotifier.muteNext()` mutes only the next call to "notifyListeners," and then
returns to the previous mute state, whether it was muted or unmuted.

`MuteableChangeNotifier/MuteableValueNotifier.mute() and .unmute()` toggle the mute state on and off.

`MuteableChangeNotifier/MuteableValueNotifier.doMuted(Function fn)` mutes the notifier, executes the function, then
returns to the previous mute state.

## Getting Started

Create a subclass of MuteableChangeNotifier or MuteableValueNotifier.

```dart
class MyChangeNotifier extends MuteableChangeNotifier {
  String _field;
  String get field => _field;

  void setField(String newValue) {
    if (newValue == _field) {
      return;
    }
    _field = newValue;
    notifyListeners();
  }

  ...
}

class MyStringValueNotifier extends MuteableValueNotifier<String> {
  MyStringValueNotifier(String value) : super(value);
}
```

You can then use the various mute functions to "turn off" any calls to `notifyListeners` while the
classes are muted.

```dart

var muteableChangeNotifier = new MyChangeNotifier(field: "initial field value");
muteableChangeNotifier.addListener(someListenerFunction);

// someListenerFunction is called.
muteableChangeNotifier.field = "second value";

muteableChangeNotifier.muteNext();
// someListenerFunction is NOT called due to `muteNext`, but `field` is still updated.
muteableChangeNotifier.field = "third field value";

// someListenerFunction IS called, as only the previous call was muted by `muteNext`.
muteableChangeNotifier.field = "fourth field value";

muteableChangeNotifier.mute();
// someListenerFunction is NOT called until `muteableChangeNotifier.unmute()` is invoked.
muteableChangeNotifier.field = "fifth field value";
muteableChangeNotifier.field = "sixth field value";
muteableChangeNotifier.field = "seventh field value";

muteableChangeNotifier.unmute();
// someListenerFunction IS called, now that the notifier has been unmuted.
muteableChangeNotifier.field = "final field value";