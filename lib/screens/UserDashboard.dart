import 'package:chama/services/fcm_service.dart';
import 'package:chama/utils/constants.dart';
import 'package:chama/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chama/services/firebase_service.dart';
import 'package:chama/screens/GroupsScreen.dart';
import 'package:chama/screens/WalletScreen.dart';
import 'package:chama/screens/Analytics.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}


class _UserDashboardState extends State<UserDashboard> {
  final FCMService _fcmService = FCMService();
  final FirebaseService _firebaseService = FirebaseService();
  int _selectedIndex = 0;
  List<dynamic> groups = [];
  List<dynamic> groupsDataInSharedPref = [];
  bool isLoading = true;
  String? fullName;
  List<Map<String, dynamic>> groupsInfoData = [];
  List<Map<String, dynamic>> upcomingContributions = [];
  List<Pod> pods = [];
  List<String> pendingInvites = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeFCM();
    _loadData();
  }

   Future<void> _initializeFCM() async {
  await _fcmService.init();
  String? token = await _fcmService.getToken();
  print("FCM Token: $token");
  if (token != null) {
    var user;
    await _firebaseService.updateFCMToken(user.uid, token);
  }
}
  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loadSharedPrefs();
      await fetchGroups();
      await fetchUpcomingContributions();
      await fetchPods();
      await fetchPendingInvites();
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<String> images = [
    "https://i.imgur.com/CzXTtJV.jpg",
    "https://i.imgur.com/OB0y6MR.jpg",
    "https://farm2.staticflickr.com/1533/26541536141_41abe98db3_z_d.jpg",
    "https://farm4.staticflickr.com/3075/3168662394_7d7103de7d_z_d.jpg",
    "https://farm9.staticflickr.com/8505/8441256181_4e98d8bff5_z_d.jpg",
    "https://i.imgur.com/OnwEDW3.jpg",
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupIdController = TextEditingController();
  final TextEditingController _groupSecretCodeController =
      TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _contributionAmountController =
      TextEditingController();

  String? creatorUserId;
  String? creatorFirstName;
  String? creatorLastName;
  String? creatorImageUrl;

  @override
  void dispose() {
    _groupIdController.dispose();
    _groupSecretCodeController.dispose();
    _groupNameController.dispose();
    _contributionAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadSharedPrefs() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        fullName =
            "${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}"
                .trim();
      });
    } else {
      print("No authenticated user found");
    }
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(message)),
    );
  }

  Future<void> fetchPods() async {
    // Fetch pods where user is admin or member
    // Update this method in your FirebaseService
    pods = (await _firebaseService.fetchUserPods()).cast<Pod>();
    setState(() {});
  }

  Future<void> fetchPendingInvites() async {
    // Fetch pods where user is admin and there are pending invites
    // Implement this method in your FirebaseService
    pendingInvites = await _firebaseService.fetchPendingInvites();
    setState(() {});
  }

  Future<void> fetchGroups() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print("No authenticated user found in fetchGroups");
        return;
      }

      List<Map<String, dynamic>> pods = await _firebaseService.fetchUserPods();

      print("Fetched ${pods.length} pods");

      for (var pod in pods) {
        print(
            "Pod: ${pod['name']}, Role: ${pod['role']}, isAdmin: ${pod['isAdmin']}");
      }

      setState(() {
        groups = pods;
        groupsInfoData = createGroupsInfoData(pods);
      });
    } catch (e) {
      print("Error fetching groups: $e");
    }
  }

  Future<void> _createPod(String name, String description, String secretCode,
      double contributionAmount) async {
    print("Starting _createPod method");
    print(
        "Name: $name, Description: $description, SecretCode: $secretCode, Amount: $contributionAmount");

    if (name.isEmpty ||
        description.isEmpty ||
        secretCode.isEmpty ||
        contributionAmount <= 0) {
      print("Validation failed");
      displayErrorToastMessage(context, 'Please fill all fields correctly');
      return;
    }

    try {
      print("Setting isLoading to true");
      setState(() => isLoading = true);

      print("Calling _firebaseService.createPod");
      String? podId = await _firebaseService.createPod(
        name: name,
        description: description,
        secretCode: secretCode,
        contributionAmount: contributionAmount,
      );

      print("Pod creation result: $podId");

      if (podId != null) {
        print("Fetching groups");
        await fetchGroups();
        print("Displaying success message");
        displaySuccessToastMessage(context, "Pod Created Successfully");
      } else {
        print("Pod creation failed");
        displayErrorToastMessage(context, 'Failed to create pod');
      }
    } catch (error) {
      print("Error caught: $error");
      displayErrorToastMessage(context, 'An error occurred: $error');
    } finally {
      print("Setting isLoading to false");
      setState(() => isLoading = false);
    }
  }


