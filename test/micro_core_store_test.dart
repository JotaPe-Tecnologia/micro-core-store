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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:micro_core_store/micro_core_store.dart';

void main() {
  group('exports |', () {
    test(
      'Should be able to access Store when importing lib/src/micro_core_store.dart',
      () {
        // Arrange
        // Act
        final store = Store<int>(0);

        // Assert
        expect(store.state, equals(0));
      },
    );

    testWidgets(
      'Should be able to access StoreBuilder when importing lib/src/micro_core_store.dart',
      (tester) async {
        // Arrange
        final store = Store<String>('Initial State');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StoreBuilder<Store<String>, String>(
                store: store,
                builder: (context, state) {
                  return Text(state);
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Initial State'), findsOneWidget);
      },
    );
  });
}
