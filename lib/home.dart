import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_book_finder/auth.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<dynamic> _books = [];
  final Uri _url = Uri.parse(
      'https://www.audible.com/pd/The-Count-of-Monte-Cristo-Audiobook/B005GFQ5WQ');
  final Uri _url2 = Uri.parse(
      'https://www.audible.com/pd/Robinson-Crusoe-Audiobook/B002V5CW08?plink=fS9Tbc6lFMCBDcan&ref=a_pd_The-Co_c5_adblp13npsbx_1_3&pf_rd_p=c09b9598-fc4b-4bcd-829c-1bd478ce94d5&pf_rd_r=ZST9165ZHKJDWD5P28TA&pageLoadId=pnrSnPVQ3GjEsVbZ&creativeId=aa49be53-d2b6-462f-8696-8b1f281125e6');
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
    _getBooks();
  }

  Future<void> _getBooks() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = json.decode(response);
    setState(() {
      _books = data['book'];
    });
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

  Widget _page2SRow() {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Count of Monte Cristo'),
                    content: const Text(
                        'On the eve of his marriage to the beautiful Mercedes, having that very day been made captain of his...'),
                    actions: <Widget>[
                      Row(
                        children: [
                          const Text('listen now on'),
                          ElevatedButton(
                              onPressed: _launchUrl,
                              child: const Text('Audible'))
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      )
                    ]);
              });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 10, color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: const Color.fromARGB(255, 56, 56, 56)),
          child: Row(children: [
            const Padding(padding: EdgeInsets.all(5)),
            //const Icon(Icons.book, color: Colors.white, size: 50),
            Image.network(
                'https://m.media-amazon.com/images/I/611Eot7+zJL._SL63_.jpg'),
            Column(
              children: const [
                Text('Bookname: Count of Monte Cristo',
                    style: TextStyle(color: Colors.white)),
                Padding(padding: EdgeInsets.all(4)),
                Text('Author: Alexandre Dumas',
                    style: TextStyle(color: Colors.white)),
              ],
            )
          ]),
        ));
  }

  Widget _page2TRow() {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Robinson Crusoe'),
                    content: const Text(
                        "Widely regarded as the first English novel, Daniel Defoe's Robinson Crusoe is one of the most popular and influential adventure stories of all time. This classic tale of shipwreck and survival on an uninhabited island..."),
                    actions: <Widget>[
                      Row(
                        children: [
                          const Text('listen now on'),
                          ElevatedButton(
                              onPressed: _launchUrl2,
                              child: const Text('Audible'))
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      )
                    ]);
              });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 10, color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: const Color.fromARGB(255, 56, 56, 56)),
          child: Row(children: [
            const Padding(padding: EdgeInsets.all(5)),
            //const Icon(Icons.book, color: Colors.white, size: 50),
            Image.network(
              'https://m.media-amazon.com/images/I/51qBBzZYbVL._SL500_.jpg',
              scale: 7,
            ),
            Column(
              children: const [
                Text('Bookname: Robinson Crusoe',
                    style: TextStyle(color: Colors.white)),
                Padding(padding: EdgeInsets.all(4)),
                Text('Author: Daniel Defoe',
                    style: TextStyle(color: Colors.white)),
              ],
            )
          ]),
        ));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchUrl2() async {
    if (!await launchUrl(_url2)) {
      throw Exception('Could not launch $_url2');
    }
  }

  Widget _listview() {
    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return ListTile(
          leading: Image.network(book['images']['product']),
          title: Text(book['title']),
          subtitle: Text(book['authors'].join(', ')),
          trailing: Text('\$${book['listPrice']['amount']}'),
        );
      },
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
            '     If anyone reading this, I want you to know that the Developer of this appication got headage, neck pain, very little sleep, and maybe already die in the process of making this application.',
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
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(5)),
            _page2FRow(),
            _page2SRow(),
            _page2TRow()
          ],
        )),
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
