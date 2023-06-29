import 'package:flutter/material.dart';

// class CustomTextSelectionControls extends TextSelectionControls {
//   @override
//   Widget buildToolbar(
//       BuildContext context,
//       Rect globalEditableRegion,
//       double textLineHeight,
//       Offset selectionMidpoint,
//       List<TextSelectionPoint> tsp,
//       TextSelectionDelegate delegate,
//       ClipboardStatusNotifier? clipboardStatus,
//       Offset? ofst) {
//     final TextSelection selection = delegate.textEditingValue.selection;

//     return TextSelectionToolbar(
//       anchorAbove: const Offset(10.0, 10.0),
//       anchorBelow: const Offset(10.0, 10.0),
//       children: [
//         if (canCut(delegate))
//           TextSelectionToolbarTextButton(
//             onPressed: () => handleCut(delegate),
//             padding: EdgeInsets.zero,
//             child: const Text('Cut'),
//           ),
//         if (canCopy(delegate))
//           TextSelectionToolbarTextButton(
//             onPressed: () => handleCopy(delegate, clipboardStatus),
//             padding: EdgeInsets.zero,
//             child: const Text('Copy'),
//           ),
//         if (canPaste(delegate))
//           TextSelectionToolbarTextButton(
//             onPressed: () => handlePaste(delegate),
//             padding: EdgeInsets.zero,
//             child: const Text('Paste'),
//           ),
//         TextSelectionToolbarTextButton(

//         ),
//         TextSelectionToolbarTextButton(
//           onPressed: () => handleFormat(delegate, selection, TextFormat.italic),
//           padding: EdgeInsets.zero,
//           child: const Text('Italic'),
//         ),
//         TextSelectionToolbarTextButton(
//           onPressed: () =>
//               handleFormat(delegate, selection, TextFormat.underline),
//           padding: EdgeInsets.zero,
//           child: const Text('Underline'),
//         ),
//         TextSelectionToolbarTextButton(
//           onPressed: () =>
//               handleFormat(delegate, selection, TextFormat.strikethrough),
//           padding: EdgeInsets.zero,
//           child: const Text('Strikethrough'),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget buildHandle(
//       BuildContext context, TextSelectionHandleType type, double textLineHeight,
//       [VoidCallback? onTap]) {
//     return Container(); // Return an empty container to hide the handles
//   }

//   @override
//   Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
//     // Return an offset with zero values to hide the handles
//     return Offset.zero;
//   }

//   @override
//   Size getHandleSize(double textLineHeight) {
//     // Return a size with zero width and height to hide the handles
//     return Size.zero;
//   }
// }

enum TextFormat {
  bold,
  italic,
  underline,
  strikethrough,
}

AdaptiveTextSelectionToolbar contextMenuBuilder(
    BuildContext context, EditableTextState editableTextState) {
  final TextEditingValue value = editableTextState.textEditingValue;
  final List<ContextMenuButtonItem> buttonItems =
      editableTextState.contextMenuButtonItems;

  buttonItems.insert(
      0,
      ContextMenuButtonItem(
        label: 'Bold',
        onPressed: () {
          ContextMenuController.removeAny();
          handleFormat(editableTextState, value.selection, TextFormat.bold);
        },
      ));

  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: buttonItems,
  );
}

void handleFormat(TextSelectionDelegate delegate, TextSelection selection,
    TextFormat format) {
  final TextEditingValue value = delegate.textEditingValue;
  final String text = value.text;
  final TextSelection base = value.selection;

  TextSelection newSelection;
  String formattedText;

  if (base.isCollapsed) {
    formattedText = _applyFormatToString(text, format);
    newSelection = base.copyWith(
      extentOffset: base.extentOffset + formattedText.length,
    );
  } else {
    final String selectedText = text.substring(base.start, base.end);
    final formattedSelectedText = _applyFormatToString(selectedText, format);

    formattedText =
        text.replaceRange(base.start, base.end, formattedSelectedText);

    final int deltaLength = formattedSelectedText.length - selectedText.length;
    newSelection = base.copyWith(
      extentOffset: base.extentOffset + deltaLength,
    );
  }

  final newTextEditingValue = TextEditingValue(
    text: formattedText,
    selection: newSelection,
    composing: TextRange.empty,
  );

  delegate.userUpdateTextEditingValue(
      newTextEditingValue, SelectionChangedCause.toolbar);
}

String _applyFormatToString(String text, TextFormat format) {
  final String startTag = _getStartTag(format);
  final String endTag = _getEndTag(format);

  // final String selectedText = text.substring(selection.start, selection.end);
  final String formattedText = '$startTag$text$endTag';

  return formattedText;
}

String _getStartTag(TextFormat format) {
  switch (format) {
    case TextFormat.bold:
      return '**';
    case TextFormat.italic:
      return '_';
    case TextFormat.underline:
      return '++';
    case TextFormat.strikethrough:
      return '~';
    default:
      return '';
  }
}

String _getEndTag(TextFormat format) {
  switch (format) {
    case TextFormat.bold:
      return '**';
    case TextFormat.italic:
      return '_';
    case TextFormat.underline:
      return '++';
    case TextFormat.strikethrough:
      return '~';
    default:
      return '';
  }
}
