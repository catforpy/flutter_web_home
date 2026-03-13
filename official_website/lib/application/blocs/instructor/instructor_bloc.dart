import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/instructor/instructor_event.dart';
import 'package:official_website/application/blocs/instructor/instructor_state.dart';
import 'package:official_website/domain/repositories/instructor_repository.dart';

/// 讲师管理 BLoC
class InstructorBloc extends Bloc<InstructorEvent, InstructorState> {
  final InstructorRepository repository;

  InstructorBloc({required this.repository}) : super(const InstructorInitial()) {
    on<LoadInstructorsEvent>(_onLoadInstructors);
    on<SearchInstructorsEvent>(_onSearchInstructors);
    on<FilterInstructorsEvent>(_onFilterInstructors);
    on<DeleteInstructorEvent>(_onDeleteInstructor);
    on<UpdateInstructorStatusEvent>(_onUpdateInstructorStatus);
  }

  Future<void> _onLoadInstructors(
    LoadInstructorsEvent event,
    Emitter<InstructorState> emit,
  ) async {
    emit(const InstructorLoading());

    final result = await repository.getInstructors(
      page: event.page,
      pageSize: event.pageSize,
      searchKeyword: event.searchKeyword,
      filterSubject: event.filterSubject,
      filterStatus: event.filterStatus,
    );

    final countResult = await repository.getInstructorCount(
      searchKeyword: event.searchKeyword,
      filterSubject: event.filterSubject,
      filterStatus: event.filterStatus,
    );

    result.fold(
      (failure) => emit(InstructorError(failure.message)),
      (instructors) {
        countResult.fold(
          (failure) => emit(InstructorError(failure.message)),
          (totalCount) {
            final hasMore = (event.page * event.pageSize) < totalCount;
            emit(InstructorLoaded(
              instructors: instructors,
              currentPage: event.page,
              pageSize: event.pageSize,
              totalCount: totalCount,
              hasMore: hasMore,
              searchKeyword: event.searchKeyword,
              filterSubject: event.filterSubject,
              filterStatus: event.filterStatus,
            ));
          },
        );
      },
    );
  }

  Future<void> _onSearchInstructors(
    SearchInstructorsEvent event,
    Emitter<InstructorState> emit,
  ) async {
    if (state is InstructorLoaded) {
      final currentState = state as InstructorLoaded;

      emit(const InstructorLoading());

      final result = await repository.getInstructors(
        page: 1,
        pageSize: currentState.pageSize,
        searchKeyword: event.keyword,
        filterSubject: currentState.filterSubject,
        filterStatus: currentState.filterStatus,
      );

      result.fold(
        (failure) => emit(InstructorError(failure.message)),
        (instructors) {
          emit(currentState.copyWith(
            instructors: instructors,
            currentPage: 1,
            searchKeyword: event.keyword,
          ));
        },
      );
    }
  }

  Future<void> _onFilterInstructors(
    FilterInstructorsEvent event,
    Emitter<InstructorState> emit,
  ) async {
    if (state is InstructorLoaded) {
      final currentState = state as InstructorLoaded;

      add(LoadInstructorsEvent(
        page: 1,
        pageSize: currentState.pageSize,
        searchKeyword: currentState.searchKeyword,
        filterSubject: event.subject,
        filterStatus: event.status,
      ));
    }
  }

  Future<void> _onDeleteInstructor(
    DeleteInstructorEvent event,
    Emitter<InstructorState> emit,
  ) async {
    final result = await repository.deleteInstructor(event.id);

    result.fold(
      (failure) => emit(InstructorError(failure.message)),
      (_) {
        if (state is InstructorLoaded) {
          final currentState = state as InstructorLoaded;
          add(LoadInstructorsEvent(
            page: currentState.currentPage,
            pageSize: currentState.pageSize,
            searchKeyword: currentState.searchKeyword,
            filterSubject: currentState.filterSubject,
            filterStatus: currentState.filterStatus,
          ));
        }
      },
    );
  }

  Future<void> _onUpdateInstructorStatus(
    UpdateInstructorStatusEvent event,
    Emitter<InstructorState> emit,
  ) async {
    final result = await repository.updateInstructorStatus(
      event.id,
      event.status,
    );

    result.fold(
      (failure) => emit(InstructorError(failure.message)),
      (_) {
        if (state is InstructorLoaded) {
          final currentState = state as InstructorLoaded;
          add(LoadInstructorsEvent(
            page: currentState.currentPage,
            pageSize: currentState.pageSize,
            searchKeyword: currentState.searchKeyword,
            filterSubject: currentState.filterSubject,
            filterStatus: currentState.filterStatus,
          ));
        }
      },
    );
  }
}
