import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/models/menu_jour.dart';
import 'package:heig_front/services/providers/menus_provider.dart';
import 'package:provider/provider.dart';

const TAB_NUMBER = 5;

/// affiche un menu complet
class MenuContainer extends StatelessWidget {
  final List<String> menuJour;
  const MenuContainer(this.menuJour, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: menuJour
          .map((e) => SizedBox(
                height: 30,
                child: Text(
                  e,
                  style: const TextStyle(
                      fontSize: 20, fontStyle: FontStyle.italic),
                ),
              ))
          .toList(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: TAB_NUMBER, vsync: this);
    GetIt.I.get<MenusProvider>().fetchMenus();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I.get<MenusProvider>(),
      child: Builder(builder: (context) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TabBar(
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2, color: Colors.red),
                    insets: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  indicatorColor: Colors.red,
                  controller: _controller,
                  tabs: [
                    _buildTab('L', context),
                    _buildTab('M', context),
                    _buildTab('M', context),
                    _buildTab('J', context),
                    _buildTab('V', context),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final List<MenuJour> menus =
                        Provider.of<MenusProvider>(context).menus;
                    final List<_Daily> list = _buildDailyMenu(menus);
                    const noMenu = Center(
                        child: Text("Le menu n'est pas encore disponible."));
                    return TabBarView(
                      controller: _controller,
                      children: list.isNotEmpty
                          ? list
                          : [for (int i = 0; i < TAB_NUMBER; i++) noMenu],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<_Daily> _buildDailyMenu(List<MenuJour> menus) {
    return menus.map((menu) => _Daily(menu)).toList();
  }

  Widget _buildTab(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Text(text,
          style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).textTheme.bodyText1!.color!)),
    );
  }
}

class _Daily extends StatelessWidget {
  final MenuJour menuJour;

  const _Daily(this.menuJour, {Key? key}) : super(key: key);

  String getDayInFrench(String englishDay) {
    switch (englishDay) {
      case 'monday':
        return 'Lundi';
      case 'tuesday':
        return 'Mardi';
      case 'wednesday':
        return 'Mercredi';
      case 'thursday':
        return 'Jeudi';
      case 'friday':
        return 'Vendredi';
      default:
        return 'Jour Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text('Menu tradition', style: TextStyle(fontSize: 30)),
        _buildLine(),
        const SizedBox(height: 20),
        MenuContainer(menuJour.tradition),
        const SizedBox(height: 20),
        const SizedBox(width: 20),
        const Text('Menu végétarien', style: TextStyle(fontSize: 30)),
        _buildLine(),
        const SizedBox(height: 20),
        MenuContainer(menuJour.vegetarien)
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      color: Colors.red,
      height: 2,
      width: 80,
      margin: const EdgeInsets.only(top: 10),
    );
  }
}
