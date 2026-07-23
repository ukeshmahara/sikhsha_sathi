import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/inquiry/domain/entities/inquiry_entity.dart';
import 'package:sikhsha_sathi/features/inquiry/presentation/state/inquiry_state.dart';
import 'package:sikhsha_sathi/features/inquiry/presentation/view_model/inquiry_view_model.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class MyInquiriesPage extends ConsumerStatefulWidget {
  const MyInquiriesPage({super.key});

  @override
  ConsumerState<MyInquiriesPage> createState() => _MyInquiriesPageState();
}

class _MyInquiriesPageState extends ConsumerState<MyInquiriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inquiryViewModelProvider.notifier).loadMyInquiries();
    });
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 30) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inquiryViewModelProvider);

    // most recent first
    final sortedInquiries = [...state.inquiries]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inquiries'),
        backgroundColor: _kPrimaryBlue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(inquiryViewModelProvider.notifier).loadMyInquiries(),
        child: _buildBody(state, sortedInquiries),
      ),
    );
  }

  Widget _buildBody(InquiryState state, List<InquiryEntity> sortedInquiries) {
    if (state.loadStatus == InquiryLoadStatus.loading && state.inquiries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.loadStatus == InquiryLoadStatus.error && state.inquiries.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              state.errorMessage ?? 'Could not load your inquiries',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    if (sortedInquiries.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Icon(Icons.help_outline, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  'You haven\'t asked any schools a question yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      itemCount: sortedInquiries.length,
      itemBuilder: (context, index) {
        final inquiry = sortedInquiries[index];
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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.school, size: 16, color: Colors.grey.shade500),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inquiry.schoolName.isEmpty
                              ? 'School removed'
                              : inquiry.schoolName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _kPrimaryBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          inquiry.message,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                      style: TextStyle(fontSize: 9, color: colors['text']),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 46, top: 4),
                child: Text(
                  'Asked ${_timeAgo(inquiry.createdAt)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ),
              if (inquiry.reply != null && inquiry.reply!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 46, top: 8),
                  child: Container(
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
                ),
            ],
          ),
        );
      },
    );
  }
}