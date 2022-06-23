import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nativ/bloc/app/app_bloc.dart';
import 'package:nativ/bloc/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'package:nativ/bloc/geolocation/bloc/geolocation_bloc.dart';
import 'package:nativ/bloc/location/location_bloc.dart';

import 'package:nativ/data/repositories/auth_repository.dart';
import 'package:nativ/data/repositories/geolocation/geolocation_repository.dart';
import 'package:nativ/data/routes/routes.dart';
import 'package:nativ/firebase_options.dart';
import 'package:nativ/view/pages/profile_menu.dart';
import 'package:nativ/view/pages/settings_menu.dart';
import 'package:nativ/view/widgets/bottom_nav_bar.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';
import 'package:nativ/view/widgets/main_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authRepository = AuthRepository();
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;

  const MyApp({
    Key? key,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _authRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
              create: (context) => AppBloc(authRepository: _authRepository),
            ),
            BlocProvider<BottomNavBarCubit>(
              create: (context) => BottomNavBarCubit(),
            ),
          ],
          child: const AppView(),
        ));
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => GeoLocationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => BottomNavBarCubit(),
          ),
          BlocProvider(
            create: (context) => LocationBloc(),
          ),
          BlocProvider(
            create: (context) => GeolocationBloc(
                geoLocationRepository: context.read<GeoLocationRepository>())
              ..add(LoadGeolocation()),
          ),
        ],
        child: GetMaterialApp(
          // TODO: darkTheme: ThemeData(),
          theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white70,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.0),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
            ),
            textTheme: GoogleFonts.lektonTextTheme(Theme.of(context).textTheme),
            chipTheme: const ChipThemeData(),
            primaryColor: Colors.white,
            // colorSchemeSeed: const Color.fromARGB(255, 76, 94, 255),
            useMaterial3: true,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 35),
              ),
            ),
          ),
          home: FlowBuilder(
            state: context.select((AppBloc bloc) => bloc.state.status),
            onGeneratePages: onGenerateAppViewPages,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Page page() => const MaterialPage<void>(child: HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentRoute = Get.currentRoute;
  final screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const SettingsMenu(),
  ];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final PanelController panelController = PanelController();
    final user = context.select((AppBloc bloc) => bloc.state.user);
    MapController mapController = MapController();
    return Scaffold(
      drawer: Drawer(
        //backgroundColor: Colors.indigo,
        child: Column(
          children: const <Widget>[
            DrawerHeader(
              child: Text(
                'Name',
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return BottomNavBar(index: state.index);
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context.read<AppBloc>().add(AppLogoutRequest());
              },
              icon: const Icon(
                Icons.exit_to_app,
              )),
        ],
        title: const Text(
          'Nativ',
        ),
        //  backgroundColor: Colors.white,
      ),
      body: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          if (state.bottomNavBarItem == BottomNavBarItem.home) {
            return Stack(
              children: [
                const MainMap(),
                BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    if (state is LocationLoading) {
                      return SlidingUpPanel(
                        controller: panelController,
                        defaultPanelState: PanelState.CLOSED,
                        parallaxEnabled: true,
                        parallaxOffset: 1.0,
                        maxHeight: MediaQuery.of(context).size.height * 0.81,
                        minHeight: 150,
                        panelBuilder: ((sc) => NativListView(
                              scrollController: sc,
                            )),
                        body: const MainMap(),
                      );
                    }
                    return const MainMap();
                  },
                ),
              ],
            );
          } else if (state.bottomNavBarItem == BottomNavBarItem.profile) {
            return const ProfileMenu();
          } else if (state.bottomNavBarItem == BottomNavBarItem.settings) {
            return const SettingsMenu();
          }
          return Container();
        },
      ),
    );
  }
}
