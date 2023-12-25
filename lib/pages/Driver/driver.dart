import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mech_app/widgets/driver_timeline.dart';
import 'package:provider/provider.dart';

import '../../provider/userprovider.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  width: 250,
                  child: Image.asset("assets/pndlogo.png")),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(Provider.of<UserProvider>(context).userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  } else if (!userSnapshot.hasData ||
                      !userSnapshot.data!.exists) {
                    return Center(child: Text('No user data found'));
                  } else {
                    String userStatus = userSnapshot.data!.get('status');

                    if (userStatus == 'On Job') {
                      // Fetch the pickup document where the driver field matches the current user ID
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('pickups')
                            .where('driver',
                                isEqualTo:
                                    Provider.of<UserProvider>(context).userId)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> pickupSnapshot) {
                          if (pickupSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (pickupSnapshot.hasError) {
                            return Center(
                                child: Text('Error: ${pickupSnapshot.error}'));
                          } else if (!pickupSnapshot.hasData ||
                              pickupSnapshot.data!.docs.isEmpty) {
                            return Center(
                                child: Text('No matching pickup found'));
                          } else {
                            // Render UI with pickup details
                            DocumentSnapshot currentPickup =
                                pickupSnapshot.data!.docs.first;
                            Map<String, dynamic> pickupData =
                                currentPickup.data() as Map<String, dynamic>;

                            return Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orangeAccent.withOpacity(0.7),
                                          Colors.redAccent.withOpacity(0.2),
                                        ],
                                        begin: AlignmentDirectional.topStart,
                                        end: AlignmentDirectional.bottomEnd,
                                      ),
                                      color: Colors.blueGrey,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                "Current Job",
                                                style: GoogleFonts.inter(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "${pickupData['vehicleNumber']}",
                                              style: GoogleFonts.inter(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.7)),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 100,
                                              width: 350,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Address",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          10), // Adjust the space between "Address" and the address text
                                                  Expanded(
                                                    child: Text(
                                                      ": ${pickupData['address']}",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.black54),
                                                      maxLines:
                                                          3, // Limits the text to 2 lines
                                                      overflow: TextOverflow
                                                          .ellipsis, // Ellipsis (...) when text overflows
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Dealer : ",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black
                                                          .withOpacity(0.7)),
                                                ),
                                                Text(
                                                  "${pickupData['job_provider']}",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black
                                                          .withOpacity(0.7)),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TimelineWidget(
                                    currentPickupId: currentPickup.id,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      // Render UI for free status
                      return Container(
                          height: 250,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.orangeAccent.withOpacity(0.7),
                                Colors.redAccent.withOpacity(0.6),
                              ],
                              begin: AlignmentDirectional.topStart,
                              end: AlignmentDirectional.bottomEnd,
                            ),
                            color: Colors.blueGrey,
                          ),
                          child: Center(
                              child: Text(
                            'You are currently free',
                            style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )));
                    }
                  }
                },
              ),
            ],
          )
        ],
      )),
    );
  }
}
