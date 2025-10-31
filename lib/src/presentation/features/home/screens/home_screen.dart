import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperbrain/src/presentation/features/chatbot/screens/chat_bottom_sheet.dart';
import 'package:paperbrain/src/presentation/features/home/widgets/home_screen_widgets.dart';
import 'package:paperbrain/src/presentation/features/home/cubits/pdf_cubit.dart';
import 'package:paperbrain/src/presentation/features/home/cubits/pdf_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openChatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChatBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocBuilder<PDFCubit, PDFStates>(
        builder: (context, state) {
          final isPDFLoaded = state is PDFLoadedState;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppBarWidget(),
                  Expanded(child: _buildContent(context, state)),
                  _buildBottomActions(context, isPDFLoaded),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PDFStates state) {
    Widget content;

    if (state is PDFInitialState) {
      content = PDFEmptyViewWidget();
    } else if (state is PDFLoadingState) {
      content = PDFLoadingViewWidget();
    } else if (state is PDFLoadedState) {
      content = PDFViewWidget(pdfPath: state.pdfPath);
    } else if (state is PDFErrorState) {
      content = PDFErrorView(errorMessage: state.errorMessage);
    } else {
      content = const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(24), child: content),
    );
  }

  Widget _buildBottomActions(BuildContext context, bool isPDFLoaded) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(flex: isPDFLoaded ? 1 : 2, child: SelectPDFButton()),
          if (isPDFLoaded) ...[
            const SizedBox(width: 12),
            Expanded(child: AskAIButton(onTap: () => _openChatSheet(context))),
          ],
        ],
      ),
    );
  }
}
