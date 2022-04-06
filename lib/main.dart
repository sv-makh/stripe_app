import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:localisation_sample/my_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:localisation_sample/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();

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
      theme: ThemeData(primarySwatch: Colors.purple,),
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
                Colors.purple : Colors.purpleAccent,
              child: const Center( child: Text('🇺🇸'))
              )
          ),
          TextButton(
              onPressed: () {
                MyApp.setLocale(context, const Locale("ru"));
              },
              child: Container(
                width: 40,
                height: 40,
                color: (Localizations.localeOf(context).languageCode != 'ru') ?
                Colors.purple : Colors.purpleAccent,
                child: const Center( child: Text('🇷🇺'))
              )
          ),
          TextButton(
              onPressed: () {
                MyApp.setLocale(context, const Locale("es"));
              },
              child: Container(
                width: 40,
                height: 40,
                color: (Localizations.localeOf(context).languageCode != 'es') ?
                Colors.purple : Colors.purpleAccent,
                child: const Center( child: Text('🇪🇸'))
              ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          myCard(context,
            winnieImg,
            translation.winnieName,
            translation.production(DateTime.parse("2022-01-17")),
            translation.honey(4),
            translation.manufacturer("\"Bearhoney\""),
            translation.value(20),
            translation.button,
            2000
          ),
          myCard(context,
            donkeyImg,
            translation.donkey,
            translation.production(DateTime.parse("2022-01-18")),
            translation.honey(1),
            translation.manufacturer("\"Donkeyhoney\""),
            translation.value(20),
            translation.button,
            2000
          ),
          myCard(context,
            kengaImg,
            translation.kangaroo,
            translation.production(DateTime.parse("2022-01-11")),
            translation.honey(0),
            translation.manufacturer(""),
            translation.value(0),
            translation.button,
            0
          ),
        ],
      ),
    );
  }
}