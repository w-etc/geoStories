import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_stories/screens/map_page.dart';
import 'package:geo_stories/services/marker_service.dart';
import 'package:latlong/latlong.dart';

import '../main.dart';

class CreateMarkerPage extends StatefulWidget{
  LatLng point;
  CreateMarkerPage(LatLng point){
    this.point = point;
  }

  @override
  MarkerPage createState() => MarkerPage(point);

}
class MarkerPage extends State<CreateMarkerPage> {
  LatLng point;
   TextEditingController titleTextController;
   TextEditingController descriptTextController;

  MarkerPage(LatLng point){
    this.point = point;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar un nuevo marker "),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
      child : Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration (labelText: "Titulo del marker",
              hintText: "Un identificador del marker"
            ),
            controller: titleTextController,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Descripción del marker",
            hintText: "Algo que describa el market"),
            controller: descriptTextController,
          ),
          RaisedButton(
              child: Text("Guardar Marker"),
              onPressed: (){
                _crearMarker(context);
              }
          )
        ],
      ),
    )
    );
  }
  void _crearMarker(BuildContext context){
    MarkerService.createMarker(titleTextController.text,descriptTextController.text,point);
    titleTextController.clear();
    descriptTextController.clear();
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapPage()));

  }
  @override
  void initState() {
    titleTextController = TextEditingController();
    descriptTextController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    titleTextController.dispose();
    descriptTextController.dispose();
    super.dispose();
  }
}

