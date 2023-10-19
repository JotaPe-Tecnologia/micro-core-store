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

import '../entities/store.dart';

/// Class that will return a [StreamBuilder] to handle the screen builds depending
/// on the changes of [State] of the [Store].
class StoreBuilder<T extends Store<State>, State> extends StatelessWidget {
  /// Callback builder that will define what build on the screen depending on the
  /// [State].
  final Widget Function(BuildContext, State) builder;
  
  /// [Store] that will handle the screen's changes of [State].
  final T store;

  const StoreBuilder({
    Key? key,
    required this.builder,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: store.state,
      stream: store.stream,
      builder: (context, _) => builder(context, store.state),
    );
  }
}
