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

import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:micro_core_store/micro_core_store.dart';

// States

// Creating all available States.

// If you want to use the new switch you have to create de "base" State with the
// sealed ***.

sealed class ListNamesStates {}

final class InitialListNamesState extends ListNamesStates {}

final class LoadingListNamesState extends ListNamesStates {}

final class ErrorListNamesState extends ListNamesStates {
  final Exception exception;

  ErrorListNamesState(this.exception);
}

final class SuccessListNamesState extends ListNamesStates {
  final List<String> names;

  SuccessListNamesState(this.names);
}

// Store

// Creating the Store of these States.

final class ListNamesStore extends Store<ListNamesStates> {
  ListNamesStore(this._listNames) : super(InitialListNamesState());

  final Future<List<String>> Function() _listNames;

  @override
  void onInit() {
    super.onInit();
    listNames();
  }

  void listNames() async {
    emit(LoadingListNamesState());

    try {
      final names = await _listNames();
      emit(SuccessListNamesState(names));
    } on Exception catch (exception) {
      emit(ErrorListNamesState(exception));
    }
  }
}

// StoreBuilder

// Creating the page that will use the StoreBuilder

class ListNamesPage extends StatefulWidget {
  const ListNamesPage({super.key, required this.listNamesStore});

  final ListNamesStore listNamesStore;

  @override
  State<ListNamesPage> createState() => _ListNamesPageState();
}

class _ListNamesPageState extends State<ListNamesPage> {
  @override
  void initState() {
    super.initState();

    // Creating the listener to listen the changes of States.
    //
    // Right here you can define some rules to show a Dialog, Snackbar or
    // Navigate to another screen if some specific State shows up.
    widget.listNamesStore.addListener(
      (state) => switch (state) {
        InitialListNamesState() => onInitialState(),
        LoadingListNamesState() => onLoadingState(),
        ErrorListNamesState() => onErrorState(state.exception),
        SuccessListNamesState() => onSuccessState(state.names),
      },
    );
  }

  @override
  void dispose() {
    widget.listNamesStore.dispose();
    super.dispose();
  }

  void onInitialState() {
    log('onInitialState');
  }

  void onLoadingState() {
    log('onLoadingState');
  }

  void onErrorState(Exception exception) {
    log('onErrorState - ${exception.toString()}');
  }

  void onSuccessState(List<String> names) {
    log('onSuccessState - $names');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Names List'),
        centerTitle: true,
      ),
      body: StoreBuilder<ListNamesStore, ListNamesStates>(
        store: widget.listNamesStore,
        builder: (context, state) => switch (state) {
          InitialListNamesState() || LoadingListNamesState() => const Center(
              child: CircularProgressIndicator(),
            ),
          ErrorListNamesState() => Center(
              child: Text('Exception - ${state.exception.toString()}'),
            ),
          SuccessListNamesState() => ListNamesSuccessBody(
              namesList: state.names,
            ),
        },
      ),
    );
  }
}

class ListNamesSuccessBody extends StatelessWidget {
  const ListNamesSuccessBody({super.key, required this.namesList});

  final List<String> namesList;

  @override
  Widget build(BuildContext context) {
    if (namesList.isEmpty) {
      return const Center(
        child: Text('No name was found!'),
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        title: Text(namesList[index]),
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: namesList.length,
    );
  }
}
