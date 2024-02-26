import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? email;
  String? name;
  String? phoneNumber;
  String? profilePic;
  final String? userType;
  final bool? isActive;
  final Timestamp? createdAt;
  final String? pushToken;
  final String? password;

  UserModel(
      {this.userId,
      this.email,
      this.name,
      this.phoneNumber,
      this.profilePic,
      this.userType,
      this.isActive,
      this.createdAt,
      this.password,
      this.pushToken});

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      profilePic: json['profilePic'],
      userType: json['userType'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      pushToken: json['pushToken'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic ??
          "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg",
      'userType': userType ?? "farmer",
      'isActive': isActive ?? true,
      'createdAt': createdAt ?? Timestamp.now(),
      'pushToken': pushToken,
      'password': password,
    };
  }
}
