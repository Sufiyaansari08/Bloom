import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class SupportTicketResult {
  final bool isSuccess;
  final String? ticketId;
  final String? message;

  const SupportTicketResult({
    required this.isSuccess,
    this.ticketId,
    this.message,
  });
}

class SupportApiService {
  SupportApiService._();
  static final SupportApiService instance = SupportApiService._();

  final Dio _dio = ApiClient.instance.dio;

  Future<SupportTicketResult> submitTicket({
    required String ticketType, // 'problem_report', 'feature_suggestion', 'feedback', 'contact_support'
    required String description,
    String? title,
    String? email,
    String? appVersion,
    String? deviceModel,
    String? osVersion,
    List<String>? attachmentUrls,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.supportTicket,
        data: {
          'ticket_type': ticketType,
          'description': description.trim(),
          if (title != null && title.isNotEmpty) 'title': title.trim(),
          if (email != null && email.isNotEmpty) 'email': email.trim(),
          if (appVersion != null) 'app_version': appVersion,
          if (deviceModel != null) 'device_model': deviceModel,
          if (osVersion != null) 'os_version': osVersion,
          if (attachmentUrls != null) 'attachment_urls': attachmentUrls,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return SupportTicketResult(
          isSuccess: true,
          ticketId: data['ticket_id']?.toString(),
          message: data['message']?.toString() ?? 'Support ticket submitted successfully.',
        );
      }
      return const SupportTicketResult(isSuccess: false, message: 'Failed to submit ticket');
    } catch (e) {
      debugPrint('SupportApiService.submitTicket error: $e');
      return SupportTicketResult(isSuccess: false, message: e.toString());
    }
  }
}
