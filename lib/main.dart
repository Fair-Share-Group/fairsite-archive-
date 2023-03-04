import 'package:fairsite/company/company_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_first/frame.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/login_page.dart';
import 'package:fairsite/dashboard/dashboard_page.dart';
import 'package:fairsite/state/generic_state_notifier.dart';
import 'package:fairsite/state/theme_state_notifier.dart';
import 'package:fairsite/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkTheme = ref.watch(themeStateNotifierProvider);
    return MaterialApp(
      title: 'Fair Share Group',
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: TheApp(),
    );
  }
}

final isLoggedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

final isLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

class TheApp extends ConsumerStatefulWidget {
  const TheApp({Key? key}) : super(key: key);
  @override
  TheAppState createState() => TheAppState();
}

class TheAppState extends ConsumerState<TheApp> {
  //bool isLoading = false;
  @override
  void initState() {
    super.initState();
    ref.read(isLoading.notifier).value = true;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        ref.read(isLoggedIn.notifier).value = false;
        ref.read(isLoading.notifier).value = false;
      } else {
        ref.read(isLoggedIn.notifier).value = true;
        ref.read(isLoading.notifier).value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(isLoading)) {
      return Center(
        child: Container(
          alignment: Alignment(0.0, 0.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Stack(
        children: [
          Opacity(
              opacity: 0.5, // set the opacity value between 0.0 and 1.0
              child: Image(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1502101872923-d48509bff386?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1932&q=80'))),
          Opacity(
              opacity: 0.8, // set the opacity value between 0.0 and 1.0
              child: Center(
                  child: SizedBox(
                      width: 800,
                      child: Frame(
                        onGenerateRoute: (RouteSettings r) {
                          print('onGenerateRoute: ${r}');
                          if (r.name == '/') {
                            return PageRouteBuilder(
                                pageBuilder: (context, a, b) => LoginPage(),
                                settings: r);
                          } else if (r.name == '/blank') {
                            return PageRouteBuilder(
                                pageBuilder: (context, a, b) => LoginPage(),
                                settings: r);
                          } else if (r.name == '/details') {
                            return PageRouteBuilder(
                                pageBuilder: (context, a, b) => LoginPage(),
                                settings: r);
                          }
                          // // return homePage;
                          // return PageRouteBuilder(
                          //     pageBuilder: (context, a, b) => HomePage1(), settings: r);
                        },
                        // count: 3,
                        // homePage: PageRouteBuilder(
                        //     pageBuilder: (context, a, b) =>
                        //         HomePage(navigatorKeys[1]),
                        //     settings: RouteSettings(name: '/'),
                        //     fullscreenDialog: true),
                        // blankPage: PageRouteBuilder(
                        //     pageBuilder: (context, a, b) => BlankPage(),
                        //     fullscreenDialog: true,
                        //     settings: RouteSettings(name: '/blank')),
                      ))))
        ],
      );
    }
    //   Scaffold(
    //       body: ref.watch(isLoggedIn) == false
    //           ? LoginPage()
    //           : DefaultTabController(
    //               initialIndex: 0,
    //               length: 1,
    //               child: Navigator(
    //                 onGenerateRoute: (RouteSettings settings) {
    //                   // print('onGenerateRoute: ${settings}');
    //                   if (settings.name == '/' || settings.name == 'search') {
    //                     return PageRouteBuilder(
    //                         pageBuilder: (_, __, ___) =>
    //                             //DashboardPage()
    //                             CompanyListPage());
    //                   } else {
    //                     //  else if (settings.name == 'lists') {
    //                     //   return PageRouteBuilder(
    //                     //       pageBuilder: (_, __, ___) => ListsPage());
    //                     // } else if (settings.name == 'pep admin') {
    //                     //   return PageRouteBuilder(
    //                     //       pageBuilder: (_, __, ___) => PepAdminPage());
    //                     // } else if (settings.name == 'pep library') {
    //                     //   return PageRouteBuilder(
    //                     //       pageBuilder: (_, __, ___) => PepLibraryPage());
    //                     // } else if (settings.name == 'adverse media') {
    //                     //   return PageRouteBuilder(
    //                     //       pageBuilder: (_, __, ___) => AdverseMediaPage());
    //                     // } else {
    //                     throw 'no page to show';
    //                   }
    //                 },
    //               )));
    // }
  }
}
