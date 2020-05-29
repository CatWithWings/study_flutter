import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../pages/home/home.dart';

Handler homePageHandler = Handler(
    handlerFunc: (
      BuildContext context, Map<String, List<String>> params
    ) {
      return HomePage();
    }
);
