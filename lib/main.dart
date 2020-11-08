import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_traveller_flutter/blocs/settings/settings_bloc.dart';

import 'blocs/bloc_observer.dart';
import 'blocs/home/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'blocs/home/flight_destination_switcher/flight_destination_switcher_cubit.dart';
import 'blocs/home/most_popular_destinations/most_popular_destinations_cubit.dart';
import 'data/data_providers/remote/amadeus_api/api_service.dart';
import 'data/data_providers/remote/amadeus_api/mocked_data.dart';
import 'data/data_providers/remote/amadeus_api/remote_data.dart';
import 'data/repositories/amadeus_repository.dart';
import 'presentation/pages/flights/search_flights_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/settings/settings_page.dart';
import 'presentation/pages/watchlist/watchlist_page.dart';
import 'config/app/debug_config.dart';
import 'config/theme/theme_config.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarIconBrightness: Brightness.light,
  //     statusBarColor: ColorUtils.primaryDefaultColorBlue,
  //   ),
  // );

  final amadeusBaseDataProvider = DebugConfig.quotaSaveMode
      ? AmadeusMockedDataProvider()
      : AmadeusRemoteDataProvider(ApiService());

  runApp(
    RepositoryProvider<AmadeusRepository>(
      create: (_) => AmadeusRepository(
        amadeusBaseDataProvider: amadeusBaseDataProvider,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc(),
          ),
          BlocProvider<BottomNavBarCubit>(
            create: (_) => BottomNavBarCubit(),
          ),
        ],
        child: MainApp(),
      ),
    ),
  );
}

// TODO: Use Navigator 2.0 (not priority)
class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final pages = <Widget>[
    HomePage(),
    SearchFlightsPage(),
    WatchlistPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavBarState = context.watch<BottomNavBarCubit>().state;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.defaultDarkBlueTheme,
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<FlightDestinationSwitcherCubit>(
              create: (_) => FlightDestinationSwitcherCubit(),
            ),
            BlocProvider<MostPopularDestinationsCubit>(
              create: (_) => MostPopularDestinationsCubit(
                context.read<AmadeusRepository>(),
              )..fetchMostPopularDestinations('MAD'),
            ),
          ],
          child: pages[bottomNavBarState],
        ),
        bottomNavigationBar: buildBottomNavigationBar(
          context,
          currentIndex: bottomNavBarState,
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(
    BuildContext context, {
    @required int currentIndex,
  }) {
    return BottomNavigationBar(
      onTap: (index) {
        context.read<BottomNavBarCubit>().changeNavBarItem(index);
      },
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Flights',
          icon: Icon(Icons.flight),
        ),
        BottomNavigationBarItem(
          label: 'Watchlist',
          icon: Icon(Icons.favorite),
        ),
        BottomNavigationBarItem(
          label: 'Settings',
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}
