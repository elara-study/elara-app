import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Elara'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Learn. Grow. Succeed.'**
  String get appTagline;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get commonError;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get commonSkip;

  /// No description provided for @commonGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get commonGetStarted;

  /// No description provided for @commonJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get commonJoin;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get commonSend;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonSomethingWentWrong;

  /// No description provided for @commonNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get commonNoData;

  /// No description provided for @commonCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get commonCompleted;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Join the Future\nof Education'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Highlight.
  ///
  /// In en, this message translates to:
  /// **'Future'**
  String get onboardingSlide1Highlight;

  /// No description provided for @onboardingSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with a global network of scholars and industry experts. Unlock personalized learning journeys powered by Elara\'s intelligence'**
  String get onboardingSlide1Subtitle;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Master Your\nPotential'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Highlight.
  ///
  /// In en, this message translates to:
  /// **'Potential'**
  String get onboardingSlide2Highlight;

  /// No description provided for @onboardingSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Embark on a learning journey tailored to your unique cognitive fingerprint, personal strengths, evolving interests, and future career goals.'**
  String get onboardingSlide2Subtitle;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered\nInsights'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Highlight.
  ///
  /// In en, this message translates to:
  /// **''**
  String get onboardingSlide3Highlight;

  /// No description provided for @onboardingSlide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Elara adapts to your unique learning style, identifying knowledge gaps and providing real-time feedback exactly when you need it most.'**
  String get onboardingSlide3Subtitle;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeBack;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to sign in'**
  String get authSignInSubtitle;

  /// No description provided for @authEmailOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Email or Username'**
  String get authEmailOrUsername;

  /// No description provided for @authEmailOrUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or username'**
  String get authEmailOrUsernameHint;

  /// No description provided for @authEmailOrUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Email or username is required'**
  String get authEmailOrUsernameRequired;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get authPasswordRequired;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginButton;

  /// No description provided for @authOrLoginWith.
  ///
  /// In en, this message translates to:
  /// **'OR LOGIN WITH'**
  String get authOrLoginWith;

  /// No description provided for @authDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authDontHaveAccount;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUp;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailHint;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get authEmailInvalid;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get authFullNameHint;

  /// No description provided for @authFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get authFullNameRequired;

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPassword;

  /// No description provided for @authNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get authNewPasswordHint;

  /// No description provided for @authNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get authNewPasswordRequired;

  /// No description provided for @authNewPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get authNewPasswordTooShort;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get authConfirmPasswordHint;

  /// No description provided for @authConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authConfirmPasswordRequired;

  /// No description provided for @authPasswordsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsMustMatch;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsername;

  /// No description provided for @authUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a unique username'**
  String get authUsernameHint;

  /// No description provided for @authUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get authUsernameRequired;

  /// No description provided for @authBirthday.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get authBirthday;

  /// No description provided for @authBirthdayRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get authBirthdayRequired;

  /// No description provided for @authSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get authSubject;

  /// No description provided for @authSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Select your subject'**
  String get authSubjectHint;

  /// No description provided for @authGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get authGrade;

  /// No description provided for @authGradeHint.
  ///
  /// In en, this message translates to:
  /// **'Select your grade'**
  String get authGradeHint;

  /// No description provided for @authGradeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your grade'**
  String get authGradeRequired;

  /// No description provided for @authCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get authCompleteProfile;

  /// No description provided for @authCompleteProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Just a few more details'**
  String get authCompleteProfileSubtitle;

  /// No description provided for @authEnterCredentials.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials'**
  String get authEnterCredentials;

  /// No description provided for @authEnterCredentialsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your details to continue'**
  String get authEnterCredentialsSubtitle;

  /// No description provided for @authCompleteRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get authCompleteRegistration;

  /// No description provided for @authPasswordHintSecure.
  ///
  /// In en, this message translates to:
  /// **'Enter a secure password'**
  String get authPasswordHintSecure;

  /// No description provided for @authPasswordConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password again'**
  String get authPasswordConfirmHint;

  /// No description provided for @authNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get authNameTooShort;

  /// No description provided for @authChooseRole.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Role'**
  String get authChooseRole;

  /// No description provided for @authChooseRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the role that best describes you'**
  String get authChooseRoleSubtitle;

  /// No description provided for @authRoleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get authRoleStudent;

  /// No description provided for @authRoleStudentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join as a student'**
  String get authRoleStudentSubtitle;

  /// No description provided for @authRoleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get authRoleTeacher;

  /// No description provided for @authRoleTeacherSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join as a teacher'**
  String get authRoleTeacherSubtitle;

  /// No description provided for @authRoleParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get authRoleParent;

  /// No description provided for @authRoleParentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join as a parent'**
  String get authRoleParentSubtitle;

  /// No description provided for @authOrSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'OR SIGN UP WITH'**
  String get authOrSignUpWith;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authRememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get authRememberPassword;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authResetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below'**
  String get authResetPasswordSubtitle;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. Please sign in.'**
  String get authPasswordResetSuccess;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to'**
  String get authOtpSubtitle;

  /// No description provided for @authOtpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authOtpResend;

  /// No description provided for @authOtpDidntReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get authOtpDidntReceive;

  /// No description provided for @authOtpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String authOtpResendIn(Object seconds);

  /// No description provided for @authOtpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authOtpVerify;

  /// No description provided for @authOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code'**
  String get authOtpInvalid;

  /// No description provided for @authSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get authSignInWithGoogle;

  /// No description provided for @authSignInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get authSignInWithFacebook;

  /// No description provided for @authLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get authLogOut;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get navRewards;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get navGroups;

  /// No description provided for @navRoadmaps.
  ///
  /// In en, this message translates to:
  /// **'Roadmaps'**
  String get navRoadmaps;

  /// No description provided for @navChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get navChildren;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeReadyToContinue.
  ///
  /// In en, this message translates to:
  /// **'Ready to continue your learning journey?'**
  String get homeReadyToContinue;

  /// No description provided for @homeDailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get homeDailyGoals;

  /// No description provided for @homeMyGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get homeMyGroups;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get homeSeeAll;

  /// No description provided for @homeComplete.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} completed'**
  String homeComplete(int done, int total);

  /// No description provided for @homeGroupProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String homeGroupProgress(int percent);

  /// No description provided for @learnMyGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get learnMyGroups;

  /// No description provided for @learnYourEnrolledClasses.
  ///
  /// In en, this message translates to:
  /// **'Your enrolled classes'**
  String get learnYourEnrolledClasses;

  /// No description provided for @learnNoGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get learnNoGroupsYet;

  /// No description provided for @learnNoGroupsHint.
  ///
  /// In en, this message translates to:
  /// **'Ask your teacher for a group code\nand tap Join to get started.'**
  String get learnNoGroupsHint;

  /// No description provided for @learnJoinGroup.
  ///
  /// In en, this message translates to:
  /// **'Join Group'**
  String get learnJoinGroup;

  /// No description provided for @learnEnterGroupCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Group Code'**
  String get learnEnterGroupCode;

  /// No description provided for @learnGroupCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. AB1234'**
  String get learnGroupCodeHint;

  /// No description provided for @learnGroupCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Group code is required'**
  String get learnGroupCodeRequired;

  /// No description provided for @learnJoinButton.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get learnJoinButton;

  /// No description provided for @learnJoining.
  ///
  /// In en, this message translates to:
  /// **'Joining...'**
  String get learnJoining;

  /// No description provided for @learnJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully joined the group!'**
  String get learnJoinSuccess;

  /// No description provided for @learnGroupCodeMinLength.
  ///
  /// In en, this message translates to:
  /// **'Code must be at least 4 characters'**
  String get learnGroupCodeMinLength;

  /// No description provided for @learnEnterGroupCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the group code provided by your teacher'**
  String get learnEnterGroupCodeSubtitle;

  /// No description provided for @learnGroupCodeHintFull.
  ///
  /// In en, this message translates to:
  /// **'Enter group code (e.g., ABCD1234)'**
  String get learnGroupCodeHintFull;

  /// No description provided for @rewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsTitle;

  /// No description provided for @rewardsBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get rewardsBadges;

  /// No description provided for @rewardsXP.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get rewardsXP;

  /// No description provided for @rewardsStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get rewardsStreak;

  /// No description provided for @rewardsDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String rewardsDays(int count);

  /// No description provided for @rewardsLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String rewardsLevel(int level);

  /// No description provided for @rewardsNoBadgesYet.
  ///
  /// In en, this message translates to:
  /// **'No badges yet'**
  String get rewardsNoBadgesYet;

  /// No description provided for @rewardsKeepLearning.
  ///
  /// In en, this message translates to:
  /// **'Keep learning to earn badges!'**
  String get rewardsKeepLearning;

  /// No description provided for @rewardsCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get rewardsCongratulations;

  /// No description provided for @rewardsBadgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'You unlocked a new badge!'**
  String get rewardsBadgeUnlocked;

  /// No description provided for @rewardsNewBadgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'NEW BADGE UNLOCKED!'**
  String get rewardsNewBadgeUnlocked;

  /// No description provided for @rewardsAwesome.
  ///
  /// In en, this message translates to:
  /// **'AWESOME!'**
  String get rewardsAwesome;

  /// No description provided for @rewardsContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get rewardsContinue;

  /// No description provided for @rewardsCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get rewardsCurrentStreak;

  /// No description provided for @rewardsTotalXP.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get rewardsTotalXP;

  /// No description provided for @rewardsAllBadges.
  ///
  /// In en, this message translates to:
  /// **'All Badges'**
  String get rewardsAllBadges;

  /// No description provided for @rewardsDailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get rewardsDailyGoals;

  /// No description provided for @rewardsLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get rewardsLeaderboard;

  /// No description provided for @rewardsAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get rewardsAchievements;

  /// No description provided for @rewardsTrackProgress.
  ///
  /// In en, this message translates to:
  /// **'Track your progress and rewards'**
  String get rewardsTrackProgress;

  /// No description provided for @rewardsLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get rewardsLessons;

  /// No description provided for @homeworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get homeworkTitle;

  /// No description provided for @homeworkProblemList.
  ///
  /// In en, this message translates to:
  /// **'Problem List'**
  String get homeworkProblemList;

  /// No description provided for @homeworkTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get homeworkTryAgain;

  /// No description provided for @homeworkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeworkCompleted;

  /// No description provided for @homeworkTotalXP.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get homeworkTotalXP;

  /// No description provided for @homeworkProblems.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} Problems'**
  String homeworkProblems(int done, int total);

  /// No description provided for @homeworkSubmitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get homeworkSubmitAnswer;

  /// No description provided for @homeworkYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get homeworkYourAnswer;

  /// No description provided for @homeworkAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here...'**
  String get homeworkAnswerHint;

  /// No description provided for @homeworkCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get homeworkCorrect;

  /// No description provided for @homeworkIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get homeworkIncorrect;

  /// No description provided for @homeworkXPEarned.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP'**
  String homeworkXPEarned(int xp);

  /// No description provided for @homeworkViewSolution.
  ///
  /// In en, this message translates to:
  /// **'View Solution'**
  String get homeworkViewSolution;

  /// No description provided for @homeworkSolution.
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get homeworkSolution;

  /// No description provided for @chatbotMicPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required for voice mode.'**
  String get chatbotMicPermissionRequired;

  /// No description provided for @chatbotDeleteChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete chat?'**
  String get chatbotDeleteChatTitle;

  /// No description provided for @chatbotDeleteChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'This removes the conversation from your history.'**
  String get chatbotDeleteChatConfirm;

  /// No description provided for @commonUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get commonUploadPhoto;

  /// No description provided for @commonUseCamera.
  ///
  /// In en, this message translates to:
  /// **'Use Camera'**
  String get commonUseCamera;

  /// No description provided for @chatbotAddCaption.
  ///
  /// In en, this message translates to:
  /// **'Add a caption (optional)'**
  String get chatbotAddCaption;

  /// No description provided for @commonSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get commonSending;

  /// No description provided for @chatbotSendImage.
  ///
  /// In en, this message translates to:
  /// **'Send image'**
  String get chatbotSendImage;

  /// No description provided for @chatbotTypeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatbotTypeMessageHint;

  /// No description provided for @chatbotVoiceInputTooltip.
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get chatbotVoiceInputTooltip;

  /// No description provided for @commonErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get commonErrorOccurred;

  /// No description provided for @voiceStatusTapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start'**
  String get voiceStatusTapToStart;

  /// No description provided for @voiceStatusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get voiceStatusConnecting;

  /// No description provided for @voiceStatusListening.
  ///
  /// In en, this message translates to:
  /// **'Listening... Tap orb to send'**
  String get voiceStatusListening;

  /// No description provided for @voiceStatusTranscribing.
  ///
  /// In en, this message translates to:
  /// **'Transcribing...'**
  String get voiceStatusTranscribing;

  /// No description provided for @voiceStatusThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get voiceStatusThinking;

  /// No description provided for @voiceStatusSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Speaking... Tap orb to interrupt'**
  String get voiceStatusSpeaking;

  /// No description provided for @voiceStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get voiceStatusPaused;

  /// No description provided for @voiceStatusTapToRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get voiceStatusTapToRetry;

  /// No description provided for @voiceMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get voiceMute;

  /// No description provided for @voiceUnmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get voiceUnmute;

  /// No description provided for @voiceEndCall.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get voiceEndCall;

  /// No description provided for @resourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resourcesTitle;

  /// No description provided for @resourcesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search resources...'**
  String get resourcesSearchHint;

  /// No description provided for @resourcesOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open resource: {title}'**
  String resourcesOpenError(String title);

  /// No description provided for @groupRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Roadmap'**
  String get groupRoadmap;

  /// No description provided for @groupAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get groupAnnouncements;

  /// No description provided for @commonThisGroup.
  ///
  /// In en, this message translates to:
  /// **'this group'**
  String get commonThisGroup;

  /// No description provided for @groupLessonProgress.
  ///
  /// In en, this message translates to:
  /// **'Lesson {completed} of {total}'**
  String groupLessonProgress(int completed, int total);

  /// No description provided for @groupLessonProgressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Lesson ...'**
  String get groupLessonProgressPlaceholder;

  /// No description provided for @groupLeaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get groupLeaveGroup;

  /// No description provided for @commonMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get commonMoreOptions;

  /// No description provided for @groupLeaveGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Group?'**
  String get groupLeaveGroupTitle;

  /// No description provided for @groupLeaveGroupConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave {courseTitle}? You will lose access to all shared materials and progress.'**
  String groupLeaveGroupConfirm(String courseTitle);

  /// No description provided for @groupYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Group Progress'**
  String get groupYourProgress;

  /// No description provided for @groupNoAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get groupNoAnnouncements;

  /// No description provided for @roadmapInteractionOptions.
  ///
  /// In en, this message translates to:
  /// **'Interaction Options'**
  String get roadmapInteractionOptions;

  /// No description provided for @roadmapTakeAQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take a Quiz'**
  String get roadmapTakeAQuiz;

  /// No description provided for @roadmapChatWithElara.
  ///
  /// In en, this message translates to:
  /// **'Chat with elara'**
  String get roadmapChatWithElara;

  /// No description provided for @commonModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get commonModule;

  /// No description provided for @roadmapLearningPath.
  ///
  /// In en, this message translates to:
  /// **'Learning Path'**
  String get roadmapLearningPath;

  /// No description provided for @roadmapPercentCompleted.
  ///
  /// In en, this message translates to:
  /// **'{percent}% completed'**
  String roadmapPercentCompleted(int percent);

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// No description provided for @parentWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get parentWelcomeBack;

  /// No description provided for @parentChildrenProgressSub.
  ///
  /// In en, this message translates to:
  /// **'Here’s how your children are doing'**
  String get parentChildrenProgressSub;

  /// No description provided for @parentMyChildren.
  ///
  /// In en, this message translates to:
  /// **'My Children'**
  String get parentMyChildren;

  /// No description provided for @parentRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get parentRecentActivity;

  /// No description provided for @homeworkGradeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grade: '**
  String get homeworkGradeLabel;

  /// No description provided for @homeworkProblemBadge.
  ///
  /// In en, this message translates to:
  /// **'PROBLEM {number}'**
  String homeworkProblemBadge(int number);

  /// No description provided for @homeworkStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get homeworkStatusActive;

  /// No description provided for @homeworkStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get homeworkStatusPending;

  /// No description provided for @homeworkStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get homeworkStatusSubmitted;

  /// No description provided for @homeworkStatusGraded.
  ///
  /// In en, this message translates to:
  /// **'Graded'**
  String get homeworkStatusGraded;

  /// No description provided for @homeworkTypeAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here...'**
  String get homeworkTypeAnswerHint;

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizTitle;

  /// No description provided for @quizSelectDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Select Difficulty'**
  String get quizSelectDifficulty;

  /// No description provided for @quizDifficultySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how challenging you want the quiz to be'**
  String get quizDifficultySubtitle;

  /// No description provided for @quizEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get quizEasy;

  /// No description provided for @quizMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get quizMedium;

  /// No description provided for @quizHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get quizHard;

  /// No description provided for @quizQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Questions'**
  String get quizQuestionCount;

  /// No description provided for @quizStartQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get quizStartQuiz;

  /// No description provided for @quizQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quizQuestion(int current, int total);

  /// No description provided for @quizSubmitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get quizSubmitAnswer;

  /// No description provided for @quizNextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get quizNextQuestion;

  /// No description provided for @quizFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish Quiz'**
  String get quizFinish;

  /// No description provided for @quizGetHint.
  ///
  /// In en, this message translates to:
  /// **'Get Hint'**
  String get quizGetHint;

  /// No description provided for @quizHint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get quizHint;

  /// No description provided for @quizResults.
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quizResults;

  /// No description provided for @quizScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get quizScore;

  /// No description provided for @quizCorrectAnswers.
  ///
  /// In en, this message translates to:
  /// **'{correct}/{total} Correct'**
  String quizCorrectAnswers(int correct, int total);

  /// No description provided for @quizXPEarned.
  ///
  /// In en, this message translates to:
  /// **'XP Earned'**
  String get quizXPEarned;

  /// No description provided for @quizAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get quizAccuracy;

  /// No description provided for @quizTimeTaken.
  ///
  /// In en, this message translates to:
  /// **'Time Taken'**
  String get quizTimeTaken;

  /// No description provided for @quizRetakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get quizRetakeQuiz;

  /// No description provided for @quizBackToGroups.
  ///
  /// In en, this message translates to:
  /// **'Back to Groups'**
  String get quizBackToGroups;

  /// No description provided for @quizLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Quiz?'**
  String get quizLeaveTitle;

  /// No description provided for @quizLeaveMessage.
  ///
  /// In en, this message translates to:
  /// **'Your progress will be lost. Are you sure you want to leave?'**
  String get quizLeaveMessage;

  /// No description provided for @quizLeaveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get quizLeaveConfirm;

  /// No description provided for @quizLeaveCancel.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get quizLeaveCancel;

  /// No description provided for @quizSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get quizSomethingWentWrong;

  /// No description provided for @quizLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load quiz'**
  String get quizLoadError;

  /// No description provided for @quizRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get quizRetry;

  /// No description provided for @quizGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get quizGreatJob;

  /// No description provided for @quizKeepItUp.
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get quizKeepItUp;

  /// No description provided for @quizNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get quizNeedsImprovement;

  /// No description provided for @quizWrittenAnswer.
  ///
  /// In en, this message translates to:
  /// **'Write your answer'**
  String get quizWrittenAnswer;

  /// No description provided for @quizWrittenAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here...'**
  String get quizWrittenAnswerHint;

  /// No description provided for @resourcesNoResources.
  ///
  /// In en, this message translates to:
  /// **'No resources available'**
  String get resourcesNoResources;

  /// No description provided for @resourcesFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get resourcesFiles;

  /// No description provided for @resourcesVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get resourcesVideos;

  /// No description provided for @resourcesLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get resourcesLinks;

  /// No description provided for @resourcesDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get resourcesDownload;

  /// No description provided for @resourcesOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get resourcesOpen;

  /// No description provided for @groupTitle.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupTitle;

  /// No description provided for @groupProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get groupProgress;

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get groupMembers;

  /// No description provided for @groupModules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get groupModules;

  /// No description provided for @groupLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get groupLessons;

  /// No description provided for @groupHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get groupHomework;

  /// No description provided for @groupQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get groupQuiz;

  /// No description provided for @groupResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get groupResources;

  /// No description provided for @groupNoModules.
  ///
  /// In en, this message translates to:
  /// **'No modules yet'**
  String get groupNoModules;

  /// No description provided for @groupNoLessons.
  ///
  /// In en, this message translates to:
  /// **'No lessons yet'**
  String get groupNoLessons;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see updates and alerts here'**
  String get notificationsEmptyHint;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationsToday;

  /// No description provided for @chatbotTitle.
  ///
  /// In en, this message translates to:
  /// **'Elara AI'**
  String get chatbotTitle;

  /// No description provided for @chatbotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI Learning Assistant'**
  String get chatbotSubtitle;

  /// No description provided for @chatbotHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get chatbotHistory;

  /// No description provided for @chatbotNewChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get chatbotNewChat;

  /// No description provided for @chatbotTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatbotTypeMessage;

  /// No description provided for @chatbotSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatbotSend;

  /// No description provided for @chatbotNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get chatbotNoHistory;

  /// No description provided for @chatbotStartConversation.
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation'**
  String get chatbotStartConversation;

  /// No description provided for @chatbotClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get chatbotClearHistory;

  /// No description provided for @chatbotErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Try again.'**
  String get chatbotErrorMessage;

  /// No description provided for @chatbotUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get chatbotUploadImage;

  /// No description provided for @chatbotUploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get chatbotUploadFile;

  /// No description provided for @chatbotCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get chatbotCamera;

  /// No description provided for @chatbotGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get chatbotGallery;

  /// No description provided for @chatbotAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get chatbotAttachment;

  /// No description provided for @chatbotSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatbotSessionsTitle;

  /// No description provided for @chatbotDeleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation'**
  String get chatbotDeleteSession;

  /// No description provided for @chatbotDeleteSessionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this conversation?'**
  String get chatbotDeleteSessionConfirm;

  /// No description provided for @chatbotDeleteSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get chatbotDeleteSessionMessage;

  /// No description provided for @voiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice Assistant'**
  String get voiceTitle;

  /// No description provided for @voiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get voiceListening;

  /// No description provided for @voiceSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak'**
  String get voiceSpeak;

  /// No description provided for @voiceProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get voiceProcessing;

  /// No description provided for @teacherHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get teacherHomeTitle;

  /// No description provided for @teacherGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get teacherGroupsTitle;

  /// No description provided for @teacherNoGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get teacherNoGroups;

  /// No description provided for @teacherCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get teacherCreateGroup;

  /// No description provided for @teacherStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get teacherStudents;

  /// No description provided for @teacherAddStudent.
  ///
  /// In en, this message translates to:
  /// **'Add Student'**
  String get teacherAddStudent;

  /// No description provided for @teacherStudentCode.
  ///
  /// In en, this message translates to:
  /// **'Student Code'**
  String get teacherStudentCode;

  /// No description provided for @teacherStudentCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter student code'**
  String get teacherStudentCodeHint;

  /// No description provided for @teacherAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get teacherAttendance;

  /// No description provided for @teacherMarkAttendance.
  ///
  /// In en, this message translates to:
  /// **'Mark Attendance'**
  String get teacherMarkAttendance;

  /// No description provided for @teacherAttendanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get teacherAttendanceHistory;

  /// No description provided for @teacherPresentCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Present'**
  String teacherPresentCount(int count);

  /// No description provided for @teacherAbsentCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Absent'**
  String teacherAbsentCount(int count);

  /// No description provided for @teacherInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get teacherInsights;

  /// No description provided for @teacherAddInsight.
  ///
  /// In en, this message translates to:
  /// **'Add Insight'**
  String get teacherAddInsight;

  /// No description provided for @teacherInsightTitle.
  ///
  /// In en, this message translates to:
  /// **'Insight Title'**
  String get teacherInsightTitle;

  /// No description provided for @teacherInsightContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get teacherInsightContent;

  /// No description provided for @teacherInsightTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get teacherInsightTitleHint;

  /// No description provided for @teacherInsightContentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter insight content...'**
  String get teacherInsightContentHint;

  /// No description provided for @teacherInsightTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get teacherInsightTitleRequired;

  /// No description provided for @teacherInsightContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Content is required'**
  String get teacherInsightContentRequired;

  /// No description provided for @teacherAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get teacherAnnouncements;

  /// No description provided for @teacherAddAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Add Announcement'**
  String get teacherAddAnnouncement;

  /// No description provided for @teacherAnnouncementTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get teacherAnnouncementTitle;

  /// No description provided for @teacherAnnouncementContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get teacherAnnouncementContent;

  /// No description provided for @teacherAnnouncementTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter announcement title'**
  String get teacherAnnouncementTitleHint;

  /// No description provided for @teacherAnnouncementContentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter announcement content...'**
  String get teacherAnnouncementContentHint;

  /// No description provided for @teacherAnnouncementTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get teacherAnnouncementTitleRequired;

  /// No description provided for @teacherAnnouncementContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Content is required'**
  String get teacherAnnouncementContentRequired;

  /// No description provided for @teacherRoadmapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Roadmaps'**
  String get teacherRoadmapsTitle;

  /// No description provided for @teacherHomeworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get teacherHomeworkTitle;

  /// No description provided for @teacherSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Submissions'**
  String get teacherSubmissions;

  /// No description provided for @teacherProblems.
  ///
  /// In en, this message translates to:
  /// **'Problems'**
  String get teacherProblems;

  /// No description provided for @teacherRated.
  ///
  /// In en, this message translates to:
  /// **'Rated'**
  String get teacherRated;

  /// No description provided for @teacherUnrated.
  ///
  /// In en, this message translates to:
  /// **'Unrated'**
  String get teacherUnrated;

  /// No description provided for @teacherRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get teacherRate;

  /// No description provided for @teacherGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get teacherGrade;

  /// No description provided for @teacherFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get teacherFeedback;

  /// No description provided for @teacherFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Enter feedback for this student...'**
  String get teacherFeedbackHint;

  /// No description provided for @teacherSubmitGrade.
  ///
  /// In en, this message translates to:
  /// **'Submit Grade'**
  String get teacherSubmitGrade;

  /// No description provided for @teacherStudentAnswer.
  ///
  /// In en, this message translates to:
  /// **'Student Answer'**
  String get teacherStudentAnswer;

  /// No description provided for @teacherNoSubmissions.
  ///
  /// In en, this message translates to:
  /// **'No submissions yet'**
  String get teacherNoSubmissions;

  /// No description provided for @teacherNoStudents.
  ///
  /// In en, this message translates to:
  /// **'No students yet'**
  String get teacherNoStudents;

  /// No description provided for @teacherStudentProfile.
  ///
  /// In en, this message translates to:
  /// **'Student Profile'**
  String get teacherStudentProfile;

  /// No description provided for @teacherRemoveStudent.
  ///
  /// In en, this message translates to:
  /// **'Remove Student'**
  String get teacherRemoveStudent;

  /// No description provided for @teacherRemoveStudentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this student from the group?'**
  String get teacherRemoveStudentConfirm;

  /// No description provided for @teacherResourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get teacherResourcesTitle;

  /// No description provided for @teacherAddResource.
  ///
  /// In en, this message translates to:
  /// **'Add Resource'**
  String get teacherAddResource;

  /// No description provided for @teacherResourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Resource Title'**
  String get teacherResourceTitle;

  /// No description provided for @teacherResourceLink.
  ///
  /// In en, this message translates to:
  /// **'Resource Link'**
  String get teacherResourceLink;

  /// No description provided for @teacherResourceTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Resource title…'**
  String get teacherResourceTitleHint;

  /// No description provided for @teacherResourceLinkHint.
  ///
  /// In en, this message translates to:
  /// **'https://...'**
  String get teacherResourceLinkHint;

  /// No description provided for @teacherResourceTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get teacherResourceTitleRequired;

  /// No description provided for @teacherResourceLinkRequired.
  ///
  /// In en, this message translates to:
  /// **'Link is required'**
  String get teacherResourceLinkRequired;

  /// No description provided for @teacherResourceLinkInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL'**
  String get teacherResourceLinkInvalid;

  /// No description provided for @teacherNoResources.
  ///
  /// In en, this message translates to:
  /// **'No resources yet'**
  String get teacherNoResources;

  /// No description provided for @teacherAddResourceButton.
  ///
  /// In en, this message translates to:
  /// **'Add Resource'**
  String get teacherAddResourceButton;

  /// No description provided for @teacherDeleteResource.
  ///
  /// In en, this message translates to:
  /// **'Delete Resource'**
  String get teacherDeleteResource;

  /// No description provided for @teacherDeleteResourceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this resource?'**
  String get teacherDeleteResourceConfirm;

  /// No description provided for @teacherGroupCode.
  ///
  /// In en, this message translates to:
  /// **'Group Code'**
  String get teacherGroupCode;

  /// No description provided for @teacherCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get teacherCopyCode;

  /// No description provided for @teacherCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get teacherCodeCopied;

  /// No description provided for @teacherChatWithElara.
  ///
  /// In en, this message translates to:
  /// **'Chat with Elara'**
  String get teacherChatWithElara;

  /// No description provided for @teacherViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get teacherViewAll;

  /// No description provided for @teacherOverallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get teacherOverallProgress;

  /// No description provided for @teacherActiveStudents.
  ///
  /// In en, this message translates to:
  /// **'Active Students'**
  String get teacherActiveStudents;

  /// No description provided for @teacherCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get teacherCompletionRate;

  /// No description provided for @teacherParentsSection.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get teacherParentsSection;

  /// No description provided for @teacherStudentStats.
  ///
  /// In en, this message translates to:
  /// **'Student Stats'**
  String get teacherStudentStats;

  /// No description provided for @teacherTotalLessons.
  ///
  /// In en, this message translates to:
  /// **'Total Lessons'**
  String get teacherTotalLessons;

  /// No description provided for @teacherCompletedLessons.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get teacherCompletedLessons;

  /// No description provided for @teacherQuizzesTaken.
  ///
  /// In en, this message translates to:
  /// **'Quizzes Taken'**
  String get teacherQuizzesTaken;

  /// No description provided for @teacherAverageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get teacherAverageScore;

  /// No description provided for @parentHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get parentHomeTitle;

  /// No description provided for @parentChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get parentChildrenTitle;

  /// No description provided for @parentReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get parentReportsTitle;

  /// No description provided for @parentNoChildren.
  ///
  /// In en, this message translates to:
  /// **'No children linked yet'**
  String get parentNoChildren;

  /// No description provided for @parentAddChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get parentAddChild;

  /// No description provided for @parentChildProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get parentChildProgress;

  /// No description provided for @parentChildHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get parentChildHomework;

  /// No description provided for @parentChildInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get parentChildInsights;

  /// No description provided for @parentChildProfile.
  ///
  /// In en, this message translates to:
  /// **'Child Profile'**
  String get parentChildProfile;

  /// No description provided for @parentChildGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get parentChildGroups;

  /// No description provided for @parentChildPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get parentChildPerformance;

  /// No description provided for @parentInsightCard.
  ///
  /// In en, this message translates to:
  /// **'AI Insight'**
  String get parentInsightCard;

  /// No description provided for @parentNoInsights.
  ///
  /// In en, this message translates to:
  /// **'No insights yet'**
  String get parentNoInsights;

  /// No description provided for @parentNoReports.
  ///
  /// In en, this message translates to:
  /// **'No reports yet'**
  String get parentNoReports;

  /// No description provided for @parentOverallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get parentOverallProgress;

  /// No description provided for @parentWeeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get parentWeeklyActivity;

  /// No description provided for @parentSubjectsBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Subjects Breakdown'**
  String get parentSubjectsBreakdown;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsProfileAndAccount.
  ///
  /// In en, this message translates to:
  /// **'Profile & Account'**
  String get settingsProfileAndAccount;

  /// No description provided for @settingsPasswordAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Password & Security'**
  String get settingsPasswordAndSecurity;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get settingsAboutUs;

  /// No description provided for @settingsContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get settingsContactSupport;

  /// No description provided for @settingsFeedbackAndSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Suggestions'**
  String get settingsFeedbackAndSuggestions;

  /// No description provided for @settingsLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogOut;

  /// No description provided for @settingsLogOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get settingsLogOutConfirm;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationSettingsStreakReminders.
  ///
  /// In en, this message translates to:
  /// **'Streak Reminders'**
  String get notificationSettingsStreakReminders;

  /// No description provided for @notificationSettingsHomeworkReminders.
  ///
  /// In en, this message translates to:
  /// **'Homework Reminders'**
  String get notificationSettingsHomeworkReminders;

  /// No description provided for @notificationSettingsNewLessons.
  ///
  /// In en, this message translates to:
  /// **'New Lessons'**
  String get notificationSettingsNewLessons;

  /// No description provided for @notificationSettingsAiReports.
  ///
  /// In en, this message translates to:
  /// **'AI Progress Reports'**
  String get notificationSettingsAiReports;

  /// No description provided for @notificationSettingsGroupUpdates.
  ///
  /// In en, this message translates to:
  /// **'Group Updates'**
  String get notificationSettingsGroupUpdates;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & Account'**
  String get profileTitle;

  /// No description provided for @profilePersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profilePersonalInformation;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// No description provided for @profileUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileUsername;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profilePhoneNumber;

  /// No description provided for @profileCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profileCountry;

  /// No description provided for @profileGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get profileGrade;

  /// No description provided for @profileSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subject(s)'**
  String get profileSubjects;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSaveChanges;

  /// No description provided for @profileDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get profileDangerZone;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all of your content'**
  String get profileDeleteAccountDescription;

  /// No description provided for @profileChangesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get profileChangesSaved;

  /// No description provided for @profileUpdatedDemo.
  ///
  /// In en, this message translates to:
  /// **'Profile updated (demo).'**
  String get profileUpdatedDemo;

  /// No description provided for @profileDeletionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Account deletion is not available yet.'**
  String get profileDeletionUnavailable;

  /// No description provided for @passwordTitle.
  ///
  /// In en, this message translates to:
  /// **'Password & Security'**
  String get passwordTitle;

  /// No description provided for @passwordSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordSectionLabel;

  /// No description provided for @passwordCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get passwordCurrent;

  /// No description provided for @passwordNew.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get passwordNew;

  /// No description provided for @passwordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get passwordConfirm;

  /// No description provided for @passwordChangeButton.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get passwordChangeButton;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated (demo).'**
  String get passwordUpdated;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordFillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get passwordFillFields;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languagePickerTitle;

  /// No description provided for @languagePickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languagePickerSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @errorPageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get errorPageNotFound;

  /// No description provided for @errorChildProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Child profile data not found'**
  String get errorChildProfileNotFound;

  /// No description provided for @errorHomeworkNotFound.
  ///
  /// In en, this message translates to:
  /// **'Homework data not found'**
  String get errorHomeworkNotFound;

  /// No description provided for @errorInsightsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Insights data not found'**
  String get errorInsightsNotFound;

  /// No description provided for @errorGroupNotFound.
  ///
  /// In en, this message translates to:
  /// **'Group not found'**
  String get errorGroupNotFound;

  /// No description provided for @errorRoadmapNotFound.
  ///
  /// In en, this message translates to:
  /// **'Roadmap not found'**
  String get errorRoadmapNotFound;

  /// No description provided for @errorStudentProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Student profile data not found'**
  String get errorStudentProfileNotFound;

  /// No description provided for @errorAttendanceHistoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Attendance history data not found'**
  String get errorAttendanceHistoryNotFound;

  /// No description provided for @errorModuleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Module data not found'**
  String get errorModuleNotFound;

  /// No description provided for @errorSubmissionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Submission data not found'**
  String get errorSubmissionNotFound;

  /// No description provided for @errorOtpNotProvided.
  ///
  /// In en, this message translates to:
  /// **'OTP arguments not provided'**
  String get errorOtpNotProvided;

  /// No description provided for @errorResetPasswordArgsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Reset password arguments not provided'**
  String get errorResetPasswordArgsNotFound;

  /// No description provided for @studentProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get studentProfileTitle;

  /// No description provided for @studentProfileLinkedParents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get studentProfileLinkedParents;

  /// No description provided for @studentProfileAddParent.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get studentProfileAddParent;

  /// No description provided for @studentSettingsLanguageComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Language picker coming soon.'**
  String get studentSettingsLanguageComingSoon;

  /// No description provided for @teacherSettingsLanguageComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Language picker coming soon.'**
  String get teacherSettingsLanguageComingSoon;

  /// No description provided for @teacherAboutUsSoon.
  ///
  /// In en, this message translates to:
  /// **'About Us coming soon.'**
  String get teacherAboutUsSoon;

  /// No description provided for @teacherContactSupportSoon.
  ///
  /// In en, this message translates to:
  /// **'Contact Support coming soon.'**
  String get teacherContactSupportSoon;

  /// No description provided for @teacherFeedbackSoon.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Suggestions coming soon.'**
  String get teacherFeedbackSoon;

  /// No description provided for @groupCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Code'**
  String get groupCodeTitle;

  /// No description provided for @createGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroupTitle;

  /// No description provided for @createGroupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get createGroupName;

  /// No description provided for @createGroupNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get createGroupNameHint;

  /// No description provided for @createGroupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Group name is required'**
  String get createGroupNameRequired;

  /// No description provided for @createGroupSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get createGroupSubject;

  /// No description provided for @createGroupSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mathematics'**
  String get createGroupSubjectHint;

  /// No description provided for @createGroupSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get createGroupSubjectRequired;

  /// No description provided for @createGroupGradeLevel.
  ///
  /// In en, this message translates to:
  /// **'Grade Level'**
  String get createGroupGradeLevel;

  /// No description provided for @createGroupGradeLevelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Grade 7'**
  String get createGroupGradeLevelHint;

  /// No description provided for @createGroupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroupCreate;

  /// No description provided for @announcementTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcementTitle;

  /// No description provided for @announcementNew.
  ///
  /// In en, this message translates to:
  /// **'New Announcement'**
  String get announcementNew;

  /// No description provided for @announcementNoAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get announcementNoAnnouncements;

  /// No description provided for @announcementPosted.
  ///
  /// In en, this message translates to:
  /// **'Announcement posted'**
  String get announcementPosted;

  /// No description provided for @attendancePresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get attendancePresent;

  /// No description provided for @attendanceAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attendanceAbsent;

  /// No description provided for @attendanceSave.
  ///
  /// In en, this message translates to:
  /// **'Save Attendance'**
  String get attendanceSave;

  /// No description provided for @attendanceSaved.
  ///
  /// In en, this message translates to:
  /// **'Attendance saved'**
  String get attendanceSaved;

  /// No description provided for @attendanceDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get attendanceDate;

  /// No description provided for @attendanceNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No attendance history'**
  String get attendanceNoHistory;

  /// No description provided for @insightAdded.
  ///
  /// In en, this message translates to:
  /// **'Insight added'**
  String get insightAdded;

  /// No description provided for @insightUpdated.
  ///
  /// In en, this message translates to:
  /// **'Insight updated'**
  String get insightUpdated;

  /// No description provided for @insightDeleted.
  ///
  /// In en, this message translates to:
  /// **'Insight deleted'**
  String get insightDeleted;

  /// No description provided for @insightGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating AI insight...'**
  String get insightGenerating;

  /// No description provided for @insightGenerateAI.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get insightGenerateAI;

  /// No description provided for @insightManual.
  ///
  /// In en, this message translates to:
  /// **'Write Manually'**
  String get insightManual;

  /// No description provided for @insightOptions.
  ///
  /// In en, this message translates to:
  /// **'Add Insight'**
  String get insightOptions;

  /// No description provided for @insightEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Insight'**
  String get insightEditTitle;

  /// No description provided for @roadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Roadmap'**
  String get roadmapTitle;

  /// No description provided for @roadmapModules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get roadmapModules;

  /// No description provided for @roadmapProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get roadmapProgress;

  /// No description provided for @roadmapNoModules.
  ///
  /// In en, this message translates to:
  /// **'No modules in this roadmap'**
  String get roadmapNoModules;

  /// No description provided for @roadmapComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get roadmapComplete;

  /// No description provided for @roadmapInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get roadmapInProgress;

  /// No description provided for @roadmapNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get roadmapNotStarted;

  /// No description provided for @addStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Student'**
  String get addStudentTitle;

  /// No description provided for @addStudentCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter student code'**
  String get addStudentCodeHint;

  /// No description provided for @addStudentCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Student code is required'**
  String get addStudentCodeRequired;

  /// No description provided for @addStudentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Student'**
  String get addStudentAdd;

  /// No description provided for @addStudentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Student added successfully'**
  String get addStudentSuccess;

  /// No description provided for @addStudentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add student'**
  String get addStudentFailed;

  /// No description provided for @submissionOverlay.
  ///
  /// In en, this message translates to:
  /// **'Submission'**
  String get submissionOverlay;

  /// No description provided for @submissionStudentAnswer.
  ///
  /// In en, this message translates to:
  /// **'Student Answer'**
  String get submissionStudentAnswer;

  /// No description provided for @submissionYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get submissionYourFeedback;

  /// No description provided for @submissionFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Enter feedback for this student...'**
  String get submissionFeedbackHint;

  /// No description provided for @submissionScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get submissionScore;

  /// No description provided for @submissionScoreHint.
  ///
  /// In en, this message translates to:
  /// **'0–100'**
  String get submissionScoreHint;

  /// No description provided for @submissionSubmitGrade.
  ///
  /// In en, this message translates to:
  /// **'Submit Grade'**
  String get submissionSubmitGrade;

  /// No description provided for @submissionGraded.
  ///
  /// In en, this message translates to:
  /// **'Graded'**
  String get submissionGraded;

  /// No description provided for @submissionPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get submissionPending;

  /// No description provided for @parentSettingsLanguageComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Language picker coming soon.'**
  String get parentSettingsLanguageComingSoon;

  /// No description provided for @parentAboutUsSoon.
  ///
  /// In en, this message translates to:
  /// **'About Us coming soon.'**
  String get parentAboutUsSoon;

  /// No description provided for @parentContactSupportSoon.
  ///
  /// In en, this message translates to:
  /// **'Contact Support coming soon.'**
  String get parentContactSupportSoon;

  /// No description provided for @parentFeedbackSoon.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Suggestions coming soon.'**
  String get parentFeedbackSoon;

  /// No description provided for @imagePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Image Preview'**
  String get imagePreviewTitle;

  /// No description provided for @imagePreviewDownload.
  ///
  /// In en, this message translates to:
  /// **'Save to Gallery'**
  String get imagePreviewDownload;

  /// No description provided for @imagePreviewSaved.
  ///
  /// In en, this message translates to:
  /// **'Image saved'**
  String get imagePreviewSaved;

  /// No description provided for @historyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get historyDeleteTitle;

  /// No description provided for @historyDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this conversation.'**
  String get historyDeleteMessage;

  /// No description provided for @historyDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDeleteConfirm;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get historyEmpty;

  /// No description provided for @historyEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Start a new chat with Elara'**
  String get historyEmptyHint;

  /// No description provided for @attachmentCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get attachmentCamera;

  /// No description provided for @attachmentGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get attachmentGallery;

  /// No description provided for @attachmentFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get attachmentFile;

  /// No description provided for @continueLearningSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearningSectionTitle;

  /// No description provided for @continueLearningModuleLabel.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get continueLearningModuleLabel;

  /// No description provided for @continueLearningLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get continueLearningLessonLabel;

  /// No description provided for @continueLearningProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String continueLearningProgressLabel(int percent);

  /// No description provided for @studentGroupProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get studentGroupProgress;

  /// No description provided for @studentGroupModules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get studentGroupModules;

  /// No description provided for @studentGroupAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get studentGroupAnnouncements;

  /// No description provided for @studentGroupNoAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get studentGroupNoAnnouncements;

  /// No description provided for @teacherReadyToInspire.
  ///
  /// In en, this message translates to:
  /// **'Ready to inspire today'**
  String get teacherReadyToInspire;

  /// No description provided for @teacherMyRoadmaps.
  ///
  /// In en, this message translates to:
  /// **'My Roadmaps'**
  String get teacherMyRoadmaps;

  /// No description provided for @teacherRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get teacherRecentActivity;

  /// No description provided for @teacherAvgAttendance.
  ///
  /// In en, this message translates to:
  /// **'Avg. Attendance'**
  String get teacherAvgAttendance;

  /// No description provided for @teacherPerfectDays.
  ///
  /// In en, this message translates to:
  /// **'Perfect Days'**
  String get teacherPerfectDays;

  /// No description provided for @teacherPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get teacherPresent;

  /// No description provided for @teacherSearchStudents.
  ///
  /// In en, this message translates to:
  /// **'Search students...'**
  String get teacherSearchStudents;

  /// No description provided for @teacherNoStudentsMatch.
  ///
  /// In en, this message translates to:
  /// **'No students match \"{query}\".'**
  String teacherNoStudentsMatch(Object query);

  /// No description provided for @teacherAddStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a Student'**
  String get teacherAddStudentTitle;

  /// No description provided for @teacherGroupJoinCode.
  ///
  /// In en, this message translates to:
  /// **'Group Join Code'**
  String get teacherGroupJoinCode;

  /// No description provided for @teacherEnterStudentUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter student\'s username'**
  String get teacherEnterStudentUsername;

  /// No description provided for @teacherSaveAttendance.
  ///
  /// In en, this message translates to:
  /// **'Save Attendance'**
  String get teacherSaveAttendance;

  /// No description provided for @teacherEditAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Edit Announcement'**
  String get teacherEditAnnouncement;

  /// No description provided for @teacherAddAnnouncementTitle.
  ///
  /// In en, this message translates to:
  /// **'Add an Announcement'**
  String get teacherAddAnnouncementTitle;

  /// No description provided for @teacherAnnouncementTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get teacherAnnouncementTitleField;

  /// No description provided for @teacherAnnouncementBodyField.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get teacherAnnouncementBodyField;

  /// No description provided for @teacherEnterAnnouncementTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter announcement title'**
  String get teacherEnterAnnouncementTitle;

  /// No description provided for @teacherEnterAnnouncementBody.
  ///
  /// In en, this message translates to:
  /// **'Enter announcement body'**
  String get teacherEnterAnnouncementBody;

  /// No description provided for @teacherSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get teacherSaveChanges;

  /// No description provided for @teacherAddModule.
  ///
  /// In en, this message translates to:
  /// **'Add Module'**
  String get teacherAddModule;

  /// No description provided for @teacherModuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get teacherModuleTitle;

  /// No description provided for @teacherEnterModuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter module title…'**
  String get teacherEnterModuleTitle;

  /// No description provided for @teacherModuleDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get teacherModuleDescription;

  /// No description provided for @teacherEnterModuleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter module description…'**
  String get teacherEnterModuleDescription;

  /// No description provided for @teacherEditModule.
  ///
  /// In en, this message translates to:
  /// **'Edit Module'**
  String get teacherEditModule;

  /// No description provided for @teacherLearningPath.
  ///
  /// In en, this message translates to:
  /// **'Learning Path'**
  String get teacherLearningPath;

  /// No description provided for @teacherInsightOptions.
  ///
  /// In en, this message translates to:
  /// **'Insight Options'**
  String get teacherInsightOptions;

  /// No description provided for @teacherElaraDrafting.
  ///
  /// In en, this message translates to:
  /// **'Elara is drafting an insight for {name}'**
  String teacherElaraDrafting(String name);

  /// No description provided for @teacherManually.
  ///
  /// In en, this message translates to:
  /// **'Manually'**
  String get teacherManually;

  /// No description provided for @teacherAddInsightTitle.
  ///
  /// In en, this message translates to:
  /// **'Add an Insight'**
  String get teacherAddInsightTitle;

  /// No description provided for @teacherSaveInsight.
  ///
  /// In en, this message translates to:
  /// **'Save Insight'**
  String get teacherSaveInsight;

  /// No description provided for @teacherInsightSavedDraft.
  ///
  /// In en, this message translates to:
  /// **'Insight saved as draft'**
  String get teacherInsightSavedDraft;

  /// No description provided for @teacherEditInsight.
  ///
  /// In en, this message translates to:
  /// **'Edit Insight'**
  String get teacherEditInsight;

  /// No description provided for @teacherInsightUpdated.
  ///
  /// In en, this message translates to:
  /// **'Insight updated successfully'**
  String get teacherInsightUpdated;

  /// No description provided for @teacherSendInsight.
  ///
  /// In en, this message translates to:
  /// **'Send Insight'**
  String get teacherSendInsight;

  /// No description provided for @teacherInsightSent.
  ///
  /// In en, this message translates to:
  /// **'Insight sent to parents'**
  String get teacherInsightSent;

  /// No description provided for @teacherMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get teacherMoreOptions;

  /// No description provided for @teacherRemoveStudentConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String teacherRemoveStudentConfirmTitle(String name);

  /// No description provided for @teacherRemoveStudentConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from {group}? They will lose access to all shared materials and progress.'**
  String teacherRemoveStudentConfirmBody(String name, String group);

  /// No description provided for @teacherAddProblem.
  ///
  /// In en, this message translates to:
  /// **'Add a Problem'**
  String get teacherAddProblem;

  /// No description provided for @teacherEditProblem.
  ///
  /// In en, this message translates to:
  /// **'Edit Problem'**
  String get teacherEditProblem;

  /// No description provided for @teacherEnterProblemDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter problem description'**
  String get teacherEnterProblemDesc;

  /// No description provided for @teacherProblemBadge.
  ///
  /// In en, this message translates to:
  /// **'PROBLEM {number}'**
  String teacherProblemBadge(int number);

  /// No description provided for @teacherAnswerBadge.
  ///
  /// In en, this message translates to:
  /// **'ANSWER {number}'**
  String teacherAnswerBadge(int number);

  /// No description provided for @teacherSubmitScore.
  ///
  /// In en, this message translates to:
  /// **'Submit Score'**
  String get teacherSubmitScore;

  /// No description provided for @teacherSaveScore.
  ///
  /// In en, this message translates to:
  /// **'Save Score'**
  String get teacherSaveScore;

  /// No description provided for @teacherRatedSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Rated Submissions'**
  String get teacherRatedSubmissions;

  /// No description provided for @teacherStudentScore.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Score'**
  String teacherStudentScore(String name);

  /// No description provided for @teacherFailedLoadSubmission.
  ///
  /// In en, this message translates to:
  /// **'Failed to load submission details.'**
  String get teacherFailedLoadSubmission;

  /// No description provided for @teacherTitleResource.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get teacherTitleResource;

  /// No description provided for @teacherUrlResource.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get teacherUrlResource;

  /// No description provided for @teacherFileResource.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get teacherFileResource;

  /// No description provided for @teacherTapSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to select file...'**
  String get teacherTapSelectFile;

  /// No description provided for @teacherDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get teacherDescriptionOptional;

  /// No description provided for @teacherBriefDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description…'**
  String get teacherBriefDescription;

  /// No description provided for @teacherTitleAndFileRequired.
  ///
  /// In en, this message translates to:
  /// **'Title and {field} are required'**
  String teacherTitleAndFileRequired(String field);

  /// No description provided for @teacherFailedPickFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick file: {error}'**
  String teacherFailedPickFile(String error);

  /// No description provided for @teacherCreateRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Create a roadmap'**
  String get teacherCreateRoadmap;

  /// No description provided for @teacherNoRoadmaps.
  ///
  /// In en, this message translates to:
  /// **'No roadmaps yet'**
  String get teacherNoRoadmaps;

  /// No description provided for @teacherTapCreateFirstRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Tap Create to add your first roadmap.'**
  String get teacherTapCreateFirstRoadmap;

  /// No description provided for @teacherTapCreateFirstClass.
  ///
  /// In en, this message translates to:
  /// **'Tap Create to add your first class.'**
  String get teacherTapCreateFirstClass;

  /// No description provided for @teacherNoProfileData.
  ///
  /// In en, this message translates to:
  /// **'No profile data available.'**
  String get teacherNoProfileData;

  /// No description provided for @teacherTotalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get teacherTotalStudents;

  /// No description provided for @teacherActiveGroups.
  ///
  /// In en, this message translates to:
  /// **'Active Groups'**
  String get teacherActiveGroups;

  /// No description provided for @teacherRoadmapsCreated.
  ///
  /// In en, this message translates to:
  /// **'Roadmaps Created'**
  String get teacherRoadmapsCreated;

  /// No description provided for @teacherYearsTeaching.
  ///
  /// In en, this message translates to:
  /// **'Years Teaching'**
  String get teacherYearsTeaching;

  /// No description provided for @teacherStudentsCount.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get teacherStudentsCount;

  /// No description provided for @teacherAvgCompletion.
  ///
  /// In en, this message translates to:
  /// **'Avg. Completion'**
  String get teacherAvgCompletion;

  /// No description provided for @teacherNoAnnouncementsYet.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet.'**
  String get teacherNoAnnouncementsYet;

  /// No description provided for @teacherXpLabel.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String teacherXpLabel(Object xp);

  /// No description provided for @teacherModuleLabel.
  ///
  /// In en, this message translates to:
  /// **'MODULE {number}'**
  String teacherModuleLabel(int number);

  /// No description provided for @teacherDeleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get teacherDeleteGroup;

  /// No description provided for @teacherDeleteGroupConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group? This action cannot be undone.'**
  String get teacherDeleteGroupConfirm;

  /// No description provided for @teacherDeleteRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Delete Roadmap'**
  String get teacherDeleteRoadmap;

  /// No description provided for @teacherDeleteRoadmapConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this roadmap? This action cannot be undone.'**
  String get teacherDeleteRoadmapConfirm;

  /// No description provided for @teacherStudentsCountProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} students • {percent}% complete'**
  String teacherStudentsCountProgress(int count, int percent);

  /// No description provided for @teacherLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get teacherLessons;

  /// No description provided for @teacherStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get teacherStreak;

  /// No description provided for @teacherParents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get teacherParents;

  /// No description provided for @teacherAttendanceToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Attendance'**
  String get teacherAttendanceToday;

  /// No description provided for @teacherHomeworkLabel.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get teacherHomeworkLabel;

  /// No description provided for @teacherResourcesLabel.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get teacherResourcesLabel;

  /// No description provided for @teacherProblemList.
  ///
  /// In en, this message translates to:
  /// **'Problem List'**
  String get teacherProblemList;

  /// No description provided for @teacherRatedTab.
  ///
  /// In en, this message translates to:
  /// **'Rated'**
  String get teacherRatedTab;

  /// No description provided for @teacherSubmissionDetails.
  ///
  /// In en, this message translates to:
  /// **'Submission Details'**
  String get teacherSubmissionDetails;

  /// No description provided for @teacherUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://...'**
  String get teacherUrlHint;

  /// No description provided for @teacherXpHint.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get teacherXpHint;

  /// No description provided for @teacherGroupsAppBar.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get teacherGroupsAppBar;

  /// No description provided for @teacherEnterReport.
  ///
  /// In en, this message translates to:
  /// **'Enter a report paragraph'**
  String get teacherEnterReport;

  /// No description provided for @teacherInteractionOptions.
  ///
  /// In en, this message translates to:
  /// **'Interaction Options'**
  String get teacherInteractionOptions;

  /// No description provided for @teacherAddResourceDialog.
  ///
  /// In en, this message translates to:
  /// **'Add Resource'**
  String get teacherAddResourceDialog;

  /// No description provided for @teacherSearchResources.
  ///
  /// In en, this message translates to:
  /// **'Search resources...'**
  String get teacherSearchResources;

  /// No description provided for @teacherRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get teacherRemove;

  /// No description provided for @teacherAttendanceHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get teacherAttendanceHistorySubtitle;

  /// No description provided for @teacherLearningPaths.
  ///
  /// In en, this message translates to:
  /// **'Learning Paths'**
  String get teacherLearningPaths;

  /// No description provided for @teacherCouldNotOpenResource.
  ///
  /// In en, this message translates to:
  /// **'Could not open resource: {title}'**
  String teacherCouldNotOpenResource(String title);

  /// No description provided for @teacherFailedAddProblem.
  ///
  /// In en, this message translates to:
  /// **'Failed to add homework problem'**
  String get teacherFailedAddProblem;

  /// No description provided for @teacherFailedUpdateProblem.
  ///
  /// In en, this message translates to:
  /// **'Failed to update homework problem'**
  String get teacherFailedUpdateProblem;

  /// No description provided for @teacherFailedDeleteProblem.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete homework problem'**
  String get teacherFailedDeleteProblem;

  /// No description provided for @teacherFailedLoadHome.
  ///
  /// In en, this message translates to:
  /// **'Failed to load home: {message}'**
  String teacherFailedLoadHome(String message);

  /// No description provided for @teacherFailedCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Failed to create group: {message}'**
  String teacherFailedCreateGroup(String message);

  /// No description provided for @teacherFailedCreateRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Failed to create roadmap: {message}'**
  String teacherFailedCreateRoadmap(String message);

  /// No description provided for @teacherNameFallback.
  ///
  /// In en, this message translates to:
  /// **'Teacher Name'**
  String get teacherNameFallback;

  /// No description provided for @teacherHandleFallback.
  ///
  /// In en, this message translates to:
  /// **'@handle'**
  String get teacherHandleFallback;

  /// No description provided for @parentNameFallback.
  ///
  /// In en, this message translates to:
  /// **'Parent Name'**
  String get parentNameFallback;

  /// No description provided for @parentHandleFallback.
  ///
  /// In en, this message translates to:
  /// **'@handle'**
  String get parentHandleFallback;

  /// No description provided for @gradePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'+20 10 12345678'**
  String get gradePhoneNumber;

  /// No description provided for @gradeFallback.
  ///
  /// In en, this message translates to:
  /// **'7'**
  String get gradeFallback;

  /// No description provided for @countryFallback.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get countryFallback;

  /// No description provided for @mathSubjectFallback.
  ///
  /// In en, this message translates to:
  /// **'Math'**
  String get mathSubjectFallback;

  /// No description provided for @comingSoonDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard coming soon'**
  String get comingSoonDashboard;

  /// No description provided for @studentProfileScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get studentProfileScreenTitle;

  /// No description provided for @parentProfileScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get parentProfileScreenTitle;

  /// No description provided for @teacherProfileScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get teacherProfileScreenTitle;

  /// No description provided for @profileProgressToLevel.
  ///
  /// In en, this message translates to:
  /// **'Progress to Level {level}'**
  String profileProgressToLevel(int level);

  /// No description provided for @profileXpToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to next level'**
  String profileXpToNextLevel(int xp);

  /// No description provided for @profileLinkParentTitle.
  ///
  /// In en, this message translates to:
  /// **'Link a Parent'**
  String get profileLinkParentTitle;

  /// No description provided for @profileLinkParentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your parent\'s username'**
  String get profileLinkParentHint;

  /// No description provided for @profileLinkParentButton.
  ///
  /// In en, this message translates to:
  /// **'Link Parent'**
  String get profileLinkParentButton;

  /// No description provided for @profileParentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get profileParentsTitle;

  /// No description provided for @profileRecentAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Achievements'**
  String get profileRecentAchievementsTitle;

  /// No description provided for @profileSignInToView.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your profile'**
  String get profileSignInToView;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
