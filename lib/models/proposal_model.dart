import 'package:cloud_firestore/cloud_firestore.dart';

class ProposalModel {
   String? title;
   String? description;
   String? targetAmount;
   double? currentAmount;
   String? status;
   String? userId;
   String? ownerName;
   String? address;
   String? id;
   int? numberOfContibutors;
   int? numberOfViews;
   double? roi;
   String? titleDeedNumber;
   GeoPoint? location;
   List<dynamic>? images;
   List<dynamic>? imageFiles;
   Timestamp? createdAt;

  ProposalModel(
      {this.title,
      this.description,
      this.targetAmount,
      this.currentAmount,
      this.imageFiles,
      this.status,
      this.userId,
      this.ownerName,
      this.address,
      this.id,
      this.numberOfContibutors = 0,
      this.numberOfViews = 0,
      this.roi,
      this.titleDeedNumber,
      this.location,
      this.images,
      this.createdAt});

  factory ProposalModel.fromJson(dynamic json) {
    return ProposalModel(
      title: json['title'],
      description: json['description'],
      targetAmount: json['targetAmount'].toString(),
      currentAmount: double.parse(json['currentAmount'].toString()),
      status: json['status'],
      userId: json['userId'],
      ownerName: json['ownerName'],
      address: json['address'],
      id: json['id'],
      numberOfContibutors: json['numberOfContibutors'] ?? 0,
      numberOfViews: json['numberOfViews'] ?? 0,
      roi: double.parse(json['roi'].toString()),
      titleDeedNumber: json['titleDeedNumber'],
      location: json['location'],
      images: json['images'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'targetAmount': targetAmount ?? 0,
      'currentAmount': currentAmount ?? 0,
      'status': status ?? "pending",
      'userId': userId,
      'ownerName': ownerName,
      'address': address,
      'id': id,
      'numberOfContibutors': numberOfContibutors ?? 0,
      'numberOfViews': numberOfViews ?? 0,
      'roi': roi ?? 0,
      'titleDeedNumber': titleDeedNumber,
      'location': location,
      'images': images,
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }
}
