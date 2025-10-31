import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFTextExtractor {
  static Future<String> extractText(String pdfPath) async {
    try {
      // Load the PDF document
      final PdfDocument document = PdfDocument(
        inputBytes: File(pdfPath).readAsBytesSync(),
      );

      // Extract text from all pages
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      final String text = extractor.extractText();

      // Dispose the document
      document.dispose();

      return text;
    } catch (e) {
      throw Exception('Failed to extract text from PDF: $e');
    }
  }
}
