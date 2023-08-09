import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/controllers/home_controller.dart';

import 'pages/home_page.dart';

void main() async {
  setupDependency();
  runApp(const MyApp());
}

void setupDependency() {
  Get.put<HomeController>(HomeController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

