import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/features/trial_continue/widgets/timeline_stepper_widget.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:intl/intl.dart';

import '../../../common_widget/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/toast.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../data/rx_get_plan/model/plan_response_model.dart';

class TrialContinueScreen extends StatefulWidget {
  const TrialContinueScreen({super.key});

  @override
  State<TrialContinueScreen> createState() => _TrialContinueScreenState();
}

class _TrialContinueScreenState extends State<TrialContinueScreen> {
  bool isChecked = false;

  void toogleChange(bool value) {
    setState(() {
      isChecked = value;
    });
  }

  bool isSelected = false;

  int? selectedIndex; // 0 = Monthly, 1 = Yearly

  @override
  void initState() {
    super.initState();
    plannRxObj.planRx();
  }

  // Future<void> stripePaymentSheet(String clientSecret) async {
  //   try {
  //     // Auto-detect intent type
  //     final isSetupIntent = clientSecret.startsWith('seti_');
  //     final isPaymentIntent = clientSecret.startsWith('pi_');

  //     print(
  //       "Client Secret Type: ${isSetupIntent
  //           ? 'Setup Intent'
  //           : isPaymentIntent
  //           ? 'Payment Intent'
  //           : 'Unknown'}",
  //     );

  //     if (isSetupIntent) {
  //       // Handle Setup Intent
  //       await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //           setupIntentClientSecret: clientSecret,
  //           merchantDisplayName: 'Fitness App',
  //         ),
  //       );
  //     } else if (isPaymentIntent) {
  //       // Handle Payment Intent
  //       await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: clientSecret,
  //           merchantDisplayName: 'Fitness App',
  //         ),
  //       );
  //     } else {
  //       throw Exception('Invalid client secret format');
  //     }

  //     await Stripe.instance.presentPaymentSheet();

