import Flutter
import UIKit
import APM

public class ApmMobileapmFlutterPlugin: NSObject, FlutterPlugin {
    
    var s247TransactionsDictionary: [String : S24Transaction] = [:]
    var s247ComponentsDictionary: [String: S24Component] = [:]
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "apm_mobileapm_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = ApmMobileapmFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    let arguments = call.arguments as? [String: Any?]
      
    switch call.method {
        
      case "startMonitoring": do {
          let appKey = arguments?["appKey"] as? String
          let uploadInterval = arguments?["uploadInterval"] as? Int
          if(appKey != nil && uploadInterval != nil){
              S24APM.start(withAppKey: appKey, interval: UInt(uploadInterval!))
          }else{
              NSLog("site24x7 either appKey or uploadInterval might be nil")
          }
      }
      case "startMonitoringWithEndPoint": do {
          let appKey = arguments?["appKey"] as? String
          let uploadInterval = arguments?["uploadInterval"] as? Int
          let endPoint = arguments?["endPoint"] as? String
          if(appKey != nil && uploadInterval != nil && endPoint != nil){
              S24APM.start(withAppKey: appKey, interval: UInt(uploadInterval!), server: endPoint)
          }else{
              NSLog("site24x7 either appKey, uploadInterval or endPoint might be nil")
          }
      }
      
      case "startTransaction": do {
          let transactionName = arguments?["name"] as? String
          guard transactionName != nil, let s247Transaction = S24APM.startTransaction(withName: transactionName) else {
              NSLog("site24x7 name should not be nil")
              return
          }
          s247TransactionsDictionary[transactionName!] = s247Transaction
      }
      
      case "stopTransaction": do {
          let transactionName = arguments?["name"] as? String
          guard transactionName != nil, s247TransactionsDictionary.contains(where: {$0.key == transactionName!}) else {
              NSLog("site24x7 either name has been nil or transaction has not been started")
              return
          }
          let transaction = s247TransactionsDictionary.removeValue(forKey: transactionName!)
          S24APM.stop(transaction)
      }
          
      case "startComponent": do {
          let transactionName = arguments?["transactionName"] as? String
          let componentName = arguments?["componentName"] as? String
          if(transactionName != nil && componentName != nil && s247TransactionsDictionary.contains(where: {$0.key == transactionName!})){
              let transaction = s247TransactionsDictionary[transactionName!]
              let component = transaction?.startComponent(withType: transactionName!+componentName!)
              s247ComponentsDictionary["transactionName+componentName"] = component
          }else{
              NSLog("site24x7 either transaction, component names are nil or transaction has not been started")
          }
      }
          
      case "stopComponent": do {
          let transactionName = arguments?["transactionName"] as? String
          let componentName = arguments?["componentName"] as? String
          guard transactionName != nil, componentName != nil, s247TransactionsDictionary.contains(where: {$0.key == transactionName}), s247ComponentsDictionary.contains(where: {$0.key == (transactionName! + componentName!)}), let transaction = s247TransactionsDictionary[transactionName!], let component = s247ComponentsDictionary[transactionName!+componentName!] else {
              NSLog("site24x7 either transaction, component names are nil or transaction, component has not been started")
              return
          }
          transaction.stop(component)
      }
          
      case "crashNative": do {
          fatalError("This is a site24x7 crash")
      }
          
      case "flush": do {
          S24APM.flush()
      }
          
      case "setUserId": do {
          let userId = arguments?["userId"] as? String
          S24APM.setUserId(userId)
      }
          
      case "addBreadcrumb": do {
          let name = arguments?["name"] as? String
          let action = arguments?["action"] as? String
          if(name != nil && action != nil){
              S24APM.addBreadcrumb(with: name, andAction: action)
          }else{
              NSLog("site24x7 either name or action is nil")
          }
      }
          
      case "addScreen": do {
          let screenName = arguments?["name"] as? String
          let loadTime = arguments?["loadTime"] as? Int
          let startTime = arguments?["startTime"] as? Int
          if(loadTime != nil && startTime != nil && screenName != nil){
            S24APM.addScreen(screenName, withTime: UInt((loadTime!)), startTime: String(startTime!))
          }else{
              NSLog("site24x7 either loadTime, startTime or screenName is nil")
          }
      }
          
      case "addHttpCall": do {
          let url = arguments?["url"] as? String
          let requestMethod = arguments?["requestMethod"] as? String
          let startTime = arguments?["startTime"] as? Int
          let loadTime = arguments?["loadTime"] as? UInt
          let statusCode = arguments?["statusCode"] as? UInt
          let screen = arguments?["currentRoute"] as? String
          if(url != nil && requestMethod != nil && startTime != nil && loadTime != nil && statusCode != nil){
            S24APM.addHttpCall(url, withTime: loadTime!, startTime: String(startTime!), respCode: statusCode!, httpMethod: requestMethod)
          }else{
              NSLog("site24x7 either of url, requestMethod, startTime, loadTime or status code is nil")
          }
      }
          
      case "captureException": do {
          let msg = arguments?["msg"] as? String
          let file = arguments?["file"] as? String
          let function = arguments?["function"] as? String
          let startTime = arguments?["startTime"] as? Int
          let stack  = arguments?["stack"] as? String
          let screenName = arguments?["currentRoute"] as? String
          let type = arguments?["type"] as? String
          let isHandled = arguments?["isHandled"] as? Bool
          guard msg != nil, file != nil, function != nil, startTime != nil, stack != nil, screenName != nil, type != nil else{
              NSLog("site24x7 either of msg, file, function, start time, stack, screenName or type is nil")
              return
          }
          S24APM.addError(msg, errorType: type, file: file, methodName: function, stackTrace: stack, screen: screenName, startTime: String(startTime!), handledException: isHandled!)
      }
        
    case "trackNativeExceptions": do {
        S24APM.enableErrorReporting()
    }
      
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
