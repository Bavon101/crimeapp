import 'dart:io';

import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, this.url, this.file}) : super(key: key);
  final String? url;
  final File? file;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: HEIGHT(context: context) * .25,
        width: WIDTH(context: context) * .35,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: url != null
              ? Image.network(
                  url!,
                  fit: BoxFit.cover,
                
                )
              : Image.file(
                  file!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
