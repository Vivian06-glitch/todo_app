import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Service/todo_services.dart';

import '../utils/snackbar_helper.dart';

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

   final isSuccess = await TodoServices.updateTodo(id, body);
    if(isSuccess){
      print("Update Success");
      print(isSuccess);
      showSuccessMessage(context, message:"Update Success");
    }
    else{
      print("Update Failed");
      showErrorMessage(context, message:"Update Failed");
    }
 }

    Future<void> submitData()async{
     //Submit data to the server
     final isSuccess = await TodoServices.addTodo(body);
    print("Add response is $isSuccess");
     if(isSuccess){
       titleController.text= "";
       descriptionController.text= "";
       print("Creation Success");
       print(isSuccess);
       showSuccessMessage(context, message:"Creation Success");
     }
     else{
       print("Creation Failed");
       showErrorMessage(context, message:"Creation Failed");
     }
   }
Map get body{
  //Get Data from form
  final title = titleController.text;
  final description = descriptionController.text;
   return{
    "title": titleController.text,
    "description": descriptionController.text,
    "is_completed": false
  };
}
 }

