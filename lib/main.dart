import 'package:Sonof/widget/switch_container.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
//import 'package:flutter/foundation.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MqttApp(),
  ));
}

class MqttApp extends StatefulWidget {
  @override
  _MqttAppState createState() => _MqttAppState();
}

final client = MqttServerClient('free.mqtt.iyoti.id', '');

class _MqttAppState extends State<MqttApp> {
  late MqttServerClient client;
  String mqttServer = 'free.mqtt.iyoti.id';
  int mqttPort = 1883;
  String mqttUsername = ''; // Jika diperlukan boleh digunakan
  final String mqttPassword = ''; // Jika diperlukan boleh digunakan

  bool isConnected = false;
  bool isButton1Pressed = false;
  bool isButton2Pressed = false;
  bool isButton3Pressed = false;
  bool isButton4Pressed = false;

  final serverController = TextEditingController();
  final portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectToMqttBroker();
  }

  void connectToMqttBroker() async {
    client = MqttServerClient.withPort(mqttServer, '', mqttPort);
    //client.port = mqttPort;
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconected;
    client.onSubscribed = onSubcribed;
    client.onSubscribeFail = onSubcribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 60;

    client.setProtocolV311();

    final connMessage = MqttConnectMessage()
        .withWillTopic('willTopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    print('MQTT_LOGS::Mosquitto client terhubung');

    client.connectionMessage = connMessage;

    try {
      await client.connect();
      isConnected = true;
      print('Terkoneksi ke MQTT broker');
      // Lakukan sesuatu setelah terhubung ke broker MQTT
    } catch (e) {
      isConnected = false;
      print('Koneksi gagal: $e');
    }
    setState(() {});
  }

  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconected() {
    isConnected = false;
    print('MQTT_LOGS:: Disconnected');
  }

  void onSubcribed(String topic) {
    print('MQTT_LOGS:: Subcribed topic : $topic');
  }

  void onSubcribeFail(String topic) {
    print('MQTT_LOGS:: Gagalsubcribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT_LOGS:: Ping response client callback invoked');
  }

  void toggleButton1(bool value) {
    setState(() {
      isButton1Pressed = value;
      if (isButton1Pressed) {
        print('Nilai = $isButton1Pressed');
        isButton2Pressed = false;
        publishMessage('cmnd/doko/POWER1', 'ON');
        publishMessage('cmnd/doko/POWER2', 'OFF');
        //print(isButton1Pressed);
      } else {
        print('Nilai = $isButton1Pressed');
        //isButton2Pressed = false;
        publishMessage('cmnd/doko/POWER1', 'OFF');
        //print(isButton1Pressed);
      }
    });
  }

  void toggleButton2(bool value) {
    setState(() {
      isButton2Pressed = value;
      if (isButton2Pressed) {
        print('Nilai = $isButton2Pressed');
        isButton1Pressed = false;
        publishMessage('cmnd/doko/POWER1', 'OFF');
        publishMessage('cmnd/doko/POWER2', 'ON');
      } else {
        print('Nilai = $isButton2Pressed');
        //isButton1Pressed = false;
        publishMessage('cmnd/doko/POWER2', 'OFF');
        //print(isButton2Pressed);
      }
    });
  }

  void toggleButton3(bool value) {
    setState(() {
      isButton3Pressed = value;
      if (isButton3Pressed) {
        print('Nilai = $isButton3Pressed');
        isButton4Pressed = false;
        publishMessage('cmnd/doko/POWER3', 'ON');
        publishMessage('cmnd/doko/POWER4', 'OFF');
      } else {
        print('Nilai = $isButton3Pressed');
        publishMessage('cmnd/doko/POWER3', 'OFF');
      }
    });
  }

  void toggleButton4(bool value) {
    setState(() {
      isButton4Pressed = value;
      if (isButton4Pressed) {
        print('Nilai = $isButton4Pressed');
        isButton3Pressed = false;
        publishMessage('cmnd/doko/POWER3', 'OFF');
        publishMessage('cmnd/doko/POWER4', 'ON');
      } else {
        print('Nilai = $isButton4Pressed');
        publishMessage('cmnd/doko/POWER4', 'OFF');
      }
    });
  }

  void publishMessage(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rigging Control System',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rigging Control System'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("MQTT SERVER: $mqttServer"),
                        Text("MQTT PORT: $mqttPort"),
                        Text(isConnected ? "Terkoneksi" : "Tidak Terkoneksi"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        testAlert(context);
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.orange),
                      child: Text(
                        "UBAH",
                        selectionColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SwitchContainer(
                          onChanged: toggleButton1,
                          value: isButton1Pressed,
                          label: "Relay 1",
                          title: "Naik",
                          isActive: isButton1Pressed,
                        ),
                        Spacer(),
                        SwitchContainer(
                          onChanged: toggleButton2,
                          value: isButton2Pressed,
                          label: "Relay 2",
                          title: "Turun",
                          isActive: isButton2Pressed,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SwitchContainer(
                          onChanged: toggleButton3,
                          value: isButton3Pressed,
                          label: "Relay 3",
                          title: "Maju",
                          isActive: isButton3Pressed,
                        ),
                        Spacer(),
                        SwitchContainer(
                          onChanged: toggleButton4,
                          value: isButton4Pressed,
                          label: "Relay 4",
                          title: "Mundur",
                          isActive: isButton4Pressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.asset("assets/Logo.png"),
                    ),
                    Text("Museum Nasional Indonesia")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void testAlert(BuildContext context) {
    serverController.text = mqttServer;
    portController.text = mqttPort.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Ubah'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'MQTT SERVER',
                    ),
                    controller: serverController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'MQTT PORT',
                    ),
                    controller: portController,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                ElevatedButton(
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    mqttServer = serverController.text;
                    mqttPort = int.parse(portController.text);
                    connectToMqttBroker();
                    setState(() {});
                    Navigator.pop(context, true);
                  },
                ),
                Spacer(),
                ElevatedButton(
                  child: Text("Batalkan"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
