import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo= widget.todo;
    if(todo!= null){
      isEdit= true;
      final title = todo["title"];
      final description = todo["description"];
      titleController.text= title;
      descriptionController.text= description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title:  Text(
            isEdit ? "Edit Todo":"Add Todo"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
           TextField(
            controller:titleController ,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 10,
          ),
            TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed:isEdit? updateData: submitData,
              child:  Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    isEdit ? "Update":"Submit"),
              ))
        ],
      ),
    );
  }
 Future<void> updateData()async{
    final todo = widget.todo;
    if(todo== null){
      print("You can not call updated without todo data");
      return;
    }
    final id = todo["_id"];
   final title = titleController.text;
   final description = descriptionController.text;
   final body = {
     "title": title,
     "description": description,
     "is_completed": false
   };
   final url = "https://api.nstack.in/v1/todos/$id";
   final uri = Uri.parse(url);
   final response = await http.put(uri,
       body: jsonEncode(body),
       headers: {
         "Content-Type": "application/json"
       }
   );
    if(response.statusCode== 200){
      print("Updation Success");
      print(response.body);
      showSuccessMessage("Updation Success");
    }
    else{
      print("Updation Failed");
      showErrorMessage("Updation Failed");
    }
 }

    Future<void> submitData()async{
     //Get Data from form
     final title = titleController.text;
     final description = descriptionController.text;
     final body = {
       "title": titleController.text,
       "description": descriptionController.text,
       "is_completed": false
     };
     //Submit data to the server
     final url = "https://api.nstack.in/v1/todos";
     final uri = Uri.parse(url);
     final response = await http.post(uri,
         body: jsonEncode(body),
         headers: {
           "Content-Type": "application/json"
         }
     );
    print("Add response is ${response.body}");
     if(response.statusCode== 201){
       titleController.text= "";
       descriptionController.text= "";
       print("Creation Success");
       print(response.body);
       showSuccessMessage("Creation Success");
     }
     else{
       print("Creation Failed");
       showErrorMessage("Creation Failed");
     }
   }
   void showSuccessMessage(String message){
     final snackBar = SnackBar(content: Text(message));
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
   void showErrorMessage(String message) {
     final snackBar = SnackBar(content: Text(message,
       style: const TextStyle(color: Colors.white),
     ),
       backgroundColor: Colors.red,
     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
 }

