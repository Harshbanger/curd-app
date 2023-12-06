import 'dart:convert';
import 'package:curd_operation/view/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'add_screen.dart';
import 'package:http/http.dart' as http;
import 'package:focus_detector_v2/focus_detector_v2.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List items = [];

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: FocusDetector(
        onVisibilityGained: () => getdata(),
        child: items.isEmpty
            ? const Center(
                child: Text("Click on add button"),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = items[index] as Map;
                  final id = data['_id'] as String;
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(data['title']),
                    subtitle: Text(data['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          Get.to(() => Editscreen(
                                title: data['title'],
                                desc: data['description'],
                                id: id,
                              ));
                        } else if (value == "delete") {
                          delete(id);
                          Fluttertoast.showToast(
                              msg: "Data deleted successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white60,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            child: Text("Edit"),
                            value: "edit",
                          ),
                          const PopupMenuItem(
                            child: Text("Delete"),
                            value: "delete",
                          ),
                        ];
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Get.to(() => const Addscreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getdata() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
  }

  Future<void> delete(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    await http.delete(uri);
    final filter = items.where((element) => element['_id'] != id).toList();
    setState(() {
      items = filter;
    });
  }
}
