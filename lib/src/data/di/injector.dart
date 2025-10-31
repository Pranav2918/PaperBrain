import 'package:get_it/get_it.dart';
import 'package:paperbrain/src/presentation/features/home/cubits/pdf_cubit.dart';
import 'package:paperbrain/src/presentation/features/chatbot/cubit/chat_cubit.dart';
import 'package:paperbrain/src/domain/services/gemini_chat_service.dart';
import 'package:paperbrain/src/data/repositories/app_repositories_impl.dart';
import 'package:paperbrain/src/domain/repositories/app_repositories.dart';

final sl = GetIt.instance;

Future<void> initDependencies({required String geminiApiKey}) async {

  //Core
  sl.registerLazySingleton<GeminiService>(() => GeminiService(geminiApiKey));

  // Repositories
  sl.registerLazySingleton<AppRepository>(
    () => AppRepositoryImpl(sl<GeminiService>()),
  );

  // Cubits
  sl.registerFactory<PDFCubit>(() => PDFCubit());
  sl.registerFactory<ChatCubit>(() => ChatCubit(sl<AppRepository>()));
}
