import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofarmer/common/api_service.dart';
import 'package:cofarmer/common/utils.dart';
import 'package:cofarmer/models/investment_model.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:cofarmer/widgets/bar_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class InvestmentsScreen extends StatelessWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi, Reuben', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: kInvestmentsRef
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            final data = {'amount': '0.0', 'investments': []};
            if (snapshot.hasData) {
              final investments = snapshot.data!.docs
                  .map((e) => InvestmentModel.fromJson(e.data()))
                  .toList();
              data['investments'] = investments;
              data['amount'] = investments.fold(
                  0.0,
                  (previousValue, element) =>
                      double.parse(previousValue.toString()) +
                      (double.parse(element.amount!)));
            }
            return Column(
              children: [
                InvestmentOverview(
                  amount: moneyFormat(data['amount'].toString()),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: BarChart(
                      investments: data['investments'] as List<dynamic>),
                ),
              ],
            );
          }),
    );
  }
}

class InvestmentOverview extends StatelessWidget {
  const InvestmentOverview({
    super.key,
    required this.amount,
  });
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          color: kPrimaryColor,
          child: Column(
            children: [
              Text(
                'Your investments value is',
                style: TextStyle(color: Colors.grey[200]),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'KES $amount',
                style: GoogleFonts.montserrat(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
        // const Positioned(
        //     bottom: -60,
        //     left: 0,
        //     right: 0,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         _InvestmentIcon(),
        //         _InvestmentIcon(),
        //         _InvestmentIcon(),
        //       ],
        //     ))
      ],
    );
  }
}

class _InvestmentIcon extends StatelessWidget {
  const _InvestmentIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(
              Iconsax.money,
              size: 24,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Investments',
        )
      ],
    );
  }
}
