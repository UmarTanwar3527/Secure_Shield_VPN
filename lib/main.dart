import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_shield_vpn/Controller/homeProvider.dart';
import 'package:secure_shield_vpn/Controller/locationProvider.dart';
import 'package:secure_shield_vpn/Controller/pref.dart';
import 'package:secure_shield_vpn/Views/Screens/Splash_Screen.dart';
import 'package:secure_shield_vpn/Views/Screens/onBoardingScreen.dart';
import 'package:secure_shield_vpn/Views/constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Pref.initializeHive();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///For Checking the user is new or not
  bool newUser = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WheretoGo();
  }

  Check() async {
    await WheretoGo();
  }

  ///For checking if user is new or old user
  WheretoGo() async {
    var sharedpreference = await SharedPreferences.getInstance();
    var user = sharedpreference.getBool('newUser');
    print(user);
    if (user != null) {
      if (user) {
        setState(() {
          newUser = true;
        });
      } else {
        setState(() {
          newUser = false;
        });
      }
    } else {
      setState(() {
        newUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VpnProvider>(create: (context) => VpnProvider()),
        ChangeNotifierProvider<LocationProvider>(
            create: (context) => LocationProvider()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: IconBluecolor,
            ),
            scaffoldBackgroundColor: primarycolor,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: primarycolor,
                  systemNavigationBarColor: primarycolor,
                )),
            brightness: Brightness.light,
            unselectedWidgetColor: Colors.white,
            checkboxTheme: CheckboxThemeData(
              fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return Colors.yellow;
                }
                return null;
              }),
            ),
            radioTheme: RadioThemeData(
              fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return Colors.yellow;
                }
                return null;
              }),
            ),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return Colors.yellow;
                }
                return null;
              }),
              trackColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return null;
                }
                if (states.contains(WidgetState.selected)) {
                  return Colors.yellow;
                }
                return null;
              }),
            ),
            // canvasColor: Colors.transparent
          ),
          debugShowCheckedModeBanner: false,
          home: newUser ? const Splash_Screen() : const OnBoardingScreen(),
        );
      }),
    );
  }
}
