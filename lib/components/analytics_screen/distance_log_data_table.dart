import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:guardian_app/components/common/custom_card.dart';
import 'package:guardian_app/models/models.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class DistanceLogDataTable extends StatelessWidget {
  final List<DistanceLog> data;

  const DistanceLogDataTable({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final DataTableSource _data = _DistanceLogDataSource(data);

    return CustomCard(
      height: 30.h,
      color: _themeOptions.primaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
        child: Theme(
          data: Theme.of(context).copyWith(
            cardTheme: const CardTheme(elevation: 0),
            cardColor: _themeOptions.primaryColor,
            dividerColor: _themeOptions.textColor,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: _themeOptions.textColor,
                  displayColor: _themeOptions.textColor,
                ),
            iconTheme: Theme.of(context).iconTheme.copyWith(
                  color: _themeOptions.textColor,
                ),
          ),
          child: PaginatedDataTable2(
            source: _data,
            header: Text(
              'Ultrasonic Sensor Distance Log',
              style: TextStyle(
                color: _themeOptions.textColor,
                fontSize: _themeOptions.textSize3,
              ),
            ),
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Distance (cm)')),
              DataColumn(label: Text('Recorded Date'))
            ],
            columnSpacing: 25,
            horizontalMargin: 10,
            wrapInCard: true,
            rowsPerPage: 5,
            showCheckboxColumn: false,
          ),
        ),
      ),
    );
  }
}

class _DistanceLogDataSource extends DataTableSource {
  final List<DistanceLog> data;

  _DistanceLogDataSource(this.data);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    DateFormat formatter = DateFormat('dd/MM/yyyy H:m:ss');
    return DataRow(cells: [
      DataCell(Text(data[index].id.toString())),
      DataCell(Text(data[index].recordedDistance.toString())),
      DataCell(Text(formatter.format(data[index].recordedDate!))),
    ]);
  }
}
