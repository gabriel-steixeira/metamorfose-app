# Site24x7 Flutter Plugin 

Site24x7 Flutter Plugin allows users to track their Flutter mobile applications' HTTP calls, crashes, screen load times, and custom data by adding transactions and 
grouping them with components, individual user, and their sessions for optimizing the app performance.

## Getting Started

Follow the given steps below to complete the installation of site24x7_flutter_plugin in your Flutter application.

# Quick Setup

## 1. Install the plugin:

```
flutter pub add site24x7_flutter_plugin
```
Open the pubspec.yaml file located inside the app folder, and you can observe that a line ```site24x7_flutter_plugin:``` under ```dependencies:``` would have been added as shown below.

```
dependencies:
  site24x7_flutter_plugin: ^1.0.0
```

## 2. Installation Steps for iOS:

1. Add pod to the podfile in your project_directory/ios/.

```
target 'Your_Project_Name' do
      
      pod 'Site24x7APM'
      
end
```

2. Run the command below in the same directory.

```
pod install
```

# Usage in Flutter Applications

Import ApmMobileapmFlutterPlugin from site24x7_flutter.dart file as follows:

```
import 'package:site24x7_flutter_plugin/site24x7_flutter_plugin.dart';
```

### 1. _Starting the Agent:_

```
import 'package:site24x7_flutter_plugin/site24x7_flutter_plugin.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  //assign the Site24x7 error callbacks
  //for non-async exceptions
  FlutterError.onError = ApmMobileapmFlutterPlugin.instance.captureFlutterError; //site24x7 custom callback

  //for async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    ApmMobileapmFlutterPlugin.instance.captureException(error, stack, false, type: "uncaughtexception"); //site24x7 custom api
    return true;
  };

  //starting the agent
  await ApmMobileapmFlutterPlugin.instance.startMonitoring("appKey", uploadInterval); //site24x7 custom api

  ...
  runApp(MyHomePage(title: 'Flutter Demo Home Page'));
  ...

}

```
Note: Make sure ```WidgetsFlutterBinding.ensureInitialized();``` is called before assigning error callbacks in the main method.

### 2. _Screen Tracking:_

You can use the mechanism below to calculate how long it takes for a screen to load. This data is pushed to the Site24x7 servers and can be used for session tracking and crash reporting.


```
For Stateless Widget:

import 'package:site24x7_flutter_plugin/site24x7_flutter_plugin.dart';

class FirstScreen extends StatelessWidget {

  FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample Widget'),
        ),
        body: Center(
            child: ElevatedButton(
              child: const Text('Go To Stateless Widget'),
              onPressed: () {
                var initialTimeStamp = DateTime.now();
                Navigator.push(
                    context, 
                    MaterialPageRoute(
                        builder: (context) => SampleStatelessWidget()
                        ),
                    ).then((value) {
                    var loadTime = DateTime.now().difference(initialTimeStamp).inMilliseconds;
                    ApmMobileapmFlutterPlugin.instance.addScreen("SampleStatelessWidget", loadTime.toDouble(), initialTimeStamp.millisecondsSinceEpoch); //site24x7 custom api
                });
              },
            ),
          ),
      );
    }
}


For Stateful Widget:


import 'package:site24x7_flutter_plugin/site24x7_flutter_plugin.dart';

class SampleWidget extends StatefulWidget {
  const SampleWidget({super.key});
  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class _SampleWidgetState extends State<SampleWidget> {
  
  late var _initialTimeStamp, _finalTimeStamp;

  @override
  void initState() {
    super.initState();
    _initialTimeStamp = DateTime.now();
  }

  void site24x7AfterBuildCallback(BuildContext context) {
    var finalTimeStamp = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.addPostFrameCallback((_) => site24x7AfterBuildCallback(context));
  
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample Widget'),
        ),
        body: Center(
          child: const Text('Hello Sample Widget');
        ),
      );
  }

  @override
  void didUpdateWidget(Fetch oldWidget) {
    super.didUpdateWidget(oldWidget);
    //send the widget loading time i.e diff b/w initial and final timestamp should be sent to server using addScreen api
    var loadTime = _finalTimeStamp.difference(_initialTimeStamp).inMilliseconds;
    ApmMobileapmFlutterPlugin.instance.addScreen("Fetch", loadTime.toDouble(), _initialTimeStamp.millisecondsSinceEpoch); //site24x7 custom api
    //assign final timestamp to initial timestamp
    _initialTimeStamp = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    //send the widget loading time i.e diff b/w initial and final timestamp should be sent to server using addScreen api
    var loadTime = _finalTimeStamp.difference(_initialTimeStamp).inMilliseconds;
    ApmMobileapmFlutterPlugin.instance.addScreen("Fetch", loadTime.toDouble(), _initialTimeStamp.millisecondsSinceEpoch); //site24x7 custom api
  }
}

```

