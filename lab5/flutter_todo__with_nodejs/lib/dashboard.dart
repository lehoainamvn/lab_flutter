import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'loginPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token,Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    getTodoList(userId);
  }

  void addTodo() async{
    if(_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty){

      var regBody = {
        "userId":userId,
        "title":_todoTitle.text,
        "description":_todoDesc.text
      };

      try {
        var response = await http.post(Uri.parse(addtodo),
            headers: {"Content-Type":"application/json"},
            body: jsonEncode(regBody)
        );

        var jsonResponse = jsonDecode(response.body);

        if(jsonResponse['status']){
          _todoDesc.clear();
          _todoTitle.clear();
          Navigator.pop(context);
          getTodoList(userId);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Thêm công việc thành công!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Có lỗi xảy ra khi thêm công việc'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi kết nối: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void getTodoList(userId) async {
    var regBody = {
      "userId":userId
    };

    var response = await http.post(Uri.parse(getToDoList),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];

    setState(() {

    });
  }

  void deleteItem(id) async{
    var regBody = {
      "id":id
    };

    try {
      var response = await http.post(Uri.parse(deleteTodo),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(regBody)
      );

      var jsonResponse = jsonDecode(response.body);
      if(jsonResponse['status']){
        getTodoList(userId);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Đã xóa công việc'),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
       body: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             padding: EdgeInsets.only(top: 60.0,left: 30.0,right: 30.0,bottom: 30.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     CircleAvatar(child: Icon(Icons.list,size: 30.0,),backgroundColor: Colors.white,radius: 30.0,),
                     IconButton(
                       onPressed: () async {
                         SharedPreferences prefs = await SharedPreferences.getInstance();
                         await prefs.remove('token');
                         Navigator.pushReplacement(
                           context, 
                           MaterialPageRoute(builder: (context) => SignInPage())
                         );
                       },
                       icon: Icon(Icons.logout, color: Colors.white, size: 28),
                       tooltip: 'Đăng xuất',
                     ),
                   ],
                 ),
                 SizedBox(height: 10.0),
                 Text('ToDo App - Quản lý công việc',style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.w700, color: Colors.white),),
                 SizedBox(height: 8.0),
                 Text('${items?.length ?? 0} công việc',style: TextStyle(fontSize: 18, color: Colors.white70),),

               ],
             ),
           ),
           Expanded(
             child: Container(
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
               ),
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: items == null ? Center(
                   child: CircularProgressIndicator(),
                 ) : items!.isEmpty ? Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.task_alt, size: 64, color: Colors.grey.shade400),
                       SizedBox(height: 16),
                       Text(
                         'Chưa có công việc nào',
                         style: TextStyle(
                           fontSize: 18,
                           color: Colors.grey.shade600,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                       SizedBox(height: 8),
                       Text(
                         'Nhấn nút + để thêm công việc mới',
                         style: TextStyle(
                           fontSize: 14,
                           color: Colors.grey.shade500,
                         ),
                       ),
                     ],
                   ),
                 ) : ListView.builder(
                     itemCount: items!.length,
                     itemBuilder: (context,int index){
                       return Slidable(
                         key: ValueKey(items![index]['_id']),
                         endActionPane: ActionPane(
                           motion: const ScrollMotion(),
                           dismissible: DismissiblePane(onDismissed: () {}),
                           children: [
                             SlidableAction(
                               backgroundColor: Color(0xFFFE4A49),
                               foregroundColor: Colors.white,
                               icon: Icons.delete,
                               label: 'Xóa',
                               onPressed: (BuildContext context) {
                                 deleteItem('${items![index]['_id']}');
                               },
                             ),
                           ],
                         ),
                         child: Card(
                           margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                           elevation: 2,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                           child: ListTile(
                             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                             leading: Container(
                               width: 40,
                               height: 40,
                               decoration: BoxDecoration(
                                 color: Colors.blue.shade100,
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: Icon(Icons.task, color: Colors.blue.shade600),
                             ),
                             title: Text(
                               '${items![index]['title']}',
                               style: TextStyle(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 16,
                               ),
                             ),
                             subtitle: Padding(
                               padding: EdgeInsets.only(top: 4),
                               child: Text(
                                 '${items![index]['description']}',
                                 style: TextStyle(
                                   color: Colors.grey.shade600,
                                   fontSize: 14,
                                 ),
                               ),
                             ),
                             trailing: Icon(Icons.drag_handle, color: Colors.grey.shade400),
                           ),
                         ),
                       );
                     }
                 ),
               ),
             ),
           )
         ],
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>_displayTextInputDialog(context) ,
        backgroundColor: Colors.blue.shade600,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Thêm công việc',
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.add_task, color: Colors.blue.shade600),
                SizedBox(width: 8),
                Text('Thêm công việc mới'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _todoTitle,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      hintText: "Tiêu đề công việc",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide.none)),
                ).p4(),
                TextField(
                  controller: _todoDesc,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      hintText: "Mô tả chi tiết",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide.none)),
                ).p4(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy', style: TextStyle(color: Colors.grey.shade600)),
              ),
              ElevatedButton(
                onPressed: (){
                  addTodo();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Thêm"),
              ),
            ],
          );
        });
  }
}

