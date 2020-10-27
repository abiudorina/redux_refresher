import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

@immutable
class AppState {
  final int counter;

  AppState({@required this.counter});

  factory AppState.initial() {
    return AppState(counter: 0);
  }
}

enum Actions { Increment }

AppState counterReducer(AppState previousState, action) {
  // mutate the state with the new value
  if (action == Actions.Increment) {
    return AppState(counter: previousState.counter + 1);
  }

  // if something goes wrong we return the previous state
  return previousState;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // create a store that stores everything
  final Store<AppState> store =
      Store(counterReducer, initialState: AppState.initial());

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: HomePage(store: store),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Store<AppState> store;

  const HomePage({Key key, @required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // wrap the scaffold in a store provider widget
    // the store provider is basically an inherited widget
    // that provides the state to app of the children
    return StoreProvider<AppState>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Redux refresher'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              StoreConnector<AppState, int>(
                converter: (store) => store.state.counter,
                builder: (BuildContext context, counter) => Text(
                  counter.toString() ?? '',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: StoreConnector<AppState, VoidCallback>(
          converter: (store) {
            return () => store.dispatch(Actions.Increment);
          },
          builder: (BuildContext context, callback) => FloatingActionButton(
            onPressed: callback,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing ,
        ),
      ),
    );
  }
}
