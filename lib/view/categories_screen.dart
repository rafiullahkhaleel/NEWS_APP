import 'package:flutter/material.dart';

import '../services/news_channel_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String category = 'general';
  NewsService bbcNews = NewsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
