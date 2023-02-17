import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ClockScreen(),
  ));
}

class AnalogClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(),
      size: const Size.square(200),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    DateTime now = DateTime.now();

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);

    // Draw the outer circle
    Paint circlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    double radius = min(centerX, centerY) - circlePaint.strokeWidth / 2;
    canvas.drawCircle(center, radius, circlePaint);

    // Draw the hour hand
    Paint hourHandPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    double hourHandLength = radius * 0.5;
    double hourRadians =
        (now.hour * pi / 6) + (now.minute * pi / 360) - (pi / 2);
    Offset hourHandEnd = Offset(centerX + cos(hourRadians) * hourHandLength,
        centerY + sin(hourRadians) * hourHandLength);
    canvas.drawLine(center, hourHandEnd, hourHandPaint);

    // Draw the minute hand
    Paint minuteHandPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    double minuteHandLength = radius * 0.7;
    double minuteRadians = (now.minute * pi / 30) - (pi / 2);
    Offset minuteHandEnd = Offset(
        centerX + cos(minuteRadians) * minuteHandLength,
        centerY + sin(minuteRadians) * minuteHandLength);
    canvas.drawLine(center, minuteHandEnd, minuteHandPaint);

    // Draw the second hand
    Paint secondHandPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double secondHandLength = radius * 0.9;
    double secondRadians = (now.second * pi / 30) - (pi / 2);
    Offset secondHandEnd = Offset(
        centerX + cos(secondRadians) * secondHandLength,
        centerY + sin(secondRadians) * secondHandLength);
    canvas.drawLine(center, secondHandEnd, secondHandPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DigitalClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
      style: const TextStyle(fontSize: 30),
    );
  }
}

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Clock App'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.timer), text: 'Clock'),
              Tab(icon: Icon(Icons.alarm), text: 'Alarms'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnalogClock(),
                  const SizedBox(height: 20),
                  DigitalClock(),
                ],
              ),
            ),
            AlarmsTab(),
            const Center(
              child: Text('This is the Settings tab'),
            ),
          ],
        ),
      ),
    );
  }
}

class AlarmsTab extends StatefulWidget {
  @override
  _AlarmsTabState createState() => _AlarmsTabState();
}

class _AlarmsTabState extends State<AlarmsTab>
    with AutomaticKeepAliveClientMixin<AlarmsTab> {
  List<Alarm> _alarms = [];

  void _addAlarm(String time) {
    setState(() {
      _alarms.add(Alarm(time: time));
    });
  }

  void _deleteAlarm(int index) {
    setState(() {
      _alarms.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_alarms[index].time),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteAlarm(index),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          AlarmForm(onSubmit: _addAlarm),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Alarm {
  final String time;

  Alarm({required this.time});
}

class AlarmForm extends StatefulWidget {
  final Function(String) onSubmit;

  const AlarmForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _AlarmFormState createState() => _AlarmFormState();
}

class _AlarmFormState extends State<AlarmForm> {
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (selectedTime != null) {
      setState(() {
        _time = selectedTime;
      });
    }
  }

  void _submit() {
    final String time = '${_time.hour}:${_time.minute}';
    widget.onSubmit(time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => _selectTime(context),
          child: Text('Set Alarm Time'),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Add Alarm'),
        ),
      ],
    );
  }
}
