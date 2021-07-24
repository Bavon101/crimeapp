import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:flutter/material.dart';

class CrimeTotals extends StatefulWidget {
  const CrimeTotals({Key? key, this.total = 0}) : super(key: key);
  final int total;

  @override
  _CrimeTotalsState createState() => _CrimeTotalsState();
}

class _CrimeTotalsState extends State<CrimeTotals> {
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          open = !open;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: AnimatedContainer(
          width: open ? WIDTH(context: context)*.75:WIDTH(context: context)*.12,
          height: WIDTH(context: context) * .12,
          duration: Duration(milliseconds: 800),
          child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text( widget.total.toString() + (open ? ' Crime(s) have been reported':''),
            overflow: TextOverflow.ellipsis,
            style:TextStyle(
              color: Colors.white,
              fontSize: WIDTH(context: context)*.05

            ))
          )),
          decoration: BoxDecoration(
            shape: !open ? BoxShape.circle:BoxShape.rectangle,
            color: Colors.grey[800]
          ),
        ),
      ),
    );
  }
}
