import 'package:flutter/material.dart';
import 'recipe_models.dart';

/// Screen: Mobile — Workflow Recipes / Templates (M054)
/// Route: /m/workflows/templates
class RecipeTemplatesView extends StatefulWidget {
  final List<RecipeTemplate> templates;
  final Map<String, String> workspaceCapabilities;
  final void Function(RecipeTemplate template)? onDeploy;

  const RecipeTemplatesView({
    super.key,
    required this.templates,
    required this.workspaceCapabilities,
    this.onDeploy,
  });

  @override
  State<RecipeTemplatesView> createState() => _RecipeTemplatesViewState();
}

class _RecipeTemplatesViewState extends State<RecipeTemplatesView> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String? _statusBanner;

  @override
  Widget build(BuildContext context) {
    final filtered = widget.templates.where((t) {
      final matchesCat = _selectedCategory == 'all' || t.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Workflow Recipes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Status Notification Banner
          if (_statusBanner != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.green.shade50,
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _statusBanner!,
                      style: TextStyle(color: Colors.green.shade900, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => setState(() => _statusBanner = null),
                  ),
                ],
              ),
            ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm recipe...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildCategoryChip('all', '🔥 Tất cả'),
                _buildCategoryChip('engagement', '💬 Tương tác'),
                _buildCategoryChip('content', '📤 Nội dung'),
                _buildCategoryChip('commerce', '🛍 Thương mại'),
                _buildCategoryChip('analytics', '📊 Phân tích'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // List of Recipe Cards
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Không tìm thấy template nào'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final tmpl = filtered[index];
                      final missing = checkMissingCapabilities(tmpl, widget.workspaceCapabilities);
                      final isEligible = missing.isEmpty;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category & Rating Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      tmpl.category.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '⭐ ${tmpl.ratingAvg.toStringAsFixed(1)} (${tmpl.reviewCount})',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: tmpl.isFree ? Colors.green.shade50 : Colors.purple.shade50,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          tmpl.isFree ? 'Miễn phí' : '\$${tmpl.priceUSD}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: tmpl.isFree ? Colors.green.shade800 : Colors.purple.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Title & Description
                              Text(
                                tmpl.title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tmpl.description,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 10),

                              // Missing Capability Warning Banner
                              if (!isEligible)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.amber.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 16),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Thiếu kết nối ${missing.first.platform.toUpperCase()}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber.shade900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        missing.first.reason,
                                        style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '→ ${missing.first.resolutionGuidance}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Deploy Action
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.download, size: 16),
                                  label: const Text('📥 Dùng template'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isEligible ? Colors.blue.shade700 : Colors.grey.shade300,
                                    foregroundColor: isEligible ? Colors.white : Colors.grey.shade600,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  onPressed: isEligible
                                      ? () {
                                          setState(() {
                                            _statusBanner = 'Đã cài đặt "${tmpl.title}". Workflow ở trạng thái Draft và có thể chỉnh sửa.';
                                          });
                                          widget.onDeploy?.call(tmpl);
                                        }
                                      : () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Không thể cài đặt: ${missing.first.reason}')),
                                          );
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label) {
    final isSelected = _selectedCategory == id;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.blue.shade100,
        checkmarkColor: Colors.blue.shade800,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue.shade900 : Colors.grey.shade800,
        ),
        onSelected: (_) => setState(() => _selectedCategory = id),
      ),
    );
  }
}
