import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';


class MPesaService {
  final String _consumerKey = 'G80XApAmHSFUz0LzDbhQdAyQ5jhAhMMO6jgIqAe6ZrAo9zMm';
  final String _consumerSecret = '2myesCsEecg3XzadjD25uLFjQPZEPhp9P59YSGwvHo1cx8eMkBh9OotYNTXnDb6d';
  final String _baseUrl = 'https://sandbox.safaricom.co.ke'; // Use production URL for live app
  final String _shortcode = '174379';
  final String _passkey = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';

  Future<String> _getAccessToken() async {
    String credentials = base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'));
    final response = await http.get(
      Uri.parse('https://cors-anywhere.herokuapp.com/$_baseUrl/oauth/v1/generate?grant_type=client_credentials'),
      headers: {
        'Authorization': 'Basic $credentials',
      },
    );

    print('Access Token Response Status: ${response.statusCode}');
    print('Access Token Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception('Failed to get access token: ${response.body}');
    }
  }

  

  Future<Map<String, dynamic>> initiateSTKPush(String phoneNumber, double amount, String userId) async {
    final accessToken = await _getAccessToken();
    final timestamp = DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
    final password = base64Encode(utf8.encode('$_shortcode$_passkey$timestamp'));

    final response = await http.post(
      Uri.parse('https://cors-anywhere.herokuapp.com/$_baseUrl/mpesa/stkpush/v1/processrequest'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'BusinessShortCode': _shortcode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount.toString(),
        'PartyA': phoneNumber,
        'PartyB': _shortcode,
        'PhoneNumber': phoneNumber,
        'CallBackURL': 'https://us-central1-application-chama.cloudfunctions.net/mpesa-callback',
        'AccountReference': userId,
        'TransactionDesc': 'Chama/ROSCA Payment',
      }),
    );

    print('STK Push Response Status: ${response.statusCode}');
    print('STK Push Response Body: ${response.body}');

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      await _saveTransaction(userId, phoneNumber, amount, result);
      return result;
    } else {
      throw Exception('Failed to initiate STK push: ${response.body}');
    }
  }

  Future<void> _saveTransaction(String userId, String phoneNumber, double amount, Map<String, dynamic> mpesaResponse) async {
    await FirebaseFirestore.instance.collection('mpesa_transactions').add({
      'user_id': userId,
      'phone_number': phoneNumber,
      'amount': amount,
      'status': 'pending',
      'transaction_id': mpesaResponse['CheckoutRequestID'],
      'created_at': FieldValue.serverTimestamp(),
      'transaction_type': 'deposit',
    });
  }

  Future<void> deposit(String phoneNumber, double amount, String userId) async {
    await initiateSTKPush(phoneNumber, amount, userId);
  }

  Future<void> withdraw(String phoneNumber, double amount, String userId) async {
    await initiateSTKPush(phoneNumber, amount, userId);
  }
}



