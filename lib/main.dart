import 'package:flutter/material.dart';
import 'package:formularios/src/blocs/provider.dart';
import 'package:formularios/src/pages/home_page.dart';
import 'package:formularios/src/pages/login_page.dart';
import 'package:formularios/src/pages/producto_page.dart';
import 'package:formularios/src/pages/registro_page.dart';
import 'package:formularios/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Preferencias de usuario
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    //Manipulacion de informacion usando Provider
    //Distribuido a traves de la aplicacion el loginBlock
    return Provider(
        child: MaterialApp(
            title: 'Material App',
            debugShowCheckedModeBanner: false,
            initialRoute: 'login',
            routes: {
              'login': (BuildContext context) => LoginPage(),
              'home': (BuildContext context) => HomePage(),
              'producto': (BuildContext context) => ProductoPage(),
              'registro': (BuildContext context) => RegistroPage(),
            },
            theme: ThemeData(primaryColor: Colors.deepPurple)));
  }
}
