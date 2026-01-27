import 'package:appedu/service/authservice.dart';
import 'package:appedu/views/admin/admin%20hompage.dart';
import 'package:appedu/views/authent/login.dart';
import 'package:appedu/views/enseignant/EnseignantHome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/authcontroller.dart';


void main() {
  runApp(const MyApp());
  Get.put(AuthService());
  Get.put(AuthController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edu App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/admin', page: () => HomeAdmin()),
        GetPage(name: '/enseignant', page: () => const HomeEnseignant()),
      ],
    );
  }
}
