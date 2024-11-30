import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/core/bloc/fetch_appointments//fetch_appointments_bloc.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/home/view/widgets/chart_employee_tile.dart';
import 'package:schedule_app/features/home/view/widgets/employees_selection_dialog.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/appointment.dart';

class HomeLineChart extends StatefulWidget {
  const HomeLineChart(
      {super.key,
      required this.allAppointmentsState,
      required this.allEmployeesState,
      required this.currentEmployeeId});

  final String currentEmployeeId;
  final FetchAppointmentsState allAppointmentsState;
  final AllEmployeesState allEmployeesState;

  @override
  State<HomeLineChart> createState() => _HomeLineChartState();
}

class _HomeLineChartState extends State<HomeLineChart> {
  DateTime selectedDate = DateTime.now();
  late DateTimeRange dateTimeRange;
  List<Employee> selectedEmployee = [];

  // late List<Color> employeeColors;
  late Map<String, Color> colorsMap;

  late List<bool> empBoolList;

  @override
  void initState() {
    super.initState();

    dateTimeRange = getCurrentWeekTimeRange();
    if (widget.allEmployeesState is AllEmployeesLoaded) {
      var allEmpState = widget.allEmployeesState as AllEmployeesLoaded;

      empBoolList =
          List.generate(allEmpState.employees.length, (int index) => true);

      var employeeColors = List.generate(
        allEmpState.employees.length,
        (int index) {
          // Генерация цвета на основе индекса и равномерного распределения по цветовому кругу
          double hue = (index * 360 / allEmpState.employees.length) % 360;
          return HSVColor.fromAHSV(1.0, hue, 0.7, 0.9)
              .toColor(); // Полнота и яркость для хорошей читаемости
        },
      );
      var idList = allEmpState.employees.map((e) => e.employeeId).toList();
      colorsMap = Map.fromIterables(idList, employeeColors);

      selectedEmployee = allEmpState.employees;
    }

    // super.initState();
  }

  DateTimeRange getCurrentWeekTimeRange() {
    DateTime now = DateTime.now();
    int daysToSubtract = now.weekday - DateTime.monday;
    var start = now.subtract(Duration(days: daysToSubtract));
    daysToSubtract = now.weekday - DateTime.sunday;
    var end = now.subtract(Duration(days: daysToSubtract));

    return DateTimeRange(start: start, end: end);
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  String formatDateTimeRange(DateTimeRange dateTimeRange) {
    return '${formatDate(dateTimeRange.start)} — ${formatDate(dateTimeRange.end)}';
  }

  int getDaysCount(DateTimeRange range) {
    return range.end.difference(range.start).inDays + 1;
  }

  void pickDateTimeRange() async {
    final DateTimeRange? pickedDateTimeRange = await showDateRangePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDateRange: dateTimeRange,
        firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2));

    if (pickedDateTimeRange != null) {
      setState(() {
        dateTimeRange = pickedDateTimeRange;
      });
    }
  }

  void openEmployeesSelectionDialog(
      List<Employee> employeeList, List<bool> empBoolList) async {
    var empList = await showDialog(
        context: context,
        builder: (ctx) => EmployeesSelectionDialog(
              employeeList: employeeList,
              empBoolList: empBoolList,
            ));
    if (empList == null) return;
    setState(() {
      selectedEmployee = empList;
    });
  }

  List<Appointment> getApposInSelectedRange(List<Appointment> allAppos) {
    return allAppos
        .where((a) =>
            a.date.isAfter(dateTimeRange.start) &&
            a.date.isBefore(dateTimeRange.end))
        .toList();
  }

  int getMaxAppointmentsPerDay(List<Appointment> appointments) {
    Map<DateTime, int> appointmentsCountByDay = {};

    for (var appo in appointments) {
      DateTime dateOnly =
          DateTime(appo.date.year, appo.date.month, appo.date.day);
      if (!appointmentsCountByDay.containsKey(dateOnly)) {
        appointmentsCountByDay[dateOnly] = 1;
      } else {
        appointmentsCountByDay[dateOnly] =
            appointmentsCountByDay[dateOnly]! + 1;
      }
    }
    return appointmentsCountByDay.values.isEmpty
        ? 0
        : appointmentsCountByDay.values.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.allAppointmentsState is FetchAppointmentsLoaded &&
        widget.allEmployeesState is AllEmployeesLoaded) {
      var allAppointments =
          (widget.allAppointmentsState as FetchAppointmentsLoaded).appointments;
      var allEmployees =
          (widget.allEmployeesState as AllEmployeesLoaded).employees;

      var apposInRange = getApposInSelectedRange(allAppointments);
      List<Employee> selectedEmpList = [];
      for (int i = 0; i < empBoolList.length; i++) {
        if (empBoolList[i]) {
          selectedEmpList.add(allEmployees[i]);
        }
      }

      var maxAppos = getMaxAppointmentsPerDay(apposInRange).toDouble();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: pickDateTimeRange,
                label: Text(formatDateTimeRange(dateTimeRange)),
                icon: const Icon(Icons.calendar_month_rounded),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  openEmployeesSelectionDialog(allEmployees, empBoolList);
                },
                label: const Text('Мастера'),
                icon: const Icon(Icons.person),
              ),
            ],
          ),
          Container(
            // margin: const EdgeInsets.all(16.0),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8, bottom: 8),
              child: LineChart(
                getSampleData1(
                    apposInRange,
                    selectedEmpList,
                    colorsMap,
                    getDaysCount(dateTimeRange).toDouble(),
                    maxAppos == 0 ? 3 : maxAppos + 1),
                duration: const Duration(milliseconds: 250),
              ),
            ),
          ),
          for (int i = 0; i < selectedEmployee.length; i++)
            ChartEmployeeTile(
                color: colorsMap[selectedEmployee[i].employeeId]!,
                text:
                    '${selectedEmployee[i].name} ${selectedEmployee[i].surname}')
        ],
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: CardCircularProgressIndicator(),
      ),
    );
  }

  LineChartData getSampleData1(List<Appointment> appos, List<Employee> empList,
      Map<String, Color> colorsMap, double maxX, double maxY) {
    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: getLineBarsData(appos, empList, colorsMap, maxX.toInt()),
      minX: 0,
      maxX: maxX,
      maxY: maxY,
      minY: 0,
    );
  }

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: getBottomTitles(dateTimeRange),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> getLineBarsData(List<Appointment> appos,
      List<Employee> empList, Map<String, Color> colorsMap, int length) {
    Map<String, List<Appointment>> appointmentsByEmployee = {};

    for (var appo in appos) {
      if (empList.any((emp) => emp.employeeId == appo.masterId)) {
        if (!appointmentsByEmployee.containsKey(appo.masterId)) {
          appointmentsByEmployee[appo.masterId] = [];
        }
        appointmentsByEmployee[appo.masterId]!.add(appo);
      }
    }

    List<LineChartBarData> lineBars = [];
    int colorIndex = 0;

    for (var entry in appointmentsByEmployee.entries) {
      List<FlSpot> spots = [];
      for (int i = 0; i < length; i++) {
        DateTime currentDay = dateTimeRange.start.add(Duration(days: i));
        int count = entry.value
            .where((a) =>
                a.date.year == currentDay.year &&
                a.date.month == currentDay.month &&
                a.date.day == currentDay.day)
            .length;

        spots.add(FlSpot(i.toDouble(), count.toDouble()));
      }

      lineBars.add(LineChartBarData(
        isCurved: false,
        color: colorsMap[entry.key],
        curveSmoothness: 0,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: spots,
      ));
      colorIndex++;
    }

    return lineBars;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return Text(value.toInt().toString(),
        style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, DateTimeRange dateTimeRange) {
    DateTime startDateTime = dateTimeRange.start;
    DateTime cellDateTime = startDateTime.add(Duration(days: value.toInt()));
    String date = '${cellDateTime.day}.${cellDateTime.month}';

    Widget text;
    if (cellDateTime == dateTimeRange.end.add(const Duration(days: 1))) {
      text = Container();
    } else {
      if (getDaysCount(dateTimeRange) > 27) {
        text = Transform.rotate(
            angle: 70,
            child: Text(
              date,
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10),
            ));
      } else {
        text = Transform.rotate(
            angle: 70,
            child: Text(date, style: Theme.of(context).textTheme.bodySmall));
      }
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles getBottomTitles(DateTimeRange dateTimeRange) => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) =>
            bottomTitleWidgets(value, meta, dateTimeRange),
      );

  FlGridData get gridData => FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black26,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black26,
            strokeWidth: 1,
          );
        },
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black26.withOpacity(0.2), width: 1),
          //Внешние бордеры
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );
}
