import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule_app/core/bloc/fetch_portfolio_photos/fetch_portfolio_photos_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/fetch_regulations_bloc.dart';
import 'package:schedule_app/core/widgets/splash_screen.dart';
import 'core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'core/bloc/fetch_appointments/fetch_appointments_bloc.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:schedule_app/features/portfolio/bloc/actions_portfolio_photos_bloc.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';
import 'package:schedule_app/features/settings/bloc/settings_bloc.dart';
import 'firebase_options.dart';
import 'package:schedule_app/core/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:schedule_app/core/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ru', null);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(
        create: (context) => UserBloc()..add(FetchUserData()),
      ),
      BlocProvider<AllEmployeesBloc>(
        create: (context) => AllEmployeesBloc()..add(FetchAllEmployeesData()),
      ),
      BlocProvider<FetchAppointmentsBloc>(
        create: (context) =>
            FetchAppointmentsBloc()..add(FetchAppointmentsData()),
      ),
      BlocProvider<FetchRegulationsBloc>(
        create: (context) =>
            FetchRegulationsBloc()..add(FetchRegulationsData()),
      ),
      BlocProvider<FetchPortfolioPhotosBloc>(
        create: (context) =>
            FetchPortfolioPhotosBloc()..add(FetchPortfolioPhotosData()),
      ),
      BlocProvider<ActionsAppointmentBloc>(
        create: (context) => ActionsAppointmentBloc(),
      ),
      BlocProvider<ActionsPortfolioPhotosBloc>(
        create: (context) => ActionsPortfolioPhotosBloc(),
      ),
      BlocProvider<ActionsRegulationsBloc>(
        create: (context) => ActionsRegulationsBloc(),
      ),
      BlocProvider<SettingsBloc>(
        create: (context) => SettingsBloc()..add(FetchSettings()),
      ),
    ],
    child: BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          return MaterialApp.router(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('ru', 'RU'), // Russian
            ],
            theme: getTheme(state.settings.themeSeed),
            routerConfig: AppRouter.router,
            // home: const App(),
          );
        }
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English
            Locale('ru', 'RU'), // Russian
          ],
          theme: getTheme(0xFF9A00A5),
          home: const SplashScreen(),
          // home: const App(),
        );
      },
    ),
  ));
}
