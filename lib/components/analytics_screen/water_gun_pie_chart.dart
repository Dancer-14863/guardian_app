import 'package:flutter/widgets.dart';
import 'package:guardian_app/components/common/custom_card.dart';
import 'package:guardian_app/models/models.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class WaterGunPieChart extends StatelessWidget {
  final List<WaterGunLog> data;
  final Map<int, int> _sectorCountMap = {};
  final List<charts.Series<int, int>> _seriesList = [];

  WaterGunPieChart({Key? key, required this.data}) : super(key: key) {
    initSectorCount();
  }

  void initSectorCount() {
    for (WaterGunLog log in data) {
      if (!_sectorCountMap.containsKey(log.deployedSector!)) {
        _sectorCountMap.addAll({log.deployedSector!: 0});
      }
      _sectorCountMap[log.deployedSector!] =
          _sectorCountMap[log.deployedSector!]! + 1;
    }

    _seriesList.add(
      charts.Series<int, int>(
        id: 'Triggered Sectors',
        domainFn: (int key, _) => key,
        measureFn: (int key, _) => _sectorCountMap[key],
        data: _sectorCountMap.keys.toList(),
        labelAccessorFn: (int key, _) =>
            'Sector $key: ${_sectorCountMap[key]} times',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return CustomCard(
      height: 35.h,
      color: _themeOptions.primaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
        child: Column(
          children: [
            Text(
              'Number of times the Water Gun was deployed to each sector',
              style: TextStyle(
                color: _themeOptions.textColor,
                fontSize: _themeOptions.textSize4,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 25.h,
              child: charts.PieChart<int>(
                _seriesList,
                animate: true,
                defaultRenderer: charts.ArcRendererConfig(
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.outside,
                      showLeaderLines: false,
                      outsideLabelStyleSpec: const charts.TextStyleSpec(
                        fontSize: 16,
                        color: charts.MaterialPalette.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
