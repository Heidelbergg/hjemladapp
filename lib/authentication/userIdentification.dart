import 'package:flutter/material.dart';
import 'package:hjemladapp/authentication/linkPayment.dart';
import 'package:page_transition/page_transition.dart';

class UserIdentificationPage extends StatefulWidget {
  const UserIdentificationPage({Key? key}) : super(key: key);

  @override
  State<UserIdentificationPage> createState() => _UserIdentificationPageState();
}

class _UserIdentificationPageState extends State<UserIdentificationPage> {
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
            child: Text("Identifikation", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, top: 20),
              child:  Text("Vedhæft nedenstående for at blive verificeret. Det er et krav at blive verificeret for at reservere vores elbiler."),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, right: 20, left: 20),
            child: ElevatedButton(onPressed: () {  }, child: Text("Vedhæft kørekort (Front)"),),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, right: 20, left: 20),
            child: ElevatedButton(onPressed: () {  }, child: Text("Vedhæft kørekort (Bag)"),),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, right: 20, left: 20),
            child: ElevatedButton(onPressed: () {  }, child: Text("Vedhæft selfie"),),
          ),
          Container(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(context, PageTransition(duration: Duration(milliseconds: 200), type: PageTransitionType.rightToLeft, child: LinkPaymentPage(), curve: Curves.easeInOutSine));
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
                primary: Colors.blue,
                minimumSize: const Size.fromHeight(65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text("Upload", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }
}
