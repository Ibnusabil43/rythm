import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rythm/FtechFromFirebase/FetchSonginUser.dart';
import 'package:rythm/FtechFromFirebase/FtechPlaylistFromFirebase.dart';
import 'package:rythm/providers/playlistProvider.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:rythm/providers/userProvider.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  group('UsersProvider Tests', () {
    late UsersProvider usersProvider;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseFirestore mockFirebaseFirestore;
    late MockFirebaseStorage mockFirebaseStorage;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseFirestore = MockFirebaseFirestore();
      mockFirebaseStorage = MockFirebaseStorage();

      usersProvider = UsersProvider();
    });

    test('setid should update id', () {
      usersProvider.setid('test_id');
      expect(usersProvider.id, 'test_id');
    });

    test('fetchImage should update profileImageUrl', () async {
      final mockDocumentSnapshot = MockDocumentSnapshot();
      final mockDocumentReference = MockDocumentReference();
      final mockCollectionReference = MockCollectionReference();

      when(mockFirebaseFirestore.collection('users')).thenReturn(
          mockCollectionReference as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data())
          .thenReturn({'profileImageUrl': 'test_image_url'});

      // Tambahkan await di sini untuk menunggu fetchImage selesai
      await usersProvider.fetchImage();

      expect(usersProvider.profileImageUrl, 'test_image_url');
    });

    test('fetchSong should update uploadedSongs', () async {
      final mockFetchedSongs = [
        SongProvider(
            id: '1',
            title: 'Song1',
            artist: 'Artist1',
            image: 'Image1',
            song: 'Song1.mp3',
            genre: 'Pop'),
        SongProvider(
            id: '2',
            title: 'Song2',
            artist: 'Artist2',
            image: 'Image2',
            song: 'Song2.mp3',
            genre: 'Rock'),
      ];

      when(fetchSongUser()).thenAnswer((_) async => mockFetchedSongs);

      await usersProvider.fetchSong();

      expect(usersProvider.uploadedSongs.length, 2);
    });

    test('deleteSongUser should remove song and update state', () async {
      final mockSong = SongProvider(
          id: '1',
          title: 'TestSong',
          artist: 'TestArtist',
          image: 'TestImage',
          song: 'TestSong.mp3',
          genre: 'TestGenre');
      usersProvider.uploadedSongs.add(mockSong);

      final mockDocumentSnapshot = MockDocumentSnapshot();
      final mockDocumentReference = MockDocumentReference();

      when(mockFirebaseFirestore.collection('songs').doc(any)).thenReturn(
          MockDocumentReference() as DocumentReference<Map<String, dynamic>>);
      when(mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.data()).thenReturn({
        'SongStorage': 'test_song_storage',
        'ImageStorage': 'test_image_storage'
      });

      await usersProvider.deleteSongUser(user: usersProvider, song: mockSong);

      expect(usersProvider.uploadedSongs, isEmpty);
    });

    test('setSongList should update tempSong', () {
      usersProvider.setSongList(['song1', 'song2']);

      expect(usersProvider.tempSong, ['song1', 'song2']);
    });

    test('fetchprofile should update username and email', () async {
      final mockDocumentSnapshot = MockDocumentSnapshot();
      final mockDocumentReference = MockDocumentReference();
      when(mockFirebaseFirestore.collection('users').doc(any)).thenReturn(
          MockDocumentReference() as DocumentReference<Map<String, dynamic>>);
      when(mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data())
          .thenReturn({'username': 'test_username', 'email': 'test_email'});

      usersProvider.fetchprofile();

      expect(usersProvider.username, 'test_username');
      expect(usersProvider.email, 'test_email');
    });

    test('fetchPlaylist should update playListArr', () async {
      final mockPlaylistArr = [
        PlayListProvider(
            id: '1', name: 'Playlist1', desc: 'Desc1', image: 'Image1'),
        PlayListProvider(
            id: '2', name: 'Playlist2', desc: 'Desc2', image: 'Image2'),
      ];
      when(ftechPlaylistFromFirebase())
          .thenAnswer((_) async => mockPlaylistArr);

      usersProvider.fetchPlaylist();

      expect(usersProvider.playListArr.length, 2);
    });

    test('tambahPlaylistBaru should add a new playlist', () async {
      final mockFile = MockFile();
      when(mockFile.exists()).thenAnswer((_) async => true);

      final appDocDir = MockDirectory();
      when(appDocDir.path).thenReturn('test_path');
      when(getApplicationDocumentsDirectory())
          .thenAnswer((_) async => appDocDir);

      final mockUuid = MockUuid();
      when(mockUuid.v4()).thenReturn('test_uuid');

      usersProvider.tambahPlaylistBaru(
        namePlaylist: 'NewPlaylist',
        descPlaylist: 'Description',
        selectedImage: mockFile,
        selectedImageFileName: 'image.jpg',
      );

      expect(usersProvider.playListArr.length, 1);
    });

    test('addLagu2 should update playlist with a new song', () async {
      final mockSong = SongProvider(
          id: '1',
          title: 'TestSong',
          artist: 'TestArtist',
          image: 'TestImage',
          song: 'TestSong.mp3',
          genre: 'TestGenre');
      final mockDocumentReference = MockDocumentReference();
      when(mockFirebaseFirestore.collection('songs').doc(any)).thenReturn(
          mockDocumentReference as DocumentReference<Map<String, dynamic>>);

      usersProvider.addLagu2(playlist: 'TestPlaylist', song: mockSong);

      verify(mockDocumentReference.update({
        'Songs': [mockDocumentReference]
      })).called(1);
    });

    test('deleteLagu2 should remove song from playlist and update state',
        () async {
      final mockSong = SongProvider(
          id: '1',
          title: 'TestSong',
          artist: 'TestArtist',
          image: 'TestImage',
          song: 'TestSong.mp3',
          genre: 'TestGenre');
      final mockPlaylist = PlayListProvider(
          id: '1',
          name: 'TestPlaylist',
          desc: 'TestDescription',
          image: 'TestImage');

      mockPlaylist.songList.add(mockSong);
      usersProvider.playListArr.add(mockPlaylist);

      final mockDocumentReference = MockDocumentReference();
      when(mockFirebaseFirestore.collection('songs').doc(any)).thenReturn(
          mockDocumentReference as DocumentReference<Map<String, dynamic>>);

      usersProvider.deleteLagu2(playlist: mockPlaylist, song: mockSong);

      expect(mockPlaylist.songList, isEmpty);
    });

    test('deletePlaylistoln should remove playlist and associated data',
        () async {
      final mockPlaylist = PlayListProvider(
          id: '1',
          name: 'TestPlaylist',
          desc: 'TestDescription',
          image: 'TestImage');

      usersProvider.playListArr.add(mockPlaylist);

      final mockQuerySnapshot = MockQuerySnapshot();
      final mockDocumentReference = MockDocumentReference();
      final mockDocumentSnapshot = MockQueryDocumentSnapshot();
      when(mockDocumentSnapshot.data())
          .thenReturn({'imageName': 'test_image_name'});
      when(mockQuerySnapshot.docs).thenReturn([mockDocumentSnapshot]);

      when(mockFirebaseFirestore.collection('users').doc(any)).thenReturn(
          MockDocumentReference() as DocumentReference<Map<String, dynamic>>);

      // Use async/await to create a Future that resolves with the mock data
      when(mockDocumentReference.collection('playlist').get()).thenAnswer(
          (_) async =>
              mockQuerySnapshot as QuerySnapshot<Map<String, dynamic>>);

      final mockFirebaseStorageRef = MockReference();
      when(mockFirebaseStorage.ref().child('your_string_value'))
          .thenReturn(mockFirebaseStorageRef);

      usersProvider.deletePlaylistoln(playlist: mockPlaylist);

      verify(mockFirebaseStorageRef.delete()).called(1);
      expect(usersProvider.playListArr, isEmpty);
    });

    test('deletePlaylist should remove playlist from state', () async {
      final mockPlaylist = PlayListProvider(
          id: '1',
          name: 'TestPlaylist',
          desc: 'TestDescription',
          image: 'TestImage');

      usersProvider.playListArr.add(mockPlaylist);

      usersProvider.deletePlaylist(playlist: mockPlaylist);

      expect(usersProvider.playListArr, isEmpty);
    });

    test('tambahLagukePlaylist should add a song to the playlist', () {
      final mockPlaylist = PlayListProvider(
          id: '1',
          name: 'TestPlaylist',
          desc: 'TestDescription',
          image: 'TestImage');
      final mockSong = SongProvider(
          id: '1',
          title: 'TestSong',
          artist: 'TestArtist',
          image: 'TestImage',
          song: 'TestSong.mp3',
          genre: 'TestGenre');

      usersProvider.tambahLagukePlaylist(
          playlist: mockPlaylist, song: mockSong);

      expect(mockPlaylist.songList, contains(mockSong));
    });

    test('deleteLagudariPlaylist should remove song from playlist', () {
      final mockPlaylist = PlayListProvider(
          id: '1',
          name: 'TestPlaylist',
          desc: 'TestDescription',
          image: 'TestImage');
      final mockSong = SongProvider(
          id: '1',
          title: 'TestSong',
          artist: 'TestArtist',
          image: 'TestImage',
          song: 'TestSong.mp3',
          genre: 'TestGenre');

      mockPlaylist.songList.add(mockSong);
      usersProvider.playListArr.add(mockPlaylist);

      usersProvider.deleteLagudariPlaylist(
          playlist: mockPlaylist, song: mockSong);

      expect(mockPlaylist.songList, isEmpty);
    });
  });
}

class MockFile extends Mock implements File {}

class MockDirectory extends Mock implements Directory {}

class MockUuid extends Mock implements Uuid {}
