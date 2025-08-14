import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../globalvariables.dart';

class MsgAnimIcon extends StatelessWidget {
  final String guestUserId;

  const MsgAnimIcon({Key? key, required this.guestUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ChatsRoomId')
          .doc(globalChatRoomId)
          .collection("usersStatus")
          .doc(guestUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(); // or loading indicator
        }

        if (snapshot.hasError) {
          print("GuestStatus error: ${snapshot.error}");
          return SizedBox(); // or error UI
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return SizedBox();
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final isTyping = userData['isTyping'] ?? false;

        if (isTyping) {
          // Random color every build (optional: can cache color to avoid flicker)


          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Card(
              elevation: 6,
              child: Container(

                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                  width: 40,
                  height: 40,
                  child: Lottie.network('https://lottie.host/1deedddc-0474-4eb6-b4aa-beaa685e4022/LrZ4QMhJwk.json')),
            ),
          );//AnimateIcon(
          //   key: UniqueKey(), // Forces rebuild to replay animation
          //   onTap: () {},
          //   iconType: IconType.continueAnimation,
          //   height: 70,
          //   width: 70,
          //   color: color,
          //   animateIcon:
          // );
        } else {
          return SizedBox();
        }
      },
    );
  }
}