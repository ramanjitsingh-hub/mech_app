import 'package:flutter/material.dart';

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
            children: [
              Container(
                  height: 250,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ))
            ],
          )
        ],
      )),
    );
  }
}
