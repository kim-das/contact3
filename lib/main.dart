import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp( MaterialApp(
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key:key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async{
    var status = await Permission.contacts.status;
    if (status.isGranted){
      print('허락됨');
      var contacts=await ContactsService.getContacts();
      print(contacts);
      name=contacts;
    }else if(status.isDenied){
      print('거절됨');
      Permission.contacts.request();
    }

  }

  var total=3;//친구 수
  var name=[];

  addOne(){
    setState((){
      total++;
  });
  }

  addName(a){
    setState(() {
      name.add(a);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context) {
            return DialogUI(addOne:addOne, addName: addName);
          }
          );
        },
      ),
          appBar:AppBar(
              title:Text(total.toString()),
              backgroundColor: Colors.blue,
              actions: [IconButton(onPressed:(){
                getPermission();
              }, icon: Icon(Icons.contacts))],
          ),
          body:
            ListView.builder(
              itemCount:name.length,
              itemBuilder:(c,i){
                return ListTile(
                  leading: Icon(Icons.account_circle),
                  title:Text(name[i].givenName)
                );
              }
            ),

          bottomNavigationBar: BottomAppBar(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.call),
                Icon(Icons.message),
                Icon(Icons.contact_page_sharp)
              ],
            )
          ),
              );

  }}


class DialogUI extends StatelessWidget {
  DialogUI({Key?key,this.addOne,this.addName}):super(key: key);
  final addOne;
  final addName;
  var inputData=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
              children: [
                TextField(controller: inputData),
                TextButton(onPressed: () {
                  addOne();
                  addName(inputData.text);
                  Navigator.pop(context);
                }, child: Text('완료')),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('취소'))
              ]
          )
      ),
    );
  }
}
