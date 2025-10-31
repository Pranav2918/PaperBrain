import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperbrain/src/presentation/features/home/cubits/pdf_cubit.dart';
import 'package:paperbrain/src/presentation/features/chatbot/cubit/chat_cubit.dart';
import 'package:paperbrain/src/data/di/injector.dart' as di;
import 'package:get_it/get_it.dart';
import 'package:paperbrain/src/presentation/features/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Replace with your actual API key (use env variables in production)
  const geminiApiKey = 'AIzaSyD_Qyk-5vVhu60DGBaTusQ6ytS-_uKpMxE';

  // Initialize DI
  await di.initDependencies(geminiApiKey: geminiApiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sl = GetIt.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PDFCubit>()),
        BlocProvider(create: (_) => sl<ChatCubit>()),
      ],
      child: MaterialApp(
        title: 'PaperBrain',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const HomeScreen(),
      ),
    );
  }
}
