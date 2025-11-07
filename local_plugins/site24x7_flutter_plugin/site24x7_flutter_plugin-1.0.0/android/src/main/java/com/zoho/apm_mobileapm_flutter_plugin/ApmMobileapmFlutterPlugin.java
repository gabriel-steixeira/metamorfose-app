package com.zoho.apm_mobileapm_flutter_plugin;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.site24x7.android.apm.Apm;
import com.site24x7.android.apm.Component;
import com.site24x7.android.apm.Transaction;

import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/** ApmMobileapmFlutterPlugin */
public class ApmMobileapmFlutterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Context context;
  private final Map<String, Transaction> transactionsMap = new HashMap<String,Transaction>();
  private Map<String, Component> componentsMap = new HashMap<String,Component>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "apm_mobileapm_flutter_plugin");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    switch (call.method) {

      case "startMonitoring": {
        String appKey = Objects.requireNonNull(call.argument("appKey")); // no I18N
        int uploadInterval = Integer.parseInt(Objects.requireNonNull(call.argument("uploadInterval")).toString());
        Apm.startMonitoring(this.context, appKey, uploadInterval);
        break;
      }

      case "startMonitoringWithEndPoint": {
        String appKey = Objects.requireNonNull(call.argument("appKey")); // no I18N
        int uploadInterval = Integer.parseInt(Objects.requireNonNull(call.argument("uploadInterval")).toString());
        String endPoint = Objects.requireNonNull(call.argument("endPoint"), "endpoint should not be null"); //no I18N
        try {
          Apm.startMonitoring(this.context, appKey, uploadInterval, endPoint);
        } catch (MalformedURLException e) {
          Log.d("site24x7", "exception while start monitoring", e); //no I18N
          throw new RuntimeException(e);
        }
        break;
      }

      case "trackNativeExceptions": {
        Apm.enableErrorReporting();
        break;
      }

      case "startTransaction": {
        try{
          String transactionName = Objects.requireNonNull(call.argument("name")); // no I18N
          Transaction transaction = Apm.startTransaction(transactionName);
          transactionsMap.put(transactionName, transaction);
        }catch (Exception e){
          Log.d("site24x7","Exception while starting transaction ", e); //no I18N
        }
        break;
      }

      case "stopTransaction": {
        String transactionName = Objects.requireNonNull(call.argument("name"), "transaction name should not be null"); // no I18N
        try{
          if (transactionsMap.containsKey(transactionName)) {
            Apm.stopTransaction(transactionsMap.remove(transactionName));
          }
        }catch (Exception e){
          Log.d("site24x7","Exception while stopping transaction ", e); //no I18N
        }
        break;
      }

      case "crashNative": {
        throw new RuntimeException("This is a site24x7 crash"); // no I18N
      }

      case "startComponent":{
        String txnName = Objects.requireNonNull(call.argument("transactionName"), "transaction name should not be null"); // no I18N
        String compName = Objects.requireNonNull(call.argument("componentName"), "component name should not be null"); // no I18N
        try{
          if(transactionsMap.containsKey(txnName)){
            componentsMap.put(txnName+compName,transactionsMap.get(txnName).startComponent(compName));
          }
        }catch (Exception e){
          Log.d("site24x7","exception while starting component ", e); //no I18N
        }
        break;
      }

      case "stopComponent": {
        String txnName = Objects.requireNonNull(call.argument("transactionName"), "transaction name should not be null"); // no I18N
        String compName = Objects.requireNonNull(call.argument("componentName"), "component name should not be null"); // no I18N
        try{
          if(transactionsMap.containsKey(txnName) && componentsMap.containsKey(txnName+compName)){
            transactionsMap.get(txnName).stopComponent(componentsMap.get(txnName + compName));
          }
        }catch (Exception e){
          Log.d("site24x7","exception while stopping component ", e); //no I18N
        }
        break;
      }

      case "flush": {
        try{
          Apm.flush();
        }catch (Exception e){
          Log.d("site24x7", "exception while flushing data", e); //no I18N
        }
        break;
      }

      case "setUserId": {
        String userId = Objects.requireNonNull(call.argument("userId"), "userId must not be null"); //no I18N
        try{
          Apm.setUserId(userId);
        }catch (Exception e){
          Log.d("site24x7", "exception while setting user id", e); //no I18N
        }
        break;
      }

      case "addBreadcrumb": {
        String name  = Objects.requireNonNull(call.argument("name")); //no I18N
        String action = Objects.requireNonNull(call.argument("action")); //no I18N
        try{
          Apm.addBreadcrumb(name, action);
        }catch (Exception e){
          Log.d("site24x7", "exception while adding breadcrumb", e); //no I18N
        }
        break;
      }

      case "addScreen": {
        String screenName = Objects.requireNonNull(call.argument("name"), "screen name should not be null"); //no I18N
        int loadTime = Objects.requireNonNull(call.argument("loadTime"), "load time should not be null"); //no I18N
        long startTime = Objects.requireNonNull(call.argument("startTime"), "start time should not be null"); //no I18N
        try{
          Apm.addScreen(screenName, (long) loadTime, startTime);
        }catch (Exception e){
          Log.d("site24x7", "exception while adding screen", e); //no I18N
        }
        break;
      }

      case "captureException": {
        String msg = Objects.requireNonNull(call.argument("msg"), "msg should not be null"); //no I18N
        String file = Objects.requireNonNull(call.argument("file"), "file should not be null"); //no I18N
        String function = Objects.requireNonNull(call.argument("function"), "function should not be null"); //no I18N
        long startTime = Objects.requireNonNull(call.argument("startTime"), "start time should not be null"); //no I18N
        String stack = Objects.requireNonNull(call.argument("stack"), "stack should not be null"); //no I18N
        String screenName = Objects.requireNonNull(call.argument("currentRoute"), "currentRoute should not be null"); //no I18N
        String type = Objects.requireNonNull(call.argument("type")); //no I18N
        try{
          Apm.addError(msg, type, file, function, stack, screenName, startTime);
        }catch (Exception e){
          Log.d("site24x7", "exception while adding error to dependent native agent"); //no I18N
        }
        break;
      }

      case "addHttpCall": {
        String url = Objects.requireNonNull(call.argument("url"), "url should not be null"); //no I18N
        String requestMethod = Objects.requireNonNull(call.argument("requestMethod"), "request method should not be null"); //no I18N
        long startTime = Objects.requireNonNull(call.argument("startTime"), "start time should not be null"); //no I18N
        int loadTime = Objects.requireNonNull(call.argument("loadTime"), "load time should not be null"); //no I18N
        int statusCode = Objects.requireNonNull(call.argument("statusCode"), "status code should not be null"); //no I18N
        String screen = Objects.requireNonNull(call.argument("currentRoute"), "current route should not be null"); //no I18N
        try{
          Apm.addHttpCalls(url, requestMethod, startTime, loadTime, statusCode, screen);
        }catch (Exception e){
          Log.d("site24x7", "exception while adding http call", e); //no I18N
        }
        break;
      }

      default:{
        result.notImplemented();
        break;
      }
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
