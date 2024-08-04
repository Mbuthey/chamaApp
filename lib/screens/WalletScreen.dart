import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Account Balance Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            _buildCurrentBalanceSection(walletProvider.balance),
            const SizedBox(height: 20),
            _buildDepositWithdrawButtons(context, walletProvider),
            const SizedBox(height: 20),
            _buildTotalContributionsAndPayouts(walletProvider),
            const SizedBox(height: 20),
            _buildTabs(context, walletProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBalanceSection(double balance) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Current Balance",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "$balance Ksh",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositWithdrawButtons(BuildContext context, WalletProvider walletProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => _showDepositDialog(context, walletProvider),
          child: const Text('Deposit Money'),
        ),
        ElevatedButton(
          onPressed: () => _showWithdrawDialog(context, walletProvider),
          child: const Text('Withdraw Money'),
        ),
      ],
    );
  }

  void _showDepositDialog(BuildContext context, WalletProvider walletProvider) {
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Deposit via M-Pesa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await walletProvider.initiateDeposit(
                                phoneController.text,
                                double.parse(amountController.text),
                                user.uid,
                              );
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Check your phone for the STK push')),
                              );
                            } else {
                              throw Exception('User not logged in');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: const Text('Deposit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showWithdrawDialog(BuildContext context, WalletProvider walletProvider) {
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Withdraw via M-Pesa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await walletProvider.initiateWithdraw(
                                phoneController.text,
                                double.parse(amountController.text),
                                user.uid,
                              );
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Withdrawal initiated, check your phone for confirmation')),
                              );
                            } else {
                              throw Exception('User not logged in');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: const Text('Withdraw'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTotalContributionsAndPayouts(WalletProvider walletProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Text('Total Contributions'),
            Text('${walletProvider.totalContributions} Ksh'),
          ],
        ),
        Column(
          children: [
            const Text('Total Payouts'),
            Text('${walletProvider.totalPayouts} Ksh'),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, WalletProvider walletProvider) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'All Transactions'),
              Tab(text: 'Deposits'),
              Tab(text: 'Withdrawals'),
            ],
          ),
          SizedBox(
            height: 400, // Set a fixed height
            child: TabBarView(
              children: [
                _buildTransactionList(walletProvider.transactions),
                _buildTransactionList(walletProvider.transactions.where((t) => t['transaction_type'] == 'deposit').toList()),
                _buildTransactionList(walletProvider.transactions.where((t) => t['transaction_type'] == 'withdrawal').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> transactions) {
    return SingleChildScrollView(
      child: Column(
        children: transactions.map((transaction) {
          return ListTile(
            title: Text('${transaction['transaction_type']} - ${transaction['amount']} Ksh'),
            subtitle: Text('Status: ${transaction['status']}'),
            trailing: Text(transaction['created_at'].toDate().toString()),
          );
        }).toList(),
      ),
    );
  }
}
