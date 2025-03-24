import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'lunar_utils.dart';
import 'holiday_info.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  List<DateTime> savedDates = [];
  // ignore: constant_identifier_names
  static const double TIMEZONE = 7.0;
  late CollectionReference _datesCollection;

  @override
  void initState() {
    super.initState();
    _datesCollection = FirebaseFirestore.instance.collection('saved_dates');
    _loadSavedDates();
  }

  Future<void> _saveDate(DateTime date) async {
    String dateString = DateFormat('yyyy-MM-dd').format(date);
    try {
      await _datesCollection.doc(dateString).set({
        'date': Timestamp.fromDate(date),
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        savedDates.add(date);
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu ngày thành công')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu ngày: $e')),
      );
    }
  }

  Future<void> _deleteDate(DateTime date) async {
    String dateString = DateFormat('yyyy-MM-dd').format(date);
    try {
      await _datesCollection.doc(dateString).delete();

      setState(() {
        savedDates.removeWhere((saved) => isSameDay(saved, date));
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa ngày thành công')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa ngày: $e')),
      );
    }
  }

  Future<void> _loadSavedDates() async {
    try {
      QuerySnapshot snapshot = await _datesCollection.get();
      setState(() {
        savedDates = snapshot.docs
            .map((doc) => (doc['date'] as Timestamp).toDate())
            .toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading dates: $e');
      }
    }
  }

  Future<void> _selectYearMonth(BuildContext context) async {
    int? selectedYear = _focusedDay.year;
    int? selectedMonth = _focusedDay.month;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Chọn tháng và năm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: selectedMonth,
                items: List.generate(12, (index) => index + 1)
                    .map((month) => DropdownMenuItem(
                          value: month,
                          child: Text('Tháng $month'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedMonth = value;
                  });
                },
                hint: const Text('Chọn tháng'),
                isExpanded: true,
              ),
              const SizedBox(height: 16),
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(201, (index) => 1900 + index)
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text('$year'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedYear = value;
                  });
                },
                hint: const Text('Chọn năm'),
                isExpanded: true,
              ),
              const SizedBox(height: 16)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (selectedYear != null && selectedMonth != null) {
                  setState(() {
                    _focusedDay = DateTime(selectedYear!, selectedMonth!, 1);
                  });
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch Dương - Âm"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(1900),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: const Icon(Icons.chevron_left),
              rightChevronIcon: const Icon(Icons.chevron_right),
              titleTextFormatter: (date, locale) =>
                  'Tháng ${date.month} năm ${date.year}',
              headerPadding: const EdgeInsets.symmetric(vertical: 8.0),
              titleTextStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              headerMargin: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return GestureDetector(
                  onTap: () => _selectYearMonth(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tháng ${day.month} năm ${day.year}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_drop_down, size: 20),
                      ],
                    ),
                  ),
                );
              },
              dowBuilder: (context, day) {
                final weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                return Center(
                  child: Text(
                    weekdays[day.weekday - 1],
                    style: const TextStyle(color: Colors.black87),
                  ),
                );
              },
              defaultBuilder: (context, day, focusedDay) {
                final lunar =
                    convertSolar2Lunar(day.day, day.month, day.year, TIMEZONE);
                final isSaved =
                    savedDates.any((saved) => isSameDay(saved, day));
                return _buildDayCell(day, lunar, false, isSaved: isSaved);
              },
              selectedBuilder: (context, day, focusedDay) {
                final lunar =
                    convertSolar2Lunar(day.day, day.month, day.year, TIMEZONE);
                final isSaved =
                    savedDates.any((saved) => isSameDay(saved, day));
                return _buildDayCell(day, lunar, true, isSaved: isSaved);
              },
              todayBuilder: (context, day, focusedDay) {
                final lunar =
                    convertSolar2Lunar(day.day, day.month, day.year, TIMEZONE);
                final isSaved =
                    savedDates.any((saved) => isSameDay(saved, day));
                return _buildDayCell(day, lunar, false,
                    isToday: true, isSaved: isSaved);
              },
            ),
            daysOfWeekHeight: 30,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                _selectedDay != null ? () => _saveDate(_selectedDay!) : null,
            child: const Text('Lưu ngày'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => StatefulBuilder(
              builder: (dialogContext, setDialogState) => AlertDialog(
                title: const Text("Các ngày đã lưu"),
                content: SingleChildScrollView(
                  child: Column(
                    children: savedDates.map((date) {
                      final lunar = convertSolar2Lunar(
                          date.day, date.month, date.year, TIMEZONE);
                      final holiday = getHoliday(
                          lunar['day']!, lunar['month']!, lunar['leap']!);
                      return ListTile(
                        title: Text(
                          "${DateFormat('dd/MM/yyyy').format(date)} - ${_formatLunarDate(lunar)} ${holiday.name.isNotEmpty ? '- ${holiday.name}' : ''}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteDate(date).then((_) {
                              setDialogState(() {});
                              setState(() {});
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Đóng'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.history),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, Map<String, int> lunar, bool isSelected,
      {bool isToday = false, bool isSaved = false}) {
    final holiday = getHoliday(lunar['day']!, lunar['month']!, lunar['leap']!);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blueGrey[300]
            : (isSaved ? Colors.yellow[100] : Colors.white),
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: Colors.blueGrey, width: 1)
            : (isSaved ? Border.all(color: Colors.yellow, width: 2) : null),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              "${day.day}",
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Text(
              _formatLunarDate(lunar),
              style: TextStyle(
                fontSize: 10,
                color: holiday.color,
                fontWeight:
                    lunar['day'] == 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (holiday.name.isNotEmpty)
            Positioned(
              top: 2,
              left: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: holiday.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  holiday.name,
                  style: TextStyle(fontSize: 8, color: holiday.color),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatLunarDate(Map<String, int> lunar) {
    String monthStr =
        lunar['leap']! == 1 ? "N${lunar['month']}" : "${lunar['month']}";
    return "${lunar['day']}/$monthStr";
  }
}
