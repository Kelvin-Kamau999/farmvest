import 'package:cofarmer/common/custom_textfield.dart';
import 'package:cofarmer/common/primary_button.dart';
import 'package:cofarmer/common/utils.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/screens/payment/payment_screen.dart';
import 'package:cofarmer/screens/proposal_details/payment_methods.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class InvestmentModal extends StatefulWidget {
  const InvestmentModal({super.key, required this.proposal});

  final ProposalModel proposal;

  @override
  State<InvestmentModal> createState() => _InvestmentModalState();
}

class _InvestmentModalState extends State<InvestmentModal> {
  final amountController = TextEditingController(text: '');
  String? paymentMethod;

  @override
  Widget build(BuildContext context) {
    amountController.addListener(() {
      setState(() {});
    });
    final roi = amountController.text.isEmpty
        ? 0
        : double.parse(amountController.text) *
            ((widget.proposal.roi! + 100) / 100);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Investment details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Amount to invest',
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                hintText: 'Enter amount to invest'),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  'Return on investment: ',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'KES ${moneyFormat(roi.toString())}',
                  style: const TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            PaymentMethods(
              onSelected: (val) {
                setState(() {
                  paymentMethod = val;
                });
              },
            ),
            const SizedBox(
              height: 14,
            ),
            PrimaryButton(
              text: "Invest now",
              onTap: () {
                if (paymentMethod == null ||
                    amountController.text.isEmpty ||
                    double.parse(amountController.text) < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill all fields'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                Navigator.pop(context);
                Get.to(() => PaymentScreen(
                      amount: amountController.text,
                      paymentMethod: paymentMethod!,
                      proposal: widget.proposal,
                    ));
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
