import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Background message handler
//
// MUST be a top-level function (not a class method) and MUST be annotated with
// @pragma('vm:entry-point') so the Dart AOT compiler does not tree-shake it.
// This function runs in a separate isolate when the app is terminated or
// backgrounded, so it must not reference any singleton state from the main
// isolate (e.g. GetIt instances or BuildContext).
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Re-initialise Firebase in the background isolate.
  // firebase_messaging guarantees this is a no-op if Firebase is already
  // initialised in this isolate.
  await Firebase.initializeApp();

  if (kDebugMode) {
    debugPrint(
      '[NotificationService][BG] message received: ${message.messageId}',
    );
  }

  // Background data-only messages that need a visible notification can be
  // shown here using flutter_local_notifications. For most apps the FCM
  // payload's notification field is enough and the system tray handles display.
}

// ─────────────────────────────────────────────────────────────────────────────
// Android notification channel constants
// ─────────────────────────────────────────────────────────────────────────────

/// The channel id used for all Elara push notifications.
const _kChannelId = 'elara_notifications_channel';

/// Human-readable channel name shown in Android system settings.
const _kChannelName = 'Elara Notifications';

/// Description shown in Android system settings.
const _kChannelDescription =
    'Elara app notifications — lessons, homework, announcements, and more.';

// ─────────────────────────────────────────────────────────────────────────────
// NotificationService
// ─────────────────────────────────────────────────────────────────────────────

/// Singleton service responsible for all Firebase Cloud Messaging (FCM) and
/// local-notification concerns.
///
/// **Responsibilities:**
/// - Firebase initialisation
/// - Notification permission requests (iOS / Android 13+)
/// - FCM token retrieval and refresh listening
/// - Foreground notification display via [FlutterLocalNotificationsPlugin]
/// - Routing notification-tap events to a caller-supplied callback
///
/// **Not responsible for:**
/// - HTTP requests — callers wire token registration via [onTokenRefresh].
/// - Navigation — callers wire navigation via [onNotificationTap].
class NotificationService {
  NotificationService._();

  /// Shared singleton instance.
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // ── Callbacks ──────────────────────────────────────────────────────────────

  /// Called whenever a new or refreshed FCM token is available.
  ///
  /// Use this to POST the token to your backend:
  /// ```dart
  /// NotificationService.instance.onTokenRefresh = (token) async {
  ///   await getIt<RegisterDeviceTokenUseCase>().call(token);
  /// };
  /// ```
  Future<void> Function(String token)? onTokenRefresh;

  /// Called when the user taps a notification and the app opens (or resumes).
  ///
  /// [payload] contains the data map from the FCM message so the UI layer can
  /// decide where to navigate.
  Future<void> Function(Map<String, dynamic> payload)? onNotificationTap;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  /// Initialises Firebase, sets up local notifications, requests permissions,
  /// fetches the FCM token, and wires all message listeners.
  ///
  /// Call this once in `main()` **after** [Firebase.initializeApp()] and after
  /// dependency injection is ready (so that callbacks can be attached before
  /// listeners fire).
  Future<void> initialize() async {
    // 1. Configure local notification plugin first so the channel exists before
    //    any message arrives.
    await setupLocalNotifications();

    // 2. Request permission from the OS.
    await requestPermission();

    // 3. Register background handler. Must be called before any other
    //    FirebaseMessaging method on Android.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 4. Set foreground notification presentation options for iOS.
    //    On Android the channel handles this; on iOS we need to opt-in.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 5. Retrieve the initial token and report it.
    await _reportToken(await getToken());

    // 6. Listen for automatic token refreshes (e.g. after app re-install or
    //    Play Services update) and report them to the caller.
    listenForTokenRefresh();

    // 7. Wire foreground message listener.
    listenForMessages();

    // 8. Handle tap when app was terminated and launched from a notification.
    await _handleInitialMessage();

    // 9. Handle tap when app was backgrounded and resumed from a notification.
    _handleMessageOpenedApp();

    if (kDebugMode) {
      debugPrint('[NotificationService] initialised successfully.');
    }
  }

  // ── Permission ─────────────────────────────────────────────────────────────

