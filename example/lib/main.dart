import 'package:flutter/material.dart';
import "package:pkg_chips/chipDate.dart";
import "package:pkg_chips/chipText.dart";
import "package:pkg_chips/common.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChipText utilisateur = ChipText(
      bgColor: Colors.blue.shade200,
      emptyMessage: "Utilisateur ?",
      tooltipMessageEmpty: "Saisir une partie du nom ou du prénom",
      tooltipMessage: "Utilisateur",
      removable: false,
      textFieldWidth: 150,
      bottomMessage: "Utilisateur",
      icon: Icons.person);

  ChipDate dateDebut = ChipDate(
    bgColor: Colors.lightGreen,
    emptyMessage: "Date début ?",
    bottomMessage: "Date début",
    icon: Icons.calendar_month_outlined,
    removable: true,
  );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Wrap(
          //direction: Axis.vertical,
          //alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NotificationListener(
                onNotification: (notification) {
                  switch (notification.runtimeType) {
                    case StringNotification:
                      print(
                          "Notif: ${(notification as StringNotification).value}");
                      break;
                    case ChipDeleteNotification:
                      print("Delete");
                      utilisateur.visible = false;
                      break;
                    default:
                  }
                  return true;
                },
                child: utilisateur,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChipText(
                bgColor: Colors.orange.shade200,
                emptyMessage: "Heure ?",
                textFieldWidth: 100,
                icon: Icons.alarm,
              ),
            ),
            NotificationListener(
                onNotification: (notification) {
                  switch (notification.runtimeType) {
                    case DateNotification:
                      print(
                          "Notif: ${(notification as DateNotification).value}");
                      break;
                    case ChipDeleteNotification:
                      print("Delete");
                      dateDebut.visible = false;
                      break;
                    default:
                  }
                  return true;
                },
                child: dateDebut),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  utilisateur.visible = true;
                  dateDebut.visible = true;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.visibility_off),
                onPressed: () {
                  utilisateur.visible = false;
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    utilisateur.textValue = "Hello";
                    dateDebut.dateValue =
                        DateTime.now().add(const Duration(days: 2));
                  },
                  child: const Text("Set Value"),
                ))
          ],
        ),
      ),
    );
  }
}
