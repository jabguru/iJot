import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/widgets/snackbar.dart';

class WhatsappCopyButton extends StatelessWidget {
  final quill.QuillController quillController;

  const WhatsappCopyButton({super.key, required this.quillController});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 81.0,
      height: 32.0,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: theme.canvasColor,
        ),
        onPressed: () {
          final String formattedText = formatText(quillController);

          Clipboard.setData(ClipboardData(text: formattedText)).then(
            (result) {
              showSuccessSnackbar(
                context,
                message: 'copy_for_whatsapp_success'.tr(),
              );
            },
            onError: (error) {
              showErrorSnackbar(
                context,
                message: 'copy_for_whatsapp_failed'.tr(),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6.0,
            vertical: 6.0,
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/whatsapp-icon.png',
                height: 18.0,
                width: 18.0,
                color: theme.iconTheme.color,
              ),
              kQuarterHSpace,
              Text(
                'copy_for_whatsapp'.tr(),
                style: TextStyle(
                  fontSize: 14.0,
                  color: theme.iconTheme.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatText(quill.QuillController controller) {
    final quill.Delta delta = controller.document.toDelta();
    final List<quill.Operation> ops = delta.toList();

    final StringBuffer formattedText = StringBuffer();

    for (final op in ops) {
      if (op.data is String) {
        String text = op.data as String;
        final Map<String, dynamic>? format = op.attributes;

        if (format?.containsKey('bold') ?? false) {
          text = '*$text*';
        }

        if (format?.containsKey('italic') ?? false) {
          text = '_${text}_';
        }

        if (format?.containsKey('strike') ?? false) {
          text = '~$text~';
        }

        formattedText.write(text);
      }
    }

    return formattedText.toString().trim();
  }
}
