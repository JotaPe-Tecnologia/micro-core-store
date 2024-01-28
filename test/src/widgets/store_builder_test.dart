// Copyright 2024 JotapeTecnologia

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
  group('Store Builder |', () {
    testWidgets(
      'Should update the Text to a new state',
      (tester) async {
        // Arrange
        final store = Store('Initial State');
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

        // Act
        expect(find.text('Initial State'), findsOneWidget);
        store.emit('New State');
        await tester.pump();

        // Assert
        expect(find.text('New State'), findsOneWidget);
      },
    );
  });
}
