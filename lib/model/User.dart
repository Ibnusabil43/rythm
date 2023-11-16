import 'package:flutter/material.dart';

class Users {
  final String? id;
  final String email;
  final String username;

  const Users({
    required this.id,
    required this.email,
    required this.username,
  });

  toJson() {
    return {
      "id": id,
      "email": email,
      "username": username,
    };
  }
}
