import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'View_data.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();print("hello");
  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(home: f_data(),));
}
class f_data extends StatefulWidget {

  String? key1,name,contact;
  f_data([this.key1, this.name, this.contact]);

  @override
  State<f_data> createState() => _f_dataState();
}

class _f_dataState extends State<f_data> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();

  notification()
  async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title!}');
        print('Message also contained a notification: ${message.notification!.body!}');
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification();
    if(widget.key1!=null)
      {
        t1.text=widget.name!;
        t2.text=widget.contact!;
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("insert"),),
      body: Column(children: [
        TextField(controller: t1,decoration: InputDecoration(hintText: "Enter Name")),
        TextField(controller: t2,decoration: InputDecoration(hintText: "Enter Contact")),

        ElevatedButton(onPressed: () async {
          if(widget.key1!=null)
            {
              DatabaseReference ref = FirebaseDatabase.instance.ref("Student").child(widget.key1!);
              await ref.update({
                "name": t1.text,
                "contact": t2.text,
              });
            }
          else
            {
              DatabaseReference ref = FirebaseDatabase.instance.ref("Student").push();
              await ref.set({
                "name": t1.text,
                "contact": t2.text,
              });
            }
        }, child: Text("Submit")),
        ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return view();
          },));
        }, child: Text("View"))
      ]),
    );
  }

}
