import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofarmer/common/custom_textfield.dart';
import 'package:cofarmer/common/primary_button.dart';
import 'package:cofarmer/models/investment_model.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/providers/proposal_provider.dart';
import 'package:cofarmer/screens/payment/invoice_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key,
      required this.proposal,
      required this.amount,
      required this.paymentMethod});

  final ProposalModel proposal;
  final String amount;
  final String paymentMethod;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final refCode = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final List steps = widget.paymentMethod == 'Mobile money'
        ? [
            'Using Lipa na Mpesa',
            'Select Buy Goods and Services',
            'Till no: 8053976',
            'Amount: KES ${widget.amount}',
            'Enter the transaction ID below',
            'Confirm payment'
          ]
        : [
            'Transfer money to the bank account',
            'Bank: National Bank',
            'Account name: CoFarmer',
            'Account number: 01521251479300',
            'Amount: KES ${widget.amount}',
            'Enter the transaction ID below',
          ];
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.paymentMethod == 'Mobile money'
                  ? "Invest via mobile money"
                  : 'Invest and pay via bank',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: SizedBox(
                width: size.width - 28,
                height: size.height - 28,
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      widget.paymentMethod == 'Mobile money'
                          ? "8053976"
                          : '01521251479300',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.paymentMethod == 'Mobile money'
                        ? "Till number"
                        : 'Bank account number'),
                    const SizedBox(
                      height: 20,
                    ),
                    ...List.generate(
                        steps.length,
                        (index) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  width: 260,
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 1),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        steps[index],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Proof of payment',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hintText: 'Enter transaction ID',
                      controller: refCode,
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: 'Confirm payment',
                      isLoading: isLoading,
                      onTap: () async {
                        final investment = InvestmentModel(
                            amount: widget.amount,
                            proposalId: widget.proposal.id,
                            ownerId: widget.proposal.userId,
                            paymentMethod: widget.paymentMethod,
                            paymentReference: refCode.text,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            createdAt: Timestamp.now());
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await Provider.of<ProposalProvider>(context,
                                  listen: false)
                              .investInProposal(investment);
                          Get.off(() => InvoiceScreen(
                              proposal: widget.proposal,
                              amount: widget.amount));

                          setState(() {
                            isLoading = false;
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