  //     // Success
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           isSetupIntent ? 'Payment Method Saved' : 'Payment Successful',
  //           style: TextStyle(fontSize: 18.sp, color: Colors.white),
  //         ),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } on StripeException catch (e) {
  //     print("Stripe Error: ${e.error.localizedMessage}");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Failed: ${e.error.localizedMessage}',
  //           style: TextStyle(fontSize: 18.sp, color: Colors.white),
  //         ),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } catch (e) {
  //     print("Error: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Operation Failed',
  //           style: TextStyle(fontSize: 18.sp, color: Colors.red),
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Future<void> confirmPayment(String clientSecret) async {
  //   try {
  //     // 1. Initialize Payment Sheet with PaymentIntent
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret:
  //             clientSecret, // Use PaymentIntent client secret
  //         merchantDisplayName: 'Fitness App',
  //         // Optional: Customize appearance
  //         // style: ThemeMode.light,
  //         // googlePay: PaymentSheetGooglePay(merchantCountryCode: "US"),
  //         // testEnv: true,
  //       ),
  //     );

  //     // 2. Present Payment Sheet for immediate payment
  //     await Stripe.instance.presentPaymentSheet();

  //     // 3. Payment successful - no need for second API call
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Payment successful!")));

  //     // 4. Handle success (redirect, update UI, etc.)
  //     //  final successToken = const Uuid().v4();
  //     // Navigate to success screen
  //   } on StripeException catch (e) {
  //     print("Stripe Error: ${e.error.localizedMessage}");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Payment failed: ${e.error.localizedMessage}")),
  //     );
  //   } catch (e) {
  //     print("Exception: $e");
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Error: $e")));
  //   } finally {
  //     //setState(() => _isLoading = false);
  //   }
  // }

  // Future<void> processManualPayment(String clientSecret) async {

  //   try {
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         setupIntentClientSecret: clientSecret,
  //         merchantDisplayName: 'Fitness App',
  //       ),
  //     );
  //     await Stripe.instance
  //         .presentPaymentSheet()
  //         .then((value) {
  //           if (value == null) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text(
  //                   'Payment Success',
  //                   style: TextStyle(fontSize: 18.sp, color: Colors.white),
  //                 ),
  //               ),
  //             );
  //           }
  //         })
  //         .catchError((e) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(
  //                 'Payment Failed',
  //                 style: TextStyle(fontSize: 18.sp, color: Colors.red),
  //               ),
  //             ),
  //           );
  //         });
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
  // Future<void> processManualPayment(String clientSecret) async {
  //   try {
  //     // 1. Get user data
  //     final userEmail = "fajla1@gmail.com";

  //     // 2. Create payment method manually
  //     final paymentMethod = await Stripe.instance.createPaymentMethod(
  //       params: PaymentMethodParams.card(
  //         paymentMethodData: PaymentMethodData(
  //           billingDetails: BillingDetails(email: userEmail),
  //         ),
  //       ),
  //     );

  //     // 3. Confirm payment with the created payment method
  //     final paymentIntentResult = await Stripe.instance.confirmPayment(
  //       paymentIntentClientSecret: clientSecret,
  //       data: PaymentMethodParams.cardFromMethodId(
  //         paymentMethodData: PaymentMethodDataCardFromMethod(
  //           paymentMethodId: paymentMethod.id, // ✅ Correct parameter structure
  //         ),
  //       ),
  //     );

  //     if (paymentIntentResult.status == PaymentIntentsStatus.Succeeded) {
  //       print("Payment successful!");
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text("Payment successful!")));
  //     } else {
  //       print("Payment failed or canceled");
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text("Payment failed")));
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Error: $e")));
  //   }
  // }

  // Future<void> startPayment() async {
  //   try {
  //     // 1. Fetch the client secret from your backend
  //     final clientSecret =
  //         "seti_1SZ6fiPDus5Inpom8RFRSuGU_secret_TW8xXySjyrj4KO7dVdgcj4npOQwCpXg";

  //     // 2. Initialize the Payment Sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: clientSecret,
  //         merchantDisplayName: 'Your Merchant Name',
  //         // customerId: 'customer-id', // Optional: If using Stripe Customer API
  //         // customerEphemeralKeySecret: 'ephemeral-key', // Optional
  //         // Card as a payment method
  //       ),
  //     );

  //     // 3. Present the Payment Sheet to the user
  //     await Stripe.instance.presentPaymentSheet();

  //     // 4. After Payment Confirmation: Retrieve the PaymentMethod ID
  //     final paymentIntent = await Stripe.instance.retrievePaymentIntent(
  //       clientSecret,
  //     );

  //     if (paymentIntent != null) {
  //       final paymentMethodId = paymentIntent.paymentMethodId;
  //       log(
  //         "Payment Method ID==============================> $paymentMethodId",
  //       );

  //       // You can now send the paymentMethodId to your backend or handle further processing
  //     }

  //     log("Payment successful!");
  //   } catch (e) {
  //     log("Payment failed: $e");
  //   }
  // }

  // Future<void> startPayment() async {
  //   try {
  //     // 1. Fetch the client secret from your backend for SetupIntent
  //     final clientSecret =
  //         "seti_1SZ7OvPDus5InpomFxXJmrtJ_secret_TW9iQ6z8hVWL6a5S7GdCFTSvcGCWUti"; // Make sure this is the SetupIntent client secret

  //     // 2. Initialize the Payment Sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: clientSecret,
  //         merchantDisplayName: 'Your Merchant Name',
  //         // customerId: 'customer-id', // Optional: If using Stripe Customer API
  //         // customerEphemeralKeySecret: 'ephemeral-key', // Optional
  //       ),
  //     );

  //     // 3. Present the Payment Sheet to the user
  //     await Stripe.instance.presentPaymentSheet();

  //     // 4. After Payment Confirmation: Retrieve the PaymentMethod ID
  //     final paymentIntent = await Stripe.instance.retrievePaymentIntent(
  //       clientSecret,
  //     );

  //     if (paymentIntent != null) {
  //       final paymentMethodId = paymentIntent.paymentMethodId;
  //       log(
  //         "Payment Method ID==============================> $paymentMethodId",
  //       );

  //       // You can now send the paymentMethodId to your backend or handle further processing
  //     }

  //     log("Payment successful!");
  //   } catch (e) {
  //     log("Payment failed: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    log("Selected Index : $selectedIndex");
    DateTime today = DateTime.now();
    DateTime lastDay = today.add(const Duration(days: 3));
    String formattedDate = DateFormat('d MMMM yyyy').format(lastDay);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: StreamBuilder<PlanResponseModel>(
            stream: plannRxObj.planRxStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return WaitingWidget();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Something went wrong",
                    textAlign: TextAlign.center,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: Colors.red,
                      fontSize: 30.sp,
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                return Center(
                  child: Text(
                    "Data is not available",
                    textAlign: TextAlign.center,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: Colors.red,
                      fontSize: 30.sp,
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    UIHelper.verticalSpace(20.h),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Start your 3-day FREE trial to continue",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                              color: const Color(0xFF000000),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),

                    UIHelper.verticalSpace(50.h),

                    TimelineStepperWidget(date3Days: formattedDate),

                    UIHelper.verticalSpace(50.h),

                    SizedBox(
                      height: 150.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.data!.length,
                        separatorBuilder: (_, _) => SizedBox(width: 20.w),
                        itemBuilder: (context, index) {
                          final plan = snapshot.data?.data?[index];

                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = plan?.id;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3.w,
                                    color:
                                        selectedIndex == plan?.id
                                            ? Color(0xFFE2448B)
                                            : Colors.transparent,
                                  ),
                                  color: Color(0xFFFFDFF0),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10.h,
                                  children: [
                                    Text(
                                      plan?.interval ?? "",
                                      style: TextFontStyle
                                          .headLine16cFFFFFFWorkSansThinW600
                                          .copyWith(
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                          ),
                                    ),
                                    Text(
                                      "${plan?.price.toString() ?? ""} / ${plan?.interval ?? ""}",
                                      style: TextFontStyle
                                          .headLine16cFFFFFFWorkSansW600
                                          .copyWith(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Row(
                    //       spacing: 20.w,
                    //       children: [
                    //         Expanded(
                    //           child: InkWell(
                    //             onTap: () {
                    //               setState(() {
                    //                 selectedIndex = 0;
                    //               });
                    //             },
                    //             child: Container(
                    //               padding: EdgeInsets.symmetric(
                    //                 horizontal: 16.w,
                    //                 vertical: 16.h,
                    //               ),
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                   width: 3.w,
                    //                   color:
                    //                       selectedIndex == 0
                    //                           ? Color(0xFFE2448B)
                    //                           : Colors.transparent,
                    //                 ),
                    //                 color: Color(0xFFFFDFF0),
                    //                 borderRadius: BorderRadius.circular(14.r),
                    //               ),

                    //               child: Column(
                    //                 spacing: 10.h,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     "Monthly",
                    //                     style: TextFontStyle
                    //                         .headLine16cFFFFFFWorkSansThinW600
                    //                         .copyWith(
                    //                           fontSize: 14.sp,
                    //                           color: Colors.black,
                    //                         ),
                    //                   ),

                    //                   Text(
                    //                     "€37.00 /mo",
                    //                     style: TextFontStyle
                    //                         .headLine16cFFFFFFWorkSansW600
                    //                         .copyWith(
                    //                           fontSize: 24.sp,
                    //                           fontWeight: FontWeight.w800,
                    //                           color: Colors.black,
                    //                         ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         // Yearly Package
                    //         Expanded(
                    //           child: InkWell(
                    //             onTap: () {
                    //               setState(() {
                    //                 selectedIndex = 1;
                    //               });
                    //             },

                    //             child: Container(
                    //               padding: EdgeInsets.symmetric(
                    //                 horizontal: 16.w,
                    //                 vertical: 16.h,
                    //               ),
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                   width: 3.w,
                    //                   color:
                    //                       selectedIndex == 1
                    //                           ? Color(0xFFE2448B)
                    //                           : Colors.transparent,
                    //                 ),
                    //                 color: Color(0xFFFFDFF0),
                    //                 borderRadius: BorderRadius.circular(14.r),
                    //               ),

                    //               child: Column(
                    //                 spacing: 10.h,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     "Yearly",
                    //                     style: TextFontStyle
                    //                         .headLine16cFFFFFFWorkSansThinW600
                    //                         .copyWith(
                    //                           fontSize: 14.sp,
                    //                           color: Colors.black,
                    //                         ),
                    //                   ),

                    //                   Text(
                    //                     "€4.75 /mo",
                    //                     style: TextFontStyle
                    //                         .headLine16cFFFFFFWorkSansW600
                    //                         .copyWith(
                    //                           fontSize: 24.sp,
                    //                           fontWeight: FontWeight.w800,
                    //                           color: Colors.black,
                    //                         ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    // UIHelper.verticalSpace(20.h),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   spacing: 10.w,

                    //   children: [
                    //     MSHCheckbox(
                    //       style: MSHCheckboxStyle.fillScaleCheck,
                    //       size: 20.sp,
                    //       value: isChecked,
                    //       onChanged: (value) => toogleChange(value),
                    //       colorConfig:
                    //           MSHColorConfig.fromCheckedUncheckedDisabled(
                    //             checkedColor: Color(0xFFF566A9),
                    //             uncheckedColor: Color(0xFFD4D4D8),
                    //           ),
                    //     ),

                    //     Text(
                    //       "No payment Due now",
                    //       textAlign: TextAlign.center,
                    //       style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                    //           .copyWith(
                    //             color: const Color(0xFF000000),
                    //             fontSize: 14.sp,
                    //             fontWeight: FontWeight.w800,
                    //           ),
                    //     ),
                    //   ],
                    // ),
                    UIHelper.verticalSpace(20.h),

                    CustomButton(
                      onPressed: () async {
                        if (selectedIndex == null) {
                          ToastUtil.showErrorShortToast(
                            "Please select an Package.",
                          );
                        } else {
                          await paymentmentSheetRxObj.paymentmentSheetRx(
                            email: appData.read(kKeyEmail),
                            planId:
                                selectedIndex!, // selectedIndex == 0 ? 2 : 3,
                          );

                          log(
                            "Client Secret Key: ${paymentmentSheetRxObj.clientSecret}",
                          );

                          log(
                            "payment intent id : ${paymentmentSheetRxObj.paymentIntentId}",
                          );

                          await Stripe.instance.initPaymentSheet(
                            paymentSheetParameters: SetupPaymentSheetParameters(
                              paymentIntentClientSecret:
                                  paymentmentSheetRxObj.clientSecret,
                              //"pi_3SZ8B0PDus5Inpom1JKeZEzr_secret_1xCO4QpONz63K22IMq6r2Tzpf",
                              merchantDisplayName: 'Travelling App',
                            ),
                          );

                          await Stripe.instance
                              .presentPaymentSheet()
                              .then((value) {
                                if (value == null) {
                                  confirmSubscriptionRxObj
                                      .confirmSubscriptionRx(
                                        paymentIntentId:
                                            paymentmentSheetRxObj
                                                .paymentIntentId ??
                                            "",
                                        planId: selectedIndex!,
                                      )
                                      .waitingForFuture()
                                      .then((success) {
                                        log(
                                          "success ======================================== $success",
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Payment Success',
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );

                                        NavigationService.navigateToReplacement(
                                          Routes.navigationScreen,
                                        );
                                      });
                                }
                              })
                              .catchError((e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Payment Failed',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }

                        // await Stripe.instance.initPaymentSheet(
                        //   paymentSheetParameters: SetupPaymentSheetParameters(
                        //     merchantDisplayName: "test",
                        //     setupIntentClientSecret:
                        //         "seti_1SZ7zsPDus5InpomvO5RXqMx_secret_TWAKZZ3gIZGAMQRCB9XHYw9kvPGqSQU",
                        //   ),
                        // );

                        // await Stripe.instance.confirmSetupIntent(
                        //   paymentIntentClientSecret:
                        //       "seti_1SZ7zsPDus5InpomvO5RXqMx_secret_TWAKZZ3gIZGAMQRCB9XHYw9kvPGqSQU",
                        //   params: PaymentMethodParams.card(
                        //     paymentMethodData: PaymentMethodData(
                        //       billingDetails: BillingDetails(
                        //         name: "sdas",
                        //         email: "test@gmail.com",
                        //       ),
                        //     ),
                        //   ),
                        // );

                        // await paymentmentSheetRxObj
                        //     .paymentmentSheetRx(
                        //       email: 'testuser@gmail.com',
                        //       planId: 2,
                        //     )
                        //     .then((value) async {
                        //       log("calling ===================== ");
                        //     });

                        // log(
                        //   "Client Secret Key: ${paymentmentSheetRxObj.clientSecret}",
                        // );

                        //  await Stripe.instance.initPaymentSheet(
                        //       paymentSheetParameters: SetupPaymentSheetParameters(
                        //         paymentIntentClientSecret:
                        //             clientSecret, // Use PaymentIntent client secret
                        //         merchantDisplayName: 'Fitness App',
                        //         // Optional: Customize appearance
                        //         // style: ThemeMode.light,
                        //         // googlePay: PaymentSheetGooglePay(merchantCountryCode: "US"),
                        //         // testEnv: true,
                        //       ),

                        // startPayment(); // if (paymentmentSheetRxObj.clientSecret != null) {
                        // processManualPayment(
                        //   // paymentmentSheetRxObj.clientSecret!,
                        //   'seti_1SYp0RPDus5InpomqeZlqgwB_secret_TVqhUaQYaorj4xDubvZqbOCa871Q5a1',
                        // );
                        // processManualPayment(
                        //   paymentmentSheetRxObj.clientSecret!,
                        // );
                        // }
                      },
                      child: Row(
                        spacing: 10.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue for FREE",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                          ),

                          SvgPicture.asset(
                            Assets.icons.rightArrows,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),

                    UIHelper.verticalSpace(10.h),

                    Text(
                      "3 days free, then €69.99 per year (€4.75 /mo)",
                      textAlign: TextAlign.center,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600
                          .copyWith(
                            color: const Color(0xFF000000),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