  /// Requests notification permission.
  ///
  /// On iOS this shows the native OS prompt.
  /// On Android 13+ (API 33+) this requests POST_NOTIFICATIONS permission.
  /// On older Android versions the permission is granted implicitly.
  ///
  /// Returns the resulting [AuthorizationStatus].
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      debugPrint(
        '[NotificationService] permission status: ${settings.authorizationStatus}',
      );
    }

    return settings.authorizationStatus;
  }

  // ── Token ──────────────────────────────────────────────────────────────────

  /// Returns the current FCM registration token for this device.
  ///
  /// May return `null` if the device has no network access or if notification
  /// permission was denied on iOS.
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      if (kDebugMode) {
        debugPrint('[NotificationService] FCM token: $token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] failed to get FCM token: $e');
      }
      return null;
    }
  }

  /// Subscribes to [FirebaseMessaging.instance.onTokenRefresh] and calls
  /// [onTokenRefresh] whenever the token changes.
  ///
  /// Tokens can change after:
  /// - App re-install
  /// - User clears app data
  /// - Firebase project changes
  /// - Play Services update (Android)
  void listenForTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      if (kDebugMode) {
        debugPrint('[NotificationService] token refreshed: $newToken');
      }
      await _reportToken(newToken);
    });
  }

  // ── Foreground messages ────────────────────────────────────────────────────

  /// Subscribes to FCM messages received **while the app is in the foreground**
  /// and displays them as a local notification via [showLocalNotification].
  ///
  /// On iOS, foreground messages are not displayed by the system by default, so
  /// this listener is mandatory for a consistent cross-platform experience.
  void listenForMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint(
          '[NotificationService][FG] message received: ${message.messageId}',
        );
      }

      // Only show a local notification banner if the message carries a
      // notification payload. Data-only messages are silently processed.
      final notification = message.notification;
      if (notification != null) {
        showLocalNotification(
          id: message.hashCode,
          title: notification.title ?? 'Elara',
          body: notification.body ?? '',
          payload: message.data,
        );
      }
    });
  }

  // ── Local notifications ────────────────────────────────────────────────────

  /// Configures [FlutterLocalNotificationsPlugin] and creates the Android
  /// notification channel.
  ///
  /// This must be called before any call to [showLocalNotification].
  Future<void> setupLocalNotifications() async {
    // Android: Use the app launcher icon as the notification small icon.
    // Replace '@mipmap/ic_launcher' with a dedicated monochrome icon asset
    // (e.g. '@drawable/ic_notification') for best results on API 21+.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS / macOS: request permission inline with initialisation so we don't
    // show a second system prompt (firebase_messaging already requests it).
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      // Called when the user taps a notification while the app is open or
      // resumes from the background via a local notification.
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Create the Android notification channel in Dart.
    // On Android 8.0+ (API 26+) a channel is required for notifications to
    // appear. This is a no-op on older API levels.
    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _kChannelId,
          _kChannelName,
          description: _kChannelDescription,
          importance: Importance.high, // Heads-up display
          playSound: true,
          enableVibration: true,
        ),
      );
    }
  }

  /// Displays a local notification banner immediately.
  ///
  /// [id] — unique integer ID; use the same ID to update/cancel later.
  /// [title] — notification title.
  /// [body] — notification body text.
  /// [payload] — arbitrary data map passed to [onNotificationTap] on tap.
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _kChannelId,
      _kChannelName,
      channelDescription: _kChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      // Shows the notification as a heads-up banner.
      fullScreenIntent: false,
      playSound: true,
      enableVibration: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    // Encode the payload map as a simple key=value string so it survives
    // the flutter_local_notifications string serialisation.
    final payloadStr = _encodePayload(payload);

    await _localNotifications.show(id, title, body, details,
        payload: payloadStr);
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Sends [token] to [onTokenRefresh] if it is non-null.
  Future<void> _reportToken(String? token) async {
    if (token == null) return;
    await onTokenRefresh?.call(token);
  }

  /// Handles the message that launched the app from a **terminated** state.
  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      if (kDebugMode) {
        debugPrint(
          '[NotificationService] app launched from notification: '
          '${message.messageId}',
        );
      }
      await onNotificationTap?.call(message.data);
    }
  }

  /// Handles taps on notifications that resume the app from the **background**.
  void _handleMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        debugPrint(
          '[NotificationService] notification tapped (background→foreground): '
          '${message.messageId}',
        );
      }
      await onNotificationTap?.call(message.data);
    });
  }

  /// Called by [FlutterLocalNotificationsPlugin] when the user taps a local
  /// notification (foreground or resumed from background).
  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = _decodePayload(response.payload);
    if (kDebugMode) {
      debugPrint(
        '[NotificationService] local notification tapped, payload: $payload',
      );
    }
    onNotificationTap?.call(payload);
  }

  // ── Payload encoding ───────────────────────────────────────────────────────
  // flutter_local_notifications only accepts a String payload, so we do a
  // trivial key=value serialisation. We intentionally avoid dart:convert/json
  // to keep this dependency-free; the values are always strings from FCM.

  String _encodePayload(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return '';
    return map.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(
          e.value?.toString() ?? '',
        )}')
        .join('&');
  }

  Map<String, dynamic> _decodePayload(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    final result = <String, dynamic>{};
    for (final part in raw.split('&')) {
      final idx = part.indexOf('=');
      if (idx == -1) continue;
      final key = Uri.decodeComponent(part.substring(0, idx));
      final value = Uri.decodeComponent(part.substring(idx + 1));
      result[key] = value;
    }
    return result;
  }
}
