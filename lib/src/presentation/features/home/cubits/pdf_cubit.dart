import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:paperbrain/src/presentation/features/home/cubits/pdf_states.dart';

class PDFCubit extends Cubit<PDFStates> {
  String? _currentPdfPath;

  PDFCubit() : super(PDFInitialState());

  String? get currentPdfPath => _currentPdfPath;

  Future<void> pickPDF() async {
    try {
      emit(PDFLoadingState());

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        _currentPdfPath = result.files.single.path!;
        emit(PDFLoadedState(_currentPdfPath!));
      } else {
        emit(PDFInitialState());
      }
    } catch (e) {
      emit(PDFErrorState('Failed to pick PDF: ${e.toString()}'));
    }
  }

  void clearPDF() {
    _currentPdfPath = null;
    emit(PDFInitialState());
  }
}