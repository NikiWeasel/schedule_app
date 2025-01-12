import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule_app/core/bloc/fetch_portfolio_photos/fetch_portfolio_photos_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/fetch_regulations_bloc.dart';
import 'core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'core/bloc/fetch_appointments/fetch_appointments_bloc.dart';
import 'features/home/bloc/user_bloc.dart';
import 'features/portfolio/bloc/actions_portfolio_photos_bloc.dart';
import 'features/regulations/bloc/actions_regulations_bloc.dart';
import 'features/schedule/bloc/all_employees_bloc.dart';
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

  WidgetsFlutterBinding.ensureInitialized();

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
    ],
    child: MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('ru', 'RU'), // Russian
      ],
      theme: theme,
      routerConfig: AppRouter.router,
      // home: const App(),
    ),
  ));
}
