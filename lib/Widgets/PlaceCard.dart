import 'package:crimeapp/Models/placeModel.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({Key? key,required this.onTap,required this.place}) : super(key: key);
  final Place place;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(Icons.location_on,),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              place.name != null ?place.name!:'',
              overflow: TextOverflow.fade,
              softWrap: true,
              maxLines: 1,
            ),
          ),
        ],
      ),
      subtitle: Container(
        width: MediaQuery.of(context).size.width * .90,
        child: Text(
           place.formattedAddress != null ?place.formattedAddress!:'',
          overflow: TextOverflow.fade,
          softWrap: true,
          maxLines: 1,
        ),
      ),
      onTap: () => onTap(place.locationId),
    );
  }
}
