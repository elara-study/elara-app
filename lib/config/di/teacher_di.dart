import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source_impl.dart';
import 'package:elara/features/teacher/domain/repositories/teacher_home_repository.dart';
import 'package:elara/features/teacher/data/repositories/teacher_home_repository_impl.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_remote_data_source.dart';
import 'package:elara/features/teacher/group/presentation/cubits/teacher_group_cubit.dart';
import 'package:elara/features/teacher/homework/data/datasources/mock_teacher_homework_datasource.dart';
import 'package:elara/features/teacher/homework/data/datasources/teacher_homework_datasource.dart';
import 'package:elara/features/teacher/homework/data/repositories/teacher_homework_repository_impl.dart';
import 'package:elara/features/teacher/homework/domain/repositories/i_teacher_homework_repository.dart';
import 'package:elara/features/teacher/homework/domain/usecases/get_teacher_module_homework_usecase.dart';
import 'package:elara/features/teacher/homework/domain/usecases/get_teacher_module_resources_usecase.dart';
import 'package:elara/features/teacher/homework/presentation/cubits/teacher_homework_cubit.dart';
import 'package:elara/features/teacher/homework/presentation/cubits/teacher_resources_cubit.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_cubit.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_cubit.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupTeacherDI() {
  // Data Sources & Cubits
  getIt.registerLazySingleton<TeacherHomeDataSource>(
    () => TeacherHomeDataSourceImpl(getIt<DioClient>().dio),
  );

  getIt.registerLazySingleton<TeacherHomeRepository>(
    () => TeacherHomeRepositoryImpl(getIt<TeacherHomeDataSource>()),
  );

  getIt.registerFactory<TeacherHomeCubit>(
    () => TeacherHomeCubit(getIt<TeacherHomeRepository>()),
  );

  getIt.registerFactory<TeacherProfileCubit>(
    () => TeacherProfileCubit(
      repository: getIt<TeacherHomeRepository>(),
    ),
  );

  // Group Detail
  getIt.registerLazySingleton<TeacherGroupDataSource>(
    () => TeacherGroupRemoteDataSourceImpl(getIt<DioClient>().dio),
  );

  getIt.registerFactory<TeacherGroupCubit>(
    () => TeacherGroupCubit(getIt<TeacherGroupDataSource>()),
  );

  // Homework & Resources
  getIt.registerLazySingleton<TeacherHomeworkDatasource>(
    () => MockTeacherHomeworkDatasource(),
  );

  getIt.registerLazySingleton<ITeacherHomeworkRepository>(
    () => TeacherHomeworkRepositoryImpl(getIt<TeacherHomeworkDatasource>()),
  );

  getIt.registerLazySingleton(
    () => GetTeacherModuleHomeworkUseCase(getIt<ITeacherHomeworkRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetTeacherModuleResourcesUseCase(getIt<ITeacherHomeworkRepository>()),
  );

  getIt.registerFactory<TeacherHomeworkCubit>(
    () => TeacherHomeworkCubit(getIt<GetTeacherModuleHomeworkUseCase>()),
  );

  getIt.registerFactory<TeacherResourcesCubit>(
    () => TeacherResourcesCubit(getIt<GetTeacherModuleResourcesUseCase>()),
  );
}
