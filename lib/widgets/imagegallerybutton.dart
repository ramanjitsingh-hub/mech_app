import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mech_app/provider/userprovider.dart';
import 'package:provider/provider.dart';

class ImageGalleryButton extends StatelessWidget {
  bool isplus = true;

  ImageGalleryButton({super.key, required this.isplus});

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
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
