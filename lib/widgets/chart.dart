import 'package:expense_tracker/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/models/database_provider.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var list = db.categories;
      var total = db.calculateTotalExpenses();
      return Row(
        children: [
          Expanded(
            flex: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Total Expenses: ${NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ').format(total)}',
                    textScaleFactor: 1.5,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                ...list.map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Container(
                          width: 8.0,
                          height: 8.0,
                          color: secondaryColors[list.indexOf(e) % secondaryColors.length],
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          e.title,
                        ),
                        const SizedBox(width: 5.0),
                        Text(total == 0
                            ? '0%'
                            : '${((e.totalAmount / total) * 100).toStringAsFixed(2)}%'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 35,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 25,
                  sections: total != 0
                      ? list
                          .map(
                            (e) => PieChartSectionData(
                              showTitle: false,
                              value: e.totalAmount,
                              color: secondaryColors[list.indexOf(e) % secondaryColors.length],
                            ),
                          )
                          .toList()
                      : list
                          .map(
                            (e) => PieChartSectionData(
                              showTitle: false,
                              color: Colors.primaries[list.indexOf(e)],
                            ),
                          )
                          .toList(),
                ),
              )),
        ],
      );
    });
  }
}
