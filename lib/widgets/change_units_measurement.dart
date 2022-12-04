/// Owner: Trung Cao
/// Revision date: Dec 3, 2022
/// Feature: Change Units Measurement
/// Description: ChangeUnitsMeasurement widget accepts unit and changeUnitMeasurement handler from its parent widget.
/// When a user clicks the icon, a menu will pop up showing two options, once user chooses one of the options, it will call the
/// handler passed from its parent to change state of unit and update the UI.
import 'package:flutter/material.dart';

enum Units { imperial, metric }

class ChangeUnitsMeasurement extends StatelessWidget {
  const ChangeUnitsMeasurement(
      {Key key, this.changeUnitMeasurement, @required this.unit})
      : super(key: key);

  final Function changeUnitMeasurement;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Units>(
        // Callback that sets the selected popup menu item.
        onSelected: (Units item) => changeUnitMeasurement(item.name),
        icon: const Icon(
          Icons.thermostat,
          color: Colors.blue,
          size: 26,
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Units>>[
              PopupMenuItem<Units>(
                value: Units.imperial,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        unit == 'imperial'
                            ? Icon(Icons.check, size: 15.0)
                            : SizedBox(
                                width: 15.0,
                              ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Fahrenheit'),
                      ],
                    ),
                    const Text(
                      '°F',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              PopupMenuItem<Units>(
                value: Units.metric,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        unit == 'metric'
                            ? Icon(Icons.check, size: 15.0)
                            : SizedBox(
                                width: 15.0,
                              ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Celsius'),
                      ],
                    ),
                    const Text(
                      '°C',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ]);
  }
}
