import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyWebview extends StatefulWidget {
  @override
  _MyWebviewState createState() => new _MyWebviewState();
}

class _MyWebviewState extends State<MyWebview> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        supportZoom: false, // zoom support
        preferredContentMode: UserPreferredContentMode.MOBILE),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("Web Message Channels")),
          body: SafeArea(
              child: Column(children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialData: InAppWebViewInitialData(data: """
<!DOCTYPE html>
<html>
<head>
    <title>API Request Example</title>
</head>
<body>
    <script src="https://cdn.docuseal.co/js/builder.js"></script>

    <h1>API Response:</h1>
    <div id="apiResponse"></div>
    <!-- <div id="docusealBuilder" data-token=""></div> -->
    <!-- <docuseal-builder  id="docusealBuilder"   data-token = "">  </docuseal-builder> -->

    <!--docuseal-builder-- 
        id="docusealBuilder"
        data-token="">
    </!--docuseal-builder-->
    <script>

        // Get a reference to the DOM element where you want to display the API response
const apiResponseElement = document.getElementById('apiResponse');

// Define the URL of your API endpoint
const apiUrl = 'https://v-room.icosnet.com/api/docu_seal';

    const url= 'https://www.mountaingoatsoftware.com/uploads/documents/example-user-stories.pdf';
// Make a GET request to your API

/* var myHeaders = new Headers();
myHeaders.append("Content-Type", "application/x-www-form-urlencoded");

var urlencoded = new URLSearchParams();
urlencoded.append("url", url);
urlencoded.append("name", "test from my embedded page");
var requestOptions = {
  method: 'POST',
  headers: myHeaders,
  body: urlencoded,
  redirect: 'follow'
}; */


var myHeaders1 = new Headers();
var username = "dsi_selfcare";
var password = "dsi_selfcare";
var base64Credentials = btoa(username + ':' + password);
console.log("token",base64Credentials);


// myHeaders1.append("Content-Type", "application/x-www-form-urlencoded");

myHeaders1.append("Access-Control-Allow-Headers", "Content-Type");
myHeaders1.append("Access-Control-Allow-Methods", "OPTIONS,POST,GET,PATCH");
myHeaders1.append("Access-Control-Allow-Origin", "*");

var urlencoded = new URLSearchParams();
urlencoded.append("url", url);
urlencoded.append("name", "test from my embedded page");

var requestOptions2 = {
// mode: 'no-cors',
  method: 'POST',
  headers: myHeaders1,
  body: urlencoded,
   redirect: 'follow'

};


/*fetch("https://ibm-p.vazii.com/esb/generate_docuseal_token.php", requestOptions)
  .then(response => response.text())
  .then(result => console.log(result))
  .catch(error => console.log('error', error));*/

fetch(apiUrl, requestOptions2)
    .then(response => {
        console.log("response",response)
        
        if (!response.ok) {
           
            throw new Error('Network response was not ok');
        }
        return response.text();
    })
    .then(data => {
        // Display the API response on the HTML page
        console.log("data",data);
        apiResponseElement.textContent = data;
        //docusealBuilder = document.getElementById('docusealBuilder');
        //docusealBuilder.setAttribute('data-token', data);
        var demoElement = document.getElementById('apiResponse');
        // var docusealBuilderElement = document.getElementById('docusealBuilder');
        // docusealBuilderElement.setAttribute('data-token', data);
        demoElement.innerHTML = `<docuseal-builder 
   id="docusealBuilder"
   data-token=` + data + `>
</docuseal-builder>`;

    })
    .catch(error => {
        apiResponseElement.textContent = 'Error: ' + error.message;
    });

    </script>
</body>
</html>

"""),
                initialOptions: options,
                onConsoleMessage: (controller, consoleMessage) {
                  print(
                      "Message coming from the Dart side: ${consoleMessage.message}");
                },
                onLoadStop: (controller, url) async {
                  if (!Platform.isAndroid ||
                      await AndroidWebViewFeature.isFeatureSupported(
                          AndroidWebViewFeature.CREATE_WEB_MESSAGE_CHANNEL)) {
                    // wait until the page is loaded, and then create the Web Message Channel
                    var webMessageChannel =
                        await controller.createWebMessageChannel();
                    var port1 = webMessageChannel!.port1;
                    var port2 = webMessageChannel.port2;

                    // set the web message callback for the port1
                    await port1.setWebMessageCallback((message) async {
                      print(
                          "Message coming from the JavaScript side: $message");
                      // when it receives a message from the JavaScript side, respond back with another message.
                      await port1.postMessage(
                          WebMessage(data: message! + " and back"));
                    });

                    // transfer port2 to the webpage to initialize the communication
                    await controller.postWebMessage(
                        message:
                            WebMessage(data: "capturePort", ports: [port2]),
                        targetOrigin: Uri.parse("*"));
                  }
                },
              ),
            ),
          ]))),
    );
  }
}
