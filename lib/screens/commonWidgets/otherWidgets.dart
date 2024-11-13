

import 'package:disputeresolverai/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsSureAlertBox extends StatelessWidget {
  String title;
  String content;
    IsSureAlertBox({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 350,
      color: Colors.red.shade300,
      child: AlertDialog(
        title: Text(title,style: MyTextStyles.myTextStyleBlueMedium,),
        content: Text(content, style: MyTextStyles.myTextStyleBlueSmall,),
        actions: [
          TextButton(child: Text(MyStrings.yes.tr), onPressed: (){
            // Get.back(result: true);
            Navigator.of(context).pop(true);
          },),
          TextButton(child: Text(MyStrings.no.tr), onPressed: (){
            // Get.back(result: false);
            Navigator.of(context).pop(false);
          },)
        ],
      ),
    );
  }
}
