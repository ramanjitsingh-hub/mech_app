import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> storePickupData({
  required String name,
  required String vehicleNumber,
  required String phoneNumber,
  required String address,
  required String state,
  required String pincode,
  required String userid,
}) async {
  try {
    await FirebaseFirestore.instance.collection('pickups').add({
      'name': name,
      'vehicleNumber': vehicleNumber,
      'phoneNumber': phoneNumber,
      'address': address,
      'state': state,
      'pincode': pincode,
      'status': "ongoing",
      'job_provider': userid,
      'job_status': "fetch",
      'driver': "fetch",
      // Add more fields if necessary
    });
    print('Pickup data added to Firestore');
  } catch (e) {
    print('Error adding pickup data to Firestore: $e');
    // Handle error as needed
  }
}
