import 'dart:async';

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
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: new GithubListPage(),
    );
  }
}

class GithubListPage extends StatefulWidget {
  @override
  createState() => new GithubListPageState();
}

class GithubListPageState extends State<GithubListPage> {
  @visibleForTesting
  static const MethodChannel channel =
      const MethodChannel('sample.ko2ic/toPlattformScreen');

  SearchBar searchBar;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<RepoEntity> _repos = [];
  bool _isLoading = false;

  final _saved = new Set<RepoEntity>();

  GithubListPageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        buildDefaultAppBar: buildAppBar);
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('GitHub検索'),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.adb), onPressed: _toPlattformScreen),
        searchBar.getSearchAction(context),
      ],
    );
  }

  void onSubmitted(String freeword) {
    setState(() => _fetch(freeword));
  }

  @override
  void initState() {
    super.initState();
    _fetch("ko2");
  }

  _fetch(String freeword) {
    _setLoading(true);
    new Github()
        .fetch(freeword)
        .then((s) => _setRepos(s.items))
        .whenComplete(() => _setLoading(false));
  }

  _setLoading(bool isLoading) {
    setState(() => this._isLoading = isLoading);
  }

  _setRepos(List<RepoEntity> repos) {
    setState(() => _repos = repos);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: _buildList(),
    );
  }

  _toPlattformScreen() {
    try {
      channel.invokeMethod('toPlattformScreen');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Widget _buildRow(RepoEntity entity) {
    final alreadySaved = _saved.contains(entity);
    return new Container(
      child: new Column(
        children: <Widget>[
          new ListTile(
              title: new Text(
                entity.fullName,
                style: _biggerFont,
              ),
              subtitle: new Text(entity.stars.toString()),
              trailing: new IconButton(
                  icon: new Icon(
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
          new Divider(),
        ],
      ),
    );
  }

  Widget _buildList() {
    return new LoadingWidget(
      isLoading: this._isLoading,
      onCompleted: () {
        return new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _repos.length,
            itemBuilder: (context, i) {
              return _buildRow(_repos[i]);
            });
      },
    );
  }
}
