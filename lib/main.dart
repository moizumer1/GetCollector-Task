import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tcg_collection_app/providers/quantity_provider.dart';
import 'package:tcg_collection_app/providers/theme_provider.dart';
import 'package:tcg_collection_app/screens/screens.dart';
import 'providers/portfolio_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  );

  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SearchProvider()), 
            ChangeNotifierProvider(create: (_) => PortfolioProvider()),
            ChangeNotifierProvider(create: (_) => CategoryProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()), 
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'TCG Collection App',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeProvider.themeMode, 
                initialRoute: Routes.bottomNavigationBarScreen,
                onGenerateRoute: RouteGenerator.generateRoute,
                builder: (context, child) {
                  return Scaffold(
                    body: Stack(
                      children: [
                        child!,
                        Positioned(
                          top: 16.h,
                          right: 16.w,
                          child: IconButton(
                            icon: Icon(
                              themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              themeProvider.toggleTheme(); 
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
