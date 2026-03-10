import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_sizes.dart';

/// 全局悬浮客服组件
/// 包含客服卡片 + 聊天窗口 + 回到顶部按钮
class FloatingWidget extends StatefulWidget {
  final Widget child; // 页面内容
  final ScrollController? scrollController; // 页面的滚动控制器
  final VoidCallback? onShowChatRequest; // 外部请求显示聊天窗口的回调

  const FloatingWidget({
    super.key,
    required this.child,
    this.scrollController,
    this.onShowChatRequest,
  });

  @override
  State<FloatingWidget> createState() => FloatingWidgetState();
}

class FloatingWidgetState extends State<FloatingWidget> {
  bool _isServiceCardVisible = true;
  bool _isChatWindowVisible = false;

  // 聊天相关
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _addDefaultMessages();
  }

  @override
  void dispose() {
    _textController.dispose();
    _phoneController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _addDefaultMessages() {
    _messages.addAll([
      ChatMessage(
        sender: '都达金牌客服',
        time: '09:00:00',
        content: '欢迎光临都达网软件服务中心\n客服在线咨询时间：周一至周日 9:00~21:00\n如果您在较长时间内未得到及时应答，您可以在对话框里直接留下您的联系电话，我们会尽快与您联系。',
        isCustomerService: true,
      ),
      ChatMessage(
        sender: '都达网在线客服',
        time: '09:00:05',
        content: '很高兴为您服务，请问您有哪方面软件定制需求？',
        isCustomerService: true,
      ),
      ChatMessage(
        sender: '都达金牌客服',
        time: '09:01:20',
        content: '您好，',
        isCustomerService: true,
      ),
      ChatMessage(
        sender: '都达金牌客服',
        time: '09:01:22',
        content: '客服电话 13961535392，如有需要您可以联系我，',
        isCustomerService: true,
      ),
    ]);
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        sender: '我',
        time: _getCurrentTime(),
        content: text,
        isCustomerService: false,
      ));
    });

    _textController.clear();
    _scrollToBottom();
  }

  void _requestCallback() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入手机号码'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入正确的手机号码'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已收到您的号码，客服将在30分钟内致电您！'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    _phoneController.clear();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 显示聊天窗口（供外部调用）
  void showChatWindow() {
    setState(() {
      _isChatWindowVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child, // 页面主要内容

        // 悬浮客服组件（固定在右下角）
        if (_isServiceCardVisible)
          Positioned(
            right: 24,
            bottom: 80,
            child: _CustomerServiceCard(
              onClose: () {
                setState(() {
                  _isServiceCardVisible = false;
                });
              },
              onConsult: () {
                debugPrint('点击免费咨询按钮');
                setState(() {
                  _isChatWindowVisible = true;
                });
              },
            ),
          ),

        // 聊天窗口（固定在右下角，覆盖客服卡片）
        if (_isChatWindowVisible)
          Positioned(
            right: 20,
            bottom: 20,
            child: _ChatWindow(
              messages: _messages,
              textController: _textController,
              phoneController: _phoneController,
              chatScrollController: _chatScrollController,
              onClose: () {
                setState(() {
                  _isChatWindowVisible = false;
                });
              },
              onSendMessage: _sendMessage,
              onCallbackRequest: _requestCallback,
            ),
          ),

        // 回到顶部按钮（固定在右下角）
        Positioned(
          right: 24,
          bottom: 24,
          child: _BackToTopButton(
            scrollController: widget.scrollController,
          ),
        ),
      ],
    );
  }
}

/// 客服卡片
class _CustomerServiceCard extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onConsult;

  const _CustomerServiceCard({
    required this.onClose,
    required this.onConsult,
  });

  @override
  State<_CustomerServiceCard> createState() => _CustomerServiceCardState();
}

class _CustomerServiceCardState extends State<_CustomerServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30), // 鲜艳红
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        width: 180,
        child: Stack(
          children: [
            // 内容
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  // 机器人头像图标
                  _buildRobotAvatar(),

                  SizedBox(height: 16),

                  // "全国热线电话"
                  Text(
                    '全国热线电话',
                    style: TextStyle(
                      fontSize: AppSizes.fsSm,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4),

                  // 电话号码
                  Text(
                    '13961535392',
                    style: TextStyle(
                      fontSize: AppSizes.fsLg,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 16),

                  // "免费咨询"按钮
                  _buildConsultButton(),
                ],
              ),
            ),

            // 关闭按钮（×）
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: widget.onClose,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? const Color(0xFFD32F2F)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '×',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 机器人头像（GIF动图）
  Widget _buildRobotAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD), // 浅灰蓝
            Color(0xFFBBDEFB),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.network(
          'https://junhe.oss-cn-beijing.aliyuncs.com/newgw/xcx/static/xiaodongxiao01.gif',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          gaplessPlayback: true, // 避免GIF加载时的闪烁
          errorBuilder: (context, error, stackTrace) {
            // 如果GIF加载失败，回退到静态图标
            return Center(
              child: CustomPaint(
                size: const Size(40, 40),
                painter: _RobotAvatarPainter(),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            // 加载中显示进度指示器
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 免费咨询按钮
  Widget _buildConsultButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onConsult,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -2.0 : 0.0),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFFF5F5F5)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          height: 40,
          child: Center(
            child: Text(
              '免费咨询',
              style: TextStyle(
                fontSize: AppSizes.fsMd,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFF3B30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 聊天窗口
class _ChatWindow extends StatelessWidget {
  final List<ChatMessage> messages;
  final TextEditingController textController;
  final TextEditingController phoneController;
  final ScrollController chatScrollController;
  final VoidCallback onClose;
  final VoidCallback onSendMessage;
  final VoidCallback onCallbackRequest;

  const _ChatWindow({
    required this.messages,
    required this.textController,
    required this.phoneController,
    required this.chatScrollController,
    required this.onClose,
    required this.onSendMessage,
    required this.onCallbackRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 8,
      child: Container(
        width: 420,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // 标题栏
            _buildHeader(context),

            // 消息区
            Expanded(
              child: Container(
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  controller: chatScrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(messages[index]);
                  },
                ),
              ),
            ),

            // 输入区
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                '都达',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 标题
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '都达网络™',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '大道至简 唯致良知',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // 关闭按钮
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onClose,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 发送者信息
          Row(
            children: [
              // 头像
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: message.isCustomerService
                      ? const Color(0xFFE53935)
                      : const Color(0xFF2196F3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  message.isCustomerService ? Icons.support_agent : Icons.person,
                  color: Colors.white,
                  size: 18,
                ),
              ),

              const SizedBox(width: 8),

              // 发送者和时间
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.sender,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    message.time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 消息内容
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // 文本输入框
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: '说点什么吧...',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE53935),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  maxLines: 2,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  onSubmitted: (_) => onSendMessage(),
                ),
              ),

              const SizedBox(width: 8),

              // 发送按钮
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: onSendMessage,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 手机号输入 + 回拨按钮
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: InputDecoration(
                    hintText: '请输入手机号',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE53935),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // 给您回电按钮
              ElevatedButton.icon(
                onPressed: onCallbackRequest,
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('给您回电'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 回到顶部按钮
class _BackToTopButton extends StatefulWidget {
  final ScrollController? scrollController;

  const _BackToTopButton({
    required this.scrollController,
  });

  @override
  State<_BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<_BackToTopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _scrollToTop,
        child: Transform.scale(
          scale: _isHovered ? 1.05 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935).withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            width: 48,
            height: 48,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_upward,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    '顶部',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToTop() {
    // 使用传入的ScrollController滚动到顶部
    if (widget.scrollController != null && widget.scrollController!.hasClients) {
      widget.scrollController!.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint('ScrollController不可用');
    }
  }
}

/// 机器人头像绘制器
class _RobotAvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 方形头（外框）
    final headSize = 24.0;
    final headRect = Rect.fromCenter(
      center: Offset(centerX, centerY - 4),
      width: headSize,
      height: headSize * 0.8,
    );
    canvas.drawRect(headRect, paint..strokeWidth = 2.5);

    // 天线（左）
    canvas.drawLine(
      Offset(centerX - 6, headRect.top),
      Offset(centerX - 8, headRect.top - 6),
      paint..strokeWidth = 2,
    );
    canvas.drawCircle(
      Offset(centerX - 8, headRect.top - 6),
      2,
      paint..style = PaintingStyle.fill,
    );

    // 天线（右）
    canvas.drawLine(
      Offset(centerX + 6, headRect.top),
      Offset(centerX + 8, headRect.top - 6),
      paint..strokeWidth = 2,
    );
    canvas.drawCircle(
      Offset(centerX + 8, headRect.top - 6),
      2,
      paint..style = PaintingStyle.fill,
    );

    // 眼睛（两点）
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX - 5, centerY - 4), 2.5, eyePaint);
    canvas.drawCircle(Offset(centerX + 5, centerY - 4), 2.5, eyePaint);

    // 嘴巴（横线）
    canvas.drawLine(
      Offset(centerX - 4, centerY + 2),
      Offset(centerX + 4, centerY + 2),
      paint..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_RobotAvatarPainter oldDelegate) => false;
}

/// 聊天消息模型
class ChatMessage {
  final String sender;
  final String time;
  final String content;
  final bool isCustomerService;

  ChatMessage({
    required this.sender,
    required this.time,
    required this.content,
    required this.isCustomerService,
  });
}
