import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disputeresolverai/model/users.dart';
import 'package:disputeresolverai/screens/chat/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  List<Person> myPerson = [];
  int i = 0;
  var myFbIns = FirebaseAuth.instance;
  var myFbFs = FirebaseFirestore.instance;

  //Fetch all user documents from firebase
  //Convert each document of user into MyUser Object
  //Save each user into the list of myUsers list
  //Then simply use this myUsers list to show the users on HomePage
  Future<List<Person>> getUsersFromFirebase() async {
    try {
      QuerySnapshot myAllDocuments =
          await FirebaseFirestore.instance.collection("Users").get();
      for (var element in myAllDocuments.docs) {
        print("***************");
        print(element.data());
        Person myUser = Person.fromJson(element.data() as Map<String, dynamic>);
        print("***************");
        myPerson.add(myUser);
      }
      myPerson.toSet().toList();
      print("My length ${myPerson.length}");
      i++;
      return myPerson;
    } catch (e) {
      print(e);
    }
    return myPerson;
  }

  //Creating Chat room
  createChatRoom(String otherUserId) async{

    String chatRoomId = "${myFbIns.currentUser!.uid}-$otherUserId";

    var myChatRoomDoc = await myFbFs.collection('chats').doc(chatRoomId).get();

    if(myChatRoomDoc.exists){
      //Navigate chat Screen
      Get.to(ChatPage());
    }else{
      await myFbFs.collection('chats').doc(chatRoomId).set({
        'chatRoomId':chatRoomId,
        'timeStamp':DateTime.now()
      }).then((value){
        print("Collection was created");
      });
      //Navigate
      Get.to(ChatPage());
    }



  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    myPerson.forEach((e) {
      print(e.name);
    });
  }
}
// mlik