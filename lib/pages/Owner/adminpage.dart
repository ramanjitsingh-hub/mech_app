import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mech_app/pages/Owner/ongoing.dart';
import 'package:mech_app/pages/homepage.dart';
import 'package:mech_app/provider/userprovider.dart';
import 'package:provider/provider.dart';

import 'analytics.dart';
import 'job.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset("assets/pndlogo.png")),
              Text(
                "Welcome, Admin",
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pickups')
                      .where('driver', isEqualTo: 'fetch')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      int jobsCount = snapshot.data!.docs.length;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Job()));
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "ASSIGN DRIVERS",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (jobsCount > 0)
                              Positioned(
                                top: 10,
                                left: 220,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    jobsCount.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => Analytics()));
              //     },
              //     child: Container(
              //       height: 50,
              //       width: 250,
              //       decoration: BoxDecoration(
              //         color: Colors.orangeAccent,
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             Icons.add,
              //             color: Colors.white,
              //           ),
              //           SizedBox(
              //             width: 50,
              //           ),
              //           Text(
              //             "REPORTS    ",
              //             style: TextStyle(
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageGallery(),
                        ));
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "IMAGE GALLERY",
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
            ],
          ),
        ),
      ],
    );
  }
}

class ImageGallery extends StatelessWidget {
  const ImageGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Gallery"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('pickups').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found for the user'));
          } else {
            final List<QueryDocumentSnapshot> pickups = snapshot.data!.docs;
            return ListView.builder(
              itemCount: pickups.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> data =
                    pickups[index].data() as Map<String, dynamic>;
                List<String> images = List<String>.from(data['images'] ?? []);
                return ListTile(
                  title: Text('Vechile Number: ${data['vehicleNumber']}'),
                  subtitle: images.isEmpty
                      ? Text('No images captured')
                      : ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    height: 250,
                                    width: 300, // Limit width here
                                    child: images.isEmpty
                                        ? Center(
                                            child: Text('No images captured'),
                                          )
                                        : ListView.builder(
                                            itemCount: images.length,
                                            itemBuilder: (context, idx) {
                                              return InteractiveViewer(
                                                minScale: 0.1,
                                                maxScale: 3.0,
                                                child: Image.network(
                                                  images[idx],
                                                  // Other parameters for customization
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('View Images'),
                        ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
