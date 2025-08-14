//
// import 'package:cloud_firestore/cloud_firestore.dart';import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'chatting_page_logic.dart';
// class CreateGroupScreen extends StatefulWidget {
//   @override
//   _CreateGroupScreenState createState() => _CreateGroupScreenState();
// }
//
// class _CreateGroupScreenState extends State<CreateGroupScreen> {
//   Map<String, String> allUsers = {};
//   ChattingPageLogic logic =Get.put(ChattingPageLogic());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Create Group"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Group Name",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: logic.groupNameController,
//               decoration: InputDecoration(
//                 hintText: "Enter Group Name",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Select Members",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('Students').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//
//                   var users = snapshot.data!.docs;
//                   allUsers.clear();
//                   users.forEach((user) {
//                     allUsers[user.id] = user['name'];
//                   });
//
//                   return ListView.builder(
//                     itemCount: users.length,
//                     itemBuilder: (context, index) {
//                       var user = users[index];
//                       String userId = user.id;
//                       String userName = user['name'];
//
//                       if (userId == FirebaseAuth.instance.currentUser!.uid) {
//                         return SizedBox();
//                       }
//
//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                         child: CheckboxListTile(
//                           title: Text(userName),
//                           value: logic.selectedUserIds.contains(userId),
//                           onChanged: (isSelected) {
//                             setState(() {
//                               if (isSelected!) {
//                                 logic.selectedUserIds.add(userId);
//                               } else {
//                                 logic.selectedUserIds.remove(userId);
//                               }
//                             });
//                           },
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   logic.saveGroup();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   "Create Group",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
