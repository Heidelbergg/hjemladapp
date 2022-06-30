import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hjemladapp/home/homepage.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetKey = GlobalKey<FormState>();

  String? validateEmail(String? email){
    if (email == null || email.isEmpty){
      return "Indsæt e-mail";
    } else if (!email.contains("@") || !email.contains(".")){
      return "Ugyldig e-mail";
    }
  }

  String? validatePassword(String? password){
    if (password == null || password.isEmpty){
      return "Indsæt password";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: SvgPicture.asset('assets/Mobile wireframe-cuate.svg',)),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, top: 5),
            child: Text("En konto med det angivne telefonnummer eksisterer allerede. Login med din email og adgangskode.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
          ),

          Form(
            key: _loginKey,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10, right: 20, top: 40),
                    child: TextFormField(validator: validateEmail, keyboardType: TextInputType.emailAddress, controller: emailController, decoration: const InputDecoration(icon: Icon(Icons.email), hintText: "E-mail", hintMaxLines: 10,),)),
                Container(
                    padding: EdgeInsets.only(left: 10, right: 20, top: 40, bottom: 20),
                    child: TextFormField(validator: validatePassword, obscureText: true, controller: passwordController, decoration: const InputDecoration(icon: Icon(Icons.password), hintText: "Adgangskode", hintMaxLines: 10,),)),
                Form(
                  key: _resetKey,
                  child: TextButton(onPressed: () async {
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(title: const Text("Nulstil adgangskode"), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), content: Text("Du er ved at nulstille din adgangskode. Hvis du har en konto, vil en e-mail vil blive sendt til dig med yderligere instrukser."), actions: [
                        TextFormField(validator: validateEmail, controller: emailController, decoration: const InputDecoration(icon: Icon(Icons.email), hintText: "E-mail", hintMaxLines: 10,),),
                        TextButton(onPressed: () async {
                          if(_resetKey.currentState!.validate()){
                            try{
                              await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(minutes: 5),
                                content: const Text("E-mail afsendt."),));
                            } on FirebaseAuthException catch (e){
                              if(e.code == "user-not-found"){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  duration: Duration(minutes: 5),
                                  content: const Text("Bruger eksisterer ikke."),));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  duration: Duration(minutes: 5),
                                  content: Text("Fejlkode ${e.code}"),));}
                            }

                          }}, child: const Text("Send e-mail"))],);});
                  }, child: Text("Glemt adgangskode")),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_loginKey.currentState!.validate()){
                        /// Navigate to OTP page where user input code from SMS. Send SMS to phone number

                        Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300), type: PageTransitionType.fade, child: MyHomePage()));
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
                    child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
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
