import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyWebview extends StatefulWidget {
  @override
  _MyWebviewState createState() => new _MyWebviewState();
}

class _MyWebviewState extends State<MyWebview> {

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("Web Message Channels")),
          body: SafeArea(
              child: Column(children: <Widget>[
                Expanded(
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(
                        data: """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebMessageChannel Test</title>
</head>
<body>
    <!-- when you click this button, it will send a message to the Dart side -->
    <button id="button" onclick="port.postMessage(input.value);" />Send</button>
    <br />
    <input id="input" type="text" value="JavaScript To Native" />
    
    <script>
      // variable that will represents the port used to communicate with the Dart side
      var port;
      // listen for messages
      window.addEventListener('message', function(event) {
          if (event.data == 'capturePort') {
              // capture port2 coming from the Dart side
              if (event.ports[0] != null) {
                  // the port is ready for communication,
                  // so you can use port.postMessage(message); wherever you want
                  port = event.ports[0];
                  // To listen to messages coming from the Dart side, set the onmessage event listener
                  port.onmessage = function (event) {
                      // event.data contains the message data coming from the Dart side 
                      console.log(event.data);
                  };
              }
          }
      }, false);
    </script>
</body>
</html>
"""),
                    initialOptions: options,
                    onConsoleMessage: (controller, consoleMessage) {
                      print("Message coming from the Dart side: ${consoleMessage.message}");
                    },
                    onLoadStop: (controller, url) async {
                      if (!Platform.isAndroid || await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.CREATE_WEB_MESSAGE_CHANNEL)) {
                        // wait until the page is loaded, and then create the Web Message Channel
                        var webMessageChannel = await controller.createWebMessageChannel();
                        var port1 = webMessageChannel!.port1;
                        var port2 = webMessageChannel.port2;
  
                        // set the web message callback for the port1
                        await port1.setWebMessageCallback((message) async {
                          print("Message coming from the JavaScript side: $message");
                          // when it receives a message from the JavaScript side, respond back with another message.
                          await port1.postMessage(WebMessage(data: message! + " and back"));
                        });
  
                        // transfer port2 to the webpage to initialize the communication
                        await controller.postWebMessage(message: WebMessage(data: "capturePort", ports: [port2]), targetOrigin: Uri.parse("*"));
                      }
                    },
                  ),
                ),
              ])
          )
      ),
    );
  }
}

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("JavaScript Handlers")),
          body: SafeArea(
              child: Column(children: <Widget>[
                Expanded(
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(
                        data: """
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    </head>
    <body>
        <h1>JavaScript Handlers</h1>
        <script>
            window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                window.flutter_inappwebview.callHandler('handlerFoo')
                  .then(function(result) {
                    // print to the console the data coming
                    // from the Flutter side.
                    console.log(JSON.stringify(result));
                    
                    window.flutter_inappwebview
                      .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);
                });
            });
        </script>
    </body>
</html>
                      """
                    ),
                    initialOptions: options,
                    onWebViewCreated: (controller) {
                      controller.addJavaScriptHandler(handlerName: 'handlerFoo', callback: (args) {
                        // return data to the JavaScript side!
                        return {
                          'bar': 'bar_value', 'baz': 'baz_value'
                        };
                      });

                      controller.addJavaScriptHandler(handlerName: 'handlerFooWithArgs', callback: (args) {
                        print(args);
                        // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                      // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                    },
                  ),
                ),
              ]))),
    );
  }
