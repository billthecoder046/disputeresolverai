import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/users.dart';
import 'home_logic.dart';

class HomeScreenPage extends StatelessWidget {
  HomeScreenPage({Key? key}) : super(key: key);

  final DetailsScreenLogic logic = Get.put(DetailsScreenLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          children: [
            const Text("Users"),
            IconButton(onPressed: (){
              logic.logout();
            }, icon: const Icon(Icons.logout))
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _showUsers(context),
    );
  }

  Widget _showUsers(BuildContext context) {
    return FutureBuilder<List<Person>>(
      future: logic.getUsersOnFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No users found"),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, i) {
            final user = snapshot.data![i];

            // Parse createdAt
            DateTime dateTime;
            if (user.createdAt.runtimeType == int) {
              dateTime =
                  DateTime.fromMicrosecondsSinceEpoch(logic.myUsers[i].createdAt);
            } else {
              dateTime = DateTime.parse(user.createdAt.toString());
            }

            DateTime adjustedDateTime =
            dateTime.subtract(const Duration(days: 20));
            String formattedDateTime =
            DateFormat.yMd().add_jm().format(adjustedDateTime);

            bool isCurrentUser = user.id == FirebaseAuth.instance.currentUser!.uid;

            // Build User Card
            return isCurrentUser
                ? Container() // Skip current user
                : Card(
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              child: ListTile(
                onTap: () {
                  logic.createChatRoom(user.id, user.name);
                },
                leading: GestureDetector(
                  onTap: () {
                    _showImageDialog(context, user.imageUrl);
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(user.imageUrl),
                    onBackgroundImageError: (_, __) {
                      // Error placeholder
                    },
                  ),
                ),
                title: Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                subtitle: Text(formattedDateTime),
              ),
            );
          },
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            color: Colors.black,
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
