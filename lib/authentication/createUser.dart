import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hjemladapp/authentication/userIdentification.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:validators/validators.dart';


class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final GlobalKey<FormState> _createUserKey = GlobalKey<FormState>();
  get getUserPhone => FirebaseAuth.instance.currentUser;
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  String? phone;

  // First name
  final fNameController = TextEditingController();
  bool validFName = false;
  // Last name
  final surnameController = TextEditingController();
  bool validSurname = false;
  // E-mail
  final emailController = TextEditingController();
  bool validEmail = false;
  // Address
  final addressController = TextEditingController();
  bool validAddress = false;
  // Country
  final countryController = TextEditingController();
  bool validCountry = false;
  // Birthday
  final birthdayController = TextEditingController();
  bool validBirthday = false;
  late String birthdate;

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

  String? validateName(String? name){
    if (name == null || name.isEmpty || name == ""){
      return "Ugyldigt input";
    }
  }

  String? validateBirthdate(String? name){
    if (birthdayController.text.isEmpty){
      return "Ugyldig fødselsdato";
    }
  }

  String? validatePhone(String? number){
    if (isNumeric(number!) == false || number == "" || number.isEmpty){
      return "Telefon skal kun indeholde numre!";
    } else if (number.length < 8 || number.length > 8){
      return "Nummeret skal være 8 cifre langt!";
    }
  }

  @override
  void initState() {
    birthdate = "Fødselsdag";
    getPhone();
    super.initState();
  }

  getPhone() async {
    setState(() {
      phone = FirebaseAuth.instance.currentUser?.phoneNumber!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, size: 20,),),
      ),
      body: Form(
        key: _createUserKey,
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text("Færdiggør din profil", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, top: 30),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green,),
                   Text(" ${phone!.substring(3,5)} ${phone!.substring(5,7)} ${phone!.substring(7,9)} ${phone!.substring(9,11)}"),
                  ],
                )
            ),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                child: TextFormField(
                  validator: validateName,
                  keyboardType: TextInputType.name,
                  controller: fNameController,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "Fornavn", hintStyle: TextStyle(color: Colors.grey[400]),),)),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  validator: validateName,
                  keyboardType: TextInputType.name,
                  controller: surnameController,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "Efternavn", hintStyle: TextStyle(color: Colors.grey[400]),),)),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "E-mail", hintStyle: TextStyle(color: Colors.grey[400]),),)),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  validator: validateName,
                  keyboardType: TextInputType.streetAddress,
                  controller: addressController,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "Adresse", hintStyle: TextStyle(color: Colors.grey[400]),),)),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: GestureDetector(
                  onTap: (){

                  },
                  child: TextFormField(
                    enabled: false,
                    controller: countryController,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "Danmark", hintStyle: TextStyle(color: Colors.black),),),
                )),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: InkWell(
                  onTap: () async {
                    birthdate = (await  showDatePicker(context: context, locale : const Locale("da","DA"), helpText: "Vælg fødselsdato", initialDate: DateTime.now(), firstDate: DateTime(1920), lastDate: DateTime.now().add(Duration(days: 30)))).toString();
                    var birth = DateTime.parse(birthdate);
                    birthdate = DateFormat('dd-MM-yyyy').format(birth);
                    setState((){birthdayController.text = birthdate;});
                    },
                  child: IgnorePointer(
                    child: TextFormField(
                      validator: validateBirthdate,
                      //enabled: false,
                      controller: birthdayController,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: birthdate, hintStyle: TextStyle(color: Colors.grey[400]),),),
                  ),
                )),
            //const Spacer(),
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () async {
                  if (_createUserKey.currentState!.validate()){
                    /// Save to db - navigate to home
                    try{
                      User? userCredential = FirebaseAuth.instance.currentUser;
                      usersRef.doc(userCredential?.uid).get().then((DocumentSnapshot documentSnapshot) async {
                        if (documentSnapshot.exists) {
                          showTopSnackBar(context, CustomSnackBar.error(message: "Bruger eksisterer allerede",),);
                          return;
                        } else if (!documentSnapshot.exists) {
                          // get token
                          String? token;
                          await FirebaseMessaging.instance.getToken().then((value) {token = value;});

                          // save user cred to db
                          await usersRef.doc(userCredential?.uid).set({
                            'email': emailController.text,
                            'fname': fNameController.text,
                            'lname': surnameController.text,
                            'address': addressController.text,
                            'country': 'Denmark',
                            'birthday': birthdayController.text,
                            'phone': phone,
                            'token': token,
                            'isActivated': false
                          });
                          if (mounted){
                            Navigator.push(context, PageTransition(duration: Duration(milliseconds: 200), type: PageTransitionType.rightToLeft, child: UserIdentificationPage(), curve: Curves.easeInOutSine));
                          }
                        }
                      });
                    } on FirebaseAuthException catch(e){
                      showTopSnackBar(context, CustomSnackBar.error(message: "Fejl ved oprettelse - ${e.code}",),);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  primary: Colors.blue,
                  minimumSize: const Size.fromHeight(65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text("Næste", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
