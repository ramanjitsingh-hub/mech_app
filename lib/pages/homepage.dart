import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mech_app/pages/ongoing.dart';
import 'package:mech_app/pages/pickup.dart';
import 'package:mech_app/pages/report.dart';
import 'package:provider/provider.dart';
import '../provider/userprovider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(Provider.of<UserProvider>(context).userId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found'));
          } else {
            String userName = snapshot.data!.get(
                'name'); // Assuming 'name' is the field for the user's name
            return Scaffold(
              body: PageView(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome, $userName",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Pickup()),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    "   ADD NEW PICKUP",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Report()));
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                    "REPORTS          ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OngoingJobsPage(),
                                  ));
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                    "ONGOING JOBS",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
