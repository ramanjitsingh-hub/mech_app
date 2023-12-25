import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mech_app/provider/userprovider.dart';
import 'package:provider/provider.dart';

class ReturnVehicle extends StatelessWidget {
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
            .where('job_provider', isEqualTo: userId)
            .where('status', isEqualTo: 'ongoing')
            .where('job_status', isEqualTo: "Car at Dealership")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Vehicles Ready for Pickup.'));
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                // Create your ListTile widgets using 'data' here
                // Example:
                return GestureDetector(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Request Driver'),
                              content: const Text(
                                  'Would You Like to Request Driver for Pickup'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('pickups')
                                        .doc(document.id)
                                        .update({
                                      'driver': 'fetch',
                                      'job_status': 'waiting for return driver',
                                    });

                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ));
                  },
                  child: Padding(
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
                            left: 290,
                            top: 20,
                            child: Container(
                              height: 100,
                              width: 100,
                              child: data['job_status'] == 'ongoing' ||
                                      data['job_status'] == 'Car at Dealership'
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
