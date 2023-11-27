import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class MetricsTab extends StatelessWidget {
  // Mock data for each day of the week
  final List<int> barChartData = [
    5,
    8,
    10,
    7,
    9,
    4,
    6
  ]; // Example: [SEG, TER, QUA, QUI, SEX, SAB, DOM]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 30),
                child: Text(
                  'Tarefas Concluídas', // The title text
                  style: TextStyle(
                      color: Colors.grey, fontSize: 20, fontFamily: 'Roboto'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  'Última semana', // The subtitle text
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey, fontFamily: 'Roboto'),
                ),
              ),
            ),
            BarChartWidget(barChartData: barChartData),
            SizedBox(height: 5),
            PieChartWidget(),
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<int> barChartData;

  BarChartWidget({required this.barChartData});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> generateBarGroups() {
      return List.generate(barChartData.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: barChartData[index].toDouble(),
              color: Color.fromRGBO(1, 169, 94, 1), // Set the color to green
              width: 28,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        );
      });
    }

    double maxY = barChartData.reduce(math.max).toDouble() + 2;

    return Container(
      height: 200,
      padding:
          EdgeInsets.fromLTRB(16.0, 12.0, 25.0, 0), // Increased left padding
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: maxY, // Use the calculated maxY
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.white,
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const daysOfWeek = [
                    'SEG',
                    'TER',
                    'QUA',
                    'QUI',
                    'SEX',
                    'SAB',
                    'DOM'
                  ];
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(daysOfWeek[value.toInt()],
                        style: TextStyle(color: Colors.grey, fontSize: 10)),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Enable Y-axis titles
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  );
                },
                interval:
                    2, // Set interval to control the frequency of the labels
                reservedSize: 30, // Adjust if necessary
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: generateBarGroups(),
        ),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 30),
            child: Text(
              'Status das tarefas', // The title text
              style: TextStyle(
                  color: Colors.grey, fontSize: 20, fontFamily: 'Roboto'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 30),
            child: Text(
              'Último mês', // The subtitle text
              style: TextStyle(
                  fontSize: 14, color: Colors.grey, fontFamily: 'Roboto'),
            ),
          ),
        ),
        Container(
          height: 150,
          child: PieChart(
            PieChartData(
              sectionsSpace: 1.5,
              centerSpaceRadius: 0,
              sections: [
                PieChartSectionData(
                  color: Color.fromRGBO(
                      1, 169, 94, 1), // Green color for 'Concluídas'
                  value: 40, // Adjust value accordingly
                  title: '40%', // You can include the percentage here
                  radius: 90,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff),
                  ),
                ),
                PieChartSectionData(
                  color: Color.fromRGBO(
                      237, 232, 100, 0.41), // Yellow color for 'Pendentes'
                  value: 30, // Adjust value accordingly
                  title: '30%', // You can include the percentage here
                  radius: 90,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff),
                  ),
                ),
                PieChartSectionData(
                  color: Color.fromRGBO(
                      237, 100, 100, 0.68), // Red color for 'Expiradas'
                  value: 30, // Adjust value accordingly
                  title: '30%', // You can include the percentage here
                  radius: 90,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    color: const Color(0xffffffff),
                  ),
                ),
                // Add more sections if needed
              ],
            ),
          ),
        ),
        SizedBox(height: 30), // Spacing between chart and subtitles
        // Subtitles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(children: <Widget>[
              CircleAvatar(
                radius: 10,
                backgroundColor: Color.fromRGBO(1, 169, 94, 1),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'Concluídas',
                    style: TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
                  )),
            ]),
            Row(children: <Widget>[
              CircleAvatar(
                radius: 10,
                backgroundColor: Color.fromRGBO(237, 232, 100, 0.41),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'Pendentes',
                    style: TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
                  ))
            ]),
            Row(children: <Widget>[
              CircleAvatar(
                radius: 10,
                backgroundColor: Color.fromRGBO(237, 100, 100, 0.68),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'Expiradas',
                    style: TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
                  ))
            ]),
          ],
        )
      ],
    );
  }
}
