import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:validators/validators.dart';

class OTPAuthPage extends StatefulWidget {
  const OTPAuthPage({Key? key}) : super(key: key);

  @override
  State<OTPAuthPage> createState() => _OTPAuthPageState();
}

class _OTPAuthPageState extends State<OTPAuthPage> {
  final otpController = TextEditingController();
  final GlobalKey<FormState> _otpKey = GlobalKey<FormState>();
  bool validOTP = false;

  String? validateOTP(String? number){
    if (number == "" || number!.isEmpty){
      return "Feltet må ikke stå tomt.";
    } else if (number.length < 6 || number.length > 6 || isNumeric(number) == false){
      return "Ugyldig kode";
    } else {
      validOTP = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: SvgPicture.asset('assets/Enter OTP-cuate.svg',)),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20),
            child: Text("Indtast engangskode", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, top: 5),
            child: Text("En SMS med en 6 cifret kode er blevet sendt. Angiv det herunder.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
          ),
          Form(
            key: _otpKey,
            child: Column(
              children: [
                /*Container(
                    padding: EdgeInsets.only(left: 10, right: 20, top: 40),
                    child: TextFormField(validator: validateOTP, controller: otpController, keyboardType: TextInputType.number, decoration: const InputDecoration(icon: Icon(Icons.password_sharp), hintText: "Kode", hintMaxLines: 10,),)),*/
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: OTPTextField(
                    length: 5,
                    width: MediaQuery.of(context).size.width / 1.1,
                    fieldWidth: 50,
                    style: TextStyle(
                        fontSize: 17
                    ),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_otpKey.currentState!.validate()){
                        /// If users phone exist = navigate to login, else navigate to signup
                        //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: OTPAuthPage()));
                        //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: OTPAuthPage()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      primary: Colors.blue,
                      minimumSize: const Size.fromHeight(65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Verificer kode", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
