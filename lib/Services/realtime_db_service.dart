// // lib/services/realtime_db_service.dart
// import 'package:firebase_database/firebase_database.dart';
//
// class RealtimeDBService {
//   final FirebaseDatabase _database = FirebaseDatabase.instance;
//
//   // Singleton pattern
//   static final RealtimeDBService _instance = RealtimeDBService._internal();
//   factory RealtimeDBService() => _instance;
//   RealtimeDBService._internal();
//
//   // ========== BASIC OPERATIONS ==========
//
//   // Write data to a path
//   Future<void> setData(String path, Map<String, dynamic> data) async {
//     try {
//       await _database.ref(path).set(data);
//       print('Data written to $path');
//     } catch (e) {
//       print('Error writing data: $e');
//       rethrow;
//     }
//   }
//
//   // Update specific fields
//   Future<void> updateData(String path, Map<String, dynamic> updates) async {
//     try {
//       await _database.ref(path).update(updates);
//       print('Data updated at $path');
//     } catch (e) {
//       print('Error updating data: $e');
//       rethrow;
//     }
//   }
//
//   // Push data (auto-generates unique key)
//   Future<DatabaseReference> pushData(String path, Map<String, dynamic> data) async {
//     try {
//       DatabaseReference ref = _database.ref(path).push();
//       await ref.set(data);
//       print('Data pushed to ${ref.path}');
//       return ref;
//     } catch (e) {
//       print('Error pushing data: $e');
//       rethrow;
//     }
//   }
//
//   // Read data once
//   Future<DataSnapshot> getData(String path) async {
//     try {
//       DataSnapshot snapshot = await _database.ref(path).get();
//       return snapshot;
//     } catch (e) {
//       print('Error reading data: $e');
//       rethrow;
//     }
//   }
//
//   // Delete data
//   Future<void> deleteData(String path) async {
//     try {
//       await _database.ref(path).remove();
//       print('Data deleted from $path');
//     } catch (e) {
//       print('Error deleting data: $e');
//       rethrow;
//     }
//   }
//
//   // ========== REAL-TIME LISTENERS ==========
//
//   // Listen to value changes at a path
//   Stream<DatabaseEvent> listenToValue(String path) {
//     return _database.ref(path).onValue;
//   }
//
//   // Listen to child additions
//   Stream<DatabaseEvent> listenToChildAdded(String path) {
//     return _database.ref(path).onChildAdded;
//   }
//
//   // Listen to child changes
//   Stream<DatabaseEvent> listenToChildChanged(String path) {
//     return _database.ref(path).onChildChanged;
//   }
//
//   // Listen to child removals
//   Stream<DatabaseEvent> listenToChildRemoved(String path) {
//     return _database.ref(path).onChildRemoved;
//   }
//
//   // Listen to all child events
//   Stream<DatabaseEvent> listenToChildren(String path) {
//     return _database.ref(path).onChildAdded.mergeWith([
//       _database.ref(path).onChildChanged,
//       _database.ref(path).onChildRemoved,
//     ]);
//   }
//
//   // ========== CHAT EXAMPLE ==========
//
//   // Send chat message
//   Future<void> sendMessage({
//     required String chatId,
//     required String senderId,
//     required String message,
//   }) async {
//     final messageData = {
//       'senderId': senderId,
//       'message': message,
//       'timestamp': ServerValue.timestamp,
//       'read': false,
//     };
//
//     await pushData('chats/$chatId/messages', messageData);
//
//     // Update chat metadata
//     await updateData('chats/$chatId', {
//       'lastMessage': message,
//       'lastMessageTime': ServerValue.timestamp,
//       'lastSenderId': senderId,
//     });
//   }
//
//   // Get chat messages stream
//   Stream<List<Map<String, dynamic>>> getChatMessages(String chatId) {
//     return listenToChildAdded('chats/$chatId/messages')
//         .asyncMap((event) async {
//       // Convert all messages to list
//       DataSnapshot snapshot = await _database
//           .ref('chats/$chatId/messages')
//           .orderByChild('timestamp')
//           .get();
//
//       if (snapshot.value == null) return [];
//
//       Map<dynamic, dynamic> messages = snapshot.value as Map<dynamic, dynamic>;
//       List<Map<String, dynamic>> messageList = [];
//
//       messages.forEach((key, value) {
//         messageList.add({
//           'id': key,
//           ...value,
//         });
//       });
//
//       // Sort by timestamp
//       messageList.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
//
//       return messageList;
//     });
//   }
//
//   // ========== PRESENCE SYSTEM ==========
//
//   // Set user online/offline
//   Future<void> setUserPresence(String userId, bool isOnline) async {
//     final presenceRef = _database.ref('presence/$userId');
//
//     if (isOnline) {
//       // Set user as online
//       await presenceRef.set({
//         'status': 'online',
//         'lastSeen': ServerValue.timestamp,
//       });
//
//       // Remove on disconnect (when app closes)
//       presenceRef.onDisconnect().set({
//         'status': 'offline',
//         'lastSeen': ServerValue.timestamp,
//       });
//     } else {
//       await presenceRef.set({
//         'status': 'offline',
//         'lastSeen': ServerValue.timestamp,
//       });
//     }
//   }
//
//   // Listen to user presence
//   Stream<Map<String, dynamic>?> listenToUserPresence(String userId) {
//     return listenToValue('presence/$userId').map((event) {
//       if (event.snapshot.value == null) return null;
//       return {
//         'userId': userId,
//         ...(event.snapshot.value as Map<dynamic, dynamic>).cast<String, dynamic>(),
//       };
//     });
//   }
//
//   // ========== COUNTERS ==========
//
//   // Atomic increment
//   Future<void> incrementCounter(String counterId, int amount) async {
//     await _database.ref('counters/$counterId').runTransaction((mutableData) async {
//       int currentValue = mutableData.value ?? 0;
//       mutableData.value = currentValue + amount;
//       return Transaction.success(mutableData);
//     });
//   }
//
//   // Listen to counter
//   Stream<int> listenToCounter(String counterId) {
//     return listenToValue('counters/$counterId').map((event) {
//       return (event.snapshot.value as int?) ?? 0;
//     });
//   }
//
//   // ========== QUERY EXAMPLES ==========
//
//   // Query with ordering
//   Stream<List<Map<String, dynamic>>> getItemsOrderedBy(String path, String orderBy) {
//     return listenToValue(path).map((event) {
//       if (event.snapshot.value == null) return [];
//
//       Map<dynamic, dynamic> items = event.snapshot.value as Map<dynamic, dynamic>;
//       List<Map<String, dynamic>> itemList = [];
//
//       items.forEach((key, value) {
//         itemList.add({
//           'id': key,
//           ...value,
//         });
//       });
//
//       // Sort by the specified field
//       itemList.sort((a, b) => (a[orderBy] ?? '').compareTo(b[orderBy] ?? ''));
//
//       return itemList;
//     });
//   }
//
//   // Query with limit
//   Future<List<Map<String, dynamic>>> getItemsWithLimit(String path, int limit) async {
//     DataSnapshot snapshot = await _database.ref(path)
//         .orderByKey()
//         .limitToLast(limit)
//         .get();
//
//     if (snapshot.value == null) return [];
//
//     Map<dynamic, dynamic> items = snapshot.value as Map<dynamic, dynamic>;
//     List<Map<String, dynamic>> itemList = [];
//
//     items.forEach((key, value) {
//       itemList.add({
//         'id': key,
//         ...value,
//       });
//     });
//
//     return itemList;
//   }
//
//   // ========== UTILITIES ==========
//
//   // Check if path exists
//   Future<bool> exists(String path) async {
//     DataSnapshot snapshot = await _database.ref(path).get();
//     return snapshot.exists;
//   }
//
//   // Get all keys at a path
//   Future<List<String>> getKeys(String path) async {
//     DataSnapshot snapshot = await _database.ref(path).get();
//     if (!snapshot.exists || snapshot.value == null) return [];
//
//     Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
//     return data.keys.cast<String>().toList();
//   }
//
//   // Clear all data at path
//   Future<void> clearPath(String path) async {
//     await _database.ref(path).remove();
//   }
// }