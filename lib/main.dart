import 'package:flutter/material.dart';
import 'vista/aplicacao.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(await Permission.unknown.isDenied == false){
    await Permission.unknown.request();
  }
  
  runApp(
    Aplicacao('Oku Sanga - Entreprise')
  );
}