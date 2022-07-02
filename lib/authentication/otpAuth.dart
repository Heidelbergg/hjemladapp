import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:validators/validators.dart';

import '../home/homepage.dart';

class OTPAuthPage extends StatefulWidget {
  final String phone;
  const OTPAuthPage({Key? key, required this.phone}) : super(key: key);

  @override
  State<OTPAuthPage> createState() => _OTPAuthPageState();
}

class _OTPAuthPageState extends State<OTPAuthPage> {
  final otpController = TextEditingController();
  final GlobalKey<FormState> _otpKey = GlobalKey<FormState>();
  bool validOTP = false;
  late String pin = "777777";
  late String verification = "";

  @override
  initState(){
    registerUser(widget.phone, context);
    super.initState();
  }

  String? validateOTP(String? number){
    if (number == "" || number!.isEmpty){
      return "Feltet må ikke stå tomt.";
    } else if (number.length < 6 || number.length > 6 || isNumeric(number) == false){
      return "Ugyldig kode";
    } else {
      validOTP = true;
    }
  }

  registerUser(String mobile, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
        phoneNumber: "+45$mobile",
        timeout: Duration(seconds: 80),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Kode bekræftet - logget ind."),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.green,
            ));
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
          });
        },
        verificationFailed:  (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(e.code.toString()),
            duration: Duration(seconds: 10),
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState((){
            verification = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user == null){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: const Text("SMS bekræftelse udløb. Gå tilbage og prøv igen."),
              duration: Duration(seconds: 5),
            ));
          }
        }
    );}

  signUserIn(String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verification, smsCode: smsCode);
    try {
      await auth.signInWithCredential(credential);
      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: MyHomePage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: const Text("SMS bekræftelse godkendt"),
        duration: Duration(seconds: 5),
      ));
    } on FirebaseAuthException catch (e){
      if (e.code == "invalid-verification-code"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Forkert bekræftelseskode"),
          duration: Duration(seconds: 5),
        ));
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("${e.code} - prøv igen"),
          duration: Duration(seconds: 10),
        ));
        return;
      }
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
            child: Text("Bekræftelseskode", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
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
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: OtpTextField(
                    numberOfFields: 6,
                    borderColor: Color(0xFF512DA8),
                    showFieldAsBox: true,
                    fieldWidth: 50,
                    borderRadius: BorderRadius.circular(15),
                    onCodeChanged: (String code) {
                    },
                    onSubmit: (String code){
                      setState((){
                        pin = code;
                      });
                    }, // end onSubmit
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_otpKey.currentState!.validate()){
                        /// If users phone exist = login user, else navigate to signup screen
                        //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: CreateUserPage()));
                        if (pin == ""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("Feltet må ikke stå tomt."),
                            duration: Duration(seconds: 20),
                          ));
                        } else {
                          signUserIn(pin);
                        }
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
