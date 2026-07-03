import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/parent/data/home/datasources/parent_home_remote_data_source.dart';
import 'package:elara/features/parent/data/home/datasources/parent_home_remote_data_source_impl.dart';
import 'package:elara/features/parent/data/home/repositories/parent_home_repository_impl.dart';
import 'package:elara/features/parent/data/profile/datasources/parent_profile_remote_data_source.dart';
import 'package:elara/features/parent/data/profile/repositories/parent_profile_repository_impl.dart';
import 'package:elara/features/parent/data/reports/datasources/parent_reports_remote_data_source.dart';
import 'package:elara/features/parent/data/reports/datasources/parent_reports_remote_data_source_impl.dart';
import 'package:elara/features/parent/data/reports/repositories/parent_reports_repository_impl.dart';
import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';
import 'package:elara/features/parent/domain/home/usecases/get_parent_children_dashboard_use_case.dart';
import 'package:elara/features/parent/domain/home/usecases/get_parent_home_use_case.dart';
import 'package:elara/features/parent/domain/home/usecases/link_student_use_case.dart';
import 'package:elara/features/parent/domain/home/usecases/respond_to_request_use_case.dart';
import 'package:elara/features/parent/domain/children/usecases/unlink_child_use_case.dart';
import 'package:elara/features/parent/domain/profile/repositories/parent_profile_repository.dart';
import 'package:elara/features/parent/domain/profile/usecases/get_parent_profile_use_case.dart';
import 'package:elara/features/parent/domain/reports/repositories/parent_reports_repository.dart';
import 'package:elara/features/parent/domain/reports/usecases/get_parent_reports_use_case.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_cubit.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_home_cubit.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_tab_cubit.dart';
import 'package:elara/features/parent/presentation/reports/cubits/parent_reports_cubit.dart';
import 'package:elara/features/parent/data/children/datasources/parent_children_remote_data_source.dart';
import 'package:elara/features/parent/data/children/datasources/parent_children_remote_data_source_impl.dart';
import 'package:elara/features/parent/data/children/repositories/parent_children_repository_impl.dart';
import 'package:elara/features/parent/domain/children/repositories/parent_children_repository.dart';
import 'package:elara/features/parent/domain/children/usecases/get_parent_child_profile_use_case.dart';
import 'package:elara/features/parent/domain/children/usecases/get_parent_child_homeworks_use_case.dart';
import 'package:elara/features/parent/domain/children/usecases/get_parent_child_insights_usecase.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_profile_cubit.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_homework_cubit.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_insights_cubit.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupParentDI() {
  getIt.registerLazySingleton<ParentHomeRemoteDataSource>(
    () => ParentHomeRemoteDataSourceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ParentHomeRepository>(
    () => ParentHomeRepositoryImpl(getIt<ParentHomeRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetParentHomeUseCase(getIt<ParentHomeRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetParentChildrenDashboardUseCase(getIt<ParentHomeRepository>()),
  );
  getIt.registerLazySingleton(
    () => LinkStudentUseCase(getIt<ParentHomeRepository>()),
  );
  getIt.registerLazySingleton(
    () => RespondToRequestUseCase(getIt<ParentHomeRepository>()),
  );
  getIt.registerLazySingleton(
    () => UnlinkChildUseCase(getIt<ParentHomeRepository>()),
  );

  getIt.registerLazySingleton<ParentReportsRemoteDataSource>(
    () => const ParentReportsRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<ParentReportsRepository>(
    () => ParentReportsRepositoryImpl(getIt<ParentReportsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetParentReportsUseCase(getIt<ParentReportsRepository>()),
  );

  getIt.registerLazySingleton<ParentProfileRemoteDataSource>(
    () => ParentProfileRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<ParentProfileRepository>(
    () => ParentProfileRepositoryImpl(getIt<ParentProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetParentProfileUseCase(getIt<ParentProfileRepository>()),
  );

  getIt.registerFactory(() => ParentTabCubit());
  getIt.registerFactory(
    () => ParentHomeCubit(getParentHomeUseCase: getIt<GetParentHomeUseCase>()),
  );
  getIt.registerFactory(
    () => ParentChildrenCubit(
      getChildrenDashboard: getIt<GetParentChildrenDashboardUseCase>(),
      linkStudent: getIt<LinkStudentUseCase>(),
      respondToRequest: getIt<RespondToRequestUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ParentReportsCubit(
      getParentReportsUseCase: getIt<GetParentReportsUseCase>(),
    ),
  );

  // Parent Child Profile
  getIt.registerLazySingleton<ParentChildrenRemoteDataSource>(
    () => ParentChildrenRemoteDataSourceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ParentChildrenRepository>(
    () => ParentChildrenRepositoryImpl(getIt<ParentChildrenRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetParentChildProfileUseCase(getIt<ParentChildrenRepository>()),
  );
  getIt.registerFactory<ParentChildProfileCubit>(
    () => ParentChildProfileCubit(
      getProfile: getIt<GetParentChildProfileUseCase>(),
      unlinkChildUseCase: getIt<UnlinkChildUseCase>(),
    ),
  );

  // Parent Child Homework
  getIt.registerLazySingleton(
    () => GetParentChildHomeworksUseCase(getIt<ParentChildrenRepository>()),
  );
  getIt.registerFactory<ParentChildHomeworkCubit>(
    () => ParentChildHomeworkCubit(
      getHomeworks: getIt<GetParentChildHomeworksUseCase>(),
    ),
  );

  // Parent Child Insights
  getIt.registerLazySingleton(
    () => GetParentChildInsightsUseCase(getIt<ParentChildrenRepository>()),
  );
  getIt.registerFactory<ParentChildInsightsCubit>(
    () => ParentChildInsightsCubit(getIt<GetParentChildInsightsUseCase>()),
  );

  // Parent Profile
  getIt.registerFactory<ParentProfileCubit>(
    () => ParentProfileCubit(
      authCubit: getIt<AuthCubit>(),
      getProfileUseCase: getIt<GetParentProfileUseCase>(),
    ),
  );
}
