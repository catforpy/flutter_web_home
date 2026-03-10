import 'package:flutter/material.dart';

/// 七牛云配置页面
class QiniuConfigPage extends StatefulWidget {
  const QiniuConfigPage({super.key});

  @override
  State<QiniuConfigPage> createState() => _QiniuConfigPageState();
}

class _QiniuConfigPageState extends State<QiniuConfigPage> {
  final _formKey = GlobalKey<FormState>();

  // 表单字段
  String _selectedRegion = '华南';
  final _bucketNameController = TextEditingController();
  final _accessKeyController = TextEditingController();
  final _secretKeyController = TextEditingController();
  final _domainController = TextEditingController();
  bool _updateDomainStrategy = false;

  // 存储区域选项
  final List<String> _regions = ['华东', '华北', '华南', '北美', '东南亚'];

  @override
  void dispose() {
    _bucketNameController.dispose();
    _accessKeyController.dispose();
    _secretKeyController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A9B8E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '七牛云配置',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A. 面包屑导航
                _buildBreadcrumb(),

                const SizedBox(height: 32),

                // B. 表单区域
                _buildFormCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 面包屑导航
  Widget _buildBreadcrumb() {
    return Row(
      children: [
        _buildCrumbItem('管理首页', () => Navigator.popUntil(context, (route) => route.isFirst)),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF999999)),
        _buildCrumbItem('音视频管理', () => Navigator.pop(context)),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF999999)),
        const Text(
          '七牛配置',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCrumbItem(String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1890FF),
          ),
        ),
      ),
    );
  }

  /// 表单卡片
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(32),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '配置信息',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 32),

          // 1. 存储区域
          _buildFormField(
            label: '存储区域',
            required: true,
            child: DropdownButtonFormField<String>(
              value: _selectedRegion,
              decoration: const InputDecoration(
                hintText: '请选择存储区域',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _regions.map((String region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRegion = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请选择存储区域';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 24),

          // 2. 存储空间名称
          _buildFormField(
            label: '存储空间名称 (Bucket)',
            required: true,
            child: TextFormField(
              controller: _bucketNameController,
              decoration: const InputDecoration(
                hintText: '请填写存储空间名称 (Bucket)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请填写存储空间名称';
                }
                // 校验：只能包含小写字母、数字、横杠
                if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
                  return '只能包含小写字母、数字、横杠';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 24),

          // 3. AccessKey
          _buildFormField(
            label: 'AccessKey',
            required: true,
            child: TextFormField(
              controller: _accessKeyController,
              decoration: const InputDecoration(
                hintText: '请填写 AccessKey',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请填写 AccessKey';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 24),

          // 4. SecretKey
          _buildFormField(
            label: 'SecretKey',
            required: true,
            child: TextFormField(
              controller: _secretKeyController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '请填写 SecretKey',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请填写 SecretKey';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 24),

          // 5. 外链域名
          _buildFormField(
            label: '外链域名',
            required: true,
            child: TextFormField(
              controller: _domainController,
              decoration: const InputDecoration(
                hintText: '请填写外链域名 (如 https://your-domain.com)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请填写外链域名';
                }
                // 校验 URL 格式
                if (!Uri.tryParse(value)!.hasAbsolutePath) {
                  return '请输入有效的URL格式';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 24),

          // 6. 域名更新策略
          _buildFormField(
            label: '域名更新策略',
            required: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _updateDomainStrategy,
                      onChanged: (value) {
                        setState(() {
                          _updateDomainStrategy = value!;
                        });
                      },
                    ),
                    const Text('是'),
                    const SizedBox(width: 24),
                    Radio<bool>(
                      value: false,
                      groupValue: _updateDomainStrategy,
                      onChanged: (value) {
                        setState(() {
                          _updateDomainStrategy = value!;
                        });
                      },
                    ),
                    const Text('否'),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E6),
                    border: Border.all(color: const Color(0xFFFFD591)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '若选是，将把已保存的旧域名下的音视频更换为新保存的域名',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // C. 底部操作区
          Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _saveConfig,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1890FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '保存',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 表单字段包装器
  Widget _buildFormField({required String label, required Widget child, bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF4D4F),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  /// 保存配置
  void _saveConfig() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: 调用后端API保存配置
    final config = {
      'region': _selectedRegion,
      'bucketName': _bucketNameController.text,
      'accessKey': _accessKeyController.text,
      'secretKey': _secretKeyController.text,
      'domain': _domainController.text,
      'updateDomainStrategy': _updateDomainStrategy,
    };

    debugPrint('保存七牛配置：$config');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('配置保存成功'),
        backgroundColor: Color(0xFF52C41A),
      ),
    );

    // 返回上一页
    Navigator.pop(context);
  }
}
