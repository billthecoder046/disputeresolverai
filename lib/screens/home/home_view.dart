import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../model/users.dart';
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
          return Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: logic.myAllStudets.length,
              itemBuilder: (context, i) {
                return Row(
                  children: [
                    Card(
                      elevation: 20,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Container(
                              height:90,
                              width: 90,
                              child: ClipOval(
                                child: Image.network(
                                    logic.myAllStudets[i].imageUrl),
                              ),
                            ),
                            Text(
                              "My Name:\n${logic.myAllStudets[i].name}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
