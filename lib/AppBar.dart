// Importa os pacotes necessários
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
    return AppBar(
      backgroundColor: const Color.fromRGBO(1, 169, 94, 1),
      leading: Padding(
        padding: EdgeInsets.only(left: 10),
        child: SizedBox(
          height: 200,
          child: Ink.image(
            fit: BoxFit.contain, //
            image: AssetImage('assets/avatar.png'),
          ),
        ),
      ),
      toolbarHeight: 70,
      title: Center(
        child: Text(_getTitleBasedOnTab(selectedIndex)),
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
