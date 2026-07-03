import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/alerts/data/datasources/alerts_data_source.dart';
import 'package:elara/features/alerts/data/datasources/alerts_data_source_impl.dart';
import 'package:elara/features/alerts/presentation/cubits/alerts_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupAlertsDI() {
  getIt.registerLazySingleton<AlertsDataSource>(
    () => AlertsDataSourceImpl(getIt<DioClient>().dio),
  );

  getIt.registerFactory<AlertsCubit>(
    () => AlertsCubit(dataSource: getIt<AlertsDataSource>()),
  );
}
