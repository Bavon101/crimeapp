import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:crimeapp/Models/CrimesModel.dart';
import 'package:crimeapp/Widgets/ImageCard.dart';
import 'package:flutter/material.dart';

class CrimeCardView extends StatelessWidget {
  const CrimeCardView({Key? key, required this.crime}) : super(key: key);
  final CrimesModel crime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEIGHT(context: context) * .45,
      width: WIDTH(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  crime.place!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: crime.reports! <= 5
                        ? Colors.green
                        : crime.reports! > 5 && crime.reports! < 20
                            ? Colors.orange
                            : Colors.red,
                    child: Text(crime.reports.toString()),
                  ),
                ),
               
              ],
            ),
          ),

          if(crime.images!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Crime Images'),
              ),

           crime.images!.isNotEmpty
              ? Container(
                  height: HEIGHT(context: context) * .30,
                  width: WIDTH(context: context),
                  child: ListView.builder(
                    physics: physics,
                    scrollDirection: Axis.horizontal,
                      itemCount: crime.images!.length,
                      itemBuilder: (context, index) {
                        return ImageCard(
                          url: crime.images![index],
                        );
                      }),
                )
              : Text('No images were uploaded for this crime')
        ],
      ),
    );
  }
}
