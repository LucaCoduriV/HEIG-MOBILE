import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/models/menu_jour.dart';
import 'package:heig_front/services/providers/menus_provider.dart';
import 'package:provider/provider.dart';

class MenuContainer extends StatelessWidget {
  final List<String> menuJour;
  const MenuContainer(this.menuJour, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String bullet = '\u2022 ';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: menuJour
          .map((e) => Text(
                bullet + e,
                style: const TextStyle(fontSize: 20),
              ))
          .toList(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I.get<MenusProvider>(),
      child: Builder(builder: (context) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: const CustomScaffold(),
        );
      }),
    );
  }
}

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    Key? key,
  }) : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  int _selectedTab = DateTime.now().weekday - 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuJour> menus = Provider.of<MenusProvider>(context).menus;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Lundi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Mardi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Mercredi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Jeudi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Vendredi',
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              GetIt.I.get<MenusProvider>().fetchMenus();
            },
            child: const Text('get Menu'),
          ),
          Expanded(
            child: menus.isNotEmpty
                ? _Daily(menus.elementAt(_selectedTab))
                : Container(),
          ),
        ],
      ),
    );
  }
}

class _Daily extends StatelessWidget {
  final MenuJour menuJour;

  const _Daily(this.menuJour, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            menuJour.day,
            style: const TextStyle(fontSize: 40),
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(width: 20),
        const Text('Tradition', style: TextStyle(fontSize: 30)),
        const SizedBox(height: 20),
        MenuContainer(menuJour.tradition),
        const SizedBox(height: 20),
        const SizedBox(width: 20),
        const Text('Vegetarien', style: TextStyle(fontSize: 30)),
        const SizedBox(height: 20),
        MenuContainer(menuJour.vegetarien)
      ],
    );
  }
}
