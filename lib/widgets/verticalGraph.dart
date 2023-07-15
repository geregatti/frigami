import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class VerticalBarChart extends StatelessWidget {
  final List<OrdinalData> data;
  final String xAxisLabel;
  final String yAxisLabel;

  VerticalBarChart(this.data, this.xAxisLabel, this.yAxisLabel);

  factory VerticalBarChart.withData(List<String> x, List<String> y) {
    final data = <OrdinalData>[];

    for (int i = 0; i < x.length; i++) {
      data.add(OrdinalData(x[i], int.parse(y[i])));
    }

    return VerticalBarChart(data, 'hours', 'kcalBurnt');
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createSeriesData(),
      animate: true,
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(),
      ),
    );
  }

  List<charts.Series<OrdinalData, String>> _createSeriesData() {
    return [
      charts.Series<OrdinalData, String>(
        id: 'Data',
        domainFn: (OrdinalData data, _) => data.x,
        measureFn: (OrdinalData data, _) => data.y,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];
  }
}

class OrdinalData {
  final String x;
  final int y;

  OrdinalData(this.x, this.y);
}

