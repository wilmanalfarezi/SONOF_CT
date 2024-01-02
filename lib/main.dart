import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
//import 'package:flutter/foundation.dart';

void main() {
  runApp(MqttApp());
}

class MqttApp extends StatefulWidget {
  @override
  _MqttAppState createState() => _MqttAppState();
}

final client = MqttServerClient('free.mqtt.iyoti.id', '');

class _MqttAppState extends State<MqttApp> {
  late MqttServerClient client;
  final String mqttServer = 'free.mqtt.iyoti.id';
  final int mqttPort = 1883;
  final String mqttUsername = ''; // Jika diperlukan boleh digunakan
  final String mqttPassword = ''; // Jika diperlukan boleh digunakan

  bool isButton1Pressed = false;
  bool isButton2Pressed = false;
  bool isButton3Pressed = false;
  bool isButton4Pressed = false;

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
      print('Terkoneksi ke MQTT broker');
      // Lakukan sesuatu setelah terhubung ke broker MQTT
    } catch (e) {
      print('Koneksi gagal: $e');
    }
  }

  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconected() {
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
      title: 'MQTT App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('MQTT App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                value: isButton1Pressed,
                onChanged: toggleButton1,
              ),
              Switch(
                value: isButton2Pressed,
                onChanged: toggleButton2,
              ),
              Switch(
                value: isButton3Pressed,
                onChanged: toggleButton3,
              ),
              Switch(
                value: isButton4Pressed,
                onChanged: toggleButton4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
