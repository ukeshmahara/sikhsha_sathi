import 'package:sikhsha_sathi/app/locale/locale_state.dart';

class AppStrings {
  AppStrings._();

  static const Map<String, Map<AppLanguage, String>> _values = {
    'profile': {
      AppLanguage.english: 'Profile',
      AppLanguage.nepali: 'प्रोफाइल',
    },
    'fullName': {
      AppLanguage.english: 'Full Name',
      AppLanguage.nepali: 'पूरा नाम',
    },
    'email': {
      AppLanguage.english: 'Email',
      AppLanguage.nepali: 'इमेल',
    },
    'phoneNumber': {
      AppLanguage.english: 'Phone Number',
      AppLanguage.nepali: 'फोन नम्बर',
    },
    'editProfile': {
      AppLanguage.english: 'Edit Profile',
      AppLanguage.nepali: 'प्रोफाइल सम्पादन गर्नुहोस्',
    },
    'logout': {
      AppLanguage.english: 'Logout',
      AppLanguage.nepali: 'लगआउट',
    },
    'light': {
      AppLanguage.english: 'Light',
      AppLanguage.nepali: 'उज्यालो',
    },
    'dark': {
      AppLanguage.english: 'Dark',
      AppLanguage.nepali: 'अँध्यारो',
    },
    'auto': {
      AppLanguage.english: 'Auto',
      AppLanguage.nepali: 'स्वचालित',
    },
    'fingerprintLogin': {
      AppLanguage.english: 'Fingerprint login',
      AppLanguage.nepali: 'फिंगरप्रिन्ट लगइन',
    },
    'unlockWithFingerprint': {
      AppLanguage.english: 'Unlock the app with your fingerprint',
      AppLanguage.nepali: 'आफ्नो फिंगरप्रिन्टले एप अनलक गर्नुहोस्',
    },
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.nepali: 'भाषा',
    },
    'unknownUser': {
      AppLanguage.english: 'Unknown User',
      AppLanguage.nepali: 'अज्ञात प्रयोगकर्ता',
    },
    'noEmail': {
      AppLanguage.english: 'No Email',
      AppLanguage.nepali: 'कुनै इमेल छैन',
    },
    'noPhone': {
      AppLanguage.english: 'No Phone',
      AppLanguage.nepali: 'कुनै फोन छैन',
    },
    'goodMorning': {
      AppLanguage.english: 'Good morning',
      AppLanguage.nepali: 'शुभ प्रभात',
    },
    'searchSchoolKeyword': {
      AppLanguage.english: 'Search school, keyword',
      AppLanguage.nepali: 'विद्यालय, किवर्ड खोज्नुहोस्',
    },
    'kathmanduNepal': {
      AppLanguage.english: 'Kathmandu, Nepal',
      AppLanguage.nepali: 'काठमाडौं, नेपाल',
    },
    'international': {
      AppLanguage.english: 'International',
      AppLanguage.nepali: 'अन्तर्राष्ट्रिय',
    },
    'public': {
      AppLanguage.english: 'Public',
      AppLanguage.nepali: 'सार्वजनिक',
    },
    'private': {
      AppLanguage.english: 'Private',
      AppLanguage.nepali: 'निजी',
    },
    'budgetFriendly': {
      AppLanguage.english: 'Budget friendly',
      AppLanguage.nepali: 'बजेट अनुकूल',
    },
    'aiRecommendationTitle': {
      AppLanguage.english: 'AI school recommendation',
      AppLanguage.nepali: 'एआई विद्यालय सिफारिस',
    },
    'aiRecommendationSubtitle': {
      AppLanguage.english: 'Get suggestions based on your needs',
      AppLanguage.nepali: 'आफ्नो आवश्यकता अनुसार सुझाव पाउनुहोस्',
    },
    'aiChatbotTitle': {
      AppLanguage.english: 'AI school assistant',
      AppLanguage.nepali: 'एआई विद्यालय सहायक',
    },
    'aiChatbotSubtitle': {
      AppLanguage.english: 'Ask anything about schools',
      AppLanguage.nepali: 'विद्यालयको बारेमा जे पनि सोध्नुहोस्',
    },
    'allSchools': {
      AppLanguage.english: 'All schools',
      AppLanguage.nepali: 'सबै विद्यालयहरू',
    },
    'filteredSchools': {
      AppLanguage.english: 'Filtered schools',
      AppLanguage.nepali: 'फिल्टर गरिएका विद्यालयहरू',
    },
    'clearFilter': {
      AppLanguage.english: 'Clear filter',
      AppLanguage.nepali: 'फिल्टर हटाउनुहोस्',
    },
    'seeAll': {
      AppLanguage.english: 'See all',
      AppLanguage.nepali: 'सबै हेर्नुहोस्',
    },
    'somethingWentWrong': {
      AppLanguage.english: 'Something went wrong',
      AppLanguage.nepali: 'केही गलत भयो',
    },
    'retry': {
      AppLanguage.english: 'Retry',
      AppLanguage.nepali: 'पुनः प्रयास गर्नुहोस्',
    },
    'noSchoolsFound': {
      AppLanguage.english: 'No schools found',
      AppLanguage.nepali: 'कुनै विद्यालय फेला परेन',
    },
    'streamsOffered': {
      AppLanguage.english: 'Streams offered',
      AppLanguage.nepali: 'प्रस्तावित विषयहरू',
    },
    'about': {
      AppLanguage.english: 'About',
      AppLanguage.nepali: 'बारेमा',
    },
    'facilities': {
      AppLanguage.english: 'Facilities',
      AppLanguage.nepali: 'सुविधाहरू',
    },
    'contact': {
      AppLanguage.english: 'Contact',
      AppLanguage.nepali: 'सम्पर्क',
    },
    'couldNotUpdateFavourite': {
      AppLanguage.english: 'Could not update favourite',
      AppLanguage.nepali: 'मनपर्ने अद्यावधिक गर्न सकिएन',
    },
    'perYear': {
      AppLanguage.english: '/year',
      AppLanguage.nepali: '/वर्ष',
    },
    'science': {
      AppLanguage.english: 'Science',
      AppLanguage.nepali: 'विज्ञान',
    },
    'management': {
      AppLanguage.english: 'Management',
      AppLanguage.nepali: 'व्यवस्थापन',
    },
    'humanities': {
      AppLanguage.english: 'Humanities',
      AppLanguage.nepali: 'मानविकी',
    },
    'compareSchools': {
      AppLanguage.english: 'Compare schools',
      AppLanguage.nepali: 'विद्यालयहरू तुलना गर्नुहोस्',
    },
    'pickTwoSchools': {
      AppLanguage.english: 'Pick two schools to compare side by side',
      AppLanguage.nepali: 'छेउछाउ तुलना गर्न दुई विद्यालय छान्नुहोस्',
    },
    'selectASchool': {
      AppLanguage.english: 'Select a school',
      AppLanguage.nepali: 'एउटा विद्यालय छान्नुहोस्',
    },
    'noSchoolsAvailable': {
      AppLanguage.english: 'No schools available',
      AppLanguage.nepali: 'कुनै विद्यालय उपलब्ध छैन',
    },
    'addFirstSchool': {
      AppLanguage.english: 'Add first school',
      AppLanguage.nepali: 'पहिलो विद्यालय थप्नुहोस्',
    },
    'addSecondSchool': {
      AppLanguage.english: 'Add second school',
      AppLanguage.nepali: 'दोस्रो विद्यालय थप्नुहोस्',
    },
    'changeSchools': {
      AppLanguage.english: 'Change schools',
      AppLanguage.nepali: 'विद्यालयहरू परिवर्तन गर्नुहोस्',
    },
    'selectTwoSchoolsPrompt': {
      AppLanguage.english: 'Select two schools above to see a\nside by side comparison',
      AppLanguage.nepali: 'छेउछाउ तुलना हेर्न माथि दुई विद्यालय छान्नुहोस्',
    },
    'location': {
      AppLanguage.english: 'Location',
      AppLanguage.nepali: 'स्थान',
    },
    'category': {
      AppLanguage.english: 'Category',
      AppLanguage.nepali: 'वर्ग',
    },
    'annualFee': {
      AppLanguage.english: 'Annual fee',
      AppLanguage.nepali: 'वार्षिक शुल्क',
    },
    'favourites': {
      AppLanguage.english: 'Favourites',
      AppLanguage.nepali: 'मनपर्ने',
    },
    'schoolsSavedForQuickAccess': {
      AppLanguage.english: "Schools you've saved for quick access",
      AppLanguage.nepali: 'द्रुत पहुँचको लागि तपाईंले बचत गर्नुभएका विद्यालयहरू',
    },
    'noFavouritesYet': {
      AppLanguage.english: 'No favourites yet',
      AppLanguage.nepali: 'अझै कुनै मनपर्ने छैन',
    },
    'tapHeartToSave': {
      AppLanguage.english:
          'Tap the heart icon on any school to save it here for quick access',
      AppLanguage.nepali:
          'द्रुत पहुँचको लागि यहाँ बचत गर्न कुनै पनि विद्यालयको हृदय आइकनमा ट्याप गर्नुहोस्',
    },
    'couldNotRemoveFavourite': {
      AppLanguage.english: 'Could not remove favourite',
      AppLanguage.nepali: 'मनपर्ने हटाउन सकिएन',
    },
    'perYearShort': {
      AppLanguage.english: '/yr',
      AppLanguage.nepali: '/वर्ष',
    },
  };

  static String get(String key, AppLanguage language) {
    return _values[key]?[language] ?? key;
  }
}