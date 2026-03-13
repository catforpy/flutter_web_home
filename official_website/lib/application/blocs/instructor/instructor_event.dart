import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/instructor.dart';

/// 讲师管理事件基类
abstract class InstructorEvent extends Equatable {
  const InstructorEvent();

  @override
  List<Object?> get props => [];
}

/// 加载讲师列表
class LoadInstructorsEvent extends InstructorEvent {
  final int page;
  final int pageSize;
  final String? searchKeyword;
  final String? filterSubject;
  final InstructorStatus? filterStatus;

  const LoadInstructorsEvent({
    this.page = 1,
    this.pageSize = 10,
    this.searchKeyword,
    this.filterSubject,
    this.filterStatus,
  });

  @override
  List<Object?> get props =>
      [page, pageSize, searchKeyword, filterSubject, filterStatus];
}

/// 搜索讲师
class SearchInstructorsEvent extends InstructorEvent {
  final String keyword;

  const SearchInstructorsEvent(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

/// 筛选讲师
class FilterInstructorsEvent extends InstructorEvent {
  final String? subject;
  final InstructorStatus? status;

  const FilterInstructorsEvent({
    this.subject,
    this.status,
  });

  @override
  List<Object?> get props => [subject, status];
}

/// 删除讲师
class DeleteInstructorEvent extends InstructorEvent {
  final String id;

  const DeleteInstructorEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// 更新讲师状态
class UpdateInstructorStatusEvent extends InstructorEvent {
  final String id;
  final InstructorStatus status;

  const UpdateInstructorStatusEvent({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}
