import 'package:cloud_firestore/cloud_firestore.dart';


abstract class BaseController {
  BaseController(this.collection);

  CollectionReference<Map<String, dynamic>> collection;
}

