// Importa os pacotes necessários
import 'package:doneapp/Profile_Screen.dart';
import 'package:flutter/material.dart';

// Constrói o Appbar/Navbar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final int selectedIndex;

  const CustomAppBar(
      {super.key, required this.tabController, required this.selectedIndex});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 15);

  @override
  Widget build(BuildContext context) {
    var appBarColor = Theme.of(context).primaryColor;
    return AppBar(
      backgroundColor: appBarColor,
      leading: Padding(
        padding: EdgeInsets.only(left: 10),
        child: SizedBox(
          height: 200,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ProfileScreen(),
                transitionDuration: Duration(milliseconds: 50),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ), //
            child: Image.asset('assets/avatar.png'),
          ),
        ),
      ),
      toolbarHeight: 70,
      title: Center(
        child: Text(_getTitleBasedOnTab(selectedIndex),
            style: TextStyle(color: Colors.white, fontFamily: 'RedHatDisplay')),
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 40),
    );
  }

  String _getTitleBasedOnTab(int index) {
    switch (index) {
      case 0:
        return 'Agenda';
      case 1:
        return 'Tarefas';
      case 2:
        return 'Métricas';
      case 3:
        return 'Compartilhar';
      default:
        return '';
    }
  }
}
