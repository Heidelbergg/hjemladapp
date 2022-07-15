import 'package:flutter/material.dart';

class LinkPaymentPage extends StatefulWidget {
  const LinkPaymentPage({Key? key}) : super(key: key);

  @override
  State<LinkPaymentPage> createState() => _LinkPaymentPageState();
}

class _LinkPaymentPageState extends State<LinkPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, top: 50),
            child: Text("Betalingsoplysninger", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, top: 20),
            child:  Text("Betalingsoplysninger gemmes til betaling af leje."),
          ),
        ],
      ),
    );
  }
}
