import 'package:flutter/material.dart';

import 'Messagdata.dart';
import 'MessageProvider.dart';
import 'ScheduleMessage.dart';


class SheduleScreen extends StatefulWidget {
  @override
  _SheduleScreenState createState() => _SheduleScreenState();
}

class _SheduleScreenState extends State<SheduleScreen> {
  TodoService _todoService;

  List<Todo> _todoList = List<Todo>();

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.udi = todo['udi'];
        model.message = todo['message'];
        model.time = todo['time'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_todoList);
    return Scaffold(

      appBar: AppBar(
        title: Text('Todolist Sqflite'),
      ),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top:8.0, left: 8.0, right: 8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => ReadList()));
                },
                child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(_todoList[index].udi ?? 'No Title')
                        ],
                      ),
                      subtitle: Text(_todoList[index].time ?? 'No time'),
                      trailing:Text(_todoList[index].todoDate ?? 'No time'),
                    )))

            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}
class ReadList extends StatefulWidget {


  @override
  _ReadListState createState() => _ReadListState();
}

class _ReadListState extends State<ReadList> {
  TodoService _todoService;

  List<Todo> _todoList = List<Todo>();

  @override
  initState() {
    super.initState();
    getAllTodos();
  }


    getAllTodos() async {
      _todoService = TodoService();
      _todoList = List<Todo>();

      var todos = await _todoService.readTodos();

      todos.forEach((todo) {
        setState(() {
          var model = Todo();
          model.id = todo['id'];
          model.udi = todo['udi'];
          model.message = todo['message'];
          model.time = todo['time'];
          model.todoDate = todo['todoDate'];
          model.isFinished = todo['isFinished'];
          _todoList.add(model);
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top:8.0, left: 8.0, right: 8.0),
              child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_todoList[index].udi ),
                        SizedBox(height: 10,),
                        Text(_todoList[index].message),
                        SizedBox(height: 10,),
                        Text(_todoList[index].time ?? 'No time'),
                        SizedBox(height: 10,),
                     Text(_todoList[index].todoDate ?? 'No time'),
                        // Text(_todoList[index].time),

                        //Text(_todoList[index].todoDate ),


                      ],
                    ),

                  )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}