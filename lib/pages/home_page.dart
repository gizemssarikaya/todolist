import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../model/gorev_type.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "ToDoS",
            style: TextStyle(
                color: Colors.amber, fontSize: 30, fontWeight: FontWeight.w400),
          ),
        ),
        body: Form(
            key: controller.formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onEditingComplete: () => controller.addtoGorev(),
                  controller: controller.gorevTextController,
                  validator: (value) => controller.validateGorevText(value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.amber)),
                    labelText: 'Bugün neler yapacaksınız?',
                    labelStyle: const TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 14),
                      onPressed: () => controller.clearGorevText(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() => DropdownButtonHideUnderline(
                            child: DropdownButton2<GorevType>(
                              hint: const Text('Görev Türü'),
                              items: getDropdownMenuItems(),
                              value: controller.currentDutyType,
                              onChanged: (GorevType? value) =>
                                  controller.changeCurrentDutyType(value),
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                ),
                                elevation: 2,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 14,
                                iconEnabledColor:
                                    Color.fromRGBO(158, 158, 158, 1),
                                iconDisabledColor: Colors.white,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                elevation: 0,
                                maxHeight: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                ),
                                offset: const Offset(-20, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: MaterialStateProperty.all(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          )),
                      ElevatedButton(
                          onPressed: () => {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Görev Ekle"),
                                      actions: [
                                        TextFormField(
                                          controller: controller
                                              .gorevTypeTextController,
                                          onEditingComplete: () {},
                                          validator: (String? value) =>
                                              controller
                                                  .validateGorevTypeText(value),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.amber)),
                                            labelText: 'Görev Türü Giriniz?',
                                            labelStyle: const TextStyle(
                                                color: Colors.black),
                                            suffixIcon: IconButton(
                                                icon: const Icon(Icons.clear,
                                                    size: 14),
                                                onPressed: () => controller
                                                    .clearGorevTypeText()),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                                child: const Text("Vazgeç"),
                                                onPressed: () =>
                                                    controller.taptoOk()),
                                            TextButton(
                                                child: const Text("Kaydet"),
                                                onPressed: () async {
                                                  await controller
                                                      .addtoGorevType();
                                                }),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                )
                              },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                              backgroundColor:
                                  const Color.fromARGB(255, 24, 151, 255),
                              padding: const EdgeInsets.all(17),
                              elevation: 0),
                          child: const Text(
                            "Görev Türü Ekle",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          )),
                    ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Tooltip(
                      message: 'Yapılmamış',
                      child: Obx(() => Text(controller.completedDutyWrite()!))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Tooltip(
                          message: "Tüm Görevler",
                          child: TextButton(
                            child: const Text(
                              "AlTodos",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            ),
                            onPressed: () async =>
                                {await controller.loadDutyList()},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Tooltip(
                          message: "Tamamlanmamış Görevler",
                          child: TextButton(
                            child: const Text(
                              "Active",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            ),
                            onPressed: () async =>
                                {await controller.loadUnCompletedList()},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0.7),
                        child: Tooltip(
                          message: "Tamamlanmış Görevler",
                          child: TextButton(
                              child: const Text(
                                "Completed",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              onPressed: () async =>
                                  {await controller.loadCompletedList()}),
                        ),
                      )
                    ],
                  ),
                )
              ]),
              Expanded(
                  child: Obx(() => ListView.builder(
                      itemCount: controller.dutyList.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.startToEnd,
                            onDismissed: ((direction) async {
                              controller
                                  .deletetGorev(controller.dutyList[index]);
                            }),
                            child: ListTile(
                              leading: Checkbox(
                                  value: controller.dutyList[index].durum,
                                  onChanged: (newvalue) async {
                                    await controller.changeDutyComplete(
                                        controller.dutyList[index]);
                                  }),
                              title: Text(controller.dutyList[index].name),
                              trailing: const Icon(Icons.forward),
                            ));
                      })))
            ])));
  }

  List<DropdownMenuItem<GorevType>> getDropdownMenuItems() {
    final data = controller.dutyTypeList;

    final menuList = <DropdownMenuItem<GorevType>>[];

    for (GorevType type in data) {
      final menuItem = DropdownMenuItem<GorevType>(
          value: type,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              controller.deletetoGorevType(type) != 0
                  ? Get.snackbar("Hata", "Silemezsin",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red)
                  : Get.snackbar("Mesaj", "Başarıyla silindi");
            },
            child: Text(type.name),
          ));
      menuList.add(menuItem);
    }
    return menuList;
  }
}
