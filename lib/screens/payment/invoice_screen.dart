// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:cofarmer/common/bottom_bar.dart';
import 'package:cofarmer/common/primary_button.dart';
import 'package:cofarmer/common/utils.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/providers/auth_provider.dart';
import 'package:cofarmer/providers/proposal_provider.dart';
import 'package:cofarmer/screens/payment/generate_invoice.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:ticket_widget/ticket_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key, required this.proposal, required this.amount})
      : super(key: key);
  final ProposalModel proposal;
  final String amount;

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  WidgetsToImageController controller = WidgetsToImageController();

  Uint8List? bytes;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    final investment =
        Provider.of<ProposalProvider>(context, listen: false).lastInvestment!;
    Widget invoice = Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TicketWidget(
        width: double.infinity,
        height: double.infinity,
        isCornerRounded: true,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Text(
              '#${investment.id!}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: QrImageView(
              data: investment.id!,
              version: 4,
              size: 190.0,
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 15,
          ),
          info('Name', user.name!),
          const SizedBox(
            height: 10,
          ),
          info('Farmer', widget.proposal.ownerName!),
          const SizedBox(
            height: 10,
          ),
          info('Address', widget.proposal.address!),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: info(
                      'Date',
                      DateFormat('MMM dd, yyyy')
                          .format(investment.createdAt!.toDate()))),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: info(
                      'Time',
                      DateFormat('hh:mm a')
                          .format(investment.createdAt!.toDate()))),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: info('Amount', 'KES ${moneyFormat(widget.amount)}')),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: info('Payment Method', investment.paymentMethod!)),
            ],
          ),
        ]),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoice',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: WidgetsToImage(
              controller: controller,
              child: invoice,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                PrimaryButton(
                    text: 'Download Invoice',
                    isLoading: isLoading,
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final bytes = await controller.capture();
                      final pdf = pw.Document();

                      final image = pw.MemoryImage(bytes!);

                      pdf.addPage(pw.Page(build: (pw.Context context) {
                        return pw.Center(
                          child: pw.Image(image),
                        ); // Center
                      }));
                      final file = await PdfApi.saveDocument(
                          name: 'Invoice.pdf', pdf: pdf);
                      await PdfApi.openFile(file);
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invoice downloaded successfully'),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 14,
                ),
                PrimaryButton(
                  text: 'Back home',
                  onTap: () {
                    Get.offAll(() => const CustomNavBar());
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget info(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(
          height: 2.5,
        ),
        Text(value)
      ],
    );
  }
}
