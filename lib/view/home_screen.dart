import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/bbc_news_channel_model.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import '../models/categries_news_model.dart';
import '../services/news_channel_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilteredList {
  bbcNews,
  aryNews,
  alJazeera,
  arabic,
  cnn,
  crypto,
  focus,
  googleNews,
  independent,
}

class _HomeScreenState extends State<HomeScreen> {
  FilteredList? selectedMenu;

  final format = DateFormat('MMMM dd,yyyy');
  String name = 'bbc-news';
  NewsService bbcNews = NewsService();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>CategoriesScreen()));
          },
          icon: Image.asset('assets/category_icon.png', height: 25, width: 25),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilteredList>(
            onSelected: (FilteredList option) {
              if (option == FilteredList.bbcNews) {
                name = 'bbc-news';
              }
              if (option == FilteredList.aryNews) {
                name = 'ary-news';
              }
              if (option == FilteredList.alJazeera) {
                name = 'al-jazeera-english';
              }
              if (option == FilteredList.arabic) {
                name = 'argaam';
              }
              if (option == FilteredList.cnn) {
                name = 'cnn';
              }
              if (option == FilteredList.crypto) {
                name = 'crypto-coins-news';
              }
              if (option == FilteredList.focus) {
                name = 'focus';
              }
              if (option == FilteredList.googleNews) {
                name = 'google-news';
              }
              if (option == FilteredList.independent) {
                name = 'independent';
              }
              setState(() {
                selectedMenu = option;
              });
            },
            initialValue: selectedMenu,
            itemBuilder: (context) {
              return <PopupMenuEntry<FilteredList>>[
                PopupMenuItem<FilteredList>(
                  value: FilteredList.bbcNews,
                  child: Text('BBCNews'),
                ),
                PopupMenuItem(
                  value: FilteredList.aryNews,
                  child: Text('ARYNews'),
                ),
                PopupMenuItem(
                  value: FilteredList.alJazeera,
                  child: Text('Al-Jazeera'),
                ),
                PopupMenuItem(
                  value: FilteredList.arabic,
                  child: Text('Arabic-News'),
                ),
                PopupMenuItem(value: FilteredList.cnn, child: Text('CNN')),
                PopupMenuItem(
                  value: FilteredList.crypto,
                  child: Text('Crypto-Currency'),
                ),
                PopupMenuItem(
                  value: FilteredList.focus,
                  child: Text('Focus-News'),
                ),
                PopupMenuItem(
                  value: FilteredList.googleNews,
                  child: Text('Google-News'),
                ),
                PopupMenuItem(
                  value: FilteredList.independent,
                  child: Text('Independent'),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            child: FutureBuilder<BBCNewsChannelModel>(
              future: bbcNews.getChannelData(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitCircle(color: Colors.blueAccent);
                } else if (snapshot.hasError) {
                  return Text('ERROR ${snapshot.hasError}');
                } else if (!snapshot.hasData) {
                  return Text('No Data Available');
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.articles?.length ?? 0,
                    itemBuilder: (context, index) {
                      final apiData = snapshot.data?.articles?[index];
                      DateTime dateTime = DateTime.parse(
                        apiData?.publishedAt.toString() ?? '',
                      );
                      return InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                  image: apiData?.urlToImage?.toString() ?? '',
                                  source: apiData?.source?.name ?? '',
                                  title: apiData?.title ?? '',
                                  timeDate: apiData?.publishedAt ?? '',
                                  description: apiData?.description ?? '',
                                  content: apiData?.content ?? '',

                              )));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              width: width * .9,
                              height: height * .55,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: apiData?.urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) =>
                                          SpinKitCircle(color: Colors.blueAccent),
                                  errorWidget:
                                      (context, url, error) =>
                                          Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: height * .25,
                                width: width * .8,
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Text(
                                          apiData?.title ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                apiData?.source?.name
                                                        .toString() ??
                                                    '',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * .05),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          FutureBuilder<CategoriesNewsModel>(
            future: bbcNews.getCategoriesData('General'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: SpinKitCircle(color: Colors.blueAccent));
              } else if (snapshot.hasError) {
                return Text('ERROR ${snapshot.hasError}');
              } else if (!snapshot.hasData) {
                return Text('No Data Available');
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.articles?.length ?? 0,
                  itemBuilder: (context, index) {
                    final apiData = snapshot.data?.articles?[index];
                    DateTime dateTime = DateTime.parse(
                      apiData?.publishedAt ?? '',
                    );
                    return InkWell(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                image: apiData?.urlToImage?.toString() ?? '',
                                source: apiData?.source?.name ?? '',
                                title: apiData?.title ?? '',
                                timeDate: apiData?.publishedAt ?? '',
                                description: apiData?.description ?? '',
                                content: apiData?.content ?? '',
                            )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: apiData?.urlToImage ?? '',
                                width: width * .3,
                                height: height * .16,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) =>
                                    SpinKitCircle(color: Colors.blueAccent),
                                errorWidget: (context, url, error) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                              ),
                            ),
                            SizedBox(width: width * .025),
                            Expanded(
                              child: SizedBox(
                                height: height * .16,
                                child: Column(
                                  children: [
                                    Text(
                                      apiData?.title ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            apiData?.source?.name ?? '',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
