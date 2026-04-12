import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/helpers/di.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../helpers/toast.dart';
import '../../helpers/ui_helpers.dart';

const Set<String> _kProductIds = {
  'com.dolceresetltd.app.monthly',
  'com.dolceresetltd.app.annual',
};

/// Native StoreKit paywall — used on iPad (compatibility mode) where
/// Superwall cannot load products properly.
class NativePaywallScreen extends StatefulWidget {
  const NativePaywallScreen({super.key});

  @override
  State<NativePaywallScreen> createState() => _NativePaywallScreenState();
}

class _NativePaywallScreenState extends State<NativePaywallScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  Timer? _purchaseTimeout;

  bool _isAvailable = false;
  bool _isLoading = true;
  bool _isPurchasing = false;

  ProductDetails? _monthlyProduct;
  ProductDetails? _annualProduct;
  String _selectedPlan = 'monthly'; // 'monthly' or 'annual'

  @override
  void initState() {
    super.initState();

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) {
        log('[NativePaywall] Purchase stream error: $error');
      },
    );

    _loadProducts();
  }

  @override
  void dispose() {
    _purchaseTimeout?.cancel();
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final available = await _iap.isAvailable().timeout(
        const Duration(seconds: 10),
        onTimeout: () => false,
      );
      if (!available) {
        log('[NativePaywall] Store not available');
        if (mounted) {
          setState(() {
            _isAvailable = false;
            _isLoading = false;
          });
        }
        return;
      }

      final response = await _iap.queryProductDetails(_kProductIds).timeout(
        const Duration(seconds: 15),
      );
      if (response.error != null) {
        log('[NativePaywall] Product query error: ${response.error}');
      }
      if (response.notFoundIDs.isNotEmpty) {
        log('[NativePaywall] Products not found: ${response.notFoundIDs}');
      }

      if (mounted) {
        setState(() {
          _isAvailable = true;
          _isLoading = false;
          for (final product in response.productDetails) {
            if (product.id == 'com.dolceresetltd.app.monthly') {
              _monthlyProduct = product;
            } else if (product.id == 'com.dolceresetltd.app.annual') {
              _annualProduct = product;
            }
          }
        });
      }
    } catch (e) {
      log('[NativePaywall] Product loading error/timeout: $e');
      if (mounted) {
        setState(() {
          _isAvailable = false;
          _isLoading = false;
        });
      }
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      log('[NativePaywall] Purchase update: ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.pending:
          // StoreKit payment sheet is showing — keep loading
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _purchaseTimeout?.cancel();
          _iap.completePurchase(purchase);
          _onPurchaseSuccess();
          break;

        case PurchaseStatus.error:
          _purchaseTimeout?.cancel();
          _iap.completePurchase(purchase);
          if (mounted) setState(() => _isPurchasing = false);
          ToastUtil.showErrorShortToast(
            'Errore durante l\'acquisto. Riprova.',
          );
          break;

        case PurchaseStatus.canceled:
          _purchaseTimeout?.cancel();
          if (mounted) setState(() => _isPurchasing = false);
          break;
      }
    }
  }

  void _onPurchaseSuccess() {
    if (!mounted) return;
    setState(() => _isPurchasing = false);

    appData.write(kKeyPaymentMethod, 1);

    // If user was Web2Wave, switch them to IAP
    final paymentSource = appData.read('payment_source');
    if (paymentSource == 'web2wave') {
      appData.remove('payment_source');
      log('[NativePaywall] Cleared payment_source (was web2wave → now IAP)');
    }

    bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
    if (isLoggedIn) {
      bool cacheLoaded = appData.read(kKeyCacheLoaded) ?? false;
      if (!cacheLoaded) {
        NavigationService.navigateToUntilReplacement(
          Routes.cacheLoadingScreen,
        );
      } else {
        NavigationService.navigateToUntilReplacement(
          Routes.navigationScreen,
        );
      }
    } else {
      appData.write(kKeyFromPaywall, true);
      NavigationService.navigateToReplacement(Routes.signUpScreen);
    }
  }

  Future<void> _buySelected() async {
    final product =
        _selectedPlan == 'annual' ? _annualProduct : _monthlyProduct;
    if (product == null) return;
    setState(() => _isPurchasing = true);

    // Safety timeout — if purchase doesn't complete within 60s, reset
    _purchaseTimeout?.cancel();
    _purchaseTimeout = Timer(const Duration(seconds: 60), () {
      log('[NativePaywall] Purchase timeout');
      if (mounted && _isPurchasing) {
        setState(() => _isPurchasing = false);
        ToastUtil.showErrorShortToast(
          'L\'acquisto ha impiegato troppo tempo. Riprova.',
        );
      }
    });

    final purchaseParam = PurchaseParam(productDetails: product);
    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _purchaseTimeout?.cancel();
      log('[NativePaywall] Buy error: $e');
      if (mounted) setState(() => _isPurchasing = false);
      ToastUtil.showErrorShortToast('Errore durante l\'acquisto. Riprova.');
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isPurchasing = true);

    // Timeout — if restore doesn't complete within 30s, reset
    _purchaseTimeout?.cancel();
    _purchaseTimeout = Timer(const Duration(seconds: 30), () {
      log('[NativePaywall] Restore timeout');
      if (mounted && _isPurchasing) {
        setState(() => _isPurchasing = false);
        ToastUtil.showErrorShortToast(
          'Nessun acquisto trovato da ripristinare.',
        );
      }
    });

    try {
      await _iap.restorePurchases();
    } catch (e) {
      _purchaseTimeout?.cancel();
      log('[NativePaywall] Restore error: $e');
      if (mounted) setState(() => _isPurchasing = false);
      ToastUtil.showErrorShortToast('Impossibile ripristinare. Riprova.');
    }
  }

  bool get _hasProducts => _monthlyProduct != null || _annualProduct != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Dolce Reset Plus',
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF000000),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF566A9),
                ),
              )
            : !_isAvailable || !_hasProducts
                ? _buildError()
                : _buildPaywall(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.grey),
            UIHelper.verticalSpace(16.h),
            Text(
              'Impossibile caricare l\'abbonamento.',
              textAlign: TextAlign.center,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              'Verifica la connessione e riprova.',
              textAlign: TextAlign.center,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF71717A),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            UIHelper.verticalSpace(24.h),
            CustomButton(
              onPressed: () {
                setState(() => _isLoading = true);
                _loadProducts();
              },
              text: 'Riprova',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaywall() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UIHelper.verticalSpace(24.h),

                  // App icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF566A9).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      size: 40.sp,
                      color: const Color(0xFFF566A9),
                    ),
                  ),

                  UIHelper.verticalSpace(24.h),

                  Text(
                    'Sblocca tutti gli allenamenti',
                    textAlign: TextAlign.center,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  UIHelper.verticalSpace(12.h),

                  Text(
                    'Accedi a tutti i workout, il Chef AI, il Coach motivazionale e molto altro.',
                    textAlign: TextAlign.center,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF71717A),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  UIHelper.verticalSpace(32.h),

                  // Features list
                  _FeatureRow(
                    icon: Icons.play_circle_outline,
                    text: 'Workout video illimitati',
                  ),
                  _FeatureRow(
                    icon: Icons.restaurant_outlined,
                    text: 'Chef AI — ricette personalizzate',
                  ),
                  _FeatureRow(
                    icon: Icons.psychology_outlined,
                    text: 'Coach motivazionale AI',
                  ),
                  _FeatureRow(
                    icon: Icons.trending_up,
                    text: 'Traccia i tuoi progressi',
                  ),

                  UIHelper.verticalSpace(32.h),

                  // Plan selection
                  Row(
                    children: [
                      if (_monthlyProduct != null)
                        Expanded(
                          child: _PlanCard(
                            title: 'Mensile',
                            price: _monthlyProduct!.price,
                            period: '/mese',
                            isSelected: _selectedPlan == 'monthly',
                            onTap: () =>
                                setState(() => _selectedPlan = 'monthly'),
                          ),
                        ),
                      if (_monthlyProduct != null && _annualProduct != null)
                        SizedBox(width: 12.w),
                      if (_annualProduct != null)
                        Expanded(
                          child: _PlanCard(
                            title: 'Annuale',
                            price: _annualProduct!.price,
                            period: '/anno',
                            isSelected: _selectedPlan == 'annual',
                            badge: 'Più scelta e consigliato',
                            onTap: () =>
                                setState(() => _selectedPlan = 'annual'),
                          ),
                        ),
                    ],
                  ),

                  UIHelper.verticalSpace(16.h),
                ],
              ),
            ),
          ),

          // Bottom buttons
          CustomButton(
            color: _isPurchasing
                ? const Color(0xFFF566A9).withValues(alpha: 0.6)
                : null,
            onPressed: _isPurchasing ? () {} : _buySelected,
            child: _isPurchasing
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Abbonati ora',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                  ),
          ),

          UIHelper.verticalSpace(12.h),

          GestureDetector(
            onTap: _isPurchasing ? null : _restorePurchases,
            child: Text(
              'Ripristina acquisti',
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF71717A),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          UIHelper.verticalSpace(12.h),

          // Legal links (Apple Guideline 3.1.2(c))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => launchUrl(
                  Uri.parse('https://www.dolcereset.com/terms-and-conditions'),
                  mode: LaunchMode.externalApplication,
                ),
                child: Text(
                  'Termini di utilizzo',
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF71717A),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  '•',
                  style: TextStyle(
                    color: const Color(0xFF71717A),
                    fontSize: 12.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => launchUrl(
                  Uri.parse('https://www.dolcereset.com/privacy-policy'),
                  mode: LaunchMode.externalApplication,
                ),
                child: Text(
                  'Privacy Policy',
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF71717A),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          UIHelper.verticalSpace(16.h),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF566A9)
                : const Color(0xFFE4E4E7),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
          color: isSelected
              ? const Color(0xFFF566A9).withValues(alpha: 0.05)
              : Colors.white,
        ),
        child: Column(
          children: [
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF566A9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    badge!,
                    style:
                        TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
            Text(
              title,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                price,
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFFF566A9),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              period,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF71717A),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8.h),
            Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? const Color(0xFFF566A9)
                  : const Color(0xFFD4D4D8),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF566A9), size: 24.sp),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Text(
              text,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
