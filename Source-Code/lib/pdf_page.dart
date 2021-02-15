import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PdfScreenPage extends StatelessWidget {

  final String pdfPath;

  PdfScreenPage(this.pdfPath);

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return PDFViewerScaffold(

        path: pdfPath);
  }
}