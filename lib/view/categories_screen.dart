import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categries_news_model.dart';

import '../services/news_channel_service.dart';
import 'news_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String category = 'General';
  NewsService bbcNews = NewsService();

  List<String> selectedCategory = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];

  final form = DateFormat('MMMM dd,yyyy');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * .06,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedCategory.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {});
                    category = selectedCategory[index];
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color:
                          category == selectedCategory[index]
                              ? Colors.blueAccent
                              : Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Text(selectedCategory[index])),
                  ),
                );
              },
            ),
          ),
          FutureBuilder<CategoriesNewsModel>(
            future: bbcNews.getCategoriesData(category),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: SpinKitCircle(color: Colors.blueAccent));
              } else if (snapshot.hasError) {
                return Text('ERROR ${snapshot.hasError}');
              } else if (!snapshot.hasData) {
                return Text('No Data Available');
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.articles?.length ?? 0,
                    itemBuilder: (context, index) {
                      final apiData = snapshot.data?.articles?[index];
                      DateTime dateTime = DateTime.parse(
                        apiData?.publishedAt ?? '',
                      );
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                    image: apiData?.urlToImage?.toString() ?? '',
                                    source: apiData?.source?.name ?? '',
                                    title: apiData?.title ?? '',
                                    timeDate: apiData?.publishedAt ?? '',
                                    description: apiData?.description ?? '',
                                    content: apiData?.content ?? ''
                                )));
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: apiData?.urlToImage ?? '',
                                  width: width * .3,
                                  height: height * .2,
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
                                  height: height * .2,
                                  child: Column(
                                    children: [
                                      Text(
                                        apiData?.title ?? '',
                                        maxLines: 3,
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
                                          Text(
                                            form.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
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
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
