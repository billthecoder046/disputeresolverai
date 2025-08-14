import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disputeresolverai/chatting_page/user_status/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../globalvariables.dart'; // Make sure this path is correct

class AdminStatus extends StatelessWidget {
  final String adminUserId;

  const AdminStatus({Key? key, required this.adminUserId}) : super(key: key);

  // Helper function to format lastSeen date
  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final lastSeenDate = DateTime(lastSeen.year, lastSeen.month, lastSeen.day);

    if (lastSeenDate.isAtSameMomentAs(today)) {
      // If today, show "Today at HH:MM AM/PM"
      return "Today at ${DateFormat('hh:mm a').format(lastSeen)}";
    } else if (lastSeenDate.isAtSameMomentAs(yesterday)) {
      // If yesterday, show "Yesterday at HH:MM AM/PM"
      return "Yesterday at ${DateFormat('hh:mm a').format(lastSeen)}";
    } else {
      // Otherwise, show full date and time
      return DateFormat('dd/MM/yyyy hh:mm a').format(lastSeen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ChatsRoomId').doc(globalChatRoomId).collection("usersStatus")
          .doc(adminUserId)
          .snapshots(),
      builder: (context, snapshot) {
        // Debug log
        print("StreamBuilder snapshot: ${snapshot.data?.data()}");
        print("StreamBuilder snapshot: ${snapshot.data?.data()}");

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final isOnline = userData['isOnline'] ?? false;
          final isTyping = userData['isTyping'] ?? false;
          final lastSeen = userData['lastSeen'] as Timestamp?; // It's a Timestamp from Firestore

          if (isTyping) {
            return const TypingIndicator(); // ✅ Animated typing effect
          } else if (isOnline) {
            return  Text(
              "Online",
              style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13,color: Colors.white))
            );
          } else {
            if (lastSeen != null) {
              DateTime dateTime = lastSeen.toDate(); // Convert Timestamp to DateTime
              String formattedStatus = _formatLastSeen(dateTime); // Use the helper function
              return Text(
                "Last seen: $formattedStatus", // Display the formatted status
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              );
            } else {
              return  Text(
                "Offline", // Changed from " Offline" to "Offline" for consistency
                style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13,))
              );
            }
          }
        } else {
          return const Text(
            "Loading admin status...",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          );
        }
      },
    );
  }
}