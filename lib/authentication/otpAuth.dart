import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
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
  late String pin = "null";
  late String verification = "null";

  @override
  initState(){
    _registerUser(widget.phone, context);
    super.initState();
  }

  String? validateOTP(String? number){
    if (number == "" || number!.isEmpty){
      return "Feltet må ikke være tomt.";
    } else if (number.length < 6 || number.length > 6 || isNumeric(number) == false){
      return "Ugyldig kode";
    } else {
      validOTP = true;
    }
  }

  _registerUser(String mobile, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
        phoneNumber: "+45$mobile",
        timeout: Duration(seconds: 80),
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (Platform.isAndroid){
            await auth.signInWithCredential(credential).then((value){
              showTopSnackBar(
                context,
                CustomSnackBar.success(
                  message:
                  "SMS bekræftelse godkendt automatisk",
                ),
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              "Fejl under bekræftelse - ${e.code}",
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState((){
            verification = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user == null){
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message:
                "SMS bekræftelse udløb. Gå tilbage og prøv igen",
              ),
            );
          }
        }
    );}

  _signUserIn(String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verification, smsCode: smsCode);
    try {
      await auth.signInWithCredential(credential);
      if(!mounted) return;
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MyHomePage()));
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message:
          "SMS bekræftelseskode godkendt",
        ),
      );
    } on FirebaseAuthException catch (e){
      if (e.code == "invalid-verification-code"){
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "Forkert bekræftelseskode",
          ),
        );
        return;
      } else if (e.code == "invalid-verification-id"){
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "En fejl opstod. Gå tilbage og prøv igen.",
          ),
        );
        return;
      } else {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "${e.code} - Prøv igen",
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, size: 20,),),
      ),
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
            child: Text("Engangsbekræftelse", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
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
                  padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_otpKey.currentState!.validate()){
                        /// Login user manually using OTP - if automatic code extraction is not possbile
                        _signUserIn(pin);
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
