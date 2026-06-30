import 'package:elara/features/teacher/domain/usecases/get_teacher_dashboard_usecase.dart';
import 'package:elara/features/teacher/domain/usecases/get_teacher_groups_usecase.dart';
import 'package:elara/features/teacher/domain/usecases/get_teacher_roadmaps_usecase.dart';
import 'package:elara/features/teacher/domain/usecases/get_teacher_roadmap_details_usecase.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_groups_cubit.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_roadmaps_cubit.dart';
import 'package:elara/features/teacher/domain/usecases/create_teacher_group_usecase.dart';
import 'package:elara/features/teacher/domain/usecases/create_teacher_roadmap_usecase.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source_impl.dart';
import 'package:elara/features/teacher/domain/repositories/teacher_home_repository.dart';
import 'package:elara/features/teacher/data/repositories/teacher_home_repository_impl.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_remote_data_source.dart';
import 'package:elara/features/teacher/group/presentation/cubits/teacher_group_cubit.dart';
import 'package:elara/features/teacher/homework/data/datasources/mock_teacher_homework_datasource.dart';
import 'package:elara/features/teacher/homework/data/datasources/teacher_homework_datasource.dart';
import 'package:elara/features/teacher/group/domain/repositories/teacher_group_repository.dart';
import 'package:elara/features/teacher/group/data/repositories/teacher_group_repository_impl.dart';
import 'package:elara/features/teacher/group/domain/usecases/get_teacher_group_detail_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/add_teacher_group_student_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/get_teacher_roadmap_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/get_teacher_student_profile_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/get_teacher_student_insights_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/get_teacher_announcements_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/add_teacher_announcement_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/delete_teacher_announcement_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/delete_teacher_group_usecase.dart';
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

  getIt.registerLazySingleton<GetTeacherDashboardUseCase>(
    () => GetTeacherDashboardUseCase(getIt<TeacherHomeRepository>()),
  );

  getIt.registerLazySingleton<CreateTeacherGroupUseCase>(
    () => CreateTeacherGroupUseCase(getIt<TeacherHomeRepository>()),
  );

  getIt.registerLazySingleton<GetTeacherGroupsUseCase>(
    () => GetTeacherGroupsUseCase(getIt<TeacherHomeRepository>()),
  );

  getIt.registerLazySingleton<CreateTeacherRoadmapUseCase>(
    () => CreateTeacherRoadmapUseCase(getIt<TeacherHomeRepository>()),
  );

  getIt.registerLazySingleton<GetTeacherRoadmapsUseCase>(
    () => GetTeacherRoadmapsUseCase(getIt<TeacherHomeRepository>()),
  );

  getIt.registerLazySingleton<GetTeacherRoadmapDetailsUseCase>(
    () => GetTeacherRoadmapDetailsUseCase(getIt<TeacherHomeRepository>()),
  );

  getIt.registerFactory<TeacherHomeCubit>(
    () => TeacherHomeCubit(
      getTeacherDashboard: getIt<GetTeacherDashboardUseCase>(),
      createTeacherGroup: getIt<CreateTeacherGroupUseCase>(),
      createTeacherRoadmap: getIt<CreateTeacherRoadmapUseCase>(),
    ),
  );

  getIt.registerFactory<TeacherProfileCubit>(
    () => TeacherProfileCubit(
      getTeacherDashboard: getIt<GetTeacherDashboardUseCase>(),
    ),
  );

  getIt.registerFactory<TeacherGroupsCubit>(
    () => TeacherGroupsCubit(
      getIt<GetTeacherGroupsUseCase>(),
      getIt<CreateTeacherGroupUseCase>(),
    ),
  );

  getIt.registerFactory<TeacherRoadmapsCubit>(
    () => TeacherRoadmapsCubit(
      getIt<GetTeacherRoadmapsUseCase>(),
      getIt<CreateTeacherRoadmapUseCase>(),
    ),
  );

  // Group Detail
  getIt.registerLazySingleton<TeacherGroupDataSource>(
    () => TeacherGroupRemoteDataSourceImpl(getIt<DioClient>().dio),
  );

  getIt.registerLazySingleton<TeacherGroupRepository>(
    () => TeacherGroupRepositoryImpl(getIt<TeacherGroupDataSource>()),
  );

  // Group UseCases
  getIt.registerLazySingleton<GetTeacherGroupDetailUseCase>(
    () => GetTeacherGroupDetailUseCase(getIt<TeacherGroupRepository>()),
  );
  getIt.registerLazySingleton<AddTeacherGroupStudentUseCase>(
    () => AddTeacherGroupStudentUseCase(getIt<TeacherGroupRepository>()),
  );
  getIt.registerLazySingleton<GetTeacherRoadmapUseCase>(
    () => GetTeacherRoadmapUseCase(getIt<TeacherGroupRepository>()),
  );
  getIt.registerLazySingleton<GetTeacherStudentProfileUseCase>(
    () => GetTeacherStudentProfileUseCase(getIt<TeacherGroupRepository>()),
  );
  getIt.registerLazySingleton<GetTeacherStudentInsightsUseCase>(
    () => GetTeacherStudentInsightsUseCase(getIt<TeacherGroupRepository>()),
  );
  getIt.registerLazySingleton<GetTeacherAnnouncementsUseCase>(
    () => GetTeacherAnnouncementsUseCase(getIt<TeacherGroupRepository>()),
  );
  getIt.registerLazySingleton<AddTeacherAnnouncementUseCase>(
    () => AddTeacherAnnouncementUseCase(getIt<TeacherGroupRepository>()),
  );
  getIt.registerLazySingleton<DeleteTeacherAnnouncementUseCase>(
    () => DeleteTeacherAnnouncementUseCase(getIt<TeacherGroupRepository>()),
  );
  getIt.registerLazySingleton<DeleteTeacherGroupUseCase>(
    () => DeleteTeacherGroupUseCase(getIt<TeacherGroupRepository>()),
  );

  getIt.registerFactory<TeacherGroupCubit>(
    () => TeacherGroupCubit(
      getGroupDetail: getIt<GetTeacherGroupDetailUseCase>(),
      addStudent: getIt<AddTeacherGroupStudentUseCase>(),
      deleteGroup: getIt<DeleteTeacherGroupUseCase>(),
    ),
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
