import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Ny reservation',
        child: const Icon(Icons.add),
      ),
    );
  }
}