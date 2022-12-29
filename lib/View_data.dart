import 'package:firebase/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class view extends StatefulWidget {
  const view({Key? key}) : super(key: key);

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {

  List keys=[];
  List names=[];
  List contacts=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('Student');
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map data = event.snapshot.value as Map;
      keys.clear();
      names.clear();
      contacts.clear();
      data.forEach((key, value) {
        keys.add(key);
        print("$key=>$value");
        Map m=value;
        names.add(m['name']);
        contacts.add(m['contact']);
      });
      setState(() {

      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("view-data"),),
      body: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          title: Text("${names[index]}"),
          subtitle: Text("${contacts[index]}"),
          trailing: Wrap(
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  DatabaseReference ref = FirebaseDatabase.instance.ref("Student").child(keys[index]);
                  await ref.remove();
                  setState(() {

                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: ()  {
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                   return f_data(keys[index],names[index],contacts[index]);
                 },));
                },
              )
            ],
          ),
        );
      },itemCount: keys.length,),
    );
  }
}
