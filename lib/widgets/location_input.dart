import 'package:SimpleFlutterGreatPlaceApp/helpers/location_helper.dart';
import 'package:SimpleFlutterGreatPlaceApp/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectedPlace;

  LocationInput(this.onSelectedPlace);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(locData) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: locData.latitude,
      longitude: locData.longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData);
      widget.onSelectedPlace(locData.latitude, locData.longitude);
    } catch (err) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation);
    widget.onSelectedPlace(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
                onPressed: _getCurrentUserLocation,
                icon: Icon(Icons.location_on),
                textColor: Theme.of(context).primaryColor,
                label: Text('Current Location')),
            FlatButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.map),
                textColor: Theme.of(context).primaryColor,
                label: Text('Select on Map')),
          ],
        )
      ],
    );
  }
}
