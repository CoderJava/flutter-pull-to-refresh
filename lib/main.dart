import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final listData = <User>[];

  @override
  void initState() {
    listData..add(User('User 1', 10))..add(User('User 2', 15))..add(User('User 3', 19));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Pull To Refresh'),
      ),
      body: Platform.isIOS ? _buildWidgetListDataIOS() : _buildWidgetListDataAndroid(),
    );
  }

  Widget _buildWidgetListDataIOS() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: refreshData,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var user = listData[index];
                return _buildWidgetItemListData(user, context);
              },
              childCount: listData.length
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetListDataAndroid() {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          var user = listData[index];
          return _buildWidgetItemListData(user, context);
        },
        itemCount: listData.length,
      ),
    );
  }

  Widget _buildWidgetItemListData(User user, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.nama),
            Text(
              '${user.nomor}',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }

  Future refreshData() async {
    listData.clear();
    await Future.delayed(Duration(seconds: 2));
    for (var index = 0; index < 10; index++) {
      var nama = 'User ${index + 1}';
      var nomor = Random().nextInt(100);
      listData.add(User(nama, nomor));
    }
    setState(() {});
  }
}

class User {
  final String nama;
  final int nomor;

  User(this.nama, this.nomor);
}
