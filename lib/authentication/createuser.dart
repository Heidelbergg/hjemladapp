import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final GlobalKey<FormState> _createUserKey = GlobalKey<FormState>();

  // First name
  final fNameController = TextEditingController();
  bool validFName = false;
  // Last name
  final surnameController = TextEditingController();
  bool validSurname = false;
  // E-mail
  final emaiLController = TextEditingController();
  bool validEmail = false;
  // Address
  final addressController = TextEditingController();
  bool validAddress = false;
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _createUserKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, top: 60),
              child: Text("Færdiggør din profil", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, top: 30),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green,),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("42 75 07 01"),
                    )
                  ],
                )
            ),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                child: TextFormField(
                  //validator: validatePhone,
                  keyboardType: TextInputType.name,
                  controller: fNameController,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "Fornavn", hintStyle: TextStyle(color: Colors.grey[400]),),)),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  //validator: validatePhone,
                  keyboardType: TextInputType.name,
                  controller: surnameController,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "Efternavn", hintStyle: TextStyle(color: Colors.grey[400]),),)),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  //validator: validatePhone,
                  keyboardType: TextInputType.emailAddress,
                  controller: emaiLController,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "E-mail", hintStyle: TextStyle(color: Colors.grey[400]),),)),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  //validator: validatePhone,
                  keyboardType: TextInputType.streetAddress,
                  controller: addressController,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(15)), hintText: "Adresse", hintStyle: TextStyle(color: Colors.grey[400]),),)),
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (_createUserKey.currentState!.validate()){
                    /// Save to db - navigate to car information

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
                child: Text("Næste", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
