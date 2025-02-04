import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lihkg_flutter/util/content_renderer.dart';
import 'package:url_launcher/url_launcher.dart';

class ThreadHtmlContent extends StatelessWidget {
  static final Map<CustomRenderMatcher, CustomRender> customRenders = {
    lihkgEmojiUriMatcher(): lihkgEmojiImageRender,
    networkSourceMatcher(): lihkgImageRender,
  };

  final String html;
  final Style? defaultTextStyle;
  const ThreadHtmlContent(this.html, {this.defaultTextStyle, Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final wildcardTextStyle = defaultTextStyle;
    return Html(
      data: html,
      onImageError: (e, _) {
        print('Fail to load image $e');
      },
      style: (wildcardTextStyle != null) ? {
        "*": wildcardTextStyle
      } : {},
      customRenders: customRenders,
      onLinkTap: (url, context, attributes, element) async {
        if (url == null) {
          return;
        }
        final uri = Uri.parse(url);
        if (!await launchUrl(uri)) throw 'Could not launch $uri';
      },
    );
  }
}

