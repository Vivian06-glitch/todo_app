import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Service/todo_services.dart';
import '../utils/snackbar_helper.dart';
import '../widget/todo_card.dart';
import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListState();
}

class _TodoListState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];



  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("Todo List"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement:  Center(
              child: Text("No Todo Item",
              style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                //final id = ["_item"] as String;
                return TodoCard(
                  index: index,
                  deleteById: deleteById,
                  navigateEdit: navigateToEditPage,
                  item: item,
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text("Add Todo"),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

 Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
  }
  Future<void> deleteById(String id) async {
    final ifSuccess = await TodoServices.deleteById(id);

    if (ifSuccess) {
      // Remove the item from the list
      final filtered = items.where((element) => element["_id"] != id).toList();

      setState(() {
        items = filtered;
      });

      showSuccessMessage("Deleted successfully");
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }
  }


  Future<void> fetchTodo() async {
    print("Todo 1");
    final response = await TodoServices.fetchTodos();
    if (response!=null) {

      print("Result is $response");
      setState(() {
        items = response;
      });
    }else{
      showErrorMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
