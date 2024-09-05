import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'request.dart';
import 'newsDataModel.dart';

TextEditingController numbercontroller = TextEditingController();
String? permnumber;
Future<List<News>> newscards = getNews();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/news',
        builder: (context, state) => const NewsPage(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkSharedPreferences();
  }

  void checkSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('number')) {
      String? pnumber = prefs.getString('number');
      getNews();
      permnumber = pnumber;
      print(pnumber);
      Timer(const Duration(seconds: 3), () => context.go('/news'));
    } else {
      Timer(const Duration(seconds: 3), () => context.go('/login'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.newspaper,
              size: 72,
              color: Color.fromARGB(255, 102, 83, 160),
            ),
            Container(
              padding: const EdgeInsets.all(36.0),
              child: const LinearProgressIndicator(
                minHeight: 6,
                color: Color.fromARGB(255, 102, 83, 160),
                backgroundColor: Color.fromARGB(127, 102, 83, 160),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController numbercontroller = TextEditingController();
  // Функция для обработки нажатия кнопки "Войти"
  Future<void> handleLogin() async {
    String pnumber = numbercontroller.text;
    print(pnumber);
    if (pnumber == '911') {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
                title: Text("Что-то пошло не так",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Color.fromARGB(255, 54, 54, 54),
                      fontSize: 16,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                    )),
                content: SingleChildScrollView(
                    child: ListBody(children: <Widget>[
                  Text("Проверьте введенные Вами данные, номер 911 недопустим",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 54, 54, 54),
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                      ))
                ])));
          });
    } else if (pnumber.isEmpty || pnumber.length < 11 || pnumber.length > 13) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
                title: Text("Что-то пошло не так",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Color.fromARGB(255, 54, 54, 54),
                      fontSize: 16,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                    )),
                content: SingleChildScrollView(
                    child: ListBody(children: <Widget>[
                  Text("Введите полный номер",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 54, 54, 54),
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                      ))
                ])));
          });
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      permnumber = pnumber;
      print(permnumber);
      getNews();
      await prefs.setString('number', pnumber);
      context.go('/news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 48),
              child: const Text(
                "Авторизоваться",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 36),
              child: TextField(
                  controller: numbercontroller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Номер телефона",
                    hintText: "+# (###) ###-##-##",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        numbercontroller.clear();
                      },
                    ),
                  )),
            ),
            Container(
                margin: const EdgeInsets.only(left: 24),
                child: SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 102, 83, 160),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        )),
                    child: const Text(
                      'Вход',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(248, 248, 248, 248),
          title: const Text(
            'Новости',
            style: TextStyle(
              color: Color.fromARGB(255, 62, 62, 62),
              fontSize: 20,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  context.push('/account');
                },
                icon: const Icon(
                  Icons.account_circle,
                  color: Color.fromARGB(255, 102, 83, 160),
                  size: 32,
                )),
          ]),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<List<News>>(
            future: newscards,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final newscards = snapshot.data!;
                return buildNews(newscards);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return const Text("Нет данных");
              }
            },
          ),
        ),
      ),
    );
  }

  buildNews(List<News> newscards) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: newscards.length,
        itemBuilder: (context, index) {
          final news = newscards[index];
          return Container(
              margin: const EdgeInsets.all(12.0),
              color: const Color.fromARGB(0, 255, 255, 255),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(news: news),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        height: 10,
                        color: Color.fromARGB(0, 255, 255, 255),
                      ),
                      Text(
                        news.date,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 62, 62, 62),
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(
                        height: 10,
                        color: Color.fromARGB(0, 255, 255, 255),
                      ),
                      Image.network(news.image),
                      const Divider(
                        height: 10,
                        color: Color.fromARGB(0, 255, 255, 255),
                      ),
                      Text(
                        news.name,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 62, 62, 62),
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(
                        height: 10,
                        color: Color.fromARGB(0, 255, 255, 255),
                      ),
                    ],
                  )));
        },
      );
}

class NewsDetailPage extends StatelessWidget {
  final News news;

  NewsDetailPage({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 102, 83, 160),
          title: Text(news.name),
        ),
        body: Container(
          margin: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.date,
                style: const TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 14,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(
                height: 10,
                color: Color.fromARGB(0, 255, 255, 255),
              ),
              Image.network(news.image),
              const Divider(
                height: 10,
                color: Color.fromARGB(0, 255, 255, 255),
              ),
              Text(
                news.name,
                style: const TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 18,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(
                height: 10,
                color: Color.fromARGB(0, 255, 255, 255),
              ),
              Text(
                news.description != null
                    ? news.description
                    : "Описание пока не добавили....",
              ),
            ],
          ),
        ));
  }
}

class AccPage extends StatefulWidget {
  const AccPage({super.key});

  @override
  _AccPageState createState() => _AccPageState();
}

class _AccPageState extends State<AccPage> {
  TextEditingController numbercontroller = TextEditingController();

  // Функция для обработки нажатия кнопки "Выйти"
  Future<void> exitAcc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('number');
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.go('/news');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 102, 83, 160),
              size: 24,
            )),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(248, 248, 248, 248),
        title: const Text(
          'Профиль',
          style: TextStyle(
            color: Color.fromARGB(255, 62, 62, 62),
            fontSize: 20,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 36),
              child: const Text(
                'Номер телефона',
                style: TextStyle(
                  color: Color.fromARGB(255, 85, 85, 85),
                  fontSize: 24,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 1000,
              height: 64,
              padding: const EdgeInsets.only(
                  left: 14, right: 24, bottom: 20, top: 20),
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 36),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, // Set border color
                    width: 1.0), // Set border width
                borderRadius: const BorderRadius.all(
                    Radius.circular(4.0)), // Set rounded corner radius
              ),
              child: Text(
                "+$permnumber",
                style: const TextStyle(
                  color: Color.fromARGB(255, 85, 85, 85),
                  fontSize: 16,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    exitAcc();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 160, 83, 83),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                      )),
                  child: const Text(
                    'Выйти',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
