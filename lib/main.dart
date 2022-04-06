// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:localisation_sample/my_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Stripe.publishableKey = "pk_test_51KjNQvGdIA07RfpY6wd42kYC60ZYvYzrZF1Ju7ryzsvxQCDiPCVavqwWXXmoOi3m6eUMu9HD5fr5cXtxDMDk2xrH00ZiOrebB5";
  //await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();

  //перестройка приложения при изменении пользователем языка
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setState(() {
      state.locale = locale;
    });
  }
}

class _MyAppState extends State<MyApp> {

  Locale? locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //при запуске приложения переменная locale = null,
      //поэтому здесь locale присваивается локаль устройства
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (this.locale == null) {
          this.locale = deviceLocale;
        }
        return this.locale;
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('ru', ''),
      ],
      theme: ThemeData(primarySwatch: Colors.blue,),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomeWidget(),
      },
    );
  }
}

class MyHomeWidget extends StatefulWidget {

  @override
  _MyHomeWidgetState createState() => _MyHomeWidgetState();
}

class _MyHomeWidgetState extends State<MyHomeWidget> {

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(translation.title),
        //кнопки для смены языка (изменения локали)
        actions: [
          TextButton(
            onPressed: () {
              MyApp.setLocale(context, Locale("en"));
            },
            child: Container(
              width: 40,
              height: 40,
              color: (Localizations.localeOf(context).languageCode != 'en') ?
                Colors.blue : Colors.lightBlueAccent,
              child: Center( child: Text('🇺🇸'))
              )
          ),
          TextButton(
              onPressed: () {
                MyApp.setLocale(context, Locale("ru"));
              },
              child: Container(
                width: 40,
                height: 40,
                color: (Localizations.localeOf(context).languageCode != 'ru') ?
                  Colors.blue : Colors.lightBlueAccent,
                child: Center( child: Text('🇷🇺'))
              )
          ),
          TextButton(
              onPressed: () {
                MyApp.setLocale(context, Locale("es"));
              },
              child: Container(
                width: 40,
                height: 40,
                color: (Localizations.localeOf(context).languageCode != 'es') ?
                  Colors.blue : Colors.lightBlueAccent,
                child: Center( child: Text('🇪🇸'))
              ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          myCard(context,
            'https://i.pinimg.com/originals/a1/90/5c/a1905c3d2adac96c9e9c094dccafc857.jpg',
            translation.winnieName,
            translation.production(DateTime.parse("2022-01-17")),
            translation.honey(4),
            translation.manufacturer("\"Bearhoney\""),
            translation.value(20),
            translation.button
          ),
          myCard(context,
              'https://upload.wikimedia.org/wikipedia/ru/7/70/Eeyore.gif',
              translation.donkey,
              translation.production(DateTime.parse("2022-01-18")),
              translation.honey(1),
              translation.manufacturer("\"Donkeyhoney\""),
              translation.value(20),
              translation.button
          ),
          myCard(context,
              'https://www.youloveit.ru/uploads/gallery/comthumb/761/youloveit_ru_winnie_pooh_baby18.jpg',
              translation.kangaroo,
              translation.production(DateTime.parse("2022-01-11")),
              translation.honey(0),
              translation.manufacturer(""),
              translation.value(0),
              translation.button
          ),
        ],
      ),
    );
  }
}