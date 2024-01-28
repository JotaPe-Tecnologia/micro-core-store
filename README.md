micro_core_store
-----
![License](https://img.shields.io/github/license/JotaPe-Tecnologia/micro-core-store?logo=apache&logoColor=%23D22128&label=License&labelColor=%23FFFFFF&color=%23D22128)
![Package Version](https://img.shields.io/pub/v/micro_core_store?logo=dart&logoColor=%230175C2&label=Version&labelColor=%23FFFFFF&color=%230175C2)
![Package Points](https://img.shields.io/pub/points/micro_core_store?logo=dart&logoColor=%230175C2&label=Points&labelColor=%23FFFFFF&color=%230175C2)
![Coverage](https://img.shields.io/codecov/c/github/JotaPe-Tecnologia/micro-core-store?logo=codecov&logoColor=%23F01F7A&label=Coverage&labelColor=%23FFFFFF&color=%23F01F7A)
----

This package is a simple approach to manage the state of the app with Streams and State Pattern. It's a lot similar to Cubit but the main difference is to add a listener to states on initState method, not in a widget.
----

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅    |

## Features

* Based on State Pattern
* Wraps a Stream to manage the state of a screen
* Listens the Stream events to take action when a especific state occours
* Builds widgets based on the state that the Store has

## Usage

### Creating the States

```dart
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
```

### Creating a Store

```dart
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
```

### Creating a Page using the StoreBuilder

```dart
/// Body when the State is a Success State
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
      itemBuilder: (context, index) => ListTile(title: Text(namesList[index])),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: namesList.length,
    );
  }
}

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
          InitialListNamesState() || LoadingListNamesState() => const Center(child: CircularProgressIndicator()),
          ErrorListNamesState() => Center(child: Text('Exception - ${state.exception.toString()}')),
          SuccessListNamesState() => ListNamesSuccessBody(namesList: state.names),
        },
      ),
    );
  }
}
```