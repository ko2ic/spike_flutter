import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:meta/meta.dart' show visibleForTesting;
import 'package:spike_flutter/domains/Github.dart';
import 'package:spike_flutter/domains/entities/repo_entity.dart';
import 'package:spike_flutter/ui/loading_widget.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: GithubListPage(),
    );
  }
}

class GithubListPage extends StatefulWidget {
  @override
  createState() => GithubListPageState();
}

class GithubListPageState extends State<GithubListPage> {
  @visibleForTesting
  static const MethodChannel channel = MethodChannel('sample.ko2ic/toPlatformScreen');

  SearchBar searchBar;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<RepoEntity> _repos = [];
  bool _isLoading = false;

  final _saved = Set<RepoEntity>();

  GithubListPageState() {
    searchBar = SearchBar(inBar: false, setState: setState, onSubmitted: onSubmitted, buildDefaultAppBar: buildAppBar);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('GitHub検索'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.adb), onPressed: _toPlatformScreen),
        searchBar.getSearchAction(context),
      ],
    );
  }

  void onSubmitted(String freeWord) {
    setState(() => _fetch(freeWord));
  }

  @override
  void initState() {
    super.initState();
    _fetch("ko2");
  }

  _fetch(String freeWord) {
    _setLoading(true);
    Github().fetch(freeWord).then((s) => _setRepos(s.items)).whenComplete(() => _setLoading(false));
  }

  _setLoading(bool isLoading) {
    setState(() => this._isLoading = isLoading);
  }

  _setRepos(List<RepoEntity> repos) {
    setState(() => _repos = repos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: _buildList(),
    );
  }

  _toPlatformScreen() async {
    try {
      var result = await channel.invokeMethod('toPlatformScreen', <String, dynamic>{"label_from_dart": "Label From Dart"});
      print(result);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Widget _buildRow(RepoEntity entity) {
    final alreadySaved = _saved.contains(entity);
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
              title: Text(
                entity.fullName,
                style: _biggerFont,
              ),
              subtitle: Text(entity.stars.toString()),
              trailing: IconButton(
                  icon: Icon(
                    alreadySaved ? Icons.favorite : Icons.favorite_border,
                    color: alreadySaved ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      if (alreadySaved) {
                        _saved.remove(entity);
                      } else {
                        _saved.add(entity);
                      }
                    });
                  }),
              onTap: () {
                setState(() {});
              }),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildList() {
    return LoadingWidget(
      isLoading: this._isLoading,
      onCompleted: () {
        return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _repos.length,
            itemBuilder: (context, i) {
              return _buildRow(_repos[i]);
            });
      },
    );
  }
}
