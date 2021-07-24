import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:crimeapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle),
      child: IconButton(
        tooltip: 'sign out',
        icon: Icon(Icons.logout,color: Colors.white,),
        onPressed: ()=> confirm(context: context),
      ),
    );
  }

  confirm({required BuildContext context}) {
    showGeneralDialog(
        barrierColor: Colors.grey.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Confirm Sign out'),
                content: Text('Are you sure you want to sign out'),
                actions: [
                  TextButton(
                      onPressed: () => goback(context: context),
                      child: Text('CANCEL')),
                  TextButton(
                    child: Text('Sign Out'),
                    onPressed: () {
                      service.signOutFromGoogle().then((value) => {
                        goback(context: context),
                         Phoenix.rebirth(context),
                       
                        showToast(message: 'You have been signed out'),
                       
                      });
                    },
                  )
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Center();
        });
  }
}
