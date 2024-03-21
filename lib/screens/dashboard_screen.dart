import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024/settings/app_value_notifier.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'),),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150')
              ),
              accountName: Text('Rubensin Torres Frias'), 
              accountEmail: Text('ruben.torres@itcelaya.edu.mx'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Prática 1'),
              subtitle: Text('Aqui iria la descripcion si tuviera una'),
              trailing: Icon(Icons.chevron_right),
            ),
             ListTile(
              leading: Icon(Icons.shop),
              title: Text('Mi despensa'),
              subtitle: Text('Relacion de productos que no voy a usar'),
              trailing: Icon(Icons.chevron_right),
               onTap: () => Navigator.pushNamed(context, '/despensa'),
              // onTap: () => Navigator.pushNamed(context, '/productoFirebase'),
            ),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text('Mi despensa 2'),
              subtitle: Text('Relacion de productos que no voy a usar'),
              trailing: Icon(Icons.chevron_right),
              // onTap: () => Navigator.pushNamed(context, '/productoFirebase'),
              onTap: () => Navigator.pushNamed(context, '/productoFirebase'),
            ),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text('Movies App'),
              subtitle: Text('Consulte peiculas'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/movies'),
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Salir'),
              subtitle: Text('Hasta luego'),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            DayNightSwitcher(
              isDarkModeEnabled: AppValueNotifier.banTheme.value,
              onStateChanged: (isDarkModeEnabled) {
                AppValueNotifier.banTheme.value = isDarkModeEnabled;
              },
            ),
          ],
        ),
      ),
    );
  }
}