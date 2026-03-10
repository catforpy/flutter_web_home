import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 评论列表内容组件（可复用的纯内容组件，不包含导航栏）
class CommentListContent extends StatefulWidget {
  final String? articleId;
  final String? articleTitle;

  const CommentListContent({
    super.key,
    this.articleId,
    this.articleTitle,
  });

  @override
  State<CommentListContent> createState() => _CommentListContentState();
}

class _CommentListContentState extends State<CommentListContent> {
  // 搜索筛选条件
  final TextEditingController _searchKeywordController = TextEditingController();
  String _selectedType = '全部';
  DateTime? _startDate;
  DateTime? _endDate;

  // 所有评论数据（模拟数据库）
  final List<Map<String, dynamic>> _allComments = [
    {
      'id': '1',
      'articleId': '1', // 关联文章ID
      'userName': 'JJDXCX',
      'type': '回复',
      'targetUser': '会员2026030811379348',
      'content': '可以啊 后面交流哈',
      'time': DateTime(2026, 3, 8, 14, 30),
    },
    {
      'id': '2',
      'articleId': '1',
      'userName': '会员2026030811379348',
      'type': '评论',
      'targetUser': null,
      'content': '看一下漫剧的制作过程',
      'time': DateTime(2026, 3, 8, 12, 15),
    },
    {
      'id': '3',
      'articleId': '2',
      'userName': '张三',
      'type': '评论',
      'targetUser': null,
      'content': '这篇文章写得非常好，学到了很多知识，感谢分享！',
      'time': DateTime(2026, 3, 7, 16, 45),
    },
    {
      'id': '4',
      'articleId': '2',
      'userName': '李四',
      'type': '回复',
      'targetUser': '张三',
      'content': '同感！我也觉得这篇文章很有价值',
      'time': DateTime(2026, 3, 7, 17, 20),
    },
    {
      'id': '5',
      'articleId': '3',
      'userName': '王五',
      'type': '评论',
      'targetUser': null,
      'content': '有没有更多的相关资料可以参考？',
      'time': DateTime(2026, 3, 6, 10, 30),
    },
    {
      'id': '6',
      'articleId': '3',
      'userName': '赵六',
      'type': '回复',
      'targetUser': '王五',
      'content': '有的，可以查看文章末尾的参考资料链接',
      'time': DateTime(2026, 3, 6, 11, 15),
    },
    {
      'id': '7',
      'articleId': '4',
      'userName': '孙七',
      'type': '评论',
      'targetUser': null,
      'content': '这个功能什么时候能上线呢？期待！',
      'time': DateTime(2026, 3, 5, 9, 20),
    },
    {
      'id': '8',
      'articleId': '5',
      'userName': '周八',
      'type': '评论',
      'targetUser': null,
      'content': '建议增加夜间模式，晚上阅读会更舒服',
      'time': DateTime(2026, 3, 4, 15, 50),
    },
  ];

  // 根据文章ID筛选评论
  List<Map<String, dynamic>> get _comments {
    if (widget.articleId == null) return _allComments;
    return _allComments.where((c) => c['articleId'] == widget.articleId).toList();
  }

  // 悬停行索引
  int? _hoveredIndex;

  // 每页显示数量
  final int _pageSize = 10;
  // 当前页码（从1开始）
  int _currentPage = 1;

  // 回复对话框控制器
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _searchKeywordController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 1. 搜索筛选区
            _buildSearchFilterBar(),

            const SizedBox(height: 16),

            // 2. 统计信息
            _buildStatistics(),

            const SizedBox(height: 16),

            // 3. 数据表格
            _buildDataTable(),

            const SizedBox(height: 16),

            // 4. 分页器
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  /// 1. 搜索筛选栏
  Widget _buildSearchFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 关键词搜索
          Expanded(
            flex: 3,
            child: _buildSearchField('关键词', '请输入评论内容或用户名', _searchKeywordController),
          ),
          const SizedBox(width: 12),

          // 类型筛选
          SizedBox(
            width: 150,
            child: _buildDropdownField('类型', ['全部', '评论', '回复'], _selectedType, (value) {
              setState(() {
                _selectedType = value;
              });
            }),
          ),
          const SizedBox(width: 12),

          // 时间范围
          Expanded(flex: 4, child: _buildDateRangePicker()),
          const SizedBox(width: 12),

