import 'package:elara/core/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceOpenService {
  const ResourceOpenService();

  Future<void> openExternal(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      _showError(context, 'Invalid resource URL');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        final fallbackLaunched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );

        if (!fallbackLaunched) {
          if (!context.mounted) {
            return;
          }
          _showError(context, 'Could not open resource');
        }
      }
    } on PlatformException {
      if (!context.mounted) {
        return;
      }
      _showError(
        context,
        'Resource launcher is not ready. Please stop and rerun the app.',
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      _showError(context, 'Could not open resource');
    }
  }

  void _showError(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }

    AppSnackBar.error(context, message);
  }
}
