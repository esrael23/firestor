import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: storage(),
    );
  }
}

class storage extends StatefulWidget {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();
  // const storage({super.key});

  @override
  State<storage> createState() => _storageState();
}

class _storageState extends State<storage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cloud firestore demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              'read data from cloun firesetore ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Container(
              height: 250,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: StreamBuilder<QuerySnapshot>(
                  stream: widget.users,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('something went wrong.');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('loading');
                    }
                    final data = snapshot.requireData;

                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: ((context, index) {
                        return Text(
                            'my name is ${data.docs[index]['name']} and i am ${data.docs[index]['age']}');
                      }),
                    );
                  }),
            ),
            Text(
              'write data to cloun firestore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            MyCustomfrom()
          ],
        ),
      ),
    );
  }
}

class MyCustomfrom extends StatefulWidget {
  const MyCustomfrom({super.key});

  @override
  State<MyCustomfrom> createState() => _MyCustomfromState();
}

class _MyCustomfromState extends State<MyCustomfrom> {
  final _formKey = GlobalKey<FormState>();
  var name = '';
  var age = 0;
  var famly = '';
  var city = '';
  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'what is your name?',
                labelText: 'name',
              ),
              onChanged: (value) {
                name = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'what is your age?',
                labelText: 'age',
              ),
              onChanged: (value) {
                age = int.parse(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'what is your age?',
                labelText: 'famly member',
              ),
              onChanged: (value) {
                famly = (value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'what is your city?',
                labelText: 'city',
              ),
              onChanged: (value) {
                city = (value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("sending data to clud firestore"),
                      ),
                    );
                  }
                  user
                      .add({
                        'name': name,
                        'age': age,
                        'famly': famly,
                        'city': city
                      })
                      .then((value) => print('user added'))
                      .catchError(
                          (error) => print('failed to add user: $error'));
                },
                child: Text('submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
