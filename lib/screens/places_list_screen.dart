import 'package:SimpleFlutterGreatPlaceApp/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: Center(
                  child: const Text('Got no places yet, start adding some'),
                ),
                builder: (ctx, gpData, ch) => gpData.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: gpData.items.length,
                        itemBuilder: (context, idx) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(gpData.items[idx].image),
                          ),
                          title: Text(gpData.items[idx].title),
                          subtitle: Text(gpData.items[idx].location.address),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                              PlaceDetailScreen.routeName,
                              arguments: gpData.items[idx].id,
                            );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
