const String kKeyID = 'id';
const String kKeyName = 'name';
const String kKeyEmail = 'email';
const String kKeyAccessToken = 'access_token';
const String kKeyIsLoggedIn = 'is_logged_in';
const String kKeyIsFirstTime = 'kKeyIsFirstTime';

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

const String kImageUrl = 'imageUrl';
// Keys
const String kKeyStatus = 'status';
const String kKeySelectedProfile = 'selected_profile';
const String kKeyJsonObject = 'json_object';
const String kKeyJsonArray = 'json_array';
const String kKeyStringData = 'string_data';
const String kKeyMessage = 'message';
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

class DefaultValue {
  static const bool kDefaultBoolean = false;
  static const int kDefaultInt = 0;
  static const double kDefaultDouble = 0.0;
  static const String kDefaultString = '';
}
