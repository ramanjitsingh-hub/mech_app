import 'package:action_slider/action_slider.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:mech_app/pages/homepage.dart';
import 'package:provider/provider.dart';

import '../firestore/storepickupdata.dart';
import '../provider/userprovider.dart';

class Pickup extends StatefulWidget {
  const Pickup({super.key});

  @override
  State<Pickup> createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _vehicleNumberController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a vehicle number';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (value.length != 10) {
      return 'Phone number should be 10 digits';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  String? _validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a state';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a PIN code';
    } else if (value.length != 6) {
      return 'PIN code should be 6 digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserProvider>(context).userId;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Icon(Icons.arrow_back_ios_new)),
        centerTitle: true,
        title: Text("Schedule Pickup"),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer Name",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 70,
                            width: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffd6e8f5)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: _nameController,
                                validator: _validateName,
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    decorationThickness: 0,
                                    color: Color(0xff43444d),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.5)),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vehicle no.",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 70,
                              width: 170,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffd6e8f5)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  controller: _vehicleNumberController,
                                  validator: _validateVehicleNumber,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      decorationThickness: 0,
                                      color: Color(0xff43444d),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.justify,
                                  decoration: InputDecoration(
                                    hintText: "PBXX-XXX",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.5)),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 70,
                          width: 270,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffd6e8f5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              controller: _phoneNumberController,
                              validator: _validatePhoneNumber,
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  decorationThickness: 0,
                                  color: Color(0xff43444d),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.justify,
                              decoration: InputDecoration(
                                hintText: "+91 XXXXXXXXX",
                                hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.5)),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 100,
                          width: 270,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffd6e8f5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              controller: _addressController,
                              validator: _validateAddress,
                              minLines: 5,
                              maxLines: 10,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  decorationThickness: 0,
                                  color: Color(0xff43444d),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.justify,
                              decoration: InputDecoration(
                                hintText: "House No.X,ABC Enclave",
                                hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.5)),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "State",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 70,
                              width: 170,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffd6e8f5)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: _stateController,
                                  validator: _validateState,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      decorationThickness: 0,
                                      color: Color(0xff43444d),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                  decoration: InputDecoration(
                                    hintText: "Punjab",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.5)),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PINCODE",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 70,
                                width: 170,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xffd6e8f5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TextFormField(
                                    controller: _pincodeController,
                                    validator: _validatePincode,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        decorationThickness: 0,
                                        color: Color(0xff43444d),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.justify,
                                    decoration: InputDecoration(
                                      hintText: "147001",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.withOpacity(0.5)),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: ActionSlider.standard(
                      sliderBehavior: SliderBehavior.stretch,
                      width: 300.0,
                      backgroundColor: Colors.white,
                      toggleColor: Colors.lightBlueAccent,
                      action: (controller) async {
                        if (_formKey.currentState!.validate()) {
                          // All validators pass
                          controller.loading();
                          await Future.delayed(const Duration(seconds: 3));
                          await storePickupData(
                            name: _nameController.text,
                            vehicleNumber: _vehicleNumberController.text,
                            phoneNumber: _phoneNumberController.text,
                            address: _addressController.text,
                            state: _stateController.text,
                            pincode: _pincodeController.text,
                            userid: userId,
                          );
                          controller.success();
                          await Future.delayed(const Duration(seconds: 2));
                          controller.reset();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        } else {
                          return SnackBar(
                              content: Text("Fill in Correct Details"));
                        }
                      },
                      child: const Text('Slide to confirm'),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class _UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(), // Auto capitalize all letters
      selection: newValue.selection,
    );
  }
}
