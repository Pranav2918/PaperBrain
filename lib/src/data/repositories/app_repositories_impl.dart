import 'package:paperbrain/src/domain/repositories/app_repositories.dart';
import 'package:paperbrain/src/domain/services/gemini_chat_service.dart';
import 'package:paperbrain/src/domain/services/pdf_text_extractor.dart';

class AppRepositoryImpl implements AppRepository {
  final GeminiService _gemini;

  AppRepositoryImpl(this._gemini);

  @override
  Future<void> initializeChatWithPDF(String pdfContent) async {
    _gemini.initializeChatWithPDF(pdfContent);
  }

  @override
  Future<String> sendMessage(String message) async {
    return await _gemini.sendMessage(message);
  }

  @override
  void clearChat() => _gemini.clearChat();


  @override
  bool get hasPDFContext => _gemini.hasPDFContext;

  @override
  Future<String> extractTextFromPdf(String pdfPath) async {
    return await PDFTextExtractor.extractText(pdfPath);
  }
}
