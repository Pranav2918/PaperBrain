import 'package:equatable/equatable.dart';

abstract class PDFStates extends Equatable {}

class PDFInitialState extends PDFStates {
  @override
  List<Object?> get props => [];
}

class PDFLoadingState extends PDFStates {
  @override
  List<Object?> get props => [];
}

class PDFLoadedState extends PDFStates {
  final String pdfPath;

  PDFLoadedState(this.pdfPath);

  @override
  List<Object?> get props => [pdfPath];
}

class PDFErrorState extends PDFStates {
  final String errorMessage;

  PDFErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
