import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/layout/news_app/cubit/cubit.dart';
import 'package:udemy_flutter/layout/shop_app/cubit/cubit.dart';
import 'package:udemy_flutter/layout/social_app/cubit/cubit.dart';
import 'package:udemy_flutter/layout/social_app/social_layout.dart';
import 'package:udemy_flutter/modules/social_app/social_login/social_login_screen.dart';
import 'package:udemy_flutter/shared/bloc_observer.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';
import 'package:udemy_flutter/shared/network/local/cache_helper.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';
import 'package:udemy_flutter/shared/styles/themes.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
  bool isDark = CacheHelper.getData(key: 'isDark');
  //bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  // token = CacheHelper.getData(key: 'token');
   uId = CacheHelper.getData(key: 'uId');

if(uId != null){
  widget = SocialLayout();
}
else{
  widget = SocialLoginScreen();
}

  // if (onBoarding != null) if (token != null) {
  //   widget = ShopLayout();
  // } else
  //   widget = ShopLoginScreen();
  // else {
  //   widget = OnBoardingScreen();
  // }

  runApp(MyApp(isDark: isDark, startWidget: widget));
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget {
  // constructor
  // build
  final bool isDark;
  final Widget startWidget;

  MyApp({this.isDark, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit()
            ..getBusiness()
            ..getSports()
            ..getScience(),
        ),
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getSocialUserData(
            )..getPosts(),
        ),
        //getSocialUserData
        BlocProvider(create: (BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
             // darkTheme:darkTheme,
              themeMode: AppCubit.get(context).isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: startWidget);
        },
      ),
    );
  }
}