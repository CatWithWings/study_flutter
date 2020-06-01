import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../pages/article/article.dart';

Handler articlePageHandler = Handler(
    handlerFunc: (
      BuildContext context, Map<String, List<String>> params
    ) {
      String articleId = params['articleId']?.first;
      String title = params['title']?.first;

      return ArticlePage(articleId, title);
    }
);
