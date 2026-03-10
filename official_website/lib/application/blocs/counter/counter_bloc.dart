import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// 计数器事件
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

/// 增加事件
class IncrementEvent extends CounterEvent {}

/// 减少事件
class DecrementEvent extends CounterEvent {}

/// 计数器状态
class CounterState extends Equatable {
  final int count;

  const CounterState({this.count = 0});

  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }

  @override
  List<Object> get props => [count];
}

/// 计数器BLoC
///
/// 状态管理示例：使用BLoC模式管理计数器状态
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    // 注册事件处理器
    on<IncrementEvent>(_onIncrement);
    on<DecrementEvent>(_onDecrement);
  }

  /// 处理增加事件
  void _onIncrement(
    IncrementEvent event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(count: state.count + 1));
  }

  /// 处理减少事件
  void _onDecrement(
    DecrementEvent event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(count: state.count - 1));
  }
}
