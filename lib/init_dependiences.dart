import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  await dotenv.load(fileName: ".env");
  final supabase = await Supabase.initialize(
    url: dotenv.env['supabaseUrl']!,
    publishableKey: dotenv.env['publishableKey'],
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
    ..registerFactory(
      () => AuthRemoteDataSoruceImpl(serviceLocator<SupabaseClient>()),
    )
    ..registerFactory(
      () => AuthRepositoryImpl(serviceLocator<AuthRemoteDataSoruceImpl>()),
    )
    ..registerFactory(() => UserSignUp(serviceLocator<AuthRepositoryImpl>()))
    ..registerFactory(() => UserLogin(serviceLocator<AuthRepositoryImpl>()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userLogin: serviceLocator<UserLogin>(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
