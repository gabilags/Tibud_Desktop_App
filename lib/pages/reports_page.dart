import 'dart:typed_data';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:queue_app/models/person.dart';
import 'package:queue_app/pages/loading.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:queue_app/utils/dialogs.dart';
import 'package:queue_app/utils/window_buttons.dart';

class ReportsForm extends StatelessWidget {
  ReportsForm({ Key? key, required this.userName, required this.person}) : super(key: key);

  String userName;
  Person person;
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  @override
  Widget build(BuildContext context) {
    double dheight = MediaQuery.of(context).size.height;
    double dwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        actions: [
          Expanded(child: MoveWindow()),
          Windowbuttons(),
        ],
      ),
      body: Row(
        children: [
          Container(
            color: Colors.blue,
            width: 50,
            height: dheight,
            child: Column(
              children: [
                Container(
                  height: 30,
                  child: MoveWindow(),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Loading(userName: userName),
                      ),
                    );
                  },
                  tooltip: 'Back',
                  splashRadius: 15,
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
                SizedBox(height: 20,),
                IconButton(
                 onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SaveDialog(pdf: pdf,);
                    });
                },
                tooltip: 'Save',
                splashRadius: 15,
                icon: Icon(Icons.save, color: Colors.white),
              ),
              ],
            ),
          ),
          Flexible(
            child: PdfPreview(
              build: (format) => _generatePdf(format, person),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, Person person) async {
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final header = await imageFromAssetBundle('assets/Letterhead.png');
    final footer = await imageFromAssetBundle('assets/Footer.png');
    
    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginTop: 0,
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0
          ),
        ),
        build: (context) {
          return pw.Column(
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 20),
                child: pw.Container(
                  height: 100,
                  child: pw.Image(header, fit: pw.BoxFit.fill)
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1),
                  ),
                  width: double.infinity,
                  height: 40,
                  child: pw.Center(child: pw.Text('Complaints Report', style: pw.TextStyle(font: font, fontSize: 20, fontWeight: pw.FontWeight.bold))),
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Row(
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                      ),
                      width: 300,
                      height: 40,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 5, top: 2),
                            child: pw.Text('Name:', style: pw.TextStyle(font: font, fontSize: 10,)),
                          ),
                          pw.Center(child: pw.Text(person.name, style: pw.TextStyle(font: font, fontSize: 12,))),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        height: 40,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 5, top: 2),
                              child: pw.Text('Date:', style: pw.TextStyle(font: font, fontSize: 10,)),
                            ),
                            pw.Center(child: pw.Text(Jiffy(person.date).yMMMMd, style: pw.TextStyle(font: font, fontSize: 12,))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1),
                  ),
                  width: double.infinity,
                  height: 150,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 5, top: 2),
                        child: pw.Text('Issue:', style: pw.TextStyle(font: font, fontSize: 10,)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 10, top: 5),
                        child: pw.Text(person.issue, overflow: pw.TextOverflow.span, style: pw.TextStyle(font: font, fontSize: 12,)),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1),
                  ),
                  width: double.infinity,
                  height: 150,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 5, top: 2),
                        child: pw.Text('Action Taken:', style: pw.TextStyle(font: font, fontSize: 10,)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 10, top: 5),
                        child: pw.Text(person.actionTaken, style: pw.TextStyle(font: font, fontSize: 12,)),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Row(
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                      ),
                      width: 300,
                      height: 40,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 5, top: 2),
                            child: pw.Text('Status:', style: pw.TextStyle(font: font, fontSize: 10,)),
                          ),
                          pw.Center(child: pw.Text(person.status, style: pw.TextStyle(font: font, fontSize: 12,))),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        height: 40,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 5, top: 2),
                              child: pw.Text('Reference No:', style: pw.TextStyle(font: font, fontSize: 10,)),
                            ),
                            pw.Center(child: pw.Text(person.refNo, style: pw.TextStyle(font: font, fontSize: 12,))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Row(
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                      ),
                      width: 300,
                      height: 40,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 5, top: 2),
                            child: pw.Text('Updated By:', style: pw.TextStyle(font: font, fontSize: 10,)),
                          ),
                          pw.Center(child: pw.Text(person.user, style: pw.TextStyle(font: font, fontSize: 12,))),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        height: 40,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 5, top: 2),
                              child: pw.Text('Last Update:', style: pw.TextStyle(font: font, fontSize: 10,)),
                            ),
                            pw.Center(child: pw.Text(Jiffy(person.lastUpdated).yMMMMd, style: pw.TextStyle(font: font, fontSize: 12,))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Row(
                children: [
                  pw.Container(
                    width: 200,
                    height: 100,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.only(top: 50, left: 10, right: 10),
                          child: pw.Divider(),
                        ),
                        pw.Text('Erljohn V. Dulla', style: pw.TextStyle(font: font, fontSize: 12,)),
                        pw.Text('HR Manager', style: pw.TextStyle(font: font, fontSize: 10,)),
                      ],
                    ),
                  ),
                pw.Container(
                    width: 200,
                    height: 100,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.only(top: 50, left: 10, right: 10),
                          child: pw.Divider(),
                        ),
                        pw.Text('Analyn F. Pabillo', style: pw.TextStyle(font: font, fontSize: 12,)),
                        pw.Text('Admin and Finance Manager', style: pw.TextStyle(font: font, fontSize: 10,)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: 100,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(top: 50, left: 10, right: 10),
                            child: pw.Divider(),
                          ),
                          pw.Text('Junbard N. Mahinay', style: pw.TextStyle(font: font, fontSize: 12,)),
                          pw.Text('General Manager', style: pw.TextStyle(font: font, fontSize: 10,)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.Expanded(
                child: pw.Container(
                  alignment: pw.Alignment.bottomCenter,
                  child: pw.Image(footer)
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}