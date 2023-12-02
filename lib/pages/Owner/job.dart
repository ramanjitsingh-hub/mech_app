import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/userprovider.dart';

class Job extends StatefulWidget {
  const Job({super.key});

  @override
  State<Job> createState() => _JobState();
}

// Function to show a popup list of available drivers
void _showDriverList(BuildContext context, String jobId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Available Drivers'),
        content: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'driver')
              .where('status', isEqualTo: 'free')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No available drivers found.'));
            } else {
              return Container(
                height: 300,
                width: 300,
                child: ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> driverData =
                          document.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            String selectedDriverId =
                                document.id; // Get selected driver's ID
                            await FirebaseFirestore.instance
                                .collection('pickups')
                                .doc(jobId)
                                .update({'driver': selectedDriverId});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(selectedDriverId)
                                .update({'status': "On Job"});
                            print(
                                'Assigned driver with ID $selectedDriverId to job $jobId');
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.redAccent,
                            ),
                            child: Center(
                              child: Text(
                                driverData['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              );
            }
          },
        ),
      );
    },
  );
}

class _JobState extends State<Job> {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserProvider>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Jobs'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pickups')
            .where('driver', isEqualTo: 'fetch')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No ongoing jobs found.'));
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String jobId = document.id;
                // Create your ListTile widgets using 'data' here
                // Example:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      _showDriverList(context, jobId);
                    },
                    child: Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.lightGreen,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                              left: 20,
                              top: 20,
                              child: Text(
                                data['vehicleNumber'],
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Positioned(
                              left: 20,
                              top: 50,
                              child: Text(
                                data['name'] + ' (' + data['phoneNumber'] + ")",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Positioned(
                              left: 20,
                              top: 70,
                              child: Text(
                                data['address'],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Positioned(
                            left: 290,
                            top: 20,
                            child: Container(
                              height: 100,
                              width: 100,
                              child: data['job_status'] == 'ongoing'
                                  ? Image.asset(
                                      "assets/wop.png",
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/driver.png",
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          Positioned(
                              left: 20,
                              top: 100,
                              child: Text(
                                "Job Status : " + data['job_status'],
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),

                      // Add more ListTile fields as needed based on your data structure
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
