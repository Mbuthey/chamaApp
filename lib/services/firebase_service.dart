import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pod {
  final String id;
  final String name;
  final String description;
  final String secretCode;
  final double contributionAmount;
  final String adminId;
  final List<String> memberIds;
  final List<String> pendingInvites;

  Pod({
    required this.id,
    required this.name,
    required this.description,
    required this.secretCode,
    required this.contributionAmount,
    required this.adminId,
    required this.memberIds,
    required this.pendingInvites,
  });
  
  static Pod fromMap(Map<String, dynamic> data) {
    return Pod(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      secretCode: data['secretCode'] ?? '',
      contributionAmount: (data['contributionAmount'] ?? 0).toDouble(),
      adminId: data['adminId'] ?? '',
      memberIds: List<String>.from(data['memberIds'] ?? []),
      pendingInvites: List<String>.from(data['pendingInvites'] ?? []),
    );
  }
  // Add toMap and fromMap methods for Firestore serialization
}

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }
  Future<void> updateFCMToken(String userId, String token) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmToken': token,
    });
  }

  Future<void> sendNotification(String userId, String title, String body) async {
    // Implement server-side notification sending logic
    // This typically involves using a server (e.g., Cloud Functions) to send FCM messages
  }

  Future<void> signUpUser(String email, String password, String firstName,
      String lastName, String nationalIdentifier) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'created_at': FieldValue.serverTimestamp(),
          'account_type': 'email'
        });

        print('User added to Firestore successfully');
      }
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> updateUserName(
      String userId, String newFirstName, String newLastName) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'first_name': newFirstName, 'last_name': newLastName});
      print('User name updated successfully');
    } catch (e) {
      print('Error updating user name: $e');
      rethrow;
    }
  }

  Future<String?> createPod({
    required String name,
    required String description,
    required String secretCode,
    required double contributionAmount,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      DocumentReference podRef = await _firestore.collection('pods').add({
        'name': name,
        'description': description,
        'secretCode': secretCode,
        'contributionAmount': contributionAmount,
        'adminId': user.uid,
        'memberIds': [user.uid],
        'pendingInvites': [],
      });

      return podRef.id;
    } catch (e) {
      print('Error creating pod: $e');
      return null;
    }
  }

// Future<String?> createPod({
//   required String name,
//   required String description,
//   required String secretCode,
//   required double contributionAmount,
// }) async {
//   print("Starting FirebaseService.createPod");
//   User? user = _auth.currentUser;
//   if (user == null) {
//     print("No authenticated user found");
//     return null;
//   }

//   try {
//     print("Adding pod to Firestore");
//     DocumentReference podRef = await _firestore.collection('pods').add({
//       'name': name,
//       'description': description,
//       'secretCode': secretCode,
//       'contributionAmount': contributionAmount,
//       'creatorId': user.uid,
//       'createdAt': FieldValue.serverTimestamp(),
//       'members': [user.uid],
//       'admins': [user.uid],
//       'totalPotAmount': 0,
//       'nextContributionDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
//     });

//     print("Adding podMembership");
//     await _firestore.collection('podMemberships').add({
//       'podId': podRef.id,
//       'userId': user.uid,
//       'role': 'admin',
//       'joinedAt': FieldValue.serverTimestamp(),
//       'status': 'active',
//     });

