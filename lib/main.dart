// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

//https://stackoverflow.com/questions/49441212/flutter-multi-lingual-application-how-to-override-the-locale/59410830#59410830

class LocaleModel with ChangeNotifier {
  Locale locale = Locale('en');
  Locale get getlocale => locale;

  void changelocale(Locale l) {
    locale = l;
    notifyListeners();
  }
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleModel(),
      child: Consumer<LocaleModel>(
        builder: (context, provider, child) =>
        MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
            const Locale('es', ''),
            const Locale('ru', ''),
          ],
          locale: Provider.of<LocaleModel>(context).locale,
          theme: ThemeData(primarySwatch: Colors.blue,),
          initialRoute: '/',
          routes: {
            '/': (context) => MyHomeWidget(),
          },
        )
      )
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
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<LocaleModel>(context, listen: false).changelocale(Locale("en"));
            },
            child: Text('🇺🇸')
          ),
          TextButton(
              onPressed: () {
                Provider.of<LocaleModel>(context, listen: false).changelocale(Locale("ru"));
              },
              child: Text('🇷🇺')
          ),
          TextButton(
              onPressed: () {
                Provider.of<LocaleModel>(context, listen: false).changelocale(Locale("es"));
              },
              child: Text('🇪🇸')
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _myCard(context,
            'https://i.pinimg.com/originals/a1/90/5c/a1905c3d2adac96c9e9c094dccafc857.jpg',
            translation.winnieName,
            translation.production(DateTime.parse("2022-01-17")),
            translation.honey(4),
            translation.manufacturer("\"Bearhoney\""),
            translation.value(20)//'4 Jars - USD 20'
          ),
          _myCard(context,
              'https://upload.wikimedia.org/wikipedia/ru/7/70/Eeyore.gif',
              translation.donkey,
              translation.production(DateTime.parse("2022-01-18")),
              translation.honey(1),
              translation.manufacturer("\"Donkeyhoney\""),
              translation.value(20)
          ),
          _myCard(context,
              'https://www.youloveit.ru/uploads/gallery/comthumb/761/youloveit_ru_winnie_pooh_baby18.jpg',
              translation.kangaroo,
              translation.production(DateTime.parse("2022-01-11")),
              translation.honey(0),
              translation.manufacturer(""),
              translation.value(0)
          ),
        ],
      ),
    );
  }
}

Widget _myCard(BuildContext context,
    String image, String name, String date, String honey, String manufacturer, String value) {

  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Image.network(image),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
              Text(date),
              Text("$honey $manufacturer - $value"),
            ],
          ),
        ],
      ),
    ),
  );
}