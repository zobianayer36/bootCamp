import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> notes = [];

  Future<void> fetchNotes(String userId) async {
    final snapshot = await _db.collection('notes').where('userId', isEqualTo: userId).get();
    notes = snapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  Future<void> addNote(String userId, String title, String content) async {
    await _db.collection('notes').add({
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.now(),
    });
    fetchNotes(userId);
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    await _db.collection('notes').doc(noteId).update({
      'title': title,
      'content': content,
    });
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await _db.collection('notes').doc(noteId).delete();
    notifyListeners();
  }
}
