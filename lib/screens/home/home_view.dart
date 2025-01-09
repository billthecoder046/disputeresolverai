import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/users.dart';
import 'chat_Page/chat_screen.dart';
import 'home_logic.dart';

class Home_screenPage extends StatelessWidget {
  Home_screenPage({Key? key}) : super(key: key);

  final Details_screenLogic logic = Get.put(Details_screenLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: showUsers(context));
  }

  showUsers(context) {
    return FutureBuilder(
        future: logic.getUsersOnFirebase(),
        builder: (context, AsyncSnapshot<List<Person>> snapshot) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: logic.myAllStudets.length,
            itemBuilder: (context, i) {
              DateTime dateTime;
              if (logic.myAllStudets[i].createdAt.runtimeType == int) {
                dateTime = DateTime.fromMicrosecondsSinceEpoch(
                    logic.myAllStudets[i].createdAt);
              } else {
                dateTime =
                    DateTime.parse(logic.myAllStudets[i].createdAt.toString());
              }
              DateTime adjustedDateTime = dateTime.subtract(Duration(days: 20));
              String papuDateAndTime =
              DateFormat.yMd().add_jm().format(adjustedDateTime);
              bool isAlreadySignedIn = logic.myAllStudets[i].id ==
                  FirebaseAuth.instance.currentUser!.uid;
              return Card(
                elevation: 8.0,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ChatScreen());
                  },
                  child: isAlreadySignedIn == true
                      ? Container()
                      : ListTile(
                    onTap: () {
                      logic.createChatRoom(logic.myAllStudets[i].id);
                    },
                    title: Text(
                      logic.myAllStudets[i].name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,
                      ),
                    ),
                    leading: InkWell(
                      onTap: () {
                        // Show dialog with image
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                color: Colors.black,
                                child: InteractiveViewer(
                                  child: Image.network(
                                    logic.myAllStudets[i].imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Image.network(
                        logic.myAllStudets[i].imageUrl,
                        height: 120,
                        width: 120,
                      ),
                    ),
                    subtitle: Text('$papuDateAndTime'),
                  ),
                ),
              );
            },
          );
        });
  }
}
