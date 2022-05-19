import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class EditorPage extends StatefulWidget {
  @override
  _EditorPage createState() => _EditorPage();
}

class _EditorPage extends State<EditorPage> {

  CheckAdminController checkAdminController = Get.find();
  HtmlEditorController controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: checkAdminController.system.mainColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Description',
        ),
        actions: [],
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {

        },
        child: _buildWelcomeEditor(context),
      ),
    );
  }

  Widget _buildWelcomeEditor(BuildContext context) {

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /*Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Container(child: toolbar),*/
          Expanded(
            child: HtmlEditor(
              htmlToolbarOptions: HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.belowEditor,
                toolbarType: ToolbarType.nativeGrid
              ),
              controller: controller, //required
              htmlEditorOptions: HtmlEditorOptions(
                hint: "Your text here...",
              ),
              otherOptions: OtherOptions(
                height: Get.height,
              ),
            ),
          ),
          TextButton(onPressed: () async {
            htmlString = await controller.getText();
            Get.back();
          }, child: Text("ADD"))
        ],
      ),
    );
  }
}