import 'package:cloud_firestore/cloud_firestore.dart';

class InvestmentModel {
  final String? amount;
  final String? paymentMethod;
  String? id;
  final String? ownerId;
  final String? paymentReference;
  final String? proposalId;
  final String? userId;
  final Timestamp? createdAt;

  InvestmentModel(
      {this.amount,
      this.paymentMethod,
      this.id,
      this.ownerId,
      this.paymentReference,
      this.proposalId,
      this.createdAt,
      this.userId});

  factory InvestmentModel.fromJson(dynamic json) {
    return InvestmentModel(
      amount: json['amount'],
      paymentMethod: json['paymentMethod'],
      id: json['id'],
      ownerId: json['ownerId'],
      paymentReference: json['paymentReference'],
      proposalId: json['proposalId'],
      userId: json['userId'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'paymentMethod': paymentMethod,
      'id': id,
      'ownerId': ownerId,
      'paymentReference': paymentReference,
      'proposalId': proposalId,
      'userId': userId,
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }
}
