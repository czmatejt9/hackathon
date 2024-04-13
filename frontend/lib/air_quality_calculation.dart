// calculation is based on https://www.airnow.gov/sites/default/files/2020-05/aqi-technical-assistance-document-sept2018.pdf
class AirQuality {
  static int calculation(
      double so2, double co, double o3, double pm10, double pm2_5, double no2) {
    co = co / 100;
    o3 = o3 / 10;
    // the 2 above lines are just magic, idk the sensors are returning the values in this weird way
    const values = {
      'so2': [35, 75, 185, 304, 604],
      'co': [4.4, 9.4, 12.4, 15.4, 30.4],
      'o3': [54, 70, 85, 105, 200],
      'pm10': [54, 154, 254, 354, 424],
      'pm2_5': [12, 35.4, 55.4, 150.4, 250.4],
      'no2': [53, 100, 360, 649, 1249],
      'scale': [50, 100, 150, 200, 300],
    };

    // find the index of the scale that the value is in and calculate the percentage
    int so2Index = values['so2']!.indexWhere((element) => so2 < element);
    int coIndex = values['co']!.indexWhere((element) => co < element);
    int o3Index = values['o3']!.indexWhere((element) => o3 < element);
    int pm10Index = values['pm10']!.indexWhere((element) => pm10 < element);
    int pm2_5Index = values['pm2_5']!.indexWhere((element) => pm2_5 < element);
    int no2Index = values['no2']!.indexWhere((element) => no2 < element);

    // calculate the percentage and value from the scale as aqi index
    int so2Percentage = (so2Index > 0
            ? (so2 - values['so2']![so2Index - 1]) /
                (values['so2']![so2Index] - values['so2']![so2Index - 1]) *
                100
            : so2Index == 0
                ? (so2 / values['so2']![so2Index]) * 100
                : 101)
        .round();
    int coPercentage = (coIndex > 0
            ? (co - values['co']![coIndex - 1]) /
                (values['co']![coIndex] - values['co']![coIndex - 1]) *
                100
            : coIndex == 0
                ? (co / values['co']![coIndex]) * 100
                : 101)
        .round();
    int o3Percentage = (o3Index > 0
            ? (o3 - values['o3']![o3Index - 1]) /
                (values['o3']![o3Index] - values['o3']![o3Index - 1]) *
                100
            : o3Index == 0
                ? (o3 / values['o3']![o3Index]) * 100
                : 101)
        .round();
    int pm10Percentage = (pm10Index > 0
            ? (pm10 - values['pm10']![pm10Index - 1]) /
                (values['pm10']![pm10Index] - values['pm10']![pm10Index - 1]) *
                100
            : pm10Index == 0
                ? (pm10 / values['pm10']![pm10Index]) * 100
                : 101)
        .round();
    int pm2_5Percentage = (pm2_5Index > 0
            ? (pm2_5 - values['pm2_5']![pm2_5Index - 1]) /
                (values['pm2_5']![pm2_5Index] -
                    values['pm2_5']![pm2_5Index - 1]) *
                100
            : pm2_5Index == 0
                ? (pm2_5 / values['pm2_5']![pm2_5Index]) * 100
                : 101)
        .round();
    int no2Percentage = (no2Index > 0
            ? (no2 - values['no2']![no2Index - 1]) /
                (values['no2']![no2Index] - values['no2']![no2Index - 1]) *
                100
            : no2Index == 0
                ? (no2 / values['no2']![no2Index]) * 100
                : 101)
        .round();

    // calculate the aqi index
    int so2Aqi = so2Index != -1
        ? (so2Percentage *
                    (values['scale']![so2Index] -
                        (so2Index > 0 ? values['scale']![so2Index - 1] : 0)) /
                    100 +
                (so2Index > 0 ? values['scale']![so2Index - 1] : 0))
            .round()
        : 301;
    int coAqi = coIndex != -1
        ? (coPercentage *
                    (values['scale']![coIndex] -
                        (coIndex > 0 ? values['scale']![coIndex - 1] : 0)) /
                    100 +
                (coIndex > 0 ? values['scale']![coIndex - 1] : 0))
            .round()
        : 301;
    int o3Aqi = o3Index != -1
        ? (o3Percentage *
                    (values['scale']![o3Index] -
                        (o3Index > 0 ? values['scale']![o3Index - 1] : 0)) /
                    100 +
                (o3Index > 0 ? values['scale']![o3Index - 1] : 0))
            .round()
        : 301;

    int pm10Aqi = pm10Index != -1
        ? (pm10Percentage *
                    (values['scale']![pm10Index] -
                        (pm10Index > 0 ? values['scale']![pm10Index - 1] : 0)) /
                    100 +
                (pm10Index > 0 ? values['scale']![pm10Index - 1] : 0))
            .round()
        : 301;
    int pm2_5Aqi = pm2_5Index != -1
        ? (pm2_5Percentage *
                    (values['scale']![pm2_5Index] -
                        (pm2_5Index > 0
                            ? values['scale']![pm2_5Index - 1]
                            : 0)) /
                    100 +
                (pm2_5Index > 0 ? values['scale']![pm2_5Index - 1] : 0))
            .round()
        : 301;

    int no2Aqi = no2Index != -1
        ? (no2Percentage *
                    (values['scale']![no2Index] -
                        (no2Index > 0 ? values['scale']![no2Index - 1] : 0)) /
                    100 +
                (no2Index > 0 ? values['scale']![no2Index - 1] : 0))
            .round()
        : 301;

    // return the highest aqi index
    return [so2Aqi, coAqi, o3Aqi, pm10Aqi, pm2_5Aqi, no2Aqi].reduce((a, b) {
      return a > b ? a : b;
    });
  }

  static double parseValue(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else {
      return 0;
    }
  }
}