//     print("Pod created with ID: ${podRef.id}");
//     return podRef.id;
//   } catch (e) {
//     print("Error creating pod: $e");
//     return null;
//   }
// }
  Future<Map<String, dynamic>> joinPod(String secretCode) async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    // Find the pod with the given secret code
    QuerySnapshot podQuery = await _firestore
        .collection('pods')
        .where('secretCode', isEqualTo: secretCode)
        .limit(1)
        .get();

    if (podQuery.docs.isEmpty) {
      return {
        'success': false,
        'message': 'No pod found with this secret code.'
      };
    }

    String podId = podQuery.docs.first.id;

    // Check if the user is already a member
    QuerySnapshot existingMembership = await _firestore
        .collection('podMemberships')
        .where('podId', isEqualTo: podId)
        .where('userId', isEqualTo: user.uid)
        .get();

    if (existingMembership.docs.isNotEmpty) {
      return {
        'success': false,
        'message': 'You are already a member of this pod.'
      };
    }

    // Add user to pod members
    await _firestore.collection('pods').doc(podId).update({
      'members': FieldValue.arrayUnion([user.uid]),
    });

    // Create membership record
    await _firestore.collection('podMemberships').add({
      'podId': podId,
      'userId': user.uid,
      'role': 'member',
      'joinedAt': FieldValue.serverTimestamp(),
      'status': 'active',
    });

    return {'success': true, 'message': 'Successfully joined the pod.'};
  }

  Future<List<Map<String, dynamic>>> fetchUserPods() async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    QuerySnapshot memberships = await _firestore
        .collection('podMemberships')
        .where('userId', isEqualTo: user.uid)
        .get();

    List<Map<String, dynamic>> pods = [];
    for (var membership in memberships.docs) {
      DocumentSnapshot podData =
          await _firestore.collection('pods').doc(membership['podId']).get();
      if (podData.exists) {
        var data = podData.data() as Map<String, dynamic>;
        pods.add({
          ...data,
          'id': podData.id,
          'role': membership['role'],
          'isAdmin': membership['role'] == 'admin',
          'contributionAmount': data['contributionAmount'] ?? 0,
          'totalPotAmount': data['totalPotAmount'] ?? 0,
        });
      }
    }

    print("Fetched ${pods.length} pods for user ${user.uid}"); // Debug print

    return pods;
  }

  // Future<void> joinPod(String podId) async {
  //   User? user = _auth.currentUser;
  //   if (user == null) throw Exception('No authenticated user found');

  //   QuerySnapshot existingMembership = await _firestore
  //       .collection('podMemberships')
  //       .where('podId', isEqualTo: podId)
  //       .where('userId', isEqualTo: user.uid)
  //       .get();

  //   if (existingMembership.docs.isNotEmpty) {
  //     throw Exception('You are already a member of this pod');
  //   }

  //   await _firestore.collection('joinRequests').add({
  //     'podId': podId,
  //     'userId': user.uid,
  //     'status': 'pending',
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });
  // }

 Future<void> updatePod(String groupId, String name, String description, double contributionAmount) async {
    try {
      await _firestore.collection('pods').doc(groupId).update({
        'name': name,
        'description': description,
        'contributionAmount': contributionAmount,
      });
    } catch (e) {
      print("Error updating pod: $e");
      rethrow;
    }
  }

  Future<void> addContribution(
      String podId, double amount, DateTime dueDate, String status) async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await _firestore.collection('contributions').add({
      'userId': user.uid,
      'podId': podId,
      'amount': amount.toString(),
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingContributions() async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    QuerySnapshot contributions = await _firestore
        .collection('contributions')
        .where('userId', isEqualTo: user.uid)
        .where('dueDate', isGreaterThan: Timestamp.now())
        .orderBy('dueDate')
        .limit(5)
        .get();

    return contributions.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        ...data,
        'amount': double.tryParse(data['amount'] ?? '0') ?? 0,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchPodContributions(String podId) async {
    QuerySnapshot contributions = await _firestore
        .collection('contributions')
        .where('podId', isEqualTo: podId)
        .orderBy('dueDate')
        .get();

    return contributions.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        ...data,
        'amount': double.tryParse(data['amount'] ?? '0') ?? 0,
      };
    }).toList();
  }

  Future<void> updatePodTotalAmount(String podId, double newTotal) async {
    await _firestore.collection('pods').doc(podId).update({
      'totalPotAmount': newTotal.toString(),
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

      // Check if user is already a member or has a pending invite
      Pod pod = Pod.fromMap(podQuery.docs.first.data() as Map<String, dynamic>);
      if (pod.memberIds.contains(user.uid)) {
        return {
          'success': false,
          'message': 'You are already a member of this pod'
        };
      }
      if (pod.pendingInvites.contains(user.uid)) {
        return {
          'success': false,
          'message': 'Your invitation is pending admin approval'
        };
      }

      // Add user to pending invites
      await podRef.update({
        'pendingInvites': FieldValue.arrayUnion([user.uid])
      });

      // Notify admin (you'd implement this using FCM or another notification system)
      _notifyAdmin(pod.adminId, 'New join request for ${pod.name}');

      return {
        'success': true,
        'message': 'Your invite has been sent to the group\'s admin'
      };
    } catch (e) {
      print('Error requesting to join pod: $e');
      return {
        'success': false,
        'message': 'An error occurred while processing your request'
      };
    }
  }

  Future<Map<String, dynamic>> respondToJoinRequest(
      String podId, String userId, bool accept) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('No authenticated user found');

      DocumentReference podRef = _firestore.collection('pods').doc(podId);
      DocumentSnapshot podSnapshot = await podRef.get();

      if (!podSnapshot.exists) {
        return {'success': false, 'message': 'Pod not found'};
      }

      Pod pod = Pod.fromMap(podSnapshot.data() as Map<String, dynamic>);

      if (pod.adminId != currentUser.uid) {
        return {
          'success': false,
          'message': 'Only the admin can respond to join requests'
        };
      }

      if (!pod.pendingInvites.contains(userId)) {
        return {'success': false, 'message': 'No pending invite for this user'};
      }

      if (accept) {
        await podRef.update({
          'memberIds': FieldValue.arrayUnion([userId]),
          'pendingInvites': FieldValue.arrayRemove([userId]),
        });
        // Notify user that their request was accepted
        _notifyUser(
            userId, 'Your request to join ${pod.name} has been accepted');
        return {'success': true, 'message': 'User added to the pod'};
      } else {
        await podRef.update({
          'pendingInvites': FieldValue.arrayRemove([userId]),
        });
        // Notify user that their request was denied
        _notifyUser(userId, 'Your request to join ${pod.name} has been denied');
        return {'success': true, 'message': 'User invite denied'};
      }
    } catch (e) {
      print('Error responding to join request: $e');
      return {
        'success': false,
        'message': 'An error occurred while processing the request'
      };
    }
  }

// Placeholder methods for notifications (implement these using FCM or another system)
  void _notifyAdmin(String adminId, String message) {
    // Implement admin notification
  }

  void _notifyUser(String userId, String message) {
    // Implement user notification
  }

  fetchPendingInvites() {}

  fetchPodPendingInvites(String id) {}

  deletePod(String id) {}
}
