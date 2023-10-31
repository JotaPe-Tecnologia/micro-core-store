// Copyright 2023 JotapeTecnologia

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:flutter/foundation.dart';

/// Class that will handle the screen's changes of [State].
base class Store<State> {
  /// Atribute that has the actual [State].
  late State _state;

  /// [StreamController] that has the stream of [State].
  late StreamController<State> _streamController;

  Store(State initialState) {
    _init(initialState);
  }

  /// Method to be overriden.
  ///
  /// It's execution completes after creating the instance of an Store.
  void onInit() {}

  /// Method to be overriden.
  ///
  /// It's execution completes when [dispose] method is called.
  void onDispose() {}

  /// Method that creates the [StreamController] in [broadcast] mode.
  ///
  /// Adds the [initialState] in the [stream] and runs the [onInit] method.
  void _init(State initialState) {
    _streamController = StreamController<State>.broadcast();
    _sink(initialState);
    onInit();
  }

  /// Method that adds a new [state] into the [stream].
  ///
  /// Update the local [state] and add the new [state] into the [stream].
  void _sink(State newState) {
    _state = newState;
    _streamController.sink.add(newState);
  }

  /// Method that disposes the [Store].
  ///
  /// Runs the [onDispose] method then remove the listener of the [stream] and
  /// closes the [_streamController].
  void dispose() {
    onDispose();
    removeListener();
    _streamController.close();
  }

  /// Getter of the [State].
  State get state => _state;

  /// Method that updates the [state].
  ///
  /// Only updates the [state] if it's a different [state] of the [state] that is
  /// already saved locally, or if the [force] flag is [true].
  void emit(State newState, {bool force = false}) {
    if (state != newState || force) _sink(newState);
  }

  /// Getter of the [Stream].
  Stream<State> get stream => _streamController.stream;

  /// Getter of the [StreamSubscription].
  StreamSubscription<State>? _listener;

  /// Getter to know if the [stream] has a [StreamSubscription].
  @visibleForTesting
  bool get hasListener => _listener != null;

  /// Getter to know if the [_streamController] is closed.
  @visibleForTesting
  bool get isClosed => _streamController.isClosed;

  /// Getter to know if the [_listener] of the [_streamController] is active and
  /// listening new events.
  @visibleForTesting
  bool get isListening => (hasListener && !_listener!.isPaused);

  /// Method that adds a [StreamSubscription] to the [stream].
  void addListener(void Function(State state) onState) {
    removeListener();
    _listener = _streamController.stream.listen(onState);
  }

  /// Method that pauses the [_listener] of the [stream] if isn't paused.
  void pauseListener() {
    if (isListening) _listener!.pause();
  }

  /// Method that resumes the [_listener] of the [stream] if is paused.
  void resumeListener() {
    if (hasListener && _listener!.isPaused) _listener!.resume();
  }

  /// Method that cancel the [_listener] of the [stream].
  void removeListener() {
    if (hasListener) {
      _listener!.cancel();
      _listener = null;
    }
  }
}
