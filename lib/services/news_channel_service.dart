import 'dart:convert';

import 'package:news_app/models/bbc_news_channel_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categries_news_model.dart';

class NewsService {

  Future<BBCNewsChannelModel> getChannelData(String key) async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?sources=$key&apiKey=f85ad21511ff40d393dac9a2f3e79546'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return BBCNewsChannelModel.fromJson(data);
    } else {
      throw Exception('ERROR OCCURRED');
    }
  }

  Future<CategoriesNewsModel> getCategoriesData(String category)async{
    final response =await http.get(Uri.parse('https://newsapi.org/v2/everything?q=$category&apiKey=f85ad21511ff40d393dac9a2f3e79546'));

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(data);
    }else{
      throw Exception('ERROR OCCURRED');
    }
  }

}
