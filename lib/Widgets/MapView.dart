import 'package:crimeapp/Contollers/AppState.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapsProvider extends StatefulWidget {
  const MapsProvider({Key? key}) : super(key: key);

  @override
  _MapsProviderState createState() => _MapsProviderState();
}

class _MapsProviderState extends State<MapsProvider>
    with AutomaticKeepAliveClientMixin<MapsProvider> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      Provider.of<AppState>(context, listen: false)
          .controller
          .future
          .then((value) {
        setState(() {
          value.setMapStyle("[]");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return appState.mapLocationLoaded()
          ? Container(
              child: GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: appState.currentLocationView(),
                trafficEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                markers: appState.crimeMarkers(),
                onMapCreated: (GoogleMapController controller) {
                  if (!appState.controller.isCompleted) {
                    appState.controller.complete(controller);
                  }
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
