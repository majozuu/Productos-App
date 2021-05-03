//Inherited Widget personalizado
import 'package:flutter/material.dart';
import 'package:formularios/src/blocs/login_bloc.dart';
import 'package:formularios/src/blocs/productos_bloc.dart';
export 'package:formularios/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget {
  //Instancia de la clase
  static Provider _instancia;
  //Factory
  //Determina si hace falta regresar una nueva instancia o la misma
  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      //Uso de constructor privado
      _instancia = new Provider._internal(
        key: key,
        child: child,
      );
    }
    //Si ya existe la instancia
    return _instancia;
  }
  //Unica instancia de loginBloc
  //Cada vez que se hace un hot reload se vuelve a generar, entonces se perdería la informacion, si no fuera un Singleton
  final loginBloc = LoginBloc();
  //Unica instancia de providerBloc
  final _productosBloc = ProductosBloc();
  //Constructor privado
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);
  // Al actualizarse notifica a sus hijos? (casi siempre es true)
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
  //Context es el arbol de widgets
  //Busca alli la instancia de este bloc
  //Login Bloc
  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        .loginBloc;
  }

  //Productos Bloc
  static ProductosBloc productosBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        ._productosBloc;
  }
}
