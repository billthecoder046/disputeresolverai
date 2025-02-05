// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'chat_controller.dart';
//
// class ChatScreen extends StatelessWidget {
//   final ChatController chatController = Get.put(ChatController());
//
//   ChatScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: AssetImage('assets/chat_logo.png'), // Add a logo or profile picture
//               radius: 18,
//             ),
//             SizedBox(width: 10),
//             Text(
//               'Chat App',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.teal,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout, color: Colors.white),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.of(context).popUntil((route) => route.isFirst);
//             },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('messages')
//                     .orderBy('timestamp', descending: true)
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error loading messages'));
//                   }
//                   return  ListView.builder(
//                     reverse: true,
//                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       final doc = snapshot.data!.docs[index];
//                       final isMe = doc['senderId'] == FirebaseAuth.instance.currentUser?.uid;
//                       final timestamp = doc['timestamp'] as Timestamp?;
//                       final messageTime = timestamp != null
//                           ? timestamp.toDate()
//                           : DateTime.now(); // اگر timestamp null ہو تو current time دکھائیں
//
//                       return Align(
//                         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                         child: GestureDetector(
//                           onLongPress: isMe ? () => chatController.deleteMessage(doc.id) : null,
//                           child: Container(
//                             margin: EdgeInsets.symmetric(vertical: 8),
//                             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                             decoration: BoxDecoration(
//                               gradient: isMe
//                                   ? LinearGradient(colors: [Colors.teal, Colors.tealAccent])
//                                   : LinearGradient(colors: [Colors.grey[300]!, Colors.white]),
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(16),
//                                 topRight: Radius.circular(16),
//                                 bottomLeft: isMe ? Radius.circular(16) : Radius.zero,
//                                 bottomRight: isMe ? Radius.zero : Radius.circular(16),
//                               ),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black26,
//                                   blurRadius: 4,
//                                   offset: Offset(2, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   doc['text'],
//                                   style: TextStyle(
//                                     color: isMe ? Colors.white : Colors.black87,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   '${messageTime.day}/${messageTime.month}/${messageTime.year} ${messageTime.hour}:${messageTime.minute}',
//                                   style: TextStyle(
//                                     color: isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//
//                 },
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 6,
//                   offset: Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child:TextField(
//                     controller: chatController.messageController,
//                     focusNode: chatController.focusNode, // فوکس نوڈ شامل کریں
//                     style: const TextStyle(fontSize: 16),
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 16),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     onSubmitted: (_) => chatController.sendMessage(), // Trigger send on Enter
//                   ),
//
//                 ),
//                 SizedBox(width: 8),
//                 Obx(
//                       () => CircleAvatar(
//                     radius: 24,
//                     backgroundColor: Colors.teal,
//                     child: chatController.isSending.value
//                         ? const SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.0,
//                         valueColor:
//                         AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                         : IconButton(
//                       icon: Icon(Icons.send, color: Colors.white),
//                       onPressed: chatController.isSending.value
//                           ? null
//                           : chatController.sendMessage,
//                     ),
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
