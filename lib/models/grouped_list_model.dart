class Car {
  final String name;
  final String company;

  Car({required this.name, required this.company});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      name: json['name'],
      company: json['company'],
    );
  }
}