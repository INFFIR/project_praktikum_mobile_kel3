// lib/app/modules/transaction/models/payment_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String paymentId;
  final String userId;
  final String productId;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime timestamp;

  PaymentModel({
    required this.paymentId,
    required this.userId,
    required this.productId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.timestamp,
  });

  // Factory constructor to create a PaymentModel from a Firestore document
  factory PaymentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PaymentModel(
      paymentId: documentId,
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      status: map['status'] ?? 'pending',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Method to convert PaymentModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
