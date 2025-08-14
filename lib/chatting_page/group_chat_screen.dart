//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class GroupChatScreen extends StatefulWidget {
//   final String groupId;
//
//   GroupChatScreen({required this.groupId});
//
//   @override
//   _GroupChatScreenState createState() => _GroupChatScreenState();
// }
//
// class _GroupChatScreenState extends State<GroupChatScreen> {
//   TextEditingController messageController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Group Chat"),
//         backgroundColor: Colors.deepPurple,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('Groups')
//                   .doc(widget.groupId)
//                   .collection('Messages')
//                    .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//                 var messages = snapshot.data!.docs;
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var message = messages[index];
//                     bool isMe = message['senderId'] == FirebaseAuth.instance.currentUser!.uid;
//
//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.deepPurple : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           message['text'],
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: "Enter message",
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.send, color: Colors.white),
//                     onPressed: () async {
//                       if (messageController.text.trim().isNotEmpty) {
//                         await FirebaseFirestore.instance
//                             .collection('Groups')
//                             .doc(widget.groupId)
//                             .collection('Messages')
//                             .add({
//                           'text': messageController.text.trim(),
//                           'senderId': FirebaseAuth.instance.currentUser!.uid,
//                           'timestamp': FieldValue.serverTimestamp(),
//                         });
//                         messageController.clear();
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
