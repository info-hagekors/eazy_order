import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/models/create_user_response_model.dart';
import 'package:core/models/user_model.dart';
import 'package:core/utils/pin_hasher.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AuthService {

  static const String _collectionUsers = 'users';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _currentUser = _auth.currentUser;
    _authStateSubscription = _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  late StreamSubscription<User?> _authStateSubscription;

  User? _currentUser;
  User? get currentUser => _currentUser;

  ConfirmationResult? _confirmation;

  static const String baseUrl = "https://us-central1-eazy-order-fcb5b.cloudfunctions.net/api";

  final StreamController<User?> _userController = StreamController<User?>.broadcast();
  Stream<User?> get userStream => _userController.stream;

  Future<Either<String, UserModel>> linkEmailToCurrentUser(String email, String password) async {
    final emailCred = EmailAuthProvider.credential(email: email, password: password);
    try {
      await FirebaseAuth.instance.currentUser?.linkWithCredential(emailCred);
      debugPrint("Email/password linked successfully");
      UserModel userModel = UserModel(
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
      );
      _currentUser = FirebaseAuth.instance.currentUser;
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      debugPrint("Linking failed: ${e.message}");
      return Left(e.message.toString());
    }
  }

  Future<Either<String, UserModel>> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = UserModel(
        uid: credential.user?.uid ?? '',
      );
      _currentUser = FirebaseAuth.instance.currentUser;
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return Left('Email is already registered');
        case 'invalid-email':
          return Left('Invalid email address');
        case 'weak-password':
          return Left('Password should be at least 6 characters');
        default:
          return Left('Registration failed. Try again.');
      }
    }
  }

  Future<Either<String, UserModel>> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = UserModel(
        uid: credential.user?.uid ?? '',
      );
      _currentUser = FirebaseAuth.instance.currentUser;
      final updatedUser = await getUser(userModel.uid);
      return Right(updatedUser);
    } catch (e) {
      debugPrint('Login Error >>>> ${e.toString()}');
      return Left(e.toString());
    }
  }

  void sendPhoneOtp(String phoneNumber, {Function(String)? onCodeSent}) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, resendToken) {
        onCodeSent?.call(verificationId);
      },
      verificationFailed: (e) => debugPrint(e.toString()),
      verificationCompleted: (credential) { },
      codeAutoRetrievalTimeout: (id) {},
    );
  }

  Future sendPhoneOtpWeb(String phoneNumber) async {
    final confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
    _confirmation = confirmationResult;
  }

  Future<Either<String, UserModel>> loginWithPhone(String verificationId, String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      UserModel userModel = UserModel(
        uid: userCredential.user?.uid ?? '',
      );
      _currentUser = FirebaseAuth.instance.currentUser;
      return Right(userModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserModel>> loginWithPhoneWeb(String verificationId, String otp) async {
    try {
      final userCredential = await _confirmation?.confirm(otp);
      if (userCredential == null) {
        return Left('Invalid Otp...');
      }
      UserModel userModel = UserModel(
        uid: userCredential.user?.uid ?? '',
      );
      _currentUser = FirebaseAuth.instance.currentUser;
      return Right(userModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  bool checkCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Stream<User?> get userChanges => _auth.userChanges();

  Future<void> saveUserDetailsToFirestore(UserModel model) async {
    final CollectionReference usersRef = _db.collection(_collectionUsers);
    await usersRef.doc(model.uid).set({
      'uid': model.uid,
      'name': model.name,
      'email': model.email,
      'email_verified': model.isEmailVerified,
      'mobile': model.mobile,
      'mobile_verified': model.isMobileVerified,
      'role': model.role,
      'business_id': model.businessId,
      'createdAt': model.createdAt,
      'updatedAt': model.updatedAt,
    });
  }

  Future<void> updateBusinessId(String businessId, String uId) async {
    await _updateMultiFieldDocument(_collectionUsers, uId,
        [
          {'field': 'business_id', 'value': businessId},
          {'field': 'updated_at', 'value': DateTime.now().toIso8601String()},
        ]
    );
  }

  Future<void> _updateMultiFieldDocument(String collectionPath, String docId, List<Map<String, String>> data) async {
    final docRef = _db.collection(collectionPath).doc(docId);
    final updateData = data.fold<Map<String, dynamic>>({}, (map, item) {
      final field = item['field'];
      if (field is String && field.isNotEmpty) {
        map[field] = item['value'];
      }
      return map;
    });
    await docRef.update(updateData);
  }

  Future<UserModel> getUser(String uid) async {
    final CollectionReference usersRef = _db.collection(_collectionUsers);
    DocumentSnapshot data = await usersRef.doc(uid).get();
    final json = data.data() as Map<String, dynamic>;
    UserModel user = UserModel.fromJson(json);
    return user;
  }

  Future<Either<String, bool>> isUserExists(String email, String mobile) async {
    final emailSnap = await _db
        .collection(_collectionUsers)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    final mobileSnap = await FirebaseFirestore.instance
        .collection(_collectionUsers)
        .where('mobile', isEqualTo: mobile)
        .limit(1)
        .get();

    if (emailSnap.docs.isNotEmpty) {
      // Email already exists
      return Right(true);
    }

    if (mobileSnap.docs.isNotEmpty) {
      // Mobile already exists
      return Right(false);
    }
    return Left('User not found');
  }

  Future<List<UserModel>> fetchUserByBusiness(String businessId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(_collectionUsers)
          .where('business_id', isEqualTo: businessId)
          .orderBy('createdAt', descending: true)
          .get();

      final result = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      final userList = UserModel.parseList(result);
      return userList;
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  Future<CreateUserResponseModel> createUser({required UserModel model}) async {
    final response = await http.post(
      Uri.parse("$baseUrl/createUser"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": model.name,
        "email": model.email,
        "phone": model.mobile,
        "role": model.role,
      }),
    );

    if (response.statusCode != 200) {
      final err = jsonDecode(response.body);
      throw Exception(err["error"] ?? "User creation failed");
    }

    return CreateUserResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<void> savePin({required String userId, required String pin,}) async {
    final salt = DateTime.now().millisecondsSinceEpoch.toString();

    final pinHash = PinHasher.hashPin(pin, salt: salt);

    await _db.collection(_collectionUsers).doc(userId).set({
      'pin_hash': pinHash,
      'pin_salt': salt,
      'pin_set_at': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }


  void _onAuthStateChanged(User? user) {
    _currentUser = user;
    _userController.add(user);
  }

  void dispose() {
    _authStateSubscription.cancel();
    _userController.close();
  }
}

// Auth Repository provider
final authServiceProvider = Provider((ref) => AuthService());
