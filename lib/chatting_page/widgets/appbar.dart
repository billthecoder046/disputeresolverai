import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart'; // Make sure you have the 'gap' package imported if you're using it
import '../user_status/guestStatus.dart';

// Assuming this is inside a StatefulWidget or StatelessWidget that has widget.receiverName and widget.receiverId
// For example:
// class ChatScreen extends StatefulWidget {
//   final String receiverName;
//   final String receiverId;
//   const ChatScreen({Key? key, required this.receiverName, required this.receiverId}) : super(key: key);
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ... (your new AppBar code here) ...
//       body: ...
//     );
//   }
// }

AppBar buildProfessionalAppBar({
  required BuildContext context,
  required String receiverName,
  required String receiverId,
}) {
  return AppBar(
    backgroundColor: Colors.deepPurple[700], // Slightly darker for more depth

    elevation: 6,

    titleSpacing: 0, // Remove default title spacing to control it fully

    // leading: IconButton(
    //   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
    //   onPressed: () => Navigator.of(context).pop(),
    // ),

    title: Padding( // Add padding around the title content
      padding: const EdgeInsets.only(left: 8.0), // Padding to the left of the title for proper alignment with leading icon
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start, // Default for Row
        crossAxisAlignment: CrossAxisAlignment.center, // Vertically center content
        children: [
          Flexible(
            child: Text(
              receiverName,
              // Use GoogleFonts directly to define the style
              style: GoogleFonts.aclonica(
                fontSize: 20, // Slightly smaller for professional look
                fontWeight: FontWeight.w600, // Semi-bold for clarity
                color: Colors.white,
                // overflow: TextOverflow.ellipsis, // Handle long names
              ),
              overflow: TextOverflow.ellipsis, // In case receiverName is too long
            ),
          ),
          const Gap(20), // Smaller gap, Gap(25) was too large

          AdminStatus(adminUserId: receiverId),
        ],
      ),
    ),

    actions: [
      IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.white),
        onPressed: () {
          // Handle more options
        },
      ),
      const Gap(8), // Small gap before the end of the appbar
    ],
  );
}