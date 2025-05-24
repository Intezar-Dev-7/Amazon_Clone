import 'dart:convert';

/* Purpose (Moto) of the File:
 This file defines the `User` model class, which represents a user in the app.
 It is used to structure and manage user-related data such as name, email,
 password, address, user type (e.g., admin, customer), and an authentication token.

 The class includes:
 - A constructor to create User instances
 - Serialization methods (toMap, fromMap, toJson, fromJson) for converting
   User objects to and from Map/JSON formats
 - A `copyWith` method to easily create modified copies of a User instance

 This model is typically used to parse user data received from a backend (e.g., API),
 save user data locally, or send data back to a server.
---------------------------------------------------------------------------*/

/*It acts as a data model to store, transfer, and manipulate user  information efficiently.

The toMap() and fromMap() methods are used for data serialization and deserialization.

toMap(): Converts a Player object into a Map (key-value pairs).

fromMap(): Converts a Map (received from a database, API, or Socket.IO) back into a Player object.*/

/// A model class representing a User in the system
class User {
  final String id;
  final String name;
  final String password;
  final String email;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;

  /// Constructor for creating a new User instance with all required fields
  User({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  /*Converts the User object to a Map <String, dynamic>
  Useful for sending data to APIs or storing locally (e.g., SQLite)*/
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'password': password,
      'email': email,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  /*Factory constructor to create a User object from a map
   This is typically used when parsing data received from APIs or databases*/
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String, // '_id' is common in MongoDB responses
      name: map['name'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      type: map['type'] as String,
      token: map['token'] as String,
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map((x) => Map<String, dynamic>.from(x)),
      ),
    );
  }

  /*Converts the User object to a JSON string
  Useful when sending user data over the network or saving in shared preferences*/
  String toJson() => json.encode(toMap());

  /*Creates a User object from a JSON string
  Helps in decoding responses from APIs into usable User instances*/
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  /*Allows creating a copy of the User object with modified fields
  This supports immutability while updating only specific properties*/
  User copyWith({
    String? id,
    String? name,
    String? password,
    String? email,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
