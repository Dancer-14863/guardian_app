import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:guardian_app/components/common/custom_card.dart';
import 'package:guardian_app/models/models.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class PressurePlateLogDataTable extends StatelessWidget {
  final List<PressurePlateLog> data;

  const PressurePlateLogDataTable({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final DataTableSource _data = _PressurePlateLogDataSource(data);

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
              'Pressure Plate Log',
              style: TextStyle(
                color: _themeOptions.textColor,
                fontSize: _themeOptions.textSize3,
              ),
            ),
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Triggered Sector')),
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

class _PressurePlateLogDataSource extends DataTableSource {
  final List<PressurePlateLog> data;

  _PressurePlateLogDataSource(this.data);

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
      DataCell(Text(data[index].triggeredPressurePlate.toString())),
      DataCell(Text(formatter.format(data[index].recordedDate!))),
    ]);
  }
}
