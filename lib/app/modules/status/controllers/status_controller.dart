import 'package:get/get.dart';

class StatusController extends GetxController {
  // Tab index untuk filter: 0 = Semua, 1 = Aktif, 2 = Selesai
  var filterIndex = 0.obs;

  void changeFilter(int index) => filterIndex.value = index;
}