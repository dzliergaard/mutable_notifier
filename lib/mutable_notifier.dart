import 'package:flutter/foundation.dart';

/// A mixin for MutableChangeNotifier and MutableValueNotifier that provides mute functions.
mixin MutableNotifier on ChangeNotifier {
  bool _muted = false;
  bool _muteNext = false;

  void notifyListeners() {
    if (_muteNext) {
      _muteNext = false;
      return;
    }
    if (_muted) {
      return;
    }
    super.notifyListeners();
  }

  /// Perform the provided function while muted, then return to previous mute state.
  void doMuted(Function fn) {
    var previousMute = _muted;
    mute();
    fn.call();
    previousMute ? mute() : unmute();
  }

  /// Mute the change notifier until [unmute] is called.
  void mute() {
    _muted = true;
  }

  /// Unmute the change notifier. No effect if not already muted.
  void unmute() {
    _muted = false;
  }

  /// Mute only the next call to [notifyListeners], then return to previous mute state.
  /// This will be reset after the next call to [notifyListeners] regardless of any other
  /// mute state such as [mute] being called, or any calls to [doMuted].
  void muteNext() {
    _muteNext = true;
  }

  /// Cancel a call to [muteNext].
  void cancelMuteNext() {
    _muteNext = false;
  }
}

/// A ValueNotifier that can be muted for single/multiple calls.
///
/// For a mixin version, see [MutableValueNotifierMixin].
abstract class MutableValueNotifier<T> = ValueNotifier<T> with MutableNotifier;

/// A ChangeNotifier that can be muted for single/multiple calls.
///
/// For a mixin version, see [MutableChangeNotifierMixin].
abstract class MutableChangeNotifier = ChangeNotifier with MutableNotifier;
