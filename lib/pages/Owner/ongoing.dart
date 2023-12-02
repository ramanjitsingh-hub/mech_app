import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/userprovider.dart';

class OngoingJobsPage extends StatelessWidget {
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
            .where('status', isEqualTo: 'ongoing')
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
                // Create your ListTile widgets using 'data' here
                // Example:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                            child: data['job_status'] == 'WORK IN PROGRESS'
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
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
