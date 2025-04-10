import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String image;
  final String source;
  final String title;
  final String timeDate;
  final String description;
  final String content;

  const NewsDetailScreen({
    super.key,
    required this.image,
    required this.source,
    required this.title,
    required this.timeDate,
    required this.description,
    required this.content,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MMMM dd,yyyy');

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.timeDate);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            SizedBox(
              width: width * .9,
              height: height * .5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
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
            Text(widget.title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: height*.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(widget.source,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
                Text(format.format(dateTime),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
            ],),
            SizedBox(height: height*.03,),
            Text(widget.description,
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            ),
            SizedBox(height: height*.015,),
            Text(widget.content,
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
