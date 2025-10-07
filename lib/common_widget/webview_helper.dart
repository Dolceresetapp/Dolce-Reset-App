// // ignore_for_file: depend_on_referenced_packages

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:poswell_app/common_widget/custom_app_bar.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// // Import for iOS features.
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// import '/networks/endpoints.dart';

// final class WebviewHelper extends StatefulWidget {
//   final String name;
//   final String url;
//   const WebviewHelper({super.key, required this.name, required this.url});

//   @override
//   State<WebviewHelper> createState() => _WebviewHelperState();
// }

// class _WebviewHelperState extends State<WebviewHelper> {
//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//         statusBarBrightness: Brightness.light,
//         statusBarIconBrightness: Brightness.dark,
//       ));
//       //}
//     } else {
//       SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ));
//     }

//     super.dispose();
//   }

//   late final WebViewController webviewController;
//   @override
//   void initState() {
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }

//     final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
//     // #enddocregion platform_features

//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.transparent)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
//                         Page resource error:
//                         code: ${error.errorCode}
//                         description: ${error.description}
//                         errorType: ${error.errorType}
//                         isForMainFrame: ${error.isForMainFrame}
//                     ''');
//           },
//           onNavigationRequest: (NavigationRequest action) {
//             if (action.url.startsWith(Endpoints.successfulPaymentUrlPrefix()) ||
//                 action.url.startsWith(Endpoints.paymentUrlProcessing()) ||
//                 action.url.startsWith(Endpoints.failedPaymentUrlPrefix())) {
//               if (action.url.startsWith(Endpoints.paymentUrlProcessing())) {
//                 Get.back(result: Endpoints.paymentUrlProcessing());
//               } else if (action.url.startsWith(Endpoints.successfulPaymentUrlPrefix())) {
//                 Get.back(result: Endpoints.successfulPaymentUrlPrefix());
//               } else {
//                 Get.back(result: Endpoints.failedPaymentUrlPrefix());
//               }
//             }
//             debugPrint('allowing navigation to ${action.url}');
//             return NavigationDecision.navigate;
//           },
//           onUrlChange: (UrlChange change) {
//             debugPrint('url change to ${change.url}');
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));

//     // #docregion platform_features
//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
//     }
//     // #enddocregion platform_features
//     webviewController = controller;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         appBar: CustomAppbar(name: widget.name),
//         body: WebViewWidget(controller: webviewController),
//       ),
//     );
//   }
// }
