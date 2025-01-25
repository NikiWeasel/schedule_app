import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/core/bloc/fetch_appointments/fetch_appointments_bloc.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/home/view/widgets/chart_employee_tile.dart';
import 'package:schedule_app/features/home/view/widgets/employees_selection_dialog.dart';
import 'package:schedule_app/features/schedule/bloc/all_employees_bloc.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/models/appointment.dart';

class HomeLineChart extends StatefulWidget {
  const HomeLineChart(
      {super.key,
      required this.allAppointments,
      required this.allEmployees,
      required this.currentEmployeeId,
      required this.allRegulations});

  final String currentEmployeeId;
  final List<Appointment> allAppointments;
  final List<Employee> allEmployees;
  final List<Regulation> allRegulations;

  @override
  State<HomeLineChart> createState() => _HomeLineChartState();
}

class _HomeLineChartState extends State<HomeLineChart> {
  DateTime selectedDate = DateTime.now();
  late DateTimeRange dateTimeRange;
  List<Employee> selectedEmployee = [];

  bool isMoneyGraph = false;
  bool isExpanded = false;

  // late List<Color> employeeColors;
  late Map<String, Color> colorsMap;

  late List<bool> empBoolList;

  @override
  void initState() {
    super.initState();

    dateTimeRange = getCurrentWeekTimeRange();
    var allEmps = widget.allEmployees;

    empBoolList = List.generate(allEmps.length, (int index) => true);

    var employeeColors = List.generate(
      allEmps.length,
      (int index) {
        // Генерация цвета на основе индекса и равномерного распределения по цветовому кругу
        double hue = (index * 360 / allEmps.length) % 360;
        return HSVColor.fromAHSV(1.0, hue, 0.7, 0.9)
            .toColor(); // Полнота и яркость для хорошей читаемости
      },
    );
    var idList = allEmps.map((e) => e.employeeId).toList();
    colorsMap = Map.fromIterables(idList, employeeColors);

    selectedEmployee = allEmps;

    // super.initState();
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void toggleGraph() {
    setState(() {
      isMoneyGraph = !isMoneyGraph;
    });
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
    Map<DateTime, List<String>> appointmentsByDay = {};

    for (var appo in appointments) {
      DateTime dateOnly =
          DateTime(appo.date.year, appo.date.month, appo.date.day);

      // Если дата ещё не добавлена, создаём запись.
      if (!appointmentsByDay.containsKey(dateOnly)) {
        appointmentsByDay[dateOnly] = [];
      }
      // Добавляем ID мастера для текущей даты.
      appointmentsByDay[dateOnly]!.add(appo.masterId);
    }

    // Считаем максимальное количество уникальных мастеров за день.
    if (appointments.isEmpty) {
      return 0;
    }

    return appointmentsByDay.values
        .map((list) => list.length) // Преобразуем списки в их длины
        .reduce((a, b) => a > b ? a : b);
  }

  int nextMultipleOfFive(int value) {
    return (value + 4) ~/ 5 * 5;
  }

  int getRegCost(String serviceName, List<Regulation> regs) {
    for (var reg in regs) {
      if (serviceName == reg.name) {
        return reg.cost;
      }
    }
    return 0;
  }

  int getMaxMoneyPerDay(
      List<Appointment> appointments, List<Regulation> regList) {
    Map<DateTime, Map<String, int>> earningsByDayAndMaster = {};

    for (var appo in appointments) {
      DateTime dateOnly =
          DateTime(appo.date.year, appo.date.month, appo.date.day);

      List<String> serviceNames = appo.serviceName.split(' + ');
      print(serviceNames);

      int totalCost = 0;
      for (var serviceName in serviceNames) {
        totalCost = totalCost + getRegCost(serviceName, regList);
      }

      if (totalCost == 0) continue;

      earningsByDayAndMaster.putIfAbsent(dateOnly, () => {});

      earningsByDayAndMaster[dateOnly]!.update(
        appo.masterId,
        (value) => value + totalCost,
        ifAbsent: () => totalCost,
      );
    }

    int maxEarnings = 0;

    for (var dailyEarnings in earningsByDayAndMaster.values) {
      int dailyMax = dailyEarnings.values
          .reduce((a, b) => a > b ? a : b); // Максимум среди мастеров за день
      if (dailyMax > maxEarnings) {
        maxEarnings = dailyMax;
      }
    }
    print(maxEarnings);

    // Округляем до кратного 5, если требуется
    return (maxEarnings / 100) % 5 == 0
        ? maxEarnings
        : nextMultipleOfFive(maxEarnings ~/ 100) * 100;
  }

  @override
  Widget build(BuildContext context) {
    var allAppointments = widget.allAppointments;
    var allEmployees = widget.allEmployees;

    var apposInRange = getApposInSelectedRange(allAppointments);
    List<Employee> selectedEmpList = [];
    for (int i = 0; i < empBoolList.length; i++) {
      if (empBoolList[i]) {
        selectedEmpList.add(allEmployees[i]);
      }
    }

    var maxAppos = getMaxAppointmentsPerDay(apposInRange).toDouble();
    var maxMoney =
        getMaxMoneyPerDay(apposInRange, widget.allRegulations).toDouble();

    print(maxMoney);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
          height: isExpanded ? 470 : 270,

          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      IconButton(
                        icon: isMoneyGraph
                            ? const Icon(Icons.monetization_on)
                            : const Icon(Icons.production_quantity_limits),
                        onPressed: toggleGraph,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: isExpanded
                            ? const Icon(Icons.keyboard_arrow_up_rounded)
                            : const Icon(Icons.keyboard_arrow_down_rounded),
                        onPressed: toggleExpansion,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: isExpanded ? 400 : 200,
                  child: LineChart(
                    isMoneyGraph
                        ? getMoneyGraphData(
                            apposInRange,
                            selectedEmpList,
                            widget.allRegulations,
                            colorsMap,
                            getDaysCount(dateTimeRange).toDouble(),
                            maxMoney == 0 ? 3 : maxMoney)
                        : getAppoGraphData(
                            apposInRange,
                            selectedEmpList,
                            colorsMap,
                            getDaysCount(dateTimeRange).toDouble(),
                            maxAppos == 0 ? 3 : maxAppos + 1),
                    duration: const Duration(milliseconds: 250),
                  ),
                ),
              ],
            ),
          ),
        ),
        for (int i = 0; i < selectedEmployee.length; i++)
          ChartEmployeeTile(
              color: colorsMap[selectedEmployee[i].employeeId]!,
              text:
                  '${selectedEmployee[i].name} ${selectedEmployee[i].surname}'),
      ],
    );
  }

  LineChartData getAppoGraphData(
      List<Appointment> appos,
      List<Employee> empList,
      Map<String, Color> colorsMap,
      double maxX,
      double maxY) {
    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridAppoData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: getLineBarsData(appos, empList, colorsMap, maxX.toInt()),
      minX: 0,
      maxX: maxX,
      maxY: maxY,
      minY: 0,
    );
  }

  LineChartData getMoneyGraphData(
      List<Appointment> appos,
      List<Employee> empList,
      List<Regulation> regList,
      Map<String, Color> colorsMap,
      double maxX,
      double maxY) {
    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridMoneyData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData:
          getLineBarsData2(appos, empList, regList, colorsMap, maxX.toInt()),
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
          sideTitles: isMoneyGraph ? leftMoneyTitles() : leftAppoTitles(),
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

  List<LineChartBarData> getLineBarsData2(
    List<Appointment> appos,
    List<Employee> empList,
    List<Regulation> regList,
    Map<String, Color> colorsMap,
    int length,
  ) {
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

        // Фильтруем `Appointment` для текущего дня
        var list = entry.value
            .where((a) =>
                a.date.year == currentDay.year &&
                a.date.month == currentDay.month &&
                a.date.day == currentDay.day)
            .toList();

        int totalEarnings = 0;

        for (var e in list) {
          // Разделяем `serviceName` на отдельные услуги
          List<String> serviceNames = e.serviceName.split(' + ');

          // Считаем стоимость всех услуг для текущего `Appointment`
          int sum = serviceNames.fold(0, (sum, serviceName) {
            var regulation = regList.firstWhere(
              (item) => item.name == serviceName,
            );
            return sum + regulation.cost;
          });

          totalEarnings += sum; // Добавляем стоимость текущего `Appointment`
        }

        spots.add(FlSpot(i.toDouble(), totalEarnings.toDouble()));
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

  SideTitles leftAppoTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  SideTitles leftMoneyTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 500,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, DateTimeRange dateTimeRange) {
    DateTime startDateTime = dateTimeRange.start;
    DateTime cellDateTime = startDateTime.add(Duration(days: value.toInt()));
    // String date = '${cellDateTime.day}.${cellDateTime.month}';

    var day = cellDateTime.day.toString().length == 1
        ? '0${cellDateTime.day}'
        : cellDateTime.day;

    var month = cellDateTime.month.toString().length == 1
        ? '0${cellDateTime.month}'
        : cellDateTime.month;

    String date = '$day.$month';

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

  FlGridData get gridAppoData => FlGridData(
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

  FlGridData get gridMoneyData => FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 500,
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
