import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hjemladapp/authentication/createUser.dart';
import 'package:hjemladapp/home/reservations.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LatLng _currentPosition;
  GoogleMapController? mapController;
  bool loading = true;
  late AnimationController localAnimationController;
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  @override
  initState(){
    _currentPosition = LatLng(55.676098, 12.568337);
    _getCurrentPosition();
    Future.delayed(const Duration(seconds: 10), (){
      _checkIfUserExists();
    });

    super.initState();
  }

  @override
  dispose(){
    super.dispose();
  }

  _checkIfUserExists() async {
    /// if user does not exist, display snackbar with onTap to createUser
    User? userCredential = FirebaseAuth.instance.currentUser;
    usersRef.doc(userCredential?.uid).get().then((DocumentSnapshot documentSnapshot) async {
      if (!documentSnapshot.exists) {
        showTopSnackBar(
          context,
          persistent: true,
          onTap: (){
            localAnimationController.reverse();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateUserPage())).then((value) {setState((){_checkIfUserExists();});});
          },
          onAnimationControllerInit: (controller) =>
          localAnimationController = controller,
          CustomSnackBar.info(
            maxLines: 3,
            message:
            "Færdiggør din profil for at få adgang til elbilerne i dit nærområde. Tryk her.",
          ),
        );
      }
    });
  }

  _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    loading = true;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if(!mounted) return;
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          "Kunne ikke fastslå din lokation. Slå dine lokationsindstillinger til og prøv igen.",
        ),
      );
      loading = false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if(!mounted) return;
        showTopSnackBar(
          context,
          persistent: true,
          onTap: () async {permission = await Geolocator.requestPermission();},
          CustomSnackBar.error(
            message:
            "Kunne ikke fastslå din lokation. Giv tilladelse for at vise elbiler i nærheden.",
          ),
        );
        loading = false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if(!mounted) return;
      showTopSnackBar(
        context,
        persistent: true,
        onTap: () async {
          await Geolocator.openAppSettings().then((value) => setState((){
            _getCurrentPosition();
          }));
          },
        CustomSnackBar.error(
          message:
          "Kunne ikke fastslå din lokation. Giv tilladelse for at fortsætte.",
        ),
      );
      loading = false;
    }

    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 17))
      );
    });

    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          loading ? Center(
              child: SpinKitRing(
                color: Colors.blue,
                size: 50,
              )) :
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller){
              setState((){
                mapController = controller;
              });
            },
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 17),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 15, right: 15),
            child: SpeedDial(
              spacing: 10,
              animatedIcon: AnimatedIcons.menu_close,
              direction: SpeedDialDirection.down,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              icon: Icons.menu,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.person_outline, color: Colors.blue,),
                  label: 'Profil'
                ),
                SpeedDialChild(
                    child: Icon(Icons.favorite_outline, color: Colors.blue,),
                    label: "Favoritter"
                ),
                SpeedDialChild(
                  child: Icon(Icons.calendar_month_outlined, color: Colors.blue,),
                  label: "Reservationer",
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReservationPage()));
                  }
                ),
              ],
            ),
          ),
        ]

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                heroTag: "addBtn",
                onPressed: (){
                  //Find nearest EV
                },
                child: Icon(Icons.electric_car_outlined),
              )
          ),
          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                heroTag: "posBtn",
                onPressed: (){
                  mapController?.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(target: _currentPosition, zoom: 18))
                  );
                },
                child: Icon(Icons.my_location),
              )
          ), // button second
        ],),
    );
  }
}