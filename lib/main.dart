import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule_app/core/bloc/fetch_portfolio_photos/local_portfolio_photos_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/repository/local_appointments_repository.dart';
import 'package:schedule_app/core/repository/local_regulations_repository.dart';
import 'package:schedule_app/core/widgets/splash_screen.dart';
import 'package:schedule_app/core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:schedule_app/features/home/user_repository.dart';
import 'package:schedule_app/features/portfolio/bloc/actions_portfolio_photos_bloc.dart';
import 'package:schedule_app/features/regulations/actions_regulations_repository.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';
import 'package:schedule_app/features/schedule/bloc/local_employees_bloc.dart';
import 'package:schedule_app/features/schedule/local_employees_repository.dart';
import 'package:schedule_app/features/settings/bloc/settings_bloc.dart';
import 'package:schedule_app/features/settings/settings_repository.dart';
import 'package:schedule_app/firebase_options.dart';
import 'package:schedule_app/core/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:schedule_app/core/app_router.dart';
import 'package:schedule_app/core/repository/local_portfolio_photos_repository.dart';
import 'package:schedule_app/core/repository/actions_appointment_repository.dart';
import 'package:schedule_app/features/portfolio/actions_portfolio_photos_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ru', null);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final LocalPortfolioPhotosRepository fetchDataRepository =
      LocalPortfolioPhotosRepository(
          firebaseAuth: firebaseAuth, firebaseStorage: firebaseStorage);

  final LocalEmployeesRepository localEmployeesRepository =
      LocalEmployeesRepository(
    firebaseFirestore: firebaseFirestore,
  );

  final LocalAppointmentsRepository localAppointmentsRepository =
      LocalAppointmentsRepository(
          firebaseFirestore: firebaseFirestore,
          firebaseAuth: firebaseAuth,
          firebaseStorage: firebaseStorage);

  final LocalRegulationsRepository localRegulationsRepository =
      LocalRegulationsRepository(
    firebaseFirestore: firebaseFirestore,
  );

  final userRepository = UserRepository(
      firebaseFirestore: firebaseFirestore, firebaseAuth: firebaseAuth);

  final actionsRegulationsRepository = ActionsRegulationsRepository(
    firebaseFirestore: firebaseFirestore,
  );

  final actionsAppointmentRepository = ActionsAppointmentRepository(
    firebaseFirestore: firebaseFirestore,
  );

  final actionsPortfolioPhotosRepository = ActionsPortfolioPhotosRepository(
      firebaseAuth: firebaseAuth, firebaseStorage: firebaseStorage);

  final settingsRepository = SettingsRepository();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(userRepository)..add(FetchUserData()),
      ),
      BlocProvider<LocalEmployeesBloc>(
        create: (context) => LocalEmployeesBloc(localEmployeesRepository)
          ..add(FetchAllEmployeesData()),
      ),
      BlocProvider<LocalAppointmentsBloc>(
        create: (context) => LocalAppointmentsBloc(localAppointmentsRepository)
          ..add(FetchAppointmentsData()),
      ),
      BlocProvider<LocalRegulationsBloc>(
        create: (context) => LocalRegulationsBloc(localRegulationsRepository)
          ..add(FetchRegulationsData()),
      ),
      BlocProvider<LocalPortfolioPhotosBloc>(
        create: (context) => LocalPortfolioPhotosBloc(fetchDataRepository)
          ..add(FetchPortfolioPhotosData()),
      ),
      BlocProvider<ActionsAppointmentBloc>(
        create: (context) =>
            ActionsAppointmentBloc(actionsAppointmentRepository),
      ),
      BlocProvider<ActionsPortfolioPhotosBloc>(
        create: (context) =>
            ActionsPortfolioPhotosBloc(actionsPortfolioPhotosRepository),
      ),
      BlocProvider<ActionsRegulationsBloc>(
        create: (context) =>
            ActionsRegulationsBloc(actionsRegulationsRepository),
      ),
      BlocProvider<SettingsBloc>(
        create: (context) =>
            SettingsBloc(settingsRepository)..add(FetchSettings()),
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
