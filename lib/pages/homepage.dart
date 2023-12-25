import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mech_app/pages/Driver/driver.dart';
import 'package:mech_app/pages/Owner/adminpage.dart';
import 'package:mech_app/pages/ongoing.dart';
import 'package:mech_app/pages/pickup.dart';
import 'package:mech_app/pages/report.dart';
import 'package:mech_app/pages/returnvehicle.dart';
import 'package:mech_app/widgets/imagegallerybutton.dart';
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
          String userName = snapshot.data!.get('name');
          String userRole = snapshot.data!.get('role');

          Widget bodyWidget;

          // Check the user's role and set the appropriate body widget
          if (userRole == 'admin') {
            // Admin body widget
            bodyWidget = AdminPage();
          } else if (userRole == 'driver') {
            // User body widget
            bodyWidget = Driver();
          } else if (userRole == 'dealer') {
            // User body widget
            bodyWidget = dealer_interface(
              userName: userName,
            );
          } else {
            // Handle other roles or show an error message
            bodyWidget = Center(child: Text('Unknown user role'));
          }

          return Scaffold(
            body: bodyWidget,
          );
        }
      },
    );
  }
}

class dealer_interface extends StatelessWidget {
  const dealer_interface({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return PageView(
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
                      MaterialPageRoute(builder: (context) => const Pickup()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
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
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => ReportsPage()));
              //     },
              //     child: Container(
              //       height: 50,
              //       width: 250,
              //       decoration: BoxDecoration(
              //         color: Colors.redAccent,
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
              //             "REPORTS          ",
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReturnVehicle(),
                        ));
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
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
                          "RETURN VEHICLE",
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
              ImageGalleryButton(true)
            ],
          ),
        ),
      ],
    );
  }
}

class ImageGalleryButton extends StatelessWidget {
  const ImageGalleryButton(
    bool bool, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            color: Colors.orangeAccent,
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
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('pickups')
            .where('job_provider',
                isEqualTo: Provider.of<UserProvider>(context).userId)
            .get(),
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
