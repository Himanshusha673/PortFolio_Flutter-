import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mysite/core/configs/configs.dart';
import 'package:mysite/core/configs/connection/bloc/connected_bloc.dart';
import 'package:mysite/core/configs/connection/network_check.dart';
import 'package:mysite/core/providers/drawer_provider.dart';
import 'package:mysite/core/providers/scroll_provider.dart';
import 'package:mysite/core/theme/cubit/theme_cubit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class MySite extends StatelessWidget {
  MySite({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initilization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initilization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print('done');
            return MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
                BlocProvider<ConnectedBloc>(
                    create: (context) => ConnectedBloc()),
              ],
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => DrawerProvider()),
                  ChangeNotifierProvider(create: (_) => ScrollProvider()),
                ],
                child: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                  return Sizer(builder: (context, orientation, deviceType) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Himanshu',
                      theme: AppTheme.themeData(state.isDarkThemeOn, context),
                      initialRoute: "/",
                      routes: {"/": (context) => const NChecking()},
                    );
                  });
                }),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
