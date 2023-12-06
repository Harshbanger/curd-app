import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Editscreen extends StatefulWidget {
  final title;
  final desc;
  final id;
  const Editscreen(
      {super.key, required this.title, required this.desc, required this.id});

  @override
  State<Editscreen> createState() => _EditscreenState();
}

class _EditscreenState extends State<Editscreen> {
  TextEditingController title = TextEditingController();
  TextEditingController des = TextEditingController();
  @override
  void initState() {
    super.initState();
    title.text = widget.title;
    des.text = widget.desc;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Details"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                hintText: "Title",
                labelText: "Title",
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: des,
              decoration: const InputDecoration(
                  hintText: "Description", labelText: "Description"),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () {
                  if (title.text.isNotEmpty && des.text.isNotEmpty) {
                    edit(widget.id);
                    Get.back();
                    Fluttertoast.showToast(
                        msg: "Data updated successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white60,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  } else if (title.text.isEmpty) {
                    const Snackbar = SnackBar(
                      content: Text("Enter a title"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(Snackbar);
                  } else if (des.text.isEmpty) {
                    const Snackbar = SnackBar(
                      content: Text("Enter a description "),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(Snackbar);
                  }
                },
                child: const Text("Update"))
          ],
        ),
      ),
    );
  }

  Future<void> edit(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final heading = title.text;
    final description = des.text;
    final body = {
      "title": heading,
      "description": description,
    };
    await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
  }
}
