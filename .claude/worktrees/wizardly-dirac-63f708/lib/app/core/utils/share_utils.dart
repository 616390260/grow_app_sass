import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../i18n/i18n_keys.dart';
import 'message_utils.dart';

/// 分享工具类
class ShareUtils {
  /// 分享到Telegram
  static Future<void> shareToTelegram(String inviteUrl) async {
    try {
      if (inviteUrl.isEmpty) {
        MessageUtils.showError('邀请链接为空，请稍后再试');
        return;
      }
      
      final String message = '${I18nKeys.inviteValidUsers.tr}\n${I18nKeys.referralLink.tr}: $inviteUrl';
      final Uri telegramUrl = Uri.parse('https://t.me/share/url?url=${Uri.encodeComponent(message)}');
      
      if (await canLaunchUrl(telegramUrl)) {
        await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);
      } else {
        // 如果无法打开Telegram，使用通用分享
        await Share.share(
          message,
          subject: I18nKeys.inviteFriendTitle.tr,
        );
      }
    } catch (e) {
      MessageUtils.showError('分享失败: $e');
    }
  }

  /// 分享到WhatsApp
  static Future<void> shareToWhatsApp(String inviteUrl) async {
    try {
      if (inviteUrl.isEmpty) {
        MessageUtils.showError('邀请链接为空，请稍后再试');
        return;
      }
      
      final String message = '${I18nKeys.inviteValidUsers.tr}\n${I18nKeys.referralLink.tr}: $inviteUrl';
      final Uri whatsappUrl = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');
      
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        // 如果无法打开WhatsApp，使用通用分享
        await Share.share(
          message,
          subject: I18nKeys.inviteFriendTitle.tr,
        );
      }
    } catch (e) {
      MessageUtils.showError('分享失败: $e');
    }
  }

  /// 分享到Facebook
  static Future<void> shareToFacebook(String inviteUrl) async {
    try {
      if (inviteUrl.isEmpty) {
        MessageUtils.showError('邀请链接为空，请稍后再试');
        return;
      }
      
      final String message = '${I18nKeys.inviteValidUsers.tr}\n${I18nKeys.referralLink.tr}: $inviteUrl';
      final Uri facebookUrl = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(inviteUrl)}');
      
      if (await canLaunchUrl(facebookUrl)) {
        await launchUrl(facebookUrl, mode: LaunchMode.externalApplication);
      } else {
        // 如果无法打开Facebook，使用通用分享
        await Share.share(
          message,
          subject: I18nKeys.inviteFriendTitle.tr,
        );
      }
    } catch (e) {
      MessageUtils.showError('分享失败: $e');
    }
  }

  /// 通用分享
  static Future<void> shareGeneral(String inviteUrl) async {
    try {
      if (inviteUrl.isEmpty) {
        MessageUtils.showError('邀请链接为空，请稍后再试');
        return;
      }
      
      final String message = '${I18nKeys.inviteValidUsers.tr}\n${I18nKeys.referralLink.tr}: $inviteUrl';
      await Share.share(
        message,
        subject: I18nKeys.inviteFriendTitle.tr,
      );
    } catch (e) {
      MessageUtils.showError('分享失败: $e');
    }
  }
}