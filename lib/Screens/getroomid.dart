import 'package:shared_preferences/shared_preferences.dart';

getRoomId() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  userID = _prefs.getString('id');
  String anotherUserID = widget.docs['id'];

  // LOGIC TO SELECT DESIRED CHAT ROOM FROM COUD FIRESTORE
  if (userID.compareTo(anotherUserID) > 0) {
    chatRoomID = '$userID - $anotherUserID';
  } else {
    chatRoomID = '$anotherUserID - $userID';
  }
  setState(() {});
}