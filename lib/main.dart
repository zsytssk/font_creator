import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_creator/home/home_model.dart';
import 'package:provider/provider.dart';
import 'package:font_creator/home/home.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

main() async {
  configureApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeNotifier(HomeData())),
      ],
      child:
          MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage())));
}
