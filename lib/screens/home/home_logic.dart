import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/users.dart';

class Details_screenLogic extends GetxController {
  List<Person> myAllStudets = [];

  Future<List<Person>> getUsersOnFirebase() async {
    QuerySnapshot myalldocs = await FirebaseFirestore.instance.collection(
        'Persons').get();
    for (var elements in myalldocs.docs) {
      Person myStudent = Person.fromJson(
          elements.data() as Map<String, dynamic>);
      myAllStudets.add(myStudent);
    }
    return myAllStudets;
  }
}
