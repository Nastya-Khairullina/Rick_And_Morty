import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:untitled1/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:untitled1/locator_service.dart';
import 'common/app_colors.dart';
import 'feature/presentation/pages/person_screen.dart';
import 'locator_service.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonListCubit>(
            create: (context) => sl<PersonListCubit>()..loadPerson()),
        BlocProvider<PersonSearchBloc>(
            create: (context) => sl<PersonSearchBloc>()),
      ],
      child: MaterialApp(
        theme: ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.mainBackground,
    foregroundColor: AppColors.mainBackground,
    ),),
        home: const HomePage(),
      ),
    );
  }
}