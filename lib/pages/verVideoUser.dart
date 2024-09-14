import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/admin.page.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class VerVideosUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: VideosUser(),
    );
  }
}

class VideosUser extends StatelessWidget {
  final vd = FirebaseFirestore.instance.collection('videos');
  late String url, videoID;

  late Future<QuerySnapshot> querySnapshot;

  Future<QuerySnapshot> viewVideo() async {
    // Call the user's CollectionReference to add a new user
    return await vd.get();
  }

  @override
  Widget build(BuildContext context) {
    Widget ytPlayer(url) {
      videoID = YoutubePlayerController.convertUrlToId(url)!;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            videoID = YoutubePlayerController.convertUrlToId(url)!;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => YoutubeViewer(videoID)));
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (kIsWeb && constraints.maxWidth > 800) {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width / 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: new Image.network(
                                YoutubePlayerController.getThumbnail(
                                    videoId: videoID),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: new Image.network(
                                YoutubePlayerController.getThumbnail(
                                    videoId: videoID,
                                    // todo: get thumbnail quality from list
                                    quality: ThumbnailQuality.max,
                                    webp: false),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: 55.0,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Vídeos Disponíveis"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
              future: viewVideo(),
              builder: (context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if (querySnapshot.connectionState == ConnectionState.waiting) {
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: querySnapshot.data?.docs.length,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Card(
                          child: ListTile(
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  querySnapshot.data?.docs[index].get('nome') +
                                      '\n' +
                                      querySnapshot.data?.docs[index]
                                          .get('data'),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                //Text(new DateFormat('yyyy-MM-dd').format(querySnapshot.data?.docs[index].data()['data'])),
                              ],
                            ),
                            title: Row(
                              children: <Widget>[
                                ytPlayer(
                                    querySnapshot.data?.docs[index].get('url')),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class YoutubeViewer extends StatefulWidget {
  final String videoID;
  YoutubeViewer(this.videoID);
  @override
  _YoutubeViewerState createState() => _YoutubeViewerState();
}

class _YoutubeViewerState extends State<YoutubeViewer> {
  // ignore: close_sinks
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoID,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false, // false for platform design
        autoPlay: false,
        enableCaption: true,
        showVideoAnnotations: false,
        enableJavaScript: true,
        privacyEnhanced: true,
        playsInline: false, // iOS only
      ),
    )..listen((value) {
        if (value.isReady && !value.hasPlayed) {
          _controller
            ..hidePauseOverlay()
            // Uncomment below to stop Autoplay
            // ..play()
            ..hideTopMenu();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: AlertDialog(
        insetPadding: EdgeInsets.all(10),
        backgroundColor: Colors.black,
        content: player,
        contentPadding: EdgeInsets.all(0),
        actions: <Widget>[
          new Center(
            child: TextButton(
              child:
                  const Text("Fechar", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
