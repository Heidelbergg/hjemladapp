import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hjemladapp/authentication/createuser.dart';
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
    showTopSnackBar(
      context,
      persistent: true,
      onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateUserPage()));},
      CustomSnackBar.info(
        maxLines: 3,
        message:
        "Færdiggør din profil for at gøre brug af laderne i din boligforening. Tryk her.",
      ),
    );
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
            "Kunne ikke fastslå din lokation. Giv tilladelse for at vise ladere i nærheden.",
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
            onMapCreated: (controller){
              setState((){
                mapController = controller;
              });
            },
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 17),
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
                  //action code for button 1
                },
                child: Icon(Icons.add),
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
                child: Icon(Icons.location_searching),
              )
          ), // button second

        ],),
    );
  }
}