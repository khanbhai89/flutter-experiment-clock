# Flutter Experimental Clock & Alarm

This is a Flutter app that includes a digital clock and an analog clock with hour, minute, and second hands. The app also has a third "Settings" tab that is not yet implemented. The "Alarms" tab allows the user to add and delete alarms.

The app consists of the following components:

- AnalogClock class, which paints an analog clock with hour, minute, and second hands using a CustomPainter.
- ClockPainter class, which draws the individual clock hands and the outer circle of the analog clock.
- DigitalClock class, which displays the current time as a digital clock.
- ClockScreen class, which uses DefaultTabController to create a tabbed interface with three tabs: "Clock", "Alarms", and "Settings".
- AlarmsTab class, which allows the user to add and delete alarms. The class uses a ListView.builder to display the list of alarms and an AlarmForm widget to add new alarms.
- Alarm class, which represents a single alarm and contains the time at which it is set.
- When the app starts, it displays the current time in both digital and analog formats. The analog clock updates every second using a Timer.periodic object, and the digital clock updates with the current time using the DateTime.now() method.

To add a new alarm, the user taps on the "Alarms" tab and enters the desired time into an AlarmForm. The form is submitted when the user taps the "Add" button, which adds a new Alarm object to the list of alarms. Each alarm can be deleted by tapping the corresponding "Delete" button.

The "Settings" tab is not yet implemented and will display a placeholder text.
