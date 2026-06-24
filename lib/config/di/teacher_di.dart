import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source_impl.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source_impl.dart';
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
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupTeacherDI() {
  // Data Sources & Cubits
  getIt.registerLazySingleton<TeacherHomeDataSource>(
    () => const TeacherHomeDataSourceImpl(),
  );

  getIt.registerFactory<TeacherHomeCubit>(
    () => TeacherHomeCubit(getIt<TeacherHomeDataSource>()),
  );

  // Group Detail
  getIt.registerLazySingleton<TeacherGroupDataSource>(
    () => const TeacherGroupDataSourceImpl(),
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
