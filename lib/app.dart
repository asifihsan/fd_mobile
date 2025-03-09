import 'package:fd_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Feedback Hub",
      home: SafeArea(
        child:Scaffold(
          appBar: AppBar(
            backgroundColor:  const Color.fromARGB(255, 170, 204, 255),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text("Feedback Hub")),
          ),
          body: HomeScreen(),
        ) 
      ),
    );
  }
}