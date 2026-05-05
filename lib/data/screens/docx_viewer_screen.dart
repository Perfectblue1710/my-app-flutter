import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocxViewerScreen extends StatelessWidget {
  final String filePath;
  final String documentName;
  
  const DocxViewerScreen({
    super.key,
    required this.filePath,
    required this.documentName,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(documentName),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Скачать документ
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Печать
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Поиск по документу
            },
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        filePath,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        pageSpacing: 5,
        scrollDirection: PdfScrollDirection.vertical,
        interactionMode: PdfInteractionMode.pan,
      ),
    );
  }
}