import 'dart:convert';

import 'package:news_app/models/bbc_news_channel_model.dart';
import 'package:http/http.dart' as http;

class BBCChannelService {

  Future<BBCNewsChannelModel> getData(String key) async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?sources=${key}&apiKey=f85ad21511ff40d393dac9a2f3e79546'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return BBCNewsChannelModel.fromJson(data);
    } else {
      throw Exception('ERROR OCCURRED');
    }
  }
}
