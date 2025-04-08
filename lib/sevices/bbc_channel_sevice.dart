import 'dart:convert';

import 'package:news_app/models/bbc_news_channel_model.dart';
import 'package:http/http.dart' as http;

class BBCChannelService {
  final String url =
      'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=f85ad21511ff40d393dac9a2f3e79546';

  Future<BBCNewsChannelModel> getData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return BBCNewsChannelModel.fromJson(data);
    } else {
      throw Exception('ERROR OCCURRED');
    }
  }
}
