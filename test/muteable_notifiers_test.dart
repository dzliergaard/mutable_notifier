import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:muteable_notifiers/muteable_notifiers.dart';

void main() {
  int Function(ChangeNotifier, Function, int, Function, int) doCalls = (
    ChangeNotifier notifier,
    Function firstCall,
    int expectCalls1,
    Function secondCall,
    int expectCalls2,
  ) {
    var gotCalls = 0;
    notifier.addListener(() => gotCalls++);

    firstCall.call();
    expect(gotCalls, expectCalls1);
    secondCall.call();
    expect(gotCalls, expectCalls2);

    return gotCalls;
  };

  var doChangeNotifierCalls = (
    MuteableChangeNotifierTestClass notifier,
    int expectCalls1,
    int expectCalls2,
  ) {
    var gotCalls = doCalls(
      notifier,
      () => notifier.stringField = "new field value",
      expectCalls1,
      () => notifier.intField = 1,
      expectCalls2,
    );

    expect(notifier.stringField, "new field value");
    expect(notifier.intField, 1);
    expect(gotCalls, expectCalls2);
  };

  var doValueNotifierCalls = (
    MuteableValueNotifierTestClass notifier,
    int expectCalls1,
    int expectCalls2,
  ) {
    int gotCalls = doCalls(
      notifier,
      () => notifier.value = "new field value",
      expectCalls1,
      () => notifier.value = "additional field value",
      expectCalls2,
    );

    expect(notifier.value, "additional field value");
    expect(gotCalls, expectCalls2);
  };

  group('MuteableChangeNotifier', () {
    test('Confirm [notifyListeners] returns true when unmuted, false when muted', () {
      var mcnt = new MuteableChangeNotifierTestClass();
      expect(mcnt.notifyListeners(), true);
      mcnt.mute();
      expect(mcnt.notifyListeners(), false);
    });

    test('Test normal behavior (no muting).', () {
      var mcnt = new MuteableChangeNotifierTestClass();
      doChangeNotifierCalls(mcnt, 1, 2);
    });

    test('Test muteNext().', () {
      var mcnt = new MuteableChangeNotifierTestClass();
      mcnt.muteNext();
      doChangeNotifierCalls(mcnt, 0, 1);
    });

    test('Test mute()/unmute().', () {
      var mcnt = new MuteableChangeNotifierTestClass();
      mcnt.mute();
      doChangeNotifierCalls(mcnt, 0, 0);
      mcnt.unmute();
      doChangeNotifierCalls(mcnt, 1, 2);
    });

    test('Test muteNext() after mute().', () {
      var mcnt = new MuteableChangeNotifierTestClass();
      mcnt.mute();
      mcnt.muteNext();
      doChangeNotifierCalls(mcnt, 0, 0);
      mcnt.unmute();
      doChangeNotifierCalls(mcnt, 1, 2);
    });

    test('Test mute() after muteNext().', () {
      var mcnt = new MuteableChangeNotifierTestClass();
      mcnt.muteNext();
      mcnt.mute();
      doChangeNotifierCalls(mcnt, 0, 0);
      mcnt.unmute();
      doChangeNotifierCalls(mcnt, 1, 2);
    });

    test('Test doMuted() while not muted.', () {
      var mcnt = new MuteableChangeNotifierTestClass();
      mcnt.doMuted(() => doChangeNotifierCalls(mcnt, 0, 0));
      doChangeNotifierCalls(mcnt, 1, 2);
    });

    test('Test doMuted() while muted (remain muted).', () {
      var mcnt = new MuteableChangeNotifierTestClass();
      mcnt.mute();
      mcnt.doMuted(() => doChangeNotifierCalls(mcnt, 0, 0));
      doChangeNotifierCalls(mcnt, 0, 0);
    });
  });

  group('MuteableValueNotifier', () {
    test('Confirm [notifyListeners] returns true when unmuted, false when muted', () {
      var mvnt = new MuteableValueNotifierTestClass("value");
      expect(mvnt.notifyListeners(), true);
      mvnt.mute();
      expect(mvnt.notifyListeners(), false);
    });

    test('Test normal behavior (no muting).', () {
      var mvnt = new MuteableValueNotifierTestClass("value");
      doValueNotifierCalls(mvnt, 1, 2);
    });

    test('Test muteNext().', () {
      var mvnt = new MuteableValueNotifierTestClass("value");
      mvnt.muteNext();
      doValueNotifierCalls(mvnt, 0, 1);
    });

    test('Test mute()/unmute().', () {
      var mvnt = new MuteableValueNotifierTestClass("value");
      mvnt.mute();
      doValueNotifierCalls(mvnt, 0, 0);
      mvnt.unmute();
      doValueNotifierCalls(mvnt, 1, 2);
    });

    test('Test muteNext() after mute().', () {
      var mvnt = new MuteableValueNotifierTestClass("value");
      mvnt.mute();
      mvnt.muteNext();
      doValueNotifierCalls(mvnt, 0, 0);
      mvnt.unmute();
      doValueNotifierCalls(mvnt, 1, 2);
    });

    test('Test mute() after muteNext().', () {
      var mvnt = new MuteableValueNotifierTestClass("value");
      mvnt.muteNext();
      mvnt.mute();
      doValueNotifierCalls(mvnt, 0, 0);
      mvnt.unmute();
      doValueNotifierCalls(mvnt, 1, 2);
    });

    test('Test doMuted() while not muted.', () {
      var mvnt = new MuteableValueNotifierTestClass("value");
      mvnt.doMuted(() => doValueNotifierCalls(mvnt, 0, 0));
      doValueNotifierCalls(mvnt, 1, 2);
    });

    test('Test doMuted() while muted (remain muted).', () {
      var mvnt = new MuteableValueNotifierTestClass("value");
      mvnt.mute();
      mvnt.doMuted(() => doValueNotifierCalls(mvnt, 0, 0));
      doValueNotifierCalls(mvnt, 0, 0);
    });
  });
}

class MuteableChangeNotifierTestClass extends MuteableChangeNotifier {
  String _stringField = "field";
  String get stringField => _stringField;
  set stringField(String stringField) {
    _stringField = stringField;
    notifyListeners();
  }

  int _intField = 0;
  int get intField => _intField;
  set intField(int intField) {
    _intField = intField;
    notifyListeners();
  }
}

class MuteableValueNotifierTestClass extends MuteableValueNotifier<String> {
  MuteableValueNotifierTestClass(String value) : super(value);
}
