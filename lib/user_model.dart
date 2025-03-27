class User {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      token: json['token'],
    );
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
    );
  }
}
