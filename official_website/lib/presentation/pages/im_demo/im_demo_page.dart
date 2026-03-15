import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/im/web_im_manager.dart';
import '../../../core/im/im_config.dart';

/// 腾讯云 IM 演示页面
class IMDemoPage extends StatefulWidget {
  const IMDemoPage({super.key});

  @override
  State<IMDemoPage> createState() => _IMDemoPageState();
}

class _IMDemoPageState extends State<IMDemoPage> {
  final IMWebManager _imManager = IMWebManager();
  bool _isInitialized = false;
  bool _isLoggedIn = false;
  String? _sdkVersion;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _toUserIdController = TextEditingController(
    text: 'user_002', // 默认发送给 user_002
  );

  // 消息列表
  final List<MessageData> _messages = [];
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _initializeIM();
    _setupMessageListener();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _toUserIdController.dispose();
    _messageSubscription?.cancel();
    _imManager.dispose();
    super.dispose();
  }

  Future<void> _initializeIM() async {
    if (IMConfig.sdkAppId == 0) {
      _showMessage('请先配置 SDKAppID');
      return;
    }

    final success = _imManager.init(IMConfig.sdkAppId);
    setState(() {
      _isInitialized = success;
      if (success) {
        _sdkVersion = _imManager.getSDKVersion();
      }
    });

    if (success) {
      _showMessage('IM SDK 初始化成功');
    } else {
      _showMessage('IM SDK 初始化失败');
    }
  }

  void _setupMessageListener() {
    // 监听新消息
    _messageSubscription = _imManager.messageStream.listen((message) {
      setState(() {
        _messages.add(message);
        // 自动滚动到底部
        if (_scrollController.hasClients) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
        }
      });
    });
  }

  void _login() {
    final userSig = IMConfig.getTestUserSig(IMConfig.currentUserId);

    if (userSig == null || userSig.isEmpty) {
      _showMessage('请先配置测试 UserSig');
      return;
    }

    final success = _imManager.login(
      IMConfig.currentUserId,
      userSig,
    );

    setState(() {
      _isLoggedIn = success;
    });

    if (success) {
      _showMessage('登录成功: ${IMConfig.currentUserId}');
    } else {
      _showMessage('登录失败');
    }
  }

  void _logout() {
    _imManager.logout();
    setState(() {
      _isLoggedIn = false;
      _messages.clear();
    });
    _showMessage('已登出');
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    final to = _toUserIdController.text.trim();

    if (text.isEmpty) {
      _showMessage('请输入消息内容');
      return;
    }

    if (to.isEmpty) {
      _showMessage('请输入接收者 ID');
      return;
    }

    if (!_isLoggedIn) {
      _showMessage('请先登录 IM');
      return;
    }

    // 发送消息
    final success = _imManager.sendTextMessage(text, to);

    if (success) {
      // 添加到消息列表（显示发送的消息）
      setState(() {
        _messages.add(MessageData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'TIMTextElem',
          text: text,
          from: IMConfig.currentUserId,
          to: to,
          timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        ));
        _messageController.clear();
      });
      _showMessage('消息已发送');
    } else {
      _showMessage('消息发送失败');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('腾讯云 IM 演示'),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: '登出',
            ),
        ],
      ),
      body: Column(
        children: [
          // 状态信息
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isInitialized ? Icons.check_circle : Icons.error,
                      color: _isInitialized ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SDK 状态: ${_isInitialized ? "已初始化" : "未初始化"}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (_sdkVersion != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('SDK 版本: $_sdkVersion'),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _isLoggedIn ? Icons.check_circle : Icons.error,
                      color: _isLoggedIn ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '登录状态: ${_isLoggedIn ? "已登录 (${IMConfig.currentUserId})" : "未登录"}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (_isLoggedIn)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '提示: 可以在 UniApp 或微信小程序中使用相同的 userID (${IMConfig.currentUserId}) 进行互通测试',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF616161),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 消息输入和发送区域
          if (_isLoggedIn) ...[
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '发送消息',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _toUserIdController,
                    decoration: const InputDecoration(
                      labelText: '接收者 ID',
                      hintText: '例如: user_002',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: '消息内容',
                      hintText: '输入要发送的消息...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send),
                      label: const Text('发送消息'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],

          // 登录按钮
          if (!_isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _isInitialized ? _login : null,
                icon: const Icon(Icons.login),
                label: const Text('登录 IM'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),

          // 消息列表标题
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  '消息记录',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '共 ${_messages.length} 条',
                  style: const TextStyle(color: Color(0xFF757575)),
                ),
              ],
            ),
          ),

          // 消息列表
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 64,
                          color: Color(0xFF9E9E9E),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '暂无消息',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '登录后可以发送和接收消息',
                          style: TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isSelf = message.from == IMConfig.currentUserId;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: isSelf
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelf
                                    ? Colors.blue.shade500
                                    : const Color(0xFFE0E0E0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(maxWidth: 280),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isSelf ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                right: 4,
                                top: 4,
                              ),
                              child: Text(
                                _formatTime(message.timestamp),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
