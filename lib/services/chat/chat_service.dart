import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';

import '../../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  ServiceAccountCredentials? _credentials;
  AutoRefreshingAuthClient? _client;
  DateTime? _tokenExpiry;
  String projectId = 'chatapptute-6f042';

  ChatService() {
    _initializeCredentials();
  }

  void _initializeCredentials() {
    _credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "chatapptute-6f042",
      "private_key_id": "8141e360a5e441c217e109f57413eab79dbb1ffc",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDr5Ng3Q4pmVjxm\n2a5MdKVCycOzygP85g4LpVOw/3nfB/5Ayr3sYsHkDkDC6EEs52UFfZVJDzbNgcUC\nRg8o4Y5AlggdklXifrL7e9DgSn94CuQEHooL/R2f0RX8gHPm+9P7nWAFLT+x0IBD\nNybPsYZG+AB6pcfoFrTp8ToApMF5HkSg7ucqoDqD2CR5E0FwCUEovNEmpv/S4QQT\nnQ69SG7vGepJAtOFgP6nvcvh7oosmH+6B4OGrP701Leczr+FWCGcxXhExlOxGvML\nMbrmw1z58uV9x4rDj/FDjGc9Pcqr4MjWDMnTmnOp41gyUPLOYfNDYkdQ6rmWQuDW\n8hY3o8mPAgMBAAECggEANarEvh3xmMK5zzRrAR3wkzdP/NFTAvBb9a5RUg1tbp5k\n69y0RNla/0V22mD4ovyp8QvXMN3zO+HwLko+HLDkKjF3+zJVs8fbdHeA1+ZbBbaE\nlaNVCNE3Mirhc6bNt5lHaxEszUC0IwIqjCA6Bjp/MBowEbcxuc2grzCgX5EcKy+V\n4HVUmeLHWh0B9OohnF3s6CMuXCgjNrffwaEWIb62UWL54fhPGXe4gaek0wKXzmBC\nbqn/x1F/PEA8G0QKsd1m9BgCLcJDmaMt+6vHO7iXqmnIO5yRTIRkbZjn/VAr07QF\nzvqAcQJjbMBZ/6ccux9OPqAxNQibFobtrXxCpFHY0QKBgQD121EMieRgrPLt9Ijs\nldBaatkRlAMCxOC3KMwhyFpOE+lyexlJ3ZTaj3P4YXTULW1UspYVgY3xa45yycvn\nrvzSWTm2/Xw6UmaDSXmnVGiA1yIDV33UJaadk/qtZOmLM1P/wreBDwOB7WnnTMHd\nFJ334XvgJ+naxX2qpo56XpoyvQKBgQD1oE2nRQYj3BvYf3TlCO6I5CRmnGJpPkxJ\nC6FNDvHnk5HMXbAamzPpJRgpyRQwkliVzwQetTESUFCHudZ6MgqHhTh6MzF9IKPk\nOKPwJF5xFTofWkxgTapmpC4UiBNCHf/mPy3fY4hGH3G8cXkIS4BPV+ZWUBW2WCLI\nbuwSPW/4OwKBgQCxX+NfenSL0vsI9i17ErLZKNEmv3RUoRnGyuZLUTLltbPs5ibe\nhcCI1opCnn0dPxDr1FQ3e9qeXIzPAAveQP8h+0GKZeMkaKKRAYeFU355xbxCUPL1\nBZzpfwOR6YYc6ZEmqqKdt+k96b1IJLaQ+/jkB4fJtsIfFfCOF9AfNPVmuQKBgQCb\n0LMyFyFMAkdP0Zrv5/iZslA9H5t2M+TkuZH7di2SwBRPVmdumWIW1kc7yqkaHtw/\nPHHaoQqeGYDceNFL9w6i5ansKymLvPb6wcuNfSTEC7kxRnEI7nvYXPI2aBP/b1R0\nVUPeYB+EjFH0Pu+OiYa9zn755he/8q0uBN+QupSbHQKBgQDkFt3TA72jLiY+G/A1\n6Jby++HV51FD20qma9nKBqUb5cuG609CvobXYeMEZ+oHMS/L0+WUzDnfa+eF3BZ2\n7zgWfYuyosJOCGH+6OT26SgqT83OjU2GBSlkqf3CCBv/fVlscs2g9M1X10ffwFTP\nMdNgK6QZOrSXg0kIa93Q5PVp9A==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-st8l2@chatapptute-6f042.iam.gserviceaccount.com",
      "client_id": "105758299199783865683",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-st8l2%40chatapptute-6f042.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });
  }

  Future<String> getAccessToken() async {
    if (_client == null || DateTime.now().isAfter(_tokenExpiry!)) {
      _client = await clientViaServiceAccount(
          _credentials!,
          ['https://www.googleapis.com/auth/firebase.messaging']
      );
      _tokenExpiry = DateTime.now().add(const Duration(hours: 1));
    }
    return _client!.credentials.accessToken.data;
  }

  Future<void> sendFCM(String token, String title, String body) async {
    try {
      print('Sending FCM notification:');
      // print('Token: $token');
      // print('Title: $title');
      // print('Body: $body');

      final accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body
            },
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done'
            }
          }
        }),
      );

      print('FCM Response status: ${response.statusCode}');
      // print('FCM Response body: ${response.body}');
    } catch (e) {
      print('Error sending FCM message: $e');
    }
  }

  Future<void> updateFCMToken() async {
    final token = await _fcm.getToken();
    if (token != null) {
      await _firestore
          .collection("User")
          .doc(_auth.currentUser!.uid)
          .update({'fcmToken': token});
    }
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("User").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Gửi tin nhắn
    await _firestore
        .collection("chatrooms")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());

    // Lấy token và gửi notification
    final receiverDoc =
        await _firestore.collection('User').doc(receiverID).get();
    final receiverToken = receiverDoc.data()?['fcmToken'];

    if (receiverToken != null) {
      await sendFCM(
        receiverToken,
        currentUserEmail,
        message,
      );
    }
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chatrooms")
        .doc(chatRoomID)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
