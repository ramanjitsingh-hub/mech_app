import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mech_app/pages/Driver/driver.dart';
import 'package:mech_app/provider/userprovider.dart';
import 'package:mech_app/widgets/photos.submit.dart';
import 'package:provider/provider.dart';

class TimelineWidget extends StatefulWidget {
  final String currentPickupId;

  TimelineWidget({required this.currentPickupId});

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  @override
  Widget build(BuildContext context) {
    Future<void> refreshData() async {
      setState(
          () {}); // Trigger a rebuild by setting state to refresh the FutureBuilder
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('pickups')
          .doc(widget.currentPickupId)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('No data found');
        } else {
          String? jobStatus = snapshot.data!.get('job_status');
          bool isTapped = false;

          if (jobStatus == 'waiting for driver') {
            return Column(
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (!isTapped && jobStatus == 'Waiting for driver') {
                      await FirebaseFirestore.instance
                          .collection('pickups')
                          .doc(widget.currentPickupId)
                          .update({'job_status': 'At Customer Location'});
                      setState(() {
                        isTapped = true;
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    child: Center(
                      child: Text(
                        "Reached Location",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: jobStatus == 'Waiting for driver'
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (jobStatus == 'At Customer Location') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubmitPhotosPage(
                            currentPickupId: widget.currentPickupId,
                          ),
                        ),
                      );
                      refreshData();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    child: Center(
                      child: Text(
                        "Submit Photos",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: jobStatus == 'At Customer Location'
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    print('Job Status: $jobStatus');
                    try {
                      if (jobStatus == 'Images Recieved') {
                        await FirebaseFirestore.instance
                            .collection('pickups')
                            .doc(widget.currentPickupId)
                            .update({'job_status': 'Leaving for Delearship'});
                        refreshData();
                      }
                    } catch (e) {
                      print('Error updating job status: $e');
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    child: Center(
                      child: Text(
                        "Go to Dealer Location",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: jobStatus == 'Images Recieved'
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      if (jobStatus == 'Leaving for Delearship') {
                        await FirebaseFirestore.instance
                            .collection('pickups')
                            .doc(widget.currentPickupId)
                            .update({
                          'job_status': 'Car at Dealership',
                          'driver': 'fetch'
                        });
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(Provider.of<UserProvider>(context,
                                    listen: false)
                                .userId)
                            .update({'status': 'free'});
                        refreshData();
                      }
                    } catch (e) {
                      print('Error updating job status: $e');
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    child: Center(
                      child: Text(
                        "Car At Dealership",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: jobStatus == 'Leaving for Delearship'
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (!isTapped && jobStatus == 'Leaving for Dealership') {
                      await FirebaseFirestore.instance
                          .collection('pickups')
                          .doc(widget.currentPickupId)
                          .update({'job_status': 'At Dealership'});
                      setState(() {
                        isTapped = true;
                      });
                      refreshData();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    child: Center(
                      child: Text(
                        "Reached Dealership",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: jobStatus == 'Leaving for Dealership'
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    try {
                      if (jobStatus == 'At Dealership') {
                        await FirebaseFirestore.instance
                            .collection('pickups')
                            .doc(widget.currentPickupId)
                            .update({'job_status': 'Leaving for Customer'});
                        refreshData();
                      }
                    } catch (e) {
                      print('Error updating job status: $e');
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    child: Center(
                      child: Text(
                        "Go to Customer",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: jobStatus == 'At Dealership'
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      if (jobStatus == 'Leaving for Customer') {
                        await FirebaseFirestore.instance
                            .collection('pickups')
                            .doc(widget.currentPickupId)
                            .update({
                          'job_status': 'Car Reached Customer',
                          'status': 'Completed',
                          'driver': 'fetch'
                        });
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(Provider.of<UserProvider>(context,
                                    listen: false)
                                .userId)
                            .update({'status': 'free'});
                        refreshData();
                      }
                    } catch (e) {
                      print('Error updating job status: $e');
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    child: Center(
                      child: Text(
                        "Reached Customer",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: jobStatus == 'Leaving for Customer'
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}
