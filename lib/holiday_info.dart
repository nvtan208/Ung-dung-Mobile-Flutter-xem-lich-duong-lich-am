import 'package:flutter/material.dart';

class HolidayInfo {
  final String name;
  final String description;
  final Color color;

  const HolidayInfo({
    required this.name,
    required this.description,
    required this.color,
  });
}

HolidayInfo getHoliday(int lunarDay, int lunarMonth, int isLeap) {
  if (isLeap == 1) {
    return const HolidayInfo(name: "", description: "", color: Colors.black54);
  }

  if (lunarDay == 1 && lunarMonth == 1) {
    return const HolidayInfo(
      name: "Tết Nguyên Đán",
      description: "Ngày đầu năm âm lịch, lễ hội lớn nhất Việt Nam.",
      color: Colors.red,
    );
  }

  if (lunarDay == 15 && lunarMonth == 1) {
    return const HolidayInfo(
      name: "Rằm Tháng Giêng",
      description: "Ngày rằm đầu tiên của năm, cầu may mắn.",
      color: Colors.purple,
    );
  }

  if (lunarDay == 10 && lunarMonth == 3) {
    return const HolidayInfo(
      name: "Giỗ Tổ Hùng Vương",
      description: "Ngày 10/3 âm lịch, tưởng nhớ các Vua Hùng.",
      color: Colors.red,
    );
  }

  if (lunarDay == 15 && lunarMonth == 4) {
    return const HolidayInfo(
      name: "Lễ Phật Đản",
      description: "Ngày Đức Phật Thích Ca đản sinh.",
      color: Colors.orange,
    );
  }

  if (lunarDay == 5 && lunarMonth == 5) {
    return const HolidayInfo(
      name: "Tết Đoan Ngọ",
      description: "Ngày 5/5 âm lịch, tống tiễn sâu bọ, tránh dịch bệnh.",
      color: Colors.green,
    );
  }

  if (lunarDay == 15 && lunarMonth == 7) {
    return const HolidayInfo(
      name: "Lễ Vu Lan",
      description: "Ngày báo hiếu cha mẹ, tổ tiên.",
      color: Colors.purple,
    );
  }

  if (lunarDay == 15 && lunarMonth == 8) {
    return const HolidayInfo(
      name: "Tết Trung Thu",
      description: "Ngày rằm tháng 8, trẻ em rước đèn, ăn bánh trung thu.",
      color: Colors.orange,
    );
  }

  if (lunarDay == 23 && lunarMonth == 12) {
    return const HolidayInfo(
      name: "Tiễn Ông Táo",
      description: "Ngày 23 tháng Chạp, ông Táo về trời báo cáo.",
      color: Colors.blue,
    );
  }

  if (lunarDay == 15) {
    return const HolidayInfo(
      name: "Ngày Rằm",
      description: "Ngày 15 âm lịch, trăng tròn.",
      color: Colors.blue,
    );
  }

  if (lunarDay == 1) {
    return const HolidayInfo(
      name: "Mùng 1",
      description: "Ngày đầu tháng âm lịch.",
      color: Colors.green,
    );
  }

  return const HolidayInfo(name: "", description: "", color: Colors.black54);
}
