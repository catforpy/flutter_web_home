import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// 主题事件
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

/// 切换主题事件
class ToggleThemeEvent extends ThemeEvent {}

/// 主题状态
class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({this.isDarkMode = false});

  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }

  @override
  List<Object> get props => [isDarkMode];
}

/// 主题BLoC
///
/// 状态管理示例：使用BLoC模式管理主题切换状态
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  /// 处理主题切换事件
  void _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}
