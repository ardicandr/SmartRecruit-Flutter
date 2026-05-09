import 'package:get/get.dart';

class AppSearchController extends GetxController { 
  var selectedFilter = "Remote".obs;
  void changeFilter(String value) => selectedFilter.value = value;
}