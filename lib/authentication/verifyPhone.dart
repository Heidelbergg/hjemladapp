import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hjemladapp/authentication/otpAuth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:validators/validators.dart';


class SignupPageOTP extends StatefulWidget {
  const SignupPageOTP({Key? key}) : super(key: key);

  @override
  State<SignupPageOTP> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPageOTP> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final GlobalKey<FormState> _otpKey = GlobalKey<FormState>();
  bool validPhone = false;

  String? validatePhone(String? number){
    if (isNumeric(number!) == false || number == "" || number.isEmpty){
      return "Telefon skal kun indeholde numre!";
    } else if (number.length < 8 || number.length > 8){
      return "Nummeret skal være 8 cifre langt!";
    } else {
      validPhone = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
                child: SvgPicture.asset('assets/Computer login-cuate.svg',)),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text("Autentificering", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
            ),
            Form(
              key: _otpKey,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 20, top: 40),
                      child: TextFormField(validator: validatePhone, controller: phoneController, decoration: const InputDecoration(icon: Icon(Icons.phone_android_sharp), hintText: "Telefon", hintMaxLines: 10,),)),
                 Container(
                        padding: EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_otpKey.currentState!.validate()){
                              /// Navigate to OTP page where user input code from SMS
                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: OTPAuthPage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16),
                            primary: Colors.blue,
                            minimumSize: const Size.fromHeight(70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text("Fortsæt", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
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
