import 'dart:async';

import 'package:formularios/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

//Mixin
class LoginBloc with Validators {
  //Creacion del Stream
  //Broadcast hace que varias instancias vean sus cambios
  //Equivalente a stream controller (pweo ws de rxdart)
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  //Ultimo valor ingresado
  String get email => _emailController.value;
  String get password => _passwordController.value;

  //Getter y setters para el Stream
  //Conveniencia para no apuntar cada vez a los metodos de Stream
  //Insertar valores
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  //Recuperar datos del Stream
  //Especificar que son de tipo String
  //Uso de transformer (desde Validators)
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  //Si hay data en ambos regresa true
  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  //Cerrar Stream
  dispose() {
    //Validacion por seguridad
    _emailController?.close();
    _passwordController?.close();
  }
}
