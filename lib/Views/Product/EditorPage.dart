import 'dart:convert';

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
            print(await controller.getText());
          }, child: Text("GET HTML"))
        ],
      ),
    );
  }
/*
  String quillDeltaToHtml(Delta delta) {
    final convertedValue = jsonEncode(delta.toJson());
    final markdown = deltaToMarkdown(convertedValue);
    final html = mark.markdownToHtml(markdown);

    return html;
  }

  // ignore: unused_element
  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.collections),
                label: const m.Text('Gallery'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
              ),
              TextButton.icon(
                icon: const Icon(Icons.link),
                label: const m.Text('Link'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
              )
            ],
          ),
        ),
      );

  Widget _buildMenuBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const itemStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
        ListTile(
          title: const Center(child: m.Text('Read only demo', style: itemStyle)),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
      ],
    );
  }*/
}