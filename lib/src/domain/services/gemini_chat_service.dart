import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  ChatSession? _chatSession;
  String? _pdfContext;

  GeminiService(String apiKey) {
    _model = GenerativeModel(model: 'gemini-2.5-flash-lite', apiKey: apiKey);
  }

  void initializeChatWithPDF(String pdfContent) {
    _pdfContext = pdfContent;

    final systemPrompt =
        '''
You are a helpful AI assistant analyzing a PDF document. 
Here is the complete content of the PDF:

$pdfContent

Please answer questions about this document accurately and concisely.
If the answer is not in the document, politely say so.
''';

    _chatSession = _model.startChat(
      history: [
        Content.text(systemPrompt),
        Content.model([
          TextPart(
            'I understand. I\'m ready to answer questions about this PDF document.',
          ),
        ]),
      ],
    );
  }

  Future<String> sendMessage(String message) async {
    try {
      if (_pdfContext == null) {
        return 'Please upload a PDF first before asking questions.';
      }

      if (_chatSession == null) {
        initializeChatWithPDF(_pdfContext!);
      }

      final response = await _chatSession!.sendMessage(Content.text(message));
      return response.text ?? 'Sorry, I couldn’t generate a response.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  void clearChat() {
    if (_pdfContext != null) {
      initializeChatWithPDF(_pdfContext!);
    } else {
      _chatSession = null;
    }
  }

  void resetAll() {
    _pdfContext = null;
    _chatSession = null;
  }

  bool get hasPDFContext => _pdfContext != null;
}
