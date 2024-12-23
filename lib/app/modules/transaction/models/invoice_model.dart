// lib/app/modules/transaction/models/invoice_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel {
  final String invoiceId;
  final String userId;
  final String transactionId;
  final double amount;
  final String details;
  final String status;
  final DateTime timestamp;

  InvoiceModel({
    required this.invoiceId,
    required this.userId,
    required this.transactionId,
    required this.amount,
    required this.details,
    required this.status,
    required this.timestamp,
  });

  // Factory constructor to create an InvoiceModel from a Firestore document
  factory InvoiceModel.fromMap(Map<String, dynamic> map, String documentId) {
    return InvoiceModel(
      invoiceId: documentId,
      userId: map['userId'] ?? '',
      transactionId: map['transactionId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      details: map['details'] ?? '',
      status: map['status'] ?? 'unpaid',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Method to convert InvoiceModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'transactionId': transactionId,
      'amount': amount,
      'details': details,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
