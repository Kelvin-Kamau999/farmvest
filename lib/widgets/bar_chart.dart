import 'package:cofarmer/models/investment_model.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';

class BarChart extends StatelessWidget {
  const BarChart({Key? key, required this.investments}) : super(key: key);
  final List<dynamic> investments;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Investment history'),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: DChartBar(
            data: [
              {
                'id': 'Bar',
                'data':
                    calculateBiMonthlyData(investments.cast<InvestmentModel>())
              }
            ],
            domainLabelPaddingToAxisLine: 15,
            minimumPaddingBetweenLabel: 15,
            axisLineTick: 2,
            axisLinePointTick: 2,
            axisLinePointWidth: 10,
            axisLineColor: Colors.grey[300],
            measureLabelPaddingToAxisLine: 16,
            animationDuration: const Duration(seconds: 1),
            barColor: (barData, index, id) => kPrimaryColor,
            showBarValue: true,
          )),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> calculateBiMonthlyData(
    List<InvestmentModel> investments) {
  final biMonthlyMap = Map<String, int>();
  final biMonthlyData = [
    {
      'domain': 'Jan-Feb',
      'measure': 0,
    },
    {
      'domain': 'Mar-Apr',
      'measure': 0,
    },
    {
      'domain': 'May-June',
      'measure': 0,
    },
    {
      'domain': 'July-Aug',
      'measure': 0,
    },
    {
      'domain': 'Sept-Oct',
      'measure': 0,
    },
    {
      'domain': 'Nov-Dec',
      'measure': 0,
    }
  ];

  for (final investment in investments) {
    final createdAt = investment.createdAt;
    if (createdAt == null) continue; // Skip if createdAt is null

    final month = createdAt.toDate().month;
    final biMonthlyPeriod = (month - 1) ~/ 2; // Calculate bi-monthly period

    final domain = biMonthlyData[biMonthlyPeriod]['domain'];

    biMonthlyMap[domain as String] = (biMonthlyMap[domain] ?? 0) + 1;
  }

  final biMonthlyDataList = biMonthlyData.map((entry) {
    final domain = entry['domain'];
    final measure = biMonthlyMap[domain] ?? 0;
    return {'domain': domain, 'measure': measure};
  }).toList();

  return biMonthlyDataList;
}