          // 查询按钮
          _buildQueryButton(),
        ],
      ),
    );
  }

  /// 构建搜索输入框
  Widget _buildSearchField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  /// 构建下拉选择框
  Widget _buildDropdownField(String label, List<String> items, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 构建日期范围选择器
  Widget _buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('评论时间', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 4),
        Row(
          children: [
            // 开始时间
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2027),
                  );
                  if (picked != null) {
                    setState(() {
                      _startDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Color(0xFF999999)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : '开始时间',
                          style: TextStyle(
                            fontSize: 14,
                            color: _startDate != null ? const Color(0xFF1F2329) : const Color(0xFF999999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('到', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
            const SizedBox(width: 8),
            // 截止时间
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2027),
                  );
                  if (picked != null) {
                    setState(() {
                      _endDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Color(0xFF999999)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '截止时间',
                          style: TextStyle(
                            fontSize: 14,
                            color: _endDate != null ? const Color(0xFF1F2329) : const Color(0xFF999999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建查询按钮
  Widget _buildQueryButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' ', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 4),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              debugPrint('查询评论列表');
              debugPrint('关键词: ${_searchKeywordController.text}');
              debugPrint('类型: $_selectedType');
              debugPrint('开始时间: $_startDate');
              debugPrint('截止时间: $_endDate');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A9B8E),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '查询',
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 2. 统计信息
  Widget _buildStatistics() {
    final commentCount = _comments.where((c) => c['type'] == '评论').length;
    final replyCount = _comments.where((c) => c['type'] == '回复').length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            '评论列表',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
          ),
          if (widget.articleTitle != null) ...[
            const SizedBox(width: 24),
            Container(width: 1, height: 20, color: const Color(0xFFE5E5E5)),
            const SizedBox(width: 24),
            Flexible(
              child: Text(
                widget.articleTitle!,
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(width: 24),
          Container(width: 1, height: 20, color: const Color(0xFFE5E5E5)),
          const SizedBox(width: 24),
          Text('评论 $commentCount', style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
          const SizedBox(width: 16),
          Text('回复 $replyCount', style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
          const SizedBox(width: 16),
          Text(
            '总计 ${_comments.length}',
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A9B8E), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// 4. 数据表格
  Widget _buildDataTable() {
    if (_comments.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: const Column(
          children: [
            Icon(Icons.inbox, size: 64, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text('暂无评论记录', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 表头
          _buildTableHeader(),

          // 表格内容
          ...List.generate(_comments.length, (index) {
            return _buildTableRow(_comments[index], index);
          }),
        ],
      ),
    );
  }

  /// 构建表头
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('评论者', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 4, child: Text('评论内容', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('时间', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('操作', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
        ],
      ),
    );
  }

  /// 构建表格行
  Widget _buildTableRow(Map<String, dynamic> comment, int index) {
    final String userName = comment['userName'] ?? '';
    final String type = comment['type'] ?? '';
    final String? targetUser = comment['targetUser'];
    final String content = comment['content'] ?? '';

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _hoveredIndex == index
              ? const Color(0xFFE6F7FF)
              : (index % 2 == 0 ? Colors.white : const Color(0xFFF9F9F9)),
          border: const Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
        ),
        child: Row(
          children: [
            // 评论者
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户名（蓝色链接样式）
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('查看用户详情: $userName');
                      },
                      child: Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1890FF),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 操作类型标签
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                        ),
                      ),
                      if (targetUser != null) ...[
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            targetUser,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // 评论内容
            Expanded(
              flex: 4,
              child: Tooltip(
                message: content,
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // 时间
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(comment['time']),
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),

            // 操作按钮
            Expanded(
              flex: 2,
              child: Wrap(
                spacing: 16,
                children: [
                  _buildActionLink('回复', const Color(0xFF1890FF), () {
                    _showReplyDialog(comment);
                  }),
                  _buildActionLink('删除', const Color(0xFFFF4D4F), () {
                    _showDeleteConfirmDialog(comment);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建操作链接
  Widget _buildActionLink(String text, Color color, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(Map<String, dynamic> comment) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: Text('确定要删除这条评论吗？\n\n${comment['content']}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _comments.removeWhere((c) => c['id'] == comment['id']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('删除成功')),
                );
              },
              child: const Text('确定', style: TextStyle(color: Color(0xFFFF4D4F))),
            ),
          ],
        );
      },
    );
  }

  /// 显示回复对话框
  void _showReplyDialog(Map<String, dynamic> comment) {
    _replyController.clear();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题栏
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '回复',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: const Icon(Icons.close, size: 20, color: Color(0xFF999999)),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // 回复对象信息
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['userName'],
                        style: const TextStyle(fontSize: 13, color: Color(0xFF1890FF)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment['content'],
                        style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 输入区域
                TextField(
                  controller: _replyController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: '请输入回复内容...',
                    hintStyle: TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 底部按钮栏
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (_replyController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(content: Text('请输入回复内容')),
                            );
                            return;
                          }
                          Navigator.of(dialogContext).pop();
                          // TODO: 调用后端 API 提交回复
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('回复成功')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1890FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '确认',
                            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 5. 分页器
  Widget _buildPagination() {
    final totalPages = (_comments.length / _pageSize).ceil();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('共 ${_comments.length} 条记录', style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
          const SizedBox(width: 16),
          const Text('每页 '),
          const Text('10', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A9B8E))),
          const Text(' 条'),
          const SizedBox(width: 16),
          // 上一页按钮
          _buildPageButton('上一页', _currentPage > 1, () {
            setState(() {
              _currentPage--;
            });
          }),
          const SizedBox(width: 8),
          // 页码
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A9B8E),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$_currentPage',
              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Text('/ $totalPages', style: const TextStyle(fontSize: 14, color: Color(0xFF999999))),
          const SizedBox(width: 8),
          // 下一页按钮
          _buildPageButton('下一页', _currentPage < totalPages, () {
            setState(() {
              _currentPage++;
            });
          }),
        ],
      ),
    );
  }

  /// 构建分页按钮
  Widget _buildPageButton(String text, bool enabled, VoidCallback onPressed) {
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: enabled ? const Color(0xFFD9D9D9) : const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: enabled ? const Color(0xFF1F2329) : const Color(0xFFCCCCCC),
            ),
          ),
        ),
      ),
    );
  }
}