//   Future<String?> createPod({
//   required String name,
//   required String description,
//   required String secretCode,
//   required double contributionAmount,
// }) async {
//   try {
//     User? user = _auth.currentUser;
//     if (user == null) throw Exception('No authenticated user found');

//     DocumentReference podRef = await _firestore.collection('pods').add({
//       'name': name,
//       'description': description,
//       'secretCode': secretCode,
//       'contributionAmount': contributionAmount,
//       'adminId': user.uid,
//       'memberIds': [user.uid],
//       'pendingInvites': [],
//       'createdAt': FieldValue.serverTimestamp(),
//     });

//     return podRef.id;
//   } catch (e) {
//     print('Error creating pod: $e');
//     return null;
//   }
// }

  Future<void> _joinPod(String secretCode) async {
    setState(() => isLoading = true);

    try {
      Map<String, dynamic> result = await _firebaseService.joinPod(secretCode);
      if (result['success']) {
        await fetchGroups(); // Refresh the groups list
        displaySuccessToastMessage(context, result['message']);
        Navigator.of(context).pop(); // Close the join pod dialog
      } else {
        displayErrorToastMessage(context, result['message']);
      }
    } catch (e) {
      displayErrorToastMessage(context, 'An error occurred: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>> joinPod(String secretCode) async {
  User? user = _auth.currentUser;
  if (user == null) throw Exception('No authenticated user found');

  QuerySnapshot podQuery = await _firestore
      .collection('pods')
      .where('secretCode', isEqualTo: secretCode)
      .limit(1)
      .get();

  if (podQuery.docs.isEmpty) {
    return {'success': false, 'message': 'No pod found with this secret code.'};
  }

  String podId = podQuery.docs.first.id;

  QuerySnapshot existingMembership = await _firestore
      .collection('podMemberships')
      .where('podId', isEqualTo: podId)
      .where('userId', isEqualTo: user.uid)
      .get();

  if (existingMembership.docs.isNotEmpty) {
    return {'success': false, 'message': 'You are already a member of this pod.'};
  }

  await _firestore.collection('pods').doc(podId).update({
    'members': FieldValue.arrayUnion([user.uid]),
  });

  await _firestore.collection('podMemberships').add({
    'podId': podId,
    'userId': user.uid,
    'role': 'member',
    'joinedAt': FieldValue.serverTimestamp(),
    'status': 'active',
  });

  return {'success': true, 'message': 'Successfully joined the pod.'};
}

  Future<void> fetchUpcomingContributions() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print("No authenticated user found in fetchUpcomingContributions");
        return;
      }

      List<Map<String, dynamic>> contributions =
          await _firebaseService.fetchUpcomingContributions();
      setState(() {
        upcomingContributions = contributions;
      });
    } catch (e) {
      print("Error fetching upcoming contributions: $e");
    }
  }

  List<Map<String, dynamic>> createGroupsInfoData(List<dynamic> pods) {
    return pods.map((pod) {
      return {
        'group_secret_code': pod['secretCode'] ?? '',
        'role_id': pod['role']?.toString() ?? '',
        'group_name': pod['name'] ?? 'N/A',
        'individual_due_amount': pod['contributionAmount']?.toString() ?? 'N/A',
        'group_pot_amount': pod['totalPotAmount']?.toString() ?? 'N/A',
        'group_status': pod['status']?.toString() ?? 'N/A',
        'individual_next_payment_date': pod['nextContributionDate'],
        'isAdmin': pod['isAdmin'] ?? false,
      };
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home - Already on UserDashboard
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GroupsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WalletScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Analytics()),
        );
        break;
      case 4:
        // More - Not implemented yet
        break;
    }
  }

  void _showJoinPodDialog() {
    final formKey = GlobalKey<FormState>();
    String secretCode = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join Pod'),
          content: Form(
            key: formKey,
            child: TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Enter Pod Secret Code'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the secret code';
                }
                return null;
              },
              onSaved: (value) => secretCode = value!,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Join'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.of(context).pop();
                  await _joinPod(secretCode);
                }
              },
            ),
          ],
        );
      },
    );
    _firebaseService.requestToJoinPod(secretCode).then((result) {
      if (result['success']) {
        displaySuccessToastMessage(context, result['message']);
      } else {
        displayErrorToastMessage(context, result['message']);
      }
    });
  }


  Future<Map<String, dynamic>> requestToJoinPod(String secretCode) async {
  try {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    QuerySnapshot podQuery = await _firestore
        .collection('pods')
        .where('secretCode', isEqualTo: secretCode)
        .limit(1)
        .get();

    if (podQuery.docs.isEmpty) {
      return {'success': false, 'message': 'No such pod exists'};
    }

    DocumentReference podRef = podQuery.docs.first.reference;
    Pod pod = Pod.fromMap(podQuery.docs.first.data() as Map<String, dynamic>);

    if (pod.memberIds.contains(user.uid)) {
      return {'success': false, 'message': 'You are already a member of this pod'};
    }
    if (pod.pendingInvites.contains(user.uid)) {
      return {'success': false, 'message': 'Your invitation is pending admin approval'};
    }

    await podRef.update({
      'pendingInvites': FieldValue.arrayUnion([user.uid])
    });

    return {'success': true, 'message': 'Your invite has been sent to the group\'s admin'};
  } catch (e) {
    print('Error requesting to join pod: $e');
    return {'success': false, 'message': 'An error occurred while processing your request'};
  }
}

  // Future<void> _joinPod(String secretCode) async {
  //   try {
  //     Map<String, dynamic> result = await _firebaseService.joinPod(secretCode);
  //     if (result['success']) {
  //       displaySuccessToastMessage(context, result['message']);
  //     } else {
  //       displayErrorToastMessage(context, result['message']);
  //     }
  //   } catch (e) {
  //     displayErrorToastMessage(context, e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    try {
      if (isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return SafeArea(
        child: Scaffold(
          backgroundColor: Constants.colorPrimary,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi ${fullName ?? ''}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            "We're glad to have you back!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined),
                        onPressed: () {
                          // Handle notifications
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton('Create Pod', Icons.group_add,
                          () => _showCreatePodDialog()),
                      _buildActionButton(
                          'Join Pod', Icons.group, () => _showJoinPodDialog()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My active pods',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle see all
                        },
                        child: const Text('See all'),
                      ),
                      TextButton(
                        onPressed: _showAllActivePods,
                        child: const Text('See all'),
                      ),
                      TextButton(
                        onPressed: _showAllUpcomingContributions,
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: groupsInfoData.isEmpty
                        ? _buildEmptyState('You have no active pods')
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: groupsInfoData.length,
                            itemBuilder: (context, index) =>
                                _buildPodCard(groupsInfoData[index]),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming contributions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle see all
                        },
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  upcomingContributions.isEmpty
                      ? _buildEmptyState('No upcoming contributions')
                      : Column(
                          children: upcomingContributions
                              .map((contribution) =>
                                  _buildContributionCard(contribution))
                              .toList(),
                        ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Pods'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.analytics), label: 'Analytics'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz), label: 'More'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error in UserDashboard build method: $e');
      print('Stack trace: $stackTrace');
      return Scaffold(
        body: Center(
          child: Text('An error occurred: $e'),
        ),
      );
    }
  }

  Widget _buildActionButton(
      String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.bgLightBrown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.brown),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

 Widget _buildPodCard(Map<String, dynamic> pod) {
  print("Building pod card for: ${pod['group_name']}");
  print("Pod data: $pod");

  final bool isAdmin = pod['isAdmin'] == true;

  return Card(
    color: Constants.bgDarkGreen,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAdmin ? 'admin' : 'member',
                style: const TextStyle(color: Colors.white),
              ),
              if (isAdmin)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (String result) {
                    if (result == 'edit') {
                      _showEditPodDialog(pod as Pod);
                    } else if (result == 'delete') {
      _showDeletePodDialog(pod as Pod);
    } else if (result == 'invites') {
      _showPendingInvitesDialog(pod as Pod);
    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit Pod'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
      child: Text('Delete Pod'),
    ),
    const PopupMenuItem<String>(
      value: 'invites',
      child: Text('Manage Invites'),
    ),
                  ],
                ),
            ],
          ),
          // ... rest of the widget remains the same
        ],
      ),
    ),
  );
}

