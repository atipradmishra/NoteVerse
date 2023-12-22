import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../database/notemodel.dart';
import '../widgets/custom_drawer.dart';


class pdf extends StatefulWidget {
  Note? notes;pdf({this.notes});

  @override
  State<pdf> createState() => _pdfState();
}

class _pdfState extends State<pdf> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(title: Text('NoteVerse')),
      body: PdfPreview(
        pdfFileName: '${widget.notes!.title}_noteverse.pdf',
        initialPageFormat: PdfPageFormat.a4,
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.openSansBold();
    final contentfont = await PdfGoogleFonts.aBeeZeeRegular();
    final doc = Document.fromJson(jsonDecode(widget.notes!.content!));
    // Uint8List imageBytes = Uint8List.view(imageData);
    var toprint = doc.getPlainText(0, doc.length);
    pdf.addPage(
      pw.MultiPage(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        pageFormat: format,
          margin: const pw.EdgeInsets.all(30),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("Made using NoteVerse:Student's Edition!!!!!",
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
          },
          build: (pw.Context context) => <pw.Widget>[
            pw.Header(level: 0, child: pw.Text("NoteVerse")),
            pw.Center(
              child: pw.Text(
                  '${widget.notes!.title}',
                  style: pw.TextStyle(
                    font : font,
                    fontSize: 30,
                    decoration: pw.TextDecoration.underline,
                    decorationStyle: pw.TextDecorationStyle.double,
                  )
              ),
            ),
            pw.Paragraph(
              text: '${toprint}',
              padding: pw.EdgeInsets.only(top: 20)
            )
          ]
      )
    );
    return pdf.save();
  }

}