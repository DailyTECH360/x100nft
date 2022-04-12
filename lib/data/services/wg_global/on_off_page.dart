import 'package:flutter/material.dart';
import 'package:cross_connectivity/cross_connectivity.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cross Connectivity Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

class OnOfflinePage extends StatefulWidget {
  const OnOfflinePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OnOfflinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross Connectivity'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: ConnectivityBuilder(
              builder: (context, isConnected, status) => Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    isConnected == true ? Icons.signal_wifi_4_bar : Icons.signal_wifi_off,
                    color: isConnected == true ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text('$status', style: TextStyle(color: status != ConnectivityStatus.none ? Colors.green : Colors.red)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
