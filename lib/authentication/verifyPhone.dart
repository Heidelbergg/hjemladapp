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
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  bool validPhone = false;

  String? validatePhone(String? number){
    if (number == "" || number!.isEmpty){
      return "Feltet må ikke stå tomt.";
    } else if (number.length < 8 || number.length > 8 || isNumeric(number) == false){
      return "Ugyldigt telefonnummer";
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
              child: Text("Bekræftelseskode", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, top: 5),
              child: Text("Indtast dit telefonnummer for at bekræfte din identitet.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
            ),
            Form(
              key: _phoneKey,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 20, top: 40),
                      child: TextFormField(validator: validatePhone, keyboardType: TextInputType.phone, controller: phoneController, decoration: const InputDecoration(icon: Icon(Icons.phone_android_sharp), hintText: "Telefon", hintMaxLines: 10,),)),
                 Container(
                        padding: EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_phoneKey.currentState!.validate()){
                              /// Navigate to OTP page where user input code from SMS. Send SMS to phone number
                              Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300), type: PageTransitionType.fade, child: OTPAuthPage(phone: phoneController.text.trim())));
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
                          child: Text("Fortsæt", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
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
