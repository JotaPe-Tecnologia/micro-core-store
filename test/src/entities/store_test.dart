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

import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:micro_core_store/micro_core_store.dart';

void main() {
  group('Store instance |', () {
    test(
      'Should update the state when the instance is created',
      () {
        // Arrange
        // Act
        final store = Store<int>(0);

        // Assert
        expect(store.state, equals(0));
      },
    );

    test(
      'Should create a Broadcast Stream of the state when the instance of the Store is created',
      () {
        // Arrange
        final store = Store<int>(0);

        // Act
        expect(store.state, equals(0));
        final stream = store.stream;

        // Assert
        expect(stream, isA<Stream<int>>());
        expect(stream.isBroadcast, isTrue);
      },
    );
  });

  group('emit() |', () {
    test(
      'Should update the state when emit is called',
      () {
        // Arrange
        // Act
        final store = Store<int>(0)..emit(1);

        // Assert
        expect(store.state, equals(1));
      },
    );
  });

  group('dispose() |', () {
    test('Should close the Stream when dispose() is called', () {
      // Arrange
      final store = Store<int>(0);

      // Act
      expect(store.isClosed, isFalse);
      store.dispose();

      // Assert
      expect(store.isClosed, isTrue);
    });

    test(
      'Should cancel the listener when is disposed',
      () async {
        // Arrange
        final store = Store<int>(0);
        store.addListener((state) => log('Listening'));

        // Act
        expect(store.hasListener, isTrue);
        expect(store.state, equals(0));
        store.dispose();

        // Assert
        expect(store.hasListener, isFalse);
        expect(store.state, equals(0));
      },
    );
  });

  group('addListener() |', () {
    test(
      'Should call the callback when stateListener is listening the changes of state',
      () async {
        // Arrange
        var called = false;
        final store = Store<int>(0)
          ..addListener(
            (state) {
              if (state == 1) {
                called = true;
              }
            },
          );

        // Act
        expect(store.hasListener, isTrue);
        expect(store.state, equals(0));
        store.emit(1);

        // Assert
        await Future<void>.delayed(const Duration(milliseconds: 1));
        expect(called, isTrue);
        expect(store.state, equals(1));
      },
    );
  });

  group('pauseListener() |', () {
    test(
      'Should pause the stateListener from listening the changes of state',
      () async {
        // Arrange
        var called = false;
        final store = Store<int>(0)
          ..addListener(
            (state) {
              if (state == 1) {
                called = true;
              }
            },
          );
        expect(store.hasListener, isTrue);
        expect(store.isListening, isTrue);
        expect(store.state, equals(0));
        store.emit(1);
        await Future<void>.delayed(const Duration(milliseconds: 1));
        expect(called, isTrue);
        expect(store.state, equals(1));

        // Act
        called = false;
        store.pauseListener();

        // Assert
        expect(store.hasListener, isTrue);
        expect(store.isListening, isFalse);
        expect(store.state, equals(1));
        store.emit(2);
        await Future<void>.delayed(const Duration(milliseconds: 1));
        expect(called, isFalse);
        expect(store.state, equals(2));
      },
    );
  });

  group('resumeListener() |', () {
    test(
      'Should resume the stateListener to listen the changes of state',
      () async {
        // Arrange
        var called = false;
        final store = Store<int>(0)
          ..addListener(
            (state) {
              if (state == 1) {
                called = true;
              }
            },
          );
        expect(store.hasListener, isTrue);
        expect(store.isListening, isTrue);
        expect(store.state, equals(0));
        store.emit(1);
        await Future<void>.delayed(const Duration(milliseconds: 1));
        expect(called, isTrue);
        expect(store.state, equals(1));
        called = false;
        store.pauseListener();
        expect(store.hasListener, isTrue);
        expect(store.isListening, isFalse);
        expect(store.state, equals(1));
        store.emit(2);
        await Future<void>.delayed(const Duration(milliseconds: 1));
        expect(called, isFalse);
        expect(store.state, equals(2));

        // Act
        store.resumeListener();

        // Assert
        expect(store.hasListener, isTrue);
        expect(store.isListening, isTrue);
        expect(store.state, equals(2));
        store.emit(1);
        await Future<void>.delayed(const Duration(milliseconds: 1));
        expect(called, isTrue);
        expect(store.state, equals(1));
      },
    );
  });
}
