const String kKeyID = 'id';
const String kKeyName = 'name';
const String kKeyEmail = 'email';
const String kKeyAvatar = 'avatar';
const String kKeyAccessToken = 'access_token';
const String kKeyIsLoggedIn = 'is_logged_in';
const String kKeyIsFirstTime = 'kKeyIsFirstTime';
const String kKeyIsNutration = 'kKeyIsNutration';
const String kKeyAvar = 'email';
const String kKeyMessage = 'kKeyMessage';

const String kKeyUsrInfo = 'kKeyUsrInfo';

// payemnt method
const String kKeyPaymentMethod = 'kKeyPaymentMethod';

const String kKeyIsOnboarding = 'kKeyIsOnboarding';

// inch and cm
const String kKeyonboard7HeightValue = 'kKeyonboard7HeightValue';
const String kKeyonboard7HeightUnit = 'onboard7HeightUnit';

//  Cuurnt Kg
const String kKeyonboard8HeightValue = 'kKeyonboard8HeightValue';
const String kKeyonboard8HeightUnit = 'onboard8HeightUnit';

// Target Kg
const String kKeyonboard9HeightValue = 'kKeyonboard9HeightValue';
const String kKeyonboard9HeightUnit = 'onboard9HeightUnit';

// Wellness Goals
const String kKeyBodyPartFocus = 'bodyPartFocus';
const String kKeyDreamBody = 'dreamBody';
const String kKeyUrgentImprovement = 'urgentImprovement';
const String kKeyTryingDuration = 'tryingDuration';

const String kImageUrl = 'imageUrl';
// Keys
const String kKeyStatus = 'status';
const String kKeySelectedProfile = 'selected_profile';
const String kKeyJsonObject = 'json_object';
const String kKeyJsonArray = 'json_array';
const String kKeyStringData = 'string_data';

const String kKeyData = 'data';
const String kKeyCode = 'code';

const String kPhone = 'phone_number';
const String kKeySelectedLocation = 'selected_location';
const String kKeySelectedLat = 'selected_lot';
const String kKeySelectedLng = 'selected_lng';
const String kKeyAddress = 'address';
const String kKeyCurrency = 'currency';
const String kKeyLanguage = 'language';
const String kKeyLanguageCode = 'language_code';
const String kKeyCountryCode = 'language_code';

const String kKeyToken = 'token';
const String kKeyTokenType = 'token_type';
const String kKeyDeviceToken = 'device_token';
const String kKeyUser = 'user';
const String kKeyEmailVerifiedAt = 'email_verified_at';
const String kKeyPhoneVerifiedAt = 'phone_verified_at';
const String kKeyFaqText = 'faq_text';
const String kKeyTermsAndConditionsText = 'toc_text';
const String kKeyAverageRating = 'average_rating';
const String kKeyViews = 'views';
const String kKeyProvider = 'provider';
const String kFacebook = 'facebook';
const String kApple = 'apple';
const String kGoogle = 'google';
const String kKeyEnglish = 'en';
const String kKeyPortuguese = 'pt';
const String kKeyFrench = 'fr';
const String kKeyGerman = 'de';
const String kKeySpanish = 'es';
const String kKeyRussian = 'ru';
const String kKeyFirstName = 'first_name';
const String kKeyLastName = 'lst_name';
const String kKeyDeviceID = 'device_id';
const String kKeyUserID = 'user_id';
const String kKeyShopID = 'shop_id';
const String kKeycategoriesID = 'categoriesId';
const String kKeyproductID = 'productId';
const String kKeyShopSlug = 'shop_slug';
const String kKeyRestaurantID = 'productId';
const String kKeyIsExploring = 'exploring';
const String kKeyIsFirst = 'is_first_time';

//order statuses

const List<String> kLanguagesKey = [
  kKeyEnglish,
  kKeyPortuguese,
  kKeyFrench,
  kKeyGerman,
  kKeySpanish,
  kKeyRussian,
];
const Map languages = <String, String>{
  kKeyEnglish: "English",
  kKeyPortuguese: "Portuguese",
  kKeyFrench: "French",
  kKeyGerman: "Dutch",
  kKeySpanish: "Spanish",
  kKeyRussian: "Russian",
};
const Map countriesCode = <String, String>{
  kKeyEnglish: "US",
  kKeyPortuguese: "PT",
  kKeyFrench: "FR",
  kKeyGerman: "DE",
  kKeySpanish: "ES",
  kKeyRussian: "RU",
};

// Pending onboarding data (stored before signup in new flow)
const String kKeyPendingOnboard1 = 'pending_onboard1';
const String kKeyPendingOnboard2 = 'pending_onboard2';
const String kKeyPendingOnboard4 = 'pending_onboard4';
const String kKeyPendingOnboard5 = 'pending_onboard5';
const String kKeyPendingOnboard7HeightValue = 'pending_onboard7_height_value';
const String kKeyPendingOnboard7HeightUnit = 'pending_onboard7_height_unit';
const String kKeyPendingOnboard8WeightValue = 'pending_onboard8_weight_value';
const String kKeyPendingOnboard8WeightUnit = 'pending_onboard8_weight_unit';
const String kKeyPendingOnboard9TargetWeightValue = 'pending_onboard9_target_weight_value';
const String kKeyPendingOnboard9TargetWeightUnit = 'pending_onboard9_target_weight_unit';
const String kKeyPendingSelectedDate = 'pending_selected_date';
const String kKeyPendingBmi = 'pending_bmi';
const String kKeyPendingOnboard12 = 'pending_onboard12';
const String kKeyPendingOnboard13 = 'pending_onboard13';
const String kKeyPendingOnboard15 = 'pending_onboard15';
const String kKeyFromPaywall = 'from_paywall';
const String kKeyPendingSignature = 'pending_signature_base64';
const String kKeyCacheLoaded = 'cache_loaded';

class DefaultValue {
  static const bool kDefaultBoolean = false;
  static const int kDefaultInt = 0;
  static const double kDefaultDouble = 0.0;
  static const String kDefaultString = '';
}