To capture breadcrumbs automatically while routing, use ```Site24x7NavigatorObserver()``` as below:

```
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      routes: {
        '/first': (context) => FirstScreen(),
        '/second': (context) => SecondScreen(),
        '/fetch': (context) => FetchScreen()
      },
      navigatorObservers: [
        Site24x7NavigatorObserver() //site24x7 custom navigator observer
      ]
    );
  }

}

```

### 3. _Network Monitoring:_

Supports HTTP and Dio packages. Captures API calls made using packages mentioned above.

HTTP Package:
```
import 'package:http/http.dart' as http;
import 'package:site24x7_flutter_plugin/site24x7_flutter.dart';

...

//site24x7 custom components
var client = Site24x7HttpClient();
                  (or)
var client = Site24x7HttpClient(client: http.Client());

var dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=1&_limit=5');
http.Response response = await client.get(dataURL);

...

```

Dio Package:

```
import 'package:dio/dio.dart';
import 'package:site24x7_flutter_plugin/site24x7_flutter_plugin.dart';

...

var dio = Dio();

dio.enableSite24x7(); //site24x7 dio extension

var dataURL = 'https://jsonplaceholder.typicode.com/posts?userId=1_limit=5';
final response = await dio.get(dataURL);

...

Note: Make sure, you have installed http and Dio packages before making api call. And use .enableSite24x7() at the end of all custom configuration on dio object.

```


### 4. _Error Monitoring:_

You can manually capture exceptions that occur in catch blocks by using the API mentioned below.

To Capture Non-Async Exceptions:
```
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = ApmMobileapmFlutterPlugin.instance.captureFlutterError; //site24x7 custom callback
  runApp(MyHomePage());
}
```

To Capture Async Exceptions:
```
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PlatformDispatcher.instance.onError = (error, stack){
    ApmMobileapmFlutterPlugin.instance.platformDispatcherErrorCallback(error, stack); //site24x7 custom api
  };
  runApp(MyHomePage());
}
```

To Capture caught exceptions
``` 
try {

  //code which might generate exceptions

} catch (exception, stack){
  ApmMobileapmFlutterPlugin.instance.captureException(exception, stack);
}
```

Note: Error Monitoring custom APIs should be used before calling runApp().


### 5. _Transactions and Components:_

You can start and stop a unique component within a transaction. In a single transaction, you can begin more than one component.

```
ApmMobileapmFlutterPlugin.instance.startTransaction("listing_blogs");

//Grouping various operations using component.
ApmMobileapmFlutterPlugin.instance.startComponent("listing_blogs", "http_request");
//your code/logic
ApmMobileapmFlutterPlugin.instance.stopComponent("listing_blogs", "http_request");

ApmMobileapmFlutterPlugin.instance.startComponent("listing_blogs", "view_data_onto_screen");
//your code/logic
ApmMobileapmFlutterPlugin.instance.stopComponent("listing_blogs", "view_data_onto_screen");

ApmMobileapmFlutterPlugin.instance.stopTransaction("listing_blogs");

```

### 6. _User Tracking:_

You can track a specific user by setting up a unique user identifier. If a unique ID is not specified, Site24x7 generates a random GUID and assigns it as the user ID.

```
ApmMobileapmFlutterPlugin.instance.setUserId("user@example.com");
```

### 7. _Breadcrumbs:_

Use the function below to add breadcrumbs manually.

```
ApmMobileapmFlutterPlugin.instance.addBreadcrumb(event, message);
ex : ApmMobileapmFlutterPlugin.instance.addBreadcrumb("Info", "download completed");
```

### 8. _Flush:_

You can use the API below to immediately flush data to the Site24x7 servers instead of waiting for the next upload interval.

``` 
ApmMobileapmFlutterPlugin.instance.flush();
```

### 9. _Crash Application:_

You can force your application to crash and display an error message saying, "This is a site24x7 crash"

```
ApmMobileapmFlutterPlugin.instance.crashApplication();
```
