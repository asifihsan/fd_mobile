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
            backgroundColor: Colors.amber,
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