import 'dart:math';

Map<String, int> convertSolar2Lunar(int dd, int mm, int yy, double timeZone) {
  int k, dayNumber, monthStart, a11, b11;
  int lunarDay, lunarMonth, lunarYear, lunarLeap;

  dayNumber = jdFromDate(dd, mm, yy);
  k = floor((dayNumber - 2415021.076998695) / 29.530588853);
  monthStart = getNewMoonDay(k + 1, timeZone);

  if (monthStart > dayNumber) {
    monthStart = getNewMoonDay(k, timeZone);
  }

  a11 = getLunarMonth11(yy, timeZone);
  b11 = a11;

  if (a11 >= monthStart) {
    lunarYear = yy;
    a11 = getLunarMonth11(yy - 1, timeZone);
  } else {
    lunarYear = yy + 1;
    b11 = getLunarMonth11(yy + 1, timeZone);
  }

  lunarDay = dayNumber - monthStart + 1;
  int diff = floor((monthStart - a11) / 29);
  lunarLeap = 0;
  lunarMonth = diff + 11;

  if (b11 - a11 > 365) {
    int leapMonthDiff = getLeapMonthOffset(a11, timeZone);
    if (diff >= leapMonthDiff) {
      lunarMonth = diff + 10;
      if (diff == leapMonthDiff) {
        lunarLeap = 1;
      }
    }
  }

  if (lunarMonth > 12) {
    lunarMonth = lunarMonth - 12;
  }

  if (lunarMonth >= 11 && diff < 4) {
    lunarYear -= 1;
  }

  return {
    'day': lunarDay,
    'month': lunarMonth,
    'year': lunarYear,
    'leap': lunarLeap
  };
}

int jdFromDate(int dd, int mm, int yy) {
  int a = floor((14 - mm) / 12);
  int y = yy + 4800 - a;
  int m = mm + 12 * a - 3;
  int jd = dd +
      floor((153 * m + 2) / 5) +
      365 * y +
      floor(y / 4) -
      floor(y / 100) +
      floor(y / 400) -
      32045;
  if (jd < 2299161) {
    jd = dd + floor((153 * m + 2) / 5) + 365 * y + floor(y / 4) - 32083;
  }
  return jd;
}

int getNewMoonDay(int k, double timeZone) {
  double T = k / 1236.85;
  // ignore: non_constant_identifier_names
  double T2 = T * T;
  // ignore: non_constant_identifier_names
  double T3 = T2 * T;
  double dr = pi / 180;
  // ignore: non_constant_identifier_names
  double Jd1 =
      2415020.75933 + 29.53058868 * k + 0.0001178 * T2 - 0.000000155 * T3;
  Jd1 = Jd1 + 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr);
  double M = 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347 * T3;
  // ignore: non_constant_identifier_names
  double Mpr = 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236 * T3;
  double F = 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239 * T3;
  // ignore: non_constant_identifier_names
  double C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
  C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
  C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
  C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr));
  C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004 * sin(dr * (2 * F + M));
  C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + Mpr));
  C1 = C1 + 0.0010 * sin(dr * (2 * F - Mpr)) + 0.0005 * sin(dr * (2 * Mpr + M));
  double deltat;
  if (T < -11) {
    deltat = 0.001 +
        0.000839 * T +
        0.0002261 * T2 -
        0.00000845 * T3 -
        0.000000081 * T * T3;
  } else {
    deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
  }
  // ignore: non_constant_identifier_names
  double JdNew = Jd1 + C1 - deltat;
  return floor(JdNew + 0.5 + timeZone / 24);
}

int getSunLongitude(int jdn, double timeZone) {
  double T = (jdn - 2451545.5 - timeZone / 24) / 36525;
  // ignore: non_constant_identifier_names
  double T2 = T * T;
  double dr = pi / 180;
  double M = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2;
  // ignore: non_constant_identifier_names
  double L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2;
  // ignore: non_constant_identifier_names
  double DL = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M);
  DL = DL +
      (0.019993 - 0.000101 * T) * sin(dr * 2 * M) +
      0.000290 * sin(dr * 3 * M);
  double L = L0 + DL;
  L = L - 360 * floor(L / 360);
  return floor(L / 30);
}

int getLunarMonth11(int yy, double timeZone) {
  int off = jdFromDate(31, 12, yy) - 2415021;
  int k = floor(off / 29.530588853);
  int nm = getNewMoonDay(k, timeZone);
  int sunLong = getSunLongitude(nm, timeZone);

  if (sunLong >= 9) {
    nm = getNewMoonDay(k - 1, timeZone);
  }

  return nm;
}

int getLeapMonthOffset(int a11, double timeZone) {
  int k = floor((a11 - 2415021.076998695) / 29.530588853 + 0.5);
  int last;
  int i = 1;
  int arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);

  do {
    last = arc;
    i++;
    arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
  } while (arc != last && i < 14);

  return i - 1;
}

int floor(double x) {
  return x.floor();
}