// Update these methods to accept Map<String, dynamic> instead of Pod

void _showEditPodDialog(Pod pod) {
  final formKey = GlobalKey<FormState>();
  String name = pod.name;
  String description = pod.description;
  double contributionAmount = pod.contributionAmount;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Pod'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Pod Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                initialValue: contributionAmount.toString(),
                decoration: const InputDecoration(labelText: 'Contribution Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value!) == null ? 'Please enter a valid number' : null,
                onSaved: (value) => contributionAmount = double.parse(value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                _firebaseService.updatePod(pod.id, name, description as String, contributionAmount).then((_) {
                  Navigator.of(context).pop();
                  fetchPods();
                });
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> updatePod(String groupId, String name, String description, double contributionAmount) async {
  try {
    // Check if the current user is an admin
    User? user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    DocumentSnapshot podDoc = await _firestore.collection('pods').doc(groupId).get();
    if (podDoc.exists && podDoc.get('adminId') == user.uid) {
      await _firestore.collection('pods').doc(groupId).update({
        'name': name,
        'description': description,
        'contributionAmount': contributionAmount,
      });
    } else {
      throw Exception('You do not have permission to update this pod');
    }
  } catch (e) {
    print("Error updating pod: $e");
    rethrow;
  }
}

Future<void> deletePod(String podId) async {
  try {
    await _firestore.collection('pods').doc(podId).delete();
  } catch (e) {
    print("Error deleting pod: $e");
    rethrow;
  }
}


void _showDeletePodDialog(Pod pod) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Pod'),
        content: Text('Are you sure you want to delete ${pod.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              _firebaseService.deletePod(pod.id).then((_) {
                Navigator.of(context).pop();
                fetchPods();
              });
            },
          ),
        ],
      );
    },
  );
}
  void _showPendingInvitesDialog(Pod pod) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pending Invites'),
          content: FutureBuilder<List<String>>(
            future: _firebaseService.fetchPodPendingInvites(pod.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No pending invites');
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => _respondToInvite(pod.id, snapshot.data![index], true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _respondToInvite(pod.id, snapshot.data![index], false),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _respondToInvite(String podId, String userId, bool accept) {
    _firebaseService.respondToJoinRequest(podId, userId, accept).then((result) {
      if (result['success']) {
        displaySuccessToastMessage(context, result['message']);
        Navigator.of(context).pop();
        fetchPendingInvites();
      } else {
        displayErrorToastMessage(context, result['message']);
      }
    });
  }

  Widget _buildContributionCard(Map<String, dynamic> contribution) {
    Color cardColor;
    switch (contribution['status']) {
      case 'pending':
        cardColor = Colors.orange.shade200;
        break;
      case 'paid':
        cardColor = Colors.green.shade200;
        break;
      case 'overdue':
        cardColor = Colors.red.shade200;
        break;
      default:
        cardColor = Colors.grey.shade200;
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(contribution['group_name'] ?? 'Unknown Group'),
        subtitle: Text(
            'Due: ${contribution['individual_next_payment_date'] ?? 'N/A'}'),
        trailing: Text(
          '${contribution['individual_due_amount'] ?? '0'} Ksh',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showCreatePodDialog() {
    final formKey = GlobalKey<FormState>();
    String groupName = '';
    String description = '';
    String secretCode = '';
    double contributionAmount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Pod'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Group Name'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a group name'
                        : null,
                    onSaved: (value) => groupName = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a description'
                        : null,
                    onSaved: (value) => description = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Secret Code'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a secret code'
                        : null,
                    onSaved: (value) => secretCode = value ?? '',
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Contribution Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a contribution amount';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Please enter a valid positive number';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        contributionAmount = double.tryParse(value ?? '') ?? 0,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  Navigator.of(context).pop();
                  _createPod(
                      groupName, description, secretCode, contributionAmount);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showContributionDetailsDialog(
      BuildContext context, Map<String, dynamic> contribution) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(contribution['group_name'] ?? 'Unknown Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: ${contribution['individual_due_amount'] ?? 'N/A'}'),
              Text(
                  'Due Date: ${contribution['individual_next_payment_date'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPodDetailsDialog(BuildContext context, Map<String, dynamic> pod) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pod['group_name'] ?? 'Unknown Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Secret Code: ${pod['group_secret_code']}'),
              Text('Role: ${pod['role_id']}'),
              Text('Contribution Amount: ${pod['individual_due_amount']}'),
              Text('Total Pot Amount: ${pod['group_pot_amount']}'),
              Text('Status: ${pod['group_status']}'),
              Text('Next Payment Date: ${pod['individual_next_payment_date']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPodOptionsDialog(BuildContext context, Map<String, dynamic> pod) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Pod'),
              onTap: () {
                Navigator.pop(context);
                // Add your edit pod logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Pod'),
              onTap: () {
                Navigator.pop(context);
                // Add your delete pod logic here
              },
            ),
          ],
        );
      },
    );
  }

  void _showAllActivePods() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Active Pods'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: groupsInfoData.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                    groupsInfoData[index]['group_name'] ?? 'Unknown Group'),
                subtitle: Text(
                    'Due: ${groupsInfoData[index]['individual_next_payment_date'] ?? 'N/A'}'),
                trailing: Text(
                    '${groupsInfoData[index]['individual_due_amount'] ?? '0'} Ksh'),
                onTap: () =>
                    _showPodDetailsDialog(context, groupsInfoData[index]),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showAllUpcomingContributions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Upcoming Contributions'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: upcomingContributions.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(upcomingContributions[index]['group_name'] ??
                    'Unknown Group'),
                subtitle: Text(
                    'Due: ${upcomingContributions[index]['individual_next_payment_date'] ?? 'N/A'}'),
                trailing: Text(
                    '${upcomingContributions[index]['individual_due_amount'] ?? '0'} Ksh'),
                onTap: () => _showContributionDetailsDialog(
                    context, upcomingContributions[index]),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
