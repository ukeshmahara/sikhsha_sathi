import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/entities/inquiry_entity.dart';
import 'package:sikhsha_sathi/features/inquiry/presentation/state/inquiry_state.dart';
import 'package:sikhsha_sathi/features/inquiry/presentation/view_model/inquiry_view_model.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class InquiryPage extends ConsumerStatefulWidget {
  final SchoolEntity school;

  const InquiryPage({super.key, required this.school});

  @override
  ConsumerState<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends ConsumerState<InquiryPage> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inquiryViewModelProvider.notifier).loadMyInquiries();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String? _imageUrl(String? image) {
    if (image == null || image.isEmpty) return null;
    final domain = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
    return '$domain$image';
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 1) return '${difference.inDays}d ago';
    if (difference.inHours >= 1) return '${difference.inHours}h ago';
    if (difference.inMinutes >= 1) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  Map<String, Color> _statusColors(InquiryStatus status) {
    switch (status) {
      case InquiryStatus.responded:
        return {'bg': const Color(0xFFEAF3DE), 'text': const Color(0xFF27500A)};
      case InquiryStatus.closed:
        return {'bg': Colors.grey.shade200, 'text': Colors.grey.shade700};
      case InquiryStatus.pending:
        return {'bg': const Color(0xFFFAEEDA), 'text': const Color(0xFF854F0B)};
    }
  }

  String _statusLabel(InquiryStatus status) {
    switch (status) {
      case InquiryStatus.responded:
        return 'Responded';
      case InquiryStatus.closed:
        return 'Closed';
      case InquiryStatus.pending:
        return 'Pending';
    }
  }

  Future<void> _submit() async {
    final message = _messageController.text.trim();

    if (message.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a more detailed question')),
      );
      return;
    }

    final success = await ref.read(inquiryViewModelProvider.notifier).submitInquiry(
          schoolId: widget.school.id!,
          message: message,
        );

    if (success && mounted) {
      _messageController.clear();
      FocusScope.of(context).unfocus();
    } else if (mounted) {
      final errorMessage = ref.read(inquiryViewModelProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Could not send your question')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inquiryViewModelProvider);
    final isSubmitting = state.submitStatus == InquirySubmitStatus.submitting;

    // only show past questions asked about THIS school
    final schoolInquiries = state.inquiries
        .where((i) => i.schoolId == widget.school.id)
        .toList();

    final imageUrl = _imageUrl(widget.school.image);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask this school'),
        backgroundColor: _kPrimaryBlue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(inquiryViewModelProvider.notifier).loadMyInquiries(),
        child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SCHOOL CONTEXT CARD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _placeholder(),
                          )
                        : _placeholder(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.school.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.school.location,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your question',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText:
                    'e.g. Do you offer hostel facilities and what is the fee?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 4),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _submit,
                icon: isSubmitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, size: 16, color: Colors.white),
                label: Text(
                  isSubmitting ? 'Sending...' : 'Send question',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Your previous questions',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            _buildInquiryList(state, schoolInquiries),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildInquiryList(InquiryState state, List<InquiryEntity> schoolInquiries) {
    if (state.loadStatus == InquiryLoadStatus.loading && state.inquiries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (schoolInquiries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'You haven\'t asked this school anything yet.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      );
    }

    return Column(
      children: schoolInquiries.map((inquiry) {
        final colors = _statusColors(inquiry.status);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      inquiry.message,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors['bg'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel(inquiry.status),
                      style: TextStyle(fontSize: 10, color: colors['text']),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Asked ${_timeAgo(inquiry.createdAt)}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              if (inquiry.reply != null && inquiry.reply!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.subdirectory_arrow_right,
                          size: 14, color: _kPrimaryBlue),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          inquiry.reply!,
                          style: const TextStyle(fontSize: 11, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 40,
      height: 40,
      color: Colors.grey.shade200,
      child: Icon(Icons.school, size: 18, color: Colors.grey.shade400),
    );
  }
}