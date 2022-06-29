import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LatLng _currentPosition;
  GoogleMapController? mapController;
  bool loading = true;

  void _showSnackBar(BuildContext context, String text, Color color, SnackBarAction action) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
      action: action,));
  }

  @override
  initState(){
    _currentPosition = LatLng(55.676098, 12.568337);
    _getCurrentPosition();
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
  }

  _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    loading = true;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Kunne ikke fastslå din lokation. Slå dine lokationsindstillinger til og prøv igen."),
      duration: Duration(seconds: 20),
      ));
      loading = false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(minutes: 5),
          content: const Text("Kunne ikke fastslå din lokation. Giv tilladelse for at vise ladere i nærheden."),
          action: SnackBarAction(onPressed: () async {permission = await Geolocator.requestPermission();}, label: "Tilladelse",),));

        loading = false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(minutes: 5),
        content: const Text("Kunne ikke fastslå din lokation. Giv tilladelse for at fortsætte."),
        action: SnackBarAction(onPressed: () async {await Geolocator.openAppSettings();}, label: "Åbn indstillinger",),));
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