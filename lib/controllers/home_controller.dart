import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dbhelper.dart';
import '../model/gorev.dart';
import '../model/gorev_type.dart';

class HomeController extends GetxController {
  final dutyTypeList = RxList<GorevType>([]);
  final dutyList = RxList<Gorev>([]);

  final _currentDutyType = Rxn<GorevType>();
  final _completedTodosCount = RxInt(0);

  GorevType? get currentDutyType => _currentDutyType.value;
  set currentDutyType(GorevType? value) => _currentDutyType.value = value;

  final formKey = GlobalKey<FormState>();
  late TextEditingController gorevTextController;
  late TextEditingController gorevTypeTextController;

  int get completedTodosCount => _completedTodosCount.value;
  set completedTodosCount(int value) => _completedTodosCount.value = value;

  @override
  Future<void> onInit() async {
    super.onInit();
    setupTextControllers();
    await loadDutyList();
    await loadGorevTuru();
    checkCompletedDuties();
  }

  @override
  void onClose() {
    disposeTextControllers();

    super.onClose();
  }

  Future<void> loadGorevTuru() async {
    final response = await DatabaseHelper.queryAllGorevType();
    dutyTypeList.clear();

    for (Map<String, dynamic> map in response) {
      final gorevTuru = GorevType.fromJson(map);

      dutyTypeList.add(gorevTuru);
    }

    dutyTypeList.refresh();
  }

  void setupTextControllers() {
    gorevTextController = TextEditingController();
    gorevTypeTextController = TextEditingController();
  }

  void disposeTextControllers() {
    gorevTextController.dispose();
    gorevTypeTextController.dispose();
  }

  String? validateGorevText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Görev türü boş bırakılamaz!';
    }

    if (value != null && value.length <= 4) {
      return 'Görev adı 5 karakterden az olamaz!';
    }

    if (currentDutyType == null) {
      return 'Görev türü seçiniz.';
    }

    return null;
  }

  String? validateGorevTypeText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Görev türü adı  boş bırakılamaz!';
    }
    return null;
  }

  void clearGorevText() {
    gorevTextController.clear();
  }

  void clearGorevTypeText() {
    gorevTypeTextController.clear();
  }

  void changeCurrentDutyType(GorevType? value) {
    currentDutyType = value;
  }

  Future<void> addtoGorevType() async {
    final name = gorevTypeTextController.text;
    final type = GorevType(null, name: name);
    await DatabaseHelper.insert_type(type);

    currentDutyType = null;
    await loadDutyTypeList();
    gorevTypeTextController.clear();

    Get.back();
  }

  Future<void> getDutyType() async {
    List<Map<String, dynamic>> response =
        await DatabaseHelper.queryAllGorevType();

    for (Map<String, dynamic> item in response) {
      final type = GorevType.fromJson(item);
      dutyTypeList.add(type);
    }

    dutyTypeList.refresh();
  }

  Future<void> loadDutyTypeList() async {
    dutyTypeList.clear();
    getDutyType();
    dutyTypeList.refresh();
  }

  void taptoOk() {
    gorevTypeTextController.clear();
    Get.back();
  }

  Future<void> addtoGorev() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String name = gorevTextController.text;
      int? id = currentDutyType!.id;
      final gorev = Gorev(name: name, durum: false, dutyTypeid: id!);
      await DatabaseHelper.insert_gorev(gorev);
      currentDutyType = null;
      FocusScope.of(Get.context!).unfocus();
      loadDutyList();
      gorevTextController.clear();
    }
  }

  Future<void> getDuty() async {
    List<Map<String, dynamic>> response = await DatabaseHelper.queryAllGorev();

    for (Map<String, dynamic> item in response) {
      final type = Gorev.fromJson(item);
      dutyList.add(type);
    }

    dutyList.refresh();
    // checkCompletedDuties();
  }

  Future<void> loadDutyList() async {
    dutyList.clear();
    getDuty();
    dutyList.refresh();
  }

  String? completedDutyWrite() {
    if (completedTodosCount == 0) {
      return 'Hiç görev tamamlanmadı.';
    } else if (completedTodosCount != 0) {
      return '$completedTodosCount tamamlandı.';
    }
  }

  void checkCompletedDuties() {
    completedTodosCount = 0;
    dutyList.refresh();
    for (Gorev gorev in dutyList) {
      if (gorev.durum == true) {
        completedTodosCount++;
      }
    }
  }

  Future<void> loadCompletedList() async {
    final completedList = <Gorev>[];
    dutyList.clear();
    await getDuty();

    for (Gorev gorev in dutyList) {
      if (gorev.durum == true) {
        completedList.add(gorev);
      }
    }

    dutyList.clear();
    dutyList.addAll(completedList);
    dutyList.refresh();
  }

  Future<void> loadUnCompletedList() async {
    dutyList.clear();
    await getDuty();

    final unCompletedList = <Gorev>[];
    for (Gorev gorev in dutyList) {
      if (gorev.durum == false) {
        unCompletedList.add(gorev);
      }
    }

    dutyList.clear();
    dutyList.addAll(unCompletedList);
    dutyList.refresh();
  }

  bool? changeDutyDurumType(Gorev gorev) {
    if (gorev.durum == 0) {
      return false;
    } else if (gorev.durum == 1) {
      return true;
    }
  }

  Future<void> changeDutyComplete(Gorev gorev) async {
    gorev.durum = !gorev.durum;

    await DatabaseHelper.update(gorev);
    dutyList.refresh();
    checkCompletedDuties();
  }

  void deletetGorev(Gorev gorev) async {
    await DatabaseHelper.delete_gorev(gorev.id!);
    await loadDutyList();
    checkCompletedDuties();
  }

  Future<int> deletetoGorevType(GorevType type) async {
   int sayac = 0;
    for (Gorev item in dutyList) {
      if (item.dutyTypeid == type.id) {
        sayac += 1;
        break;
      }
    }
    if (sayac == 0) {
      currentDutyType = null;
      await DatabaseHelper.delete_gorevtype(type.id!);

      await loadDutyTypeList();
    }

    Get.back();
    return sayac;
  }
}
