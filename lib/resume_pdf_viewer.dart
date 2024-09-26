import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio_site/RadialGradientColorSplash.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:pdfrx/pdfrx.dart';
import 'dart:html';

class ResumePdf extends StatefulWidget {

  PdfViewerController controller = PdfViewerController();

  @override
  State<ResumePdf> createState() => _ResumePdfState();
}

class _ResumePdfState extends State<ResumePdf> {

  // hacky
  Future<void> _downloadAsset(String assetPath, String fileName) async {
    ByteData data = await rootBundle.load(assetPath);

    final Uint8List bytes = data.buffer.asUint8List();

    final blob = Blob([bytes]);

    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    Color surfaceColor = Theme.of(context).colorScheme.secondary;
    PdfViewerParams pdfViewerParams = PdfViewerParams(
      enableTextSelection: true,
      backgroundColor: surfaceColor,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume"),
        backgroundColor: Theme.of(context).colorScheme.primary,  // You can style the toolbar
        actions: [
          IconButton(
            icon: Icon(Icons.download),  // Example action (e.g., Share button)
            onPressed: () {
              if (kIsWeb) {
                _downloadAsset('EatonWuResume.pdf', 'EatonWuResume.pdf');
              }
            },
            tooltip: 'Download Resume',
          ),
          // IconButton(
          //   icon: Icon(Icons.zoom_in),
          //   onPressed: () {
          //     widget.controller.zoomUp();
          //   },
          // )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
          child: PdfViewer.asset('EatonWuResume.pdf',
            params: pdfViewerParams,
            controller: widget.controller,
          ),
      ),
    );
  }
}


