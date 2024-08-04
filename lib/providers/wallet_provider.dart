import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/mpesa_service.dart';

class WalletProvider with ChangeNotifier {
  final MPesaService _mpesaService = MPesaService();
  double _balance = 0.0;
  double _totalContributions = 0.0;
  double _totalPayouts = 0.0;
  List<Map<String, dynamic>> _transactions = [];

  double get balance => _balance;
  double get totalContributions => _totalContributions;
  double get totalPayouts => _totalPayouts;
  List<Map<String, dynamic>> get transactions => _transactions;

  WalletProvider() {
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    // Assume we have user ID
    String userId = 'some-user-id';
    
    try {
      // Fetch user wallet data
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _balance = userData['account_balance'] ?? 0.0;
        _totalContributions = userData['total_contributions'] ?? 0.0;
      }
      
      // Fetch user transactions
      QuerySnapshot transactionDocs = await FirebaseFirestore.instance
          .collection('mpesa_transactions')
          .where('user_id', isEqualTo: userId)
          .get();
      
      _transactions = transactionDocs.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      _totalPayouts = _transactions
          .where((t) => t['transaction_type'] == 'withdrawal')
          .map((t) => t['amount'] as double)
          .fold(0.0, (prev, element) => prev + element);
      
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error loading wallet data: $e');
    }
  }

  Future<void> initiateDeposit(String phoneNumber, double amount, String userId) async {
    try {
      // Call M-Pesa API to initiate deposit
      await _mpesaService.deposit(phoneNumber, amount, userId);
      // Update local state if necessary
      await _loadWalletData();
    } catch (e) {
      // Handle error
      print('Error initiating deposit: $e');
      rethrow;
    }
  }

  Future<void> initiateWithdraw(String phoneNumber, double amount, String userId) async {
    try {
      // Call M-Pesa API to initiate withdrawal
      await _mpesaService.withdraw(phoneNumber, amount, userId);
      // Update local state if necessary
      await _loadWalletData();
    } catch (e) {
      // Handle error
      print('Error initiating withdrawal: $e');
      rethrow;
    }
  }
}
