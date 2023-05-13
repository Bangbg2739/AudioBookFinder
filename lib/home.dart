import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_book_finder/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audio_book_finder/models/channel_model.dart';
import 'package:audio_book_finder/models/video_model.dart';
import 'package:audio_book_finder/screens/video_screen.dart';
import 'package:audio_book_finder/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.home, color: Colors.white)),
    Tab(icon: Icon(Icons.book_online, color: Colors.white)),
    Tab(icon: Icon(Icons.settings, color: Colors.white)),
    Tab(icon: Icon(Icons.manage_accounts, color: Colors.white)),
    Tab(icon: Icon(Icons.contact_page, color: Colors.white))
  ];
  late TabController _tabController;
  late Channel _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCA8Bg-tQKShZRZhe610SC-Q');
    setState(() {
      _channel = channel;
    });
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 140.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Audiobooks Finder');
  }

  Widget _firstrow() {
    var home = Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text('Home',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15)),
        Spacer(),
      ],
    );
    return home;
  }

  Widget _userUid() {
    var uid = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Hello ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20)),
        Text(user?.email ?? 'User Email',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20))
      ],
    );
    return uid;
  }

  Widget _overviewButton() {
    return ElevatedButton(
        onPressed: () {},
        child: const Text('Overview'),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)));
  }

  Widget _infoBox() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 10, color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: const Color.fromARGB(255, 56, 56, 56)),
      child: Column(children: [
        const Text('Continue listen',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20)),
        Row(
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            InkWell(
                onTap: () async {
                  const url =
                      'https://www.audible.com/pd/The-Rainbow-Audiobook/B004IUHT02?ref=a_ep_FreeLi_c6_product_1_2&pf_rd_p=6b2d7e18-1cc2-450b-956e-6a11412e2a98&pf_rd_r=FJ542T3VZ72ZD218JSAB&pageLoadId=nxcFrfbuaUIMKWc8&creativeId=35651b16-d1f3-4349-90d0-8c0adcf31590';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Image(
                    width: 150,
                    image: NetworkImage(
                      'https://m.media-amazon.com/images/I/51P23qFgT7L._SL500_.jpg',
                    ))),
            const Padding(padding: EdgeInsets.all(5)),
            const Image(
                width: 150,
                image: NetworkImage(
                  'https://m.media-amazon.com/images/I/415tOEm6t6L._SL500_.jpg',
                )),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Row(
          children: const [
            Padding(padding: EdgeInsets.all(5)),
            Image(
                width: 150,
                image: NetworkImage(
                  'https://m.media-amazon.com/images/I/51HrqRPNy+L._SL500_.jpg',
                )),
            Padding(padding: EdgeInsets.all(5)),
            Image(
                width: 150,
                image: NetworkImage(
                  'https://m.media-amazon.com/images/I/61KcKjNIbyL._SL500_.jpg',
                )),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
      ]),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('sign out'));
  }

  Widget _page2FRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Padding(padding: EdgeInsets.all(5)),
        Text('Books suggestion',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15)),
        Spacer(),
      ],
    );
  }

  Widget _accountMM() {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(10)),
        const Icon(
          Icons.face,
          color: Colors.white,
          size: 200,
        ),
        const Padding(padding: EdgeInsets.all(30)),
        Row(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            const Text('Email: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20)),
            Text(user?.email ?? 'User Email',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20))
          ],
        )
      ],
    );
  }

  Widget _aboutUs() {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(10)),
        const Text('From Developer of This Appication',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20)),
        const Padding(padding: EdgeInsets.all(30)),
        const Text(
            '     If anyone reading this, I want you to know that the Developer of this appication got headache, neck pain, very little sleep, and maybe already die in the process of making this application.',
            style: TextStyle(
              color: Colors.white,
            )),
        const Padding(padding: EdgeInsets.all(10)),
        const Text(
            '     In addition This application was made to satisfied the head coder of this group by sacrifice some members to successfully create this application.',
            style: TextStyle(
              color: Color.fromARGB(255, 92, 92, 92),
            )),
        const Padding(
          padding: EdgeInsets.all(30),
        ),
        InkWell(
          onTap: () {},
          child: const Icon(Icons.report_problem,
              color: Color.fromARGB(255, 85, 84, 84), size: 100),
        ),
        const Padding(padding: EdgeInsets.all(10)),
        const Text(
            "Please do not try to hit the report button because the Developer don't have enough time to implement it to call 191. Hitting it will only make the developer become more depression and want to kill himself(even if he already dead in the process).",
            style: TextStyle(
              color: Color.fromARGB(255, 66, 65, 65),
            )),
      ],
    );
  }

  Widget _listvideo() {
    return SizedBox(
        width: 500.0,
        height: 600.0,
        child: Scaffold(
          body: _channel != null
              ? NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollDetails) {
                    if (!_isLoading &&
                        _channel.videos.length !=
                            int.parse(_channel.videoCount) &&
                        scrollDetails.metrics.pixels ==
                            scrollDetails.metrics.maxScrollExtent) {
                      _loadMoreVideos();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: _channel.videos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Video video = _channel.videos[index];
                      return _buildVideo(video);
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor, // Red
                    ),
                  ),
                ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: myTabs,
      ),
      body: TabBarView(controller: _tabController, children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(5)),
              _firstrow(),
              const Padding(padding: EdgeInsets.all(10)),
              _userUid(),
              const Padding(padding: EdgeInsets.all(20)),
              _overviewButton(),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              _infoBox(),
            ],
          ),
        ),
        Center(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(5)),
            _page2FRow(),
            _listvideo()
          ],
        ))),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[_signOutButton()],
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_accountMM()],
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_aboutUs()],
          ),
        ),
      ]),
    );
  }
}
