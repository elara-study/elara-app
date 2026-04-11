import 'package:elara/features/student/group/domain/entities/group_roadmap.dart';
import 'package:elara/features/student/group/domain/usecases/get_group_roadmap_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'roadmap_state.dart';

class RoadmapCubit extends Cubit<RoadmapState> {
  final GetGroupRoadmapUseCase _getGroupRoadmap;
  final String _groupId;

  RoadmapCubit(this._getGroupRoadmap, this._groupId)
    : super(const RoadmapState.initial());

  Future<void> loadRoadmap() async {
    emit(const RoadmapState.loading());
    final result = await _getGroupRoadmap(groupId: _groupId);
    emit(
      result.fold(
        onSuccess: RoadmapState.loaded,
        onFailure: (f) => RoadmapState.failure(f.message),
      ),
    );
  }
}
