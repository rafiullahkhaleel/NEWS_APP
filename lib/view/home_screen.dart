import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/bbc_channel_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final format = DateFormat('MMMM dd,yyyy');
  BBCChannelService bbcNews = BBCChannelService();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset('assets/category_icon.png', height: 25, width: 25),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            child: FutureBuilder(
              future: bbcNews.getData(),
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
                      DateTime dateTime = DateTime.parse(apiData?.publishedAt.toString() ?? '');
                      return Stack(
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
                              height: height*.25,
                              width: width*.8,
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Text(apiData?.title ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500
                                      ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text(apiData?.source?.name.toString() ?? '',
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        Text(format.format(dateTime),
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500
                                          ),
                                        )
                                      ],)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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
