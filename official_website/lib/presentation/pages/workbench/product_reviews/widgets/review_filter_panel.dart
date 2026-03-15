import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/product_review/product_review_bloc.dart';
import 'package:official_website/application/blocs/product_review/product_review_event.dart';
import 'package:official_website/application/blocs/product_review/product_review_state.dart';
import 'package:official_website/domain/entities/product_review.dart';

/// 评价筛选面板
class ReviewFilterPanel extends StatefulWidget {
  const ReviewFilterPanel({super.key});

  @override
  State<ReviewFilterPanel> createState() => _ReviewFilterPanelState();
}

class _ReviewFilterPanelState extends State<ReviewFilterPanel> {
  String? _selectedProductId;
  int? _selectedMinRating;
  int? _selectedMaxRating;
  ReviewStatus? _selectedStatus;
  bool? _selectedHasImages;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductReviewBloc, ProductReviewState>(
      builder: (context, state) {
        final products = state is ProductReviewLoaded && state.products != null
            ? state.products!
            : <Map<String, dynamic>>[];

        return Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '筛选条件',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              const Divider(height: 1),

              // 筛选选项
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildProductFilter(products),
                    const SizedBox(height: 24),
                    _buildRatingFilter(),
                    const SizedBox(height: 24),
                    _buildStatusFilter(),
                    const SizedBox(height: 24),
                    _buildImageFilter(),
                    const SizedBox(height: 24),
                    _buildResetButton(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductFilter(List<Map<String, dynamic>> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '商品',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedProductId,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          hint: const Text('全部商品', style: TextStyle(fontSize: 14)),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('全部商品', style: TextStyle(fontSize: 14)),
            ),
            ...products.map<DropdownMenuItem<String>>((product) {
              return DropdownMenuItem<String>(
                value: product['id'] as String?,
                child: Text(
                  product['name'] as String,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedProductId = value;
              _applyFilter();
            });
          },
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '评分范围',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedMinRating,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                hint: const Text('最低分', style: TextStyle(fontSize: 14)),
                items: List.generate(5, (index) {
                  final rating = index + 1;
                  return DropdownMenuItem<int>(
                    value: rating,
                    child: Text('$rating星', style: const TextStyle(fontSize: 14)),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedMinRating = value;
                    _applyFilter();
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedMaxRating,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                hint: const Text('最高分', style: TextStyle(fontSize: 14)),
                items: List.generate(5, (index) {
                  final rating = index + 1;
                  return DropdownMenuItem<int>(
                    value: rating,
                    child: Text('$rating星', style: const TextStyle(fontSize: 14)),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedMaxRating = value;
                    _applyFilter();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '审核状态',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: ReviewStatus.values.map((status) {
            final isSelected = _selectedStatus == status;

            return CheckboxListTile(
              title: Text(status.displayName),
              value: isSelected,
              onChanged: (selected) {
                setState(() {
                  _selectedStatus = selected! ? status : null;
                  _applyFilter();
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '是否包含图片',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              label: Text('有图', style: TextStyle(fontSize: 12)),
            ),
            ButtonSegment(
              value: false,
              label: Text('全部', style: TextStyle(fontSize: 12)),
            ),
          ],
          selected: _selectedHasImages == true ? {true} : const {},
          onSelectionChanged: (selected) {
            setState(() {
              _selectedHasImages = selected == true ? true : null;
              _applyFilter();
            });
          },
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            _selectedProductId = null;
            _selectedMinRating = null;
            _selectedMaxRating = null;
            _selectedStatus = null;
            _selectedHasImages = null;
            _applyFilter();
          });
        },
        icon: const Icon(Icons.refresh),
        label: const Text('重置筛选'),
      ),
    );
  }

  void _applyFilter() {
    context.read<ProductReviewBloc>().add(
          FilterReviewsEvent(
            productId: _selectedProductId,
            minRating: _selectedMinRating,
            maxRating: _selectedMaxRating,
            status: _selectedStatus,
            hasImages: _selectedHasImages,
          ),
        );
  }
}
