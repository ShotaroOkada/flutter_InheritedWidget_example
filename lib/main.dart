import 'package:flutter/material.dart';

void main() => runApp(TopPage());

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        child: Scaffold(
          appBar: AppBar(
            title: Text('InheritedWidget Demo'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              WidgetA(),
              WidgetB(),
              WidgetC(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyInheritedWidget extends InheritedWidget {
  _MyInheritedWidget({
    Key key,
    @required Widget child, // widgetのchild以下を要求
    @required this.data, // 今回要求するdataはHOmePageState
  }) : super(key: key, child: child);

  final HomePageState data;

  @override
  // inheritFromWidgetOfExactTypeを呼び出すWidgetにリビルドをすることを通知するかをboolで返す
  bool updateShouldNotify(_MyInheritedWidget oldWidget) {
    return true;
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  HomePageState createState() => HomePageState();

  static HomePageState of(BuildContext context, {bool rebuild = true}) {
    if (rebuild) {
      return (context.inheritFromWidgetOfExactType(_MyInheritedWidget) as _MyInheritedWidget).data;
    }
    return (context.ancestorWidgetOfExactType(_MyInheritedWidget) as _MyInheritedWidget).data;
    // 実は下を使うの方が良い
    // return (context.ancestorInheritedElementForWidgetOfExactType(_MyInheritedWidget).widget as _MyInheritedWidget).data;
  }
}

class HomePageState extends State<HomePage> {
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _MyInheritedWidgetのインスタンスを作り直してreturn
    return _MyInheritedWidget(
      data: this,
      child: widget.child, // HomepageWidgetが保持しているWidgetツリーを使いまわす
    );
  }
}

class WidgetA extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    final HomePageState state = HomePage.of(context);
    print(state.counter);
    return Center(
      child: Text(
        '${state.counter}',
         style: Theme.of(context).textTheme.display1,
      ),
    );
  }
}

class WidgetB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('I am a widget that will not be rebuilt.');
  }
}

class WidgetC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomePageState state = HomePage.of(context, rebuild: false);
    return RaisedButton(
      onPressed: () {
        state._incrementCounter();
      },
      child: Icon(Icons.add),
    );
  }
}