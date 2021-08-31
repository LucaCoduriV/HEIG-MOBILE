import 'package:hive_flutter/adapters.dart';

part 'user.g.dart';

@HiveType(typeId: 8)
class User {
  @HiveField(0)
  late String firstname;
  @HiveField(1)
  late String lastname;
  @HiveField(2)
  late String email;
  @HiveField(3)
  late String phone;
  @HiveField(4)
  late String address;
  @HiveField(5)
  late String city;
  @HiveField(6)
  late String avatarUrl;

  User(String firstname, String lastname, String email, String phone,
      String address, String city, String avatarUrl) {
    this.firstname = firstname;
    this.lastname = lastname;
    this.email = email;
    this.phone = phone;
    this.address = address;
    this.city = city;
    this.avatarUrl = avatarUrl;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['firstname'] as String,
      json['lastname'] as String,
      json['email'] as String,
      json['phone'] as String,
      json['address'] as String,
      json['city'] as String,
      json['img'] as String,
    );
  }

  @override
  String toString() {
    return 'User{firstname: $firstname, lastname: $lastname, email: $email, phone: $phone, address: $address, city: $city, avatarUrl: $avatarUrl}';
  }
}
