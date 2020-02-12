import 'dart:convert';
import 'dart:math';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:news_app/SearchPage.dart';
import 'package:news_app/login.dart';
import 'clickedarticle.dart';
import 'model/article.dart';
import 'sign_in.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> articleList;
  String _apiKey = "917d8cfbb1264bd5b6ad257fd7662c10";
  InterstitialAd myInterstitial;
  var inactiveColor = Colors.black;
  int currentPage =0;
  TextEditingController editingController = TextEditingController();
  String currentTitle;
  Color currentColor ;

  String query = "Todays news";
  Future<List<Article>> getNews () async {


    if(query.isEmpty) {
      setState(() {
        query = "Today";
      });
    }
    if(query.contains(" ' ") || query.contains(" ? ") || query.contains(' " ')) {
      query.replaceAll(' " ', "");
      query.replaceAll(" ' ", "");
      query.replaceAll(" ? ", "");
    }


    String url = "https://newsapi.org/v2/everything?q=$query&apiKey=$_apiKey";

   Response response = await http.get(url);
    articleList = [];
   var result = jsonDecode(response.body);
        List articleListfromJson = result["articles"];

        for(Map v in articleListfromJson) {
          Article article = Article.fromJson(v);
          articleList.add(article);
        }
         /* for(v in result.get(key)) {
            Article article = Article.fromJson(v);
          }*/
         return articleList;
  }

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-8786039456324585/3651343273",
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  void showInterstitialAd() {
    myInterstitial..show();
  }

  void showRandomInterstitialAd() {
    Random r = new Random();
    bool value = r.nextBool();

    if (value == true) {
      myInterstitial..show();
    }
  }
  @override
  void dispose() {
    myInterstitial.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInterstitial = buildInterstitialAd()..load();
  }

  Widget _createDrawerItem(
      {String icon, String text, GestureTapCallback onTap}) {
    return InkWell(
      onTap: () {
        setState(() {
          query = text;
          Navigator.pop(context);
        });
      },
      child: ListTile(
        title: Row(
          children: <Widget>[
            Image(image: AssetImage(icon),height: 30,),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(text),
            )
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea( 
        child: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
          child: Drawer(
            child:ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                    ],
                  ),
                  decoration: BoxDecoration(

                    image: DecorationImage(
                      image: AssetImage('asset/news.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 5,),
                Align(
                    alignment: Alignment.center,
                    child: InkWell(
                        child: Text("Topics",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)))),
                SizedBox(height: 10,),
                _createDrawerItem(icon : "asset/fast.png",text: 'Sports',),
                _createDrawerItem(icon : "asset/government.png",text: 'World Politics',),
                _createDrawerItem(icon : "asset/tech.PNG",text: 'Technology',),
                _createDrawerItem(icon : "asset/food.png",text: 'Food',),
                _createDrawerItem(icon : "asset/etertainment.png",text: 'Entertainment',),
                _createDrawerItem(icon : "asset/health.png",text: 'Health',),
              ],

            )

          ),
        ),
      ),
      appBar: AppBar(title: Text("Live News"),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: InkWell(
              onTap:() {
                signOutGoogle(context);
              },
              child: Icon(Icons.exit_to_app)),
        )
      ],
      centerTitle: true,
      ),
      bottomNavigationBar: CubertoBottomBar(
        inactiveIconColor: inactiveColor,
        tabStyle: CubertoTabStyle.STYLE_FADED_BACKGROUND, // By default its CubertoTabStyle.STYLE_NORMAL
        selectedTab: currentPage, // By default its 0, Current page which is fetched when a tab is clickd, should be set here so as the change the tabs, and the same can be done if willing to programmatically change the tab.
        drawer: CubertoDrawer(style: CubertoDrawerStyle.NO_DRAWER), // By default its NO_DRAWER (Availble START_DRAWER and END_DRAWER as per where you want to how the drawer icon in Cuberto Bottom bar)
        tabs: [
          TabData(
            iconData: Icons.home,
            title: "Home",
            tabColor: Colors.deepPurple,
          ),
          TabData(
            iconData: Icons.search,
            title: "Search",
            tabColor: Colors.pink,
          ),

        ],
        onTabChangedListener: (position, title, color) {
         /* if(position == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
          }*/
          setState(() {
            currentPage = position;
            currentTitle = title;
            currentColor = color;
          });
        },
      ),

      body: FutureBuilder(
    future: getNews(),
    builder: (context ,snapshot) {
    if(snapshot.connectionState == ConnectionState.waiting) {
    return Center(
    child: Container(
    height: 300,
    width: 300,
    child: LiquidCircularProgressIndicator(
    value: 0.61, // Defaults to 0.5.
    valueColor: AlwaysStoppedAnimation(Colors.blue), // Defaults to the current Theme's accentColor.
    backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
    borderColor: Colors.white,
    borderWidth: 2.0,
    direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
    center: Text("Loading...",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
    ),
    ),
    );
    } else
    {
    return Column(
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {

            },
            onEditingComplete: () {
              setState(() {
                query = editingController.text;
              });
            },
            controller: editingController,
            decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),

        Expanded(
          child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,index) {
                Article article = snapshot.data[index];
                return InkWell(
                  onTap: () {
                    showInterstitialAd();
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) {
                          return ClickedArticle(article);
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 6.0,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(3),
                            child: Text(article.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontFamily: "Playfair Display"),),
                          ),
                          SizedBox(height: 5,),
                          article.urlToImage!=null ? Image.network(article.urlToImage): Text("Search an News"),
                          SizedBox(height: 5,),
                          Container(
                              padding: EdgeInsets.all(8),
                              child: Text(article.description,style: TextStyle(fontSize: 17),))
                        ],
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
    }
    },



      ));

  }
}
