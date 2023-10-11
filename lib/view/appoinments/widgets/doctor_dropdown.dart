import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:project/view/appoinments/add_appoi.dart';
import 'package:project/view/home_screen.dart';

class DoctorDropdown extends StatefulWidget {
  DoctorDropdown({
    super.key,
    required this.doctorNameController,
  });
  final TextEditingController doctorNameController;

  @override
  State<DoctorDropdown> createState() => _DoctorDropdownState();
}

class _DoctorDropdownState extends State<DoctorDropdown> {
  List<String> doctorNames = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            doctorNames.clear();
            final patients = snapshot.data!.docs;
            for (var patient in patients) {
              var data = patient.data();
              String patientName =
                  data['name']; // Replace 'Name' with your Firestore field name
              doctorNames.add(patientName);
            }

            return Container(
              width: 250,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Select Patient',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: doctorNames
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: selectedDoctor,
                  onChanged: (value) {
                    setState(() {
                      selectedDoctor = value!;
                    });
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: 200,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 200,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: widget.doctorNameController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: widget.doctorNameController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for an item...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value.toString().contains(searchValue);
                    },
                  ),
                  //This to clear the search value when you close the menu
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      widget.doctorNameController.clear();
                    }
                  },
                ),
              ),
            );
          } else {
            return Container(
              width: 250,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }
        });
  }
}
