import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/instructor.dart';

/// 讲师管理状态基类
abstract class InstructorState extends Equatable {
  const InstructorState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class InstructorInitial extends InstructorState {
  const InstructorInitial();
}

/// 加载中
class InstructorLoading extends InstructorState {
  const InstructorLoading();
}

/// 已加载
class InstructorLoaded extends InstructorState {
  final List<Instructor> instructors;
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final bool hasMore;
  final String? searchKeyword;
  final String? filterSubject;
  final InstructorStatus? filterStatus;

  const InstructorLoaded({
    this.instructors = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalCount = 0,
    this.hasMore = false,
    this.searchKeyword,
    this.filterSubject,
    this.filterStatus,
  });

  @override
  List<Object?> get props => [
        instructors,
        currentPage,
        pageSize,
        totalCount,
        hasMore,
        searchKeyword,
        filterSubject,
        filterStatus,
      ];

  InstructorLoaded copyWith({
    List<Instructor>? instructors,
    int? currentPage,
    int? pageSize,
    int? totalCount,
    bool? hasMore,
    String? searchKeyword,
    String? filterSubject,
    InstructorStatus? filterStatus,
  }) {
    return InstructorLoaded(
      instructors: instructors ?? this.instructors,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      filterSubject: filterSubject ?? this.filterSubject,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }
}

/// 错误状态
class InstructorError extends InstructorState {
  final String message;

  const InstructorError(this.message);

  @override
  List<Object?> get props => [message];
}
