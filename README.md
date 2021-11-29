# Relocated

* Discontinued - renamed to "[muteable_notifiers](https://pub.dev/packages/muteable_notifiers)".

# mutable_notifier

Extensions of ChangeNotifier and ValueNotifier that allow for temporarily muting the notifier in question.

`MutableChangeNotifier/MutableValueNotifier.muteNext()` mutes only the next call to "notifyListeners," and then
returns to the previous mute state, whether it was muted or unmuted.

`MutableChangeNotifier/MutableValueNotifier.mute() and .unmute()` toggle the mute state on and off.

`MutableChangeNotifier/MutableValueNotifier.doMuted(Function fn)` mutes the notifier, executes the function, then
returns to the previous mute state.

## Getting Started

Create a subclass of MutableChangeNotifier or MutableValueNotifier.

```dart

class MyChangeNotifier extends MutableChangeNotifier {
  String _field;
  String get field => _field;
  set Field(String newValue) {
    if (newValue == _field) {
      return;
    }
    _field = newValue;
    notifyListeners();
  }

  ...
}

class MyStringValueNotifier extends MutableValueNotifier<String> {
  MyStringValueNotifier(String value) : super(value);
}
```

You can then use the various mute functions to "turn off" any calls to `notifyListeners` while the
classes are muted.

```dart

var mutableChangeNotifier = new MyChangeNotifier(field: "initial field value");
mutableChangeNotifier.addListener(someListenerFunction);

// someListenerFunction is called.
mutableChangeNotifier.field = "second value";

mutableChangeNotifier.muteNext();
// someListenerFunction is NOT called due to `muteNext`, but `field` is still updated.
mutableChangeNotifier.field = "third field value";

// someListenerFunction IS called, as only the previous call was muted by `muteNext`.
mutableChangeNotifier.field = "fourth field value";

mutableChangeNotifier.mute();
// someListenerFunction is NOT called until `mutableChangeNotifier.unmute()` is invoked.
mutableChangeNotifier.field = "fifth field value";
mutableChangeNotifier.field = "sixth field value";
mutableChangeNotifier.field = "seventh field value";

mutableChangeNotifier.unmute();
// someListenerFunction IS called, now that the notifier has been unmuted.
mutableChangeNotifier.field = "final field value";