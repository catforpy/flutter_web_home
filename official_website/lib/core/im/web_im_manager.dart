import 'dart:js_interop';
import 'dart:async';

/// 全局消息接收回调（供 JavaScript 调用）
/// 这个函数会在 web/index.html 中被定义
@JS('onTIMMessageReceived')
external void setOnTIMMessageReceived(JSFunction callback);

/// 设置 TIM 实例并注册事件监听器
@JS('setTimInstance')
external void _setTimInstance(JSObject tim);

/// TIM 消息接收处理器（接收 JSArray）
void _onMessageReceivedHandler(JSArray<JSObject> messages) {
  try {
    // 将消息传递给 manager 处理
    final manager = IMWebManager();
    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      manager.handleReceivedMessage(msg);
    }
  } catch (e) {
    print('全局消息处理失败: $e');
  }
}

/// 将 Dart 函数转换为 JSFunction
JSFunction _toJSCallback(void Function(JSArray<JSObject>) fn) {
  return ((JSArray<JSObject> messages) {
    fn(messages);
  }).toJS;
}

/// TIM SDK 创建配置
@JS()
@anonymous
@staticInterop
class TIMCreateConfig {
  external factory TIMCreateConfig({
    required int sdkAppId,
  });
}

/// TIM 登录配置
@JS()
@anonymous
@staticInterop
class TIMLoginConfig {
  external factory TIMLoginConfig({
    required String userID,
    required String userSig,
  });
}

/// TIM 文本消息配置
@JS()
@anonymous
@staticInterop
class TIMTextMessageConfig {
  external factory TIMTextMessageConfig({
    required String to,
    required String conversationType,
    required TIMTextPayload payload,
  });
}

/// TIM 文本消息内容
@JS()
@anonymous
@staticInterop
class TIMTextPayload {
  external factory TIMTextPayload({
    required String text,
  });
}

/// TIM 消息对象（JS 对象的包装）
@JS()
@staticInterop
class TIMMessage {
  external factory TIMMessage();
}

/// TIM 消息对象的扩展（实例方法）
extension TIMMessageExtension on TIMMessage {
  external String get msgID;
  external String get type;
  external TIMTextPayload? get textElem;
  external String get from;
  external String get to;
  external int get timestamp;
}

/// TIM 事件类型常量
@JS('TencentCloudChat')
@staticInterop
class TIMEvents {
  external static String get MESSAGE_RECEIVED;
  external static String get CONVERSATION_LIST_UPDATED;
  external static String get SDK_READY;
}

/// TIM SDK 实例（静态互操作类 - 只有静态方法）
@JS('TencentCloudChat')
@staticInterop
class TIM {
  /// 创建 TIM 实例的静态方法
  external static TIM create(TIMCreateConfig options);
}

/// TIM 实例的扩展方法（包含所有实例方法）
extension TIMMethods on TIM {
  /// 登录
  external void login(TIMLoginConfig options);

  /// 登出
  external void logout();

  /// 获取 SDK 版本
  external String getSDKVersion();

  /// 创建文本消息
  external TIMMessage createTextMessage(TIMTextMessageConfig config);

  /// 发送消息（返回 Promise）
  external JSAny? send(TIMMessage message);
}

/// 消息数据模型（Dart 端使用）
class MessageData {
  final String id;
  final String type;
  final String text;
  final String from;
  final String to;
  final int timestamp;

  MessageData({
    required this.id,
    required this.type,
    required this.text,
    required this.from,
    required this.to,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'Message{id: $id, text: $text, from: $from}';
  }
}

/// 腾讯云 IM Web 管理器（单例）
class IMWebManager {
  static final IMWebManager _instance = IMWebManager._internal();
  factory IMWebManager() => _instance;
  IMWebManager._internal();

  TIM? _tim;
  String? _currentUserId;
  bool _isLoggedIn = false;

  // 消息流控制器
  final _messageStreamController = StreamController<MessageData>.broadcast();

  /// 消息流（外部监听新消息）
  Stream<MessageData> get messageStream => _messageStreamController.stream;

  /// 初始化 IM SDK
  ///
  /// [sdkAppId] 腾讯云 IM 应用 ID
  bool init(int sdkAppId) {
    try {
      _tim = TIM.create(TIMCreateConfig(sdkAppId: sdkAppId));
      _setupEventListeners();
      print('IM Web SDK 初始化成功: SDKAppID=$sdkAppId');
      return true;
    } catch (e) {
      print('IM Web SDK 初始化失败: $e');
      return false;
    }
  }

  /// 设置事件监听
  void _setupEventListeners() {
    try {
      if (_tim == null) {
        print('警告: TIM 实例为 null，无法设置事件监听器');
        return;
      }

      // 将 TIM 实例传递给 JavaScript，以便 JS 可以注册事件监听器
      final timObj = _tim as JSObject;
      _setTimInstance(timObj);

      // 注册全局消息接收回调
      final callback = _toJSCallback(_onMessageReceivedHandler);
      setOnTIMMessageReceived(callback);

      print('IM 事件监听器设置成功');
    } catch (e) {
      print('设置事件监听器失败: $e');
    }
  }

  /// 处理接收到的消息（公开方法，供全局回调调用）
  void handleReceivedMessage(JSObject jsMessage) {
    try {
      // 将 JSObject 转换为 MessageData
      // 注意：这里使用简化的方式，实际的属性访问在 JavaScript 中完成
      // 我们通过 HTML 中的 JavaScript 代码来传递解析好的数据

      // 由于 dart:js_interop 的限制，我们使用全局方法获取属性
      final msgId = _getProperty(jsMessage, 'msgID');
      final type = _getProperty(jsMessage, 'type');
      final from = _getProperty(jsMessage, 'from');
      final to = _getProperty(jsMessage, 'to');
      final timestampStr = _getProperty(jsMessage, 'timestamp');

      // 获取文本内容
      String text = '';
      if (type == 'TIMTextElem') {
        final textElem = _getProperty(jsMessage, 'textElem');
        if (textElem != null && textElem.isNotEmpty) {
          // textElem 是一个对象，需要特殊处理
          // 这里我们依赖 HTML 中的 JavaScript 已经解析好
          text = _getProperty(jsMessage, 'text') ?? '';
        }
      }

      final message = MessageData(
        id: msgId ?? '',
        type: type ?? 'TIMTextElem',
        text: text,
        from: from ?? '',
        to: to ?? '',
        timestamp: timestampStr != null ? int.parse(timestampStr) : DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );

      // 添加到消息流
      _messageStreamController.add(message);
      print('收到新消息: $text (from: $from)');
    } catch (e) {
      print('解析消息失败: $e');
    }
  }

  /// 从 JSObject 获取属性的辅助方法
  String? _getProperty(JSObject obj, String propertyName) {
    try {
      // 使用 dart:js_interop 的全局函数
      final result = _getPropertyFromJS(obj, propertyName);
      if (result == null) return null;

      // 直接转换为字符串
      return result.toString();
    } catch (e) {
      return null;
    }
  }

  /// 登录 IM
  ///
  /// [userId] 用户 ID
  /// [userSig] 用户签名（从后端获取）
  bool login(String userId, String userSig) {
    try {
      if (_tim == null) {
        print('错误: IM SDK 未初始化');
        return false;
      }

      _tim!.login(TIMLoginConfig(userID: userId, userSig: userSig));
      _currentUserId = userId;
      _isLoggedIn = true;
      print('IM 登录成功: $userId');
      return true;
    } catch (e) {
      print('IM 登录失败: $e');
      return false;
    }
  }

  /// 登出
  void logout() {
    try {
      _tim?.logout();
      _isLoggedIn = false;
      _currentUserId = null;
      print('IM 登出成功');
    } catch (e) {
      print('IM 登出失败: $e');
    }
  }

  /// 发送文本消息
  ///
  /// [text] 消息文本
  /// [to] 接收者 userID
  /// 返回：是否成功
  bool sendTextMessage(String text, String to) {
    try {
      if (_tim == null || !_isLoggedIn) {
        print('错误: IM 未登录');
        return false;
      }

      print('发送消息: "$text" -> $to');

      // 创建文本消息
      final message = _tim!.createTextMessage(
        TIMTextMessageConfig(
          to: to,
          conversationType: 'C2C',
          payload: TIMTextPayload(text: text),
        ),
      );

      // 发送消息（返回 Object 而不是 Promise）
      final promise = _tim!.send(message);

      // 处理发送结果（简化版）
      _handleSendPromise(promise, text);

      return true;
    } catch (e) {
      print('发送消息失败: $e');
      return false;
    }
  }

  /// 处理发送 Promise
  void _handleSendPromise(JSAny? promise, String text) {
    try {
      // 这里 Promise 实际上是 JavaScript 的 Promise 对象
      // 我们暂时不做处理，因为真正的回调会在 HTML 中的 JavaScript 中完成
      print('消息发送请求已提交: $text');
    } catch (e) {
      print('处理 Promise 失败: $e');
    }
  }

  /// 获取当前用户 ID
  String? get currentUserId => _currentUserId;

  /// 是否已登录
  bool get isLoggedIn => _isLoggedIn;

  /// 获取 SDK 版本
  String? getSDKVersion() {
    try {
      return _tim?.getSDKVersion();
    } catch (e) {
      print('获取 SDK 版本失败: $e');
      return null;
    }
  }

  /// 释放资源
  void dispose() {
    _messageStreamController.close();
  }
}

/// JavaScript 全局辅助函数，用于从 JSObject 获取属性
@JS('_getPropertyFromJS')
external JSAny? _getPropertyFromJS(JSObject obj, String prop);
