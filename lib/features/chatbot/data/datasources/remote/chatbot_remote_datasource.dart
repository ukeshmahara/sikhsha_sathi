import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_client.dart';
import 'package:sikhsha_sathi/core/api/api_endpoints.dart';

import 'package:sikhsha_sathi/features/chatbot/data/datasources/chatbot_datasource.dart';
import 'package:sikhsha_sathi/features/chatbot/data/models/chat_message_api_model.dart';

final chatbotRemoteDatasourceProvider = Provider<IChatbotRemoteDataSource>((ref) {
  return ChatbotRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

class ChatbotRemoteDatasource implements IChatbotRemoteDataSource {
  final ApiClient apiClient;

  ChatbotRemoteDatasource({required this.apiClient});

  @override
  Future<List<ChatMessageApiModel>> getHistory() async {
    final response = await apiClient.get(ApiEndpoints.chatbot);

    final List<dynamic> data = response.data["data"] ?? [];

    return data.map((j) => ChatMessageApiModel.fromJson(j)).toList();
  }

  @override
  Future<ChatMessageApiModel> sendMessage(String message) async {
    final response = await apiClient.post(
      ApiEndpoints.chatbot,
      data: {"message": message},
    );

    return ChatMessageApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<bool> clearHistory() async {
    final response = await apiClient.delete(ApiEndpoints.chatbot);

    return response.data["success"] == true;
  }
}