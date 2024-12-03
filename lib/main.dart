import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/models/grouped_list_model.dart';

void main() {
  runApp(CarList());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

class CarList extends StatefulWidget {
  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  List<Car> cars = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCarsFromJson().then((data) {
      setState(() {
        cars = data;
        loading = false;
      });
    });
  }

  Future<List<Car>> loadCarsFromJson() async {
    final jsonString = await rootBundle.loadString('assets/cars_data.json');
    final jsonData = jsonDecode(jsonString);
    return (jsonData['cars'] as List)
        .map((data) => Car.fromJson(data))
        .toList();
  }

  // Filtering the cars by company
  List<Car> filterCarsByCompany(String company) {
    return cars.where((car) => car.company == company).toList();
  }

  // Display the brand section
  Widget brandSection(String company) {
    List<Car> brandCars = filterCarsByCompany(company);
    bool showMore = brandCars.length > 4;
    List<Car> displayCars = showMore ? brandCars.sublist(0, 5) : brandCars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          company,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayCars.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(displayCars[index].name),
            );
          },
        ),
        if (showMore)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Show all cars in this category
                setState(() {
                  // When showMore is tapped, show all cars
                  displayCars = brandCars;
                });
              },
              child: const Text('Show More'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  brandSection('Honda'),
                  brandSection('Hyundai'),
                  brandSection('Mahindra'),
                  brandSection('Tata'),
                ],
              ),
      ),
    );
  }
}
