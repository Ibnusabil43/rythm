import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rythm/providers/playlistProvider.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockDocumentReference extends Mock implements DocumentReference {}

void main() {
  group('PlayListProvider Tests', () {
    late PlayListProvider playListProvider;
    late MockFirebaseFirestore mockFirebaseFirestore;

    setUp(() {
      mockFirebaseFirestore = MockFirebaseFirestore();
      playListProvider = PlayListProvider();
    });

    test('addSong should add a song to the songList', () {
      final mockSong = SongProvider(
        id: '1',
        title: 'TestSong',
        artist: 'TestArtist',
        image: 'TestImage',
        song: 'TestSong.mp3',
        genre: 'TestGenre',
      );

      playListProvider.addSong(mockSong);

      expect(playListProvider.songList, [mockSong]);
    });

    test('ftechSonginPlaylistFromFirebase should fetch songs from Firebase',
        () async {
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockDocumentSnapshot = MockQueryDocumentSnapshot();

      // Import the library that defines 'docs' getter in MockQuerySnapshot
      when(mockFirebaseFirestore.collection('songs')).thenReturn(
        MockCollectionReference() as CollectionReference<Map<String, dynamic>>,
      );

      // Replace any with specific values or matchers
      when(mockQuerySnapshot.docs).thenReturn([mockDocumentSnapshot]);
      when(mockFirebaseFirestore.collection('songs').where(
        'someField', // Replace with the actual field name you are querying
        whereIn: [
          'someValue'
        ], // Replace with the actual values you are querying
      ).get())
          .thenAnswer((_) async =>
              Future<QuerySnapshot<Map<String, dynamic>>>.value(
                  mockQuerySnapshot as QuerySnapshot<Map<String, dynamic>>));

      when(mockDocumentSnapshot.data()).thenReturn({
        'id': '1',
        'title': 'TestSong',
        'artist': 'TestArtist',
        'image': 'TestImage',
        'song': 'TestSong.mp3',
        'genre': 'TestGenre',
      });

      await playListProvider.ftechSonginPlaylistFromFirebase();

      expect(playListProvider.songList.length, 1);
      verify(playListProvider.notifyListeners()).called(1);
    });

    test('fetchplaylistid should fetch playlist data from Firebase', () async {
      final mockDocumentSnapshot = MockDocumentSnapshot();

      // Replace any with specific values or matchers
      when(mockFirebaseFirestore.collection('users').doc('userId')).thenReturn(
          MockDocumentReference() as DocumentReference<Map<String, dynamic>>);

      // Replace any with specific values or matchers
      when(mockFirebaseFirestore
              .collection('songs')
              .where('someField', whereIn: ['someValue']))
          .thenReturn(MockQuerySnapshot() as Query<Map<String, dynamic>>);

      // Replace any with specific values or matchers
      when(mockFirebaseFirestore
              .collection('users')
              .doc('userId')
              .collection('playlist')
              .doc('playlistId')
              .get())
          .thenAnswer((_) async =>
              mockDocumentSnapshot as DocumentSnapshot<Map<String, dynamic>>);

      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({
        'name': 'TestPlaylist',
        'image': 'TestImage',
        'desc': 'TestDesc',
        'Songs': ['1', '2', '3'],
      });

      // Update the userId and playlistId with specific values you want to test
      await playListProvider.fetchplaylistid('playlistId');

      expect(playListProvider.id, 'playlistId');
      expect(playListProvider.name, 'TestPlaylist');
      expect(playListProvider.image, 'TestImage');
      expect(playListProvider.desc, 'TestDesc');
      expect(playListProvider.tempSong, ['1', '2', '3']);
      verify(playListProvider.notifyListeners()).called(1);
    });

    // Add more tests as needed
  });
}
