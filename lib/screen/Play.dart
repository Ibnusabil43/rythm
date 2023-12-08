// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rythm/providers/playlistProvider.dart';
import '../providers/userProvider.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:provider/provider.dart';

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class Play extends StatefulWidget {
  final List<SongProvider> listSong;
  final SongProvider song;
  final int currIndex;

  const Play({
    Key? key,
    required this.listSong,
    required this.song,
    required this.currIndex,
  }) : super(key: key);

  @override
  State<Play> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<Play> {
  late AudioPlayer _audioPlayer;

  // final _playlist = ConcatenatingAudioSource(children: widget.song.song);

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    List<AudioSource> audioQuery = [];
    for (int i = 0; i < widget.listSong.length; i++) {
      audioQuery.add(AudioSource.uri(Uri.parse(widget.listSong[i].song),
          tag: MediaItem(
            id: widget.listSong[i].id,
            album: widget.listSong[i].title,
            title: widget.listSong[i].title,
            artist: widget.listSong[i].artist,
            artUri: Uri.parse(widget.listSong[i].image),
          )));
    }
    context.read<UsersProvider>().fetchPlaylist();
    print("Playlist Arr");
    print(context.read<UsersProvider>().getPlayListArr);
    super.initState();
    context.read<UsersProvider>().fetchPlaylist();
    print("Playlist Arr");
    print(context.read<UsersProvider>().getPlayListArr);

    _init(audioQuery);
  }

  Future<void> _init(List<AudioSource> audioQuery) async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: audioQuery,
      ),
      initialIndex: widget.currIndex,
      preload: true,
    );
    _audioPlayer.play();
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {}
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C27),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFFD2AFFF),
                size: 33,
              ),
            ),
            Text(
              'Now Playing',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 35,
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40, bottom: 0, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<SequenceState?>(
                  stream: _audioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metadata = state!.currentSource!.tag as MediaItem;
                    return MediaMetadata(
                      imageUrl: metadata.artUri.toString(),
                      title: metadata.title,
                      artist: metadata.artist ?? '',
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return ProgressBar(
                      barHeight: 8,
                      baseBarColor: Color(0xFFD2AFFF).withOpacity(0.4),
                      bufferedBarColor: Color(0xFFD2AFFF).withOpacity(0.15),
                      thumbColor: Colors.white,
                      progressBarColor: Color(0xFFD2AFFF),
                      timeLabelTextStyle: const TextStyle(
                        color: Color(0xFFD2AFFF),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      onSeek: (Duration position) {
                        _audioPlayer.seek(position);
                      },
                    );
                  },
                ),
                Controls(audioPlayer: _audioPlayer),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            _addtoPlaylistButton(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addtoPlaylistButton() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(top: 24, left: 31, right: 31),
                height: 437,
                decoration: ShapeDecoration(
                  color: Color(0xFFD2AFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        Text(
                          'Tambahkan ke Playlist',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount:
                          context.watch<UsersProvider>().playListArr.length,
                      itemBuilder: (context, index) {
                        if (index <=
                            context.watch<UsersProvider>().playListArr.length) {
                          final PlayListProvider iniDaftarPlaylist =
                              context.watch<UsersProvider>().playListArr[index];
                          return DaftarPlaylisttoAdd(
                              iniListPlaylisttambah: iniDaftarPlaylist,
                              song: widget.listSong[widget.currIndex]);
                        }
                      },
                    ))
                  ],
                ),
              );
            });
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tambahkan ke Playlist',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(Icons.add_circle_rounded, color: Color(0xFFD2AFFF), size: 24),
          ],
        ),
      ),
    );
  }
}

class MediaMetadata extends StatelessWidget {
  const MediaMetadata({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
  });

  final String imageUrl;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DecoratedBox(
        decoration: BoxDecoration(
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black,
          //     offset: Offset(2, 4),
          //     blurRadius: 4,
          //   ),
          // ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            height: 280,
            width: 280,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(
        height: 65,
      ),
      Text(
        title,
        style: TextStyle(
          color: Color(0xFFD2AFFF),
          fontSize: 22,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        artist,
        style: TextStyle(
          color: Color(0xFFD2AFFF),
          fontSize: 13,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      )
    ]);
  }
}

class Controls extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const Controls({
    super.key,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<bool>(
          stream: audioPlayer.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            return _shuffleButton(context, snapshot.data ?? false);
          },
        ),
        InkWell(
          onTap: () {
            audioPlayer.seekToPrevious();
          },
          child: Container(
            child: Icon(
              Icons.skip_previous,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final PlayerState = snapshot.data;
            final processingState = PlayerState?.processingState;
            final playing = PlayerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 80,
                color: Color(0xFFD2AFFF),
                icon: const Icon(Icons.play_circle_fill_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 80,
                color: Color(0xFFD2AFFF),
                icon: const Icon(Icons.pause_circle_filled_rounded),
              );
            }

            return const Icon(
              Icons.play_circle_fill_rounded,
              size: 80,
              color: Color(0xFFD2AFFF),
            );
          },
        ),
        InkWell(
          onTap: () {
            audioPlayer.seekToNext();
          },
          child: Container(
            child: Icon(
              Icons.skip_next,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        StreamBuilder<LoopMode>(
          stream: audioPlayer.loopModeStream,
          builder: (context, snapshot) {
            return _repeatButton(context, snapshot.data ?? LoopMode.all);
          },
        ),
      ],
    );
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
      icon: isEnabled
          ? Icon(Icons.shuffle, color: Color(0xFFD2AFFF))
          : Icon(
              Icons.shuffle,
              color: Colors.white,
            ),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await audioPlayer.shuffle();
        }
        await audioPlayer.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      Icon(
        Icons.repeat,
        color: Colors.white,
      ),
      Icon(Icons.repeat_one, color: Color(0xFFD2AFFF)),
    ];
    const cycleModes = [
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}

class DaftarPlaylisttoAdd extends StatefulWidget {
  final PlayListProvider iniListPlaylisttambah;
  final SongProvider song;

  DaftarPlaylisttoAdd({
    Key? key,
    required this.iniListPlaylisttambah,
    required this.song,
  }) : super(key: key);

  @override
  _DaftarPlaylisttoAddState createState() => _DaftarPlaylisttoAddState();
}

class _DaftarPlaylisttoAddState extends State<DaftarPlaylisttoAdd> {
  bool isButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    child: Image.network(
                      widget.iniListPlaylisttambah.image,
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.iniListPlaylisttambah.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.iniListPlaylisttambah.desc,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (!isButtonClicked) {
                    setState(() {
                      isButtonClicked = true;
                    });
                    context.read<UsersProvider>().addLagu2(
                        playlist: widget.iniListPlaylisttambah.id,
                        song: widget.song);
                  } else {
                    // Tidak ada tindakan yang diambil ketika tombol sudah diklik
                  }
                },
                child: isButtonClicked
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 35,
                      )
                    : Icon(
                        Icons.add_circle_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }
}
