//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../model/students.dart';
// import 'logic.dart';
//
//
// class SelectUsersPage extends StatefulWidget {
//   final Function(List<String>) onUsersSelected;
//   SelectUsersPage({required this.onUsersSelected});
//
//   @override
//   _SelectUsersPageState createState() => _SelectUsersPageState();
// }
//
// class _SelectUsersPageState extends State<SelectUsersPage> {
//   final HomeLogic logic = Get.find();
//   List<String> selectedUsers = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select Members")),
//       body: FutureBuilder<List<Students>>(
//         future: logic.getUserOnFirebase(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, i) {
//               final user = snapshot.data![i];
//               return CheckboxListTile(
//                 title: Text(user.name),
//                 value: selectedUsers.contains(user.id),
//                 onChanged: (selected) {
//                   setState(() {
//                     if (selected!) {
//                       selectedUsers.add(user.id);
//                     } else {
//                       selectedUsers.remove(user.id);
//                     }
//                   });
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.check),
//         onPressed: () {
//           widget.onUsersSelected(selectedUsers);
//           Get.back();
//         },
//       ),
//     );
//   }
// }
