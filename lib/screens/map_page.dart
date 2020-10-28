import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_stories/components/btn_createmarker.dart';
import 'package:geo_stories/components/marker_icon.dart';
import 'package:geo_stories/models/marker_dto.dart';
import 'package:geo_stories/services/marker_service.dart';
import 'package:latlong/latlong.dart';
import 'package:geo_stories/screens/create_marker_page.dart';

class MapPage extends StatefulWidget {

  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MarkerPage form;
  bool _modoCreacion = false;
  Future<List<MarkerDTO>> futureMarkers;

  @override
  void initState() {
    super.initState();
    futureMarkers = MarkerService.getMarkers();
  }

  void _activarModoCreacion() {
    setState(() {
      _modoCreacion = !_modoCreacion;
    });
  }

  void _onTap(LatLng point) {
    if (!_modoCreacion) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return CreateMarkerPage(point);
    }));
  }

  List<Marker> _markers(List<MarkerDTO> markerDtos) {
    return markerDtos.map((markerDto) {
      return Marker(
        anchorPos: AnchorPos.align(AnchorAlign.top),
        width: 60.0,
        height: 60.0,
        point: LatLng(markerDto.latitude, markerDto.longitude),
        builder: (ctx) => MarkerIcon(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _modoCreacion
          ? AppBar(title: Text('Toca el mapa para crear un marcador'),)
          : null,
      floatingActionButton: ButtonCreateMarker(onPressed: _activarModoCreacion,),
      body: FutureBuilder<List<MarkerDTO>>(
        future: futureMarkers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FlutterMap(
              options: MapOptions(
                onTap: _onTap,
                minZoom: 2,
                maxZoom: 18,
                center: LatLng(-34.6001014, -58.3824443),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                    minZoom: 2,
                    maxZoom: 18,
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: _markers(snapshot.data),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}