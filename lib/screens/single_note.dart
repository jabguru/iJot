import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:ijot/services/firebase_storage.dart';
import 'package:ijot/widgets/note/time_stamp_embed_widget.dart';
import 'package:ijot/widgets/note/universal_ui/universal_ui.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:ijot/constants/category.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/snackbar.dart';

class SingleNote extends StatefulWidget {
  final Note? note;

  const SingleNote({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  SingleNoteState createState() => SingleNoteState();
}

class SingleNoteState extends State<SingleNote> {
  late String _noteCat = widget.note?.category ?? 'Uncategorized';
  late String? _noteTitle = widget.note?.title;
  late String? _noteDetails = widget.note?.details;
  late final String? _noteDetailsJSON = widget.note?.detailsJSON;
  late final bool _isUpdateMode = widget.note != null;

  late quill.QuillController _quillController;
  late Widget quillEditor;
  late Widget toolbar;
  final FocusNode _focusNode = FocusNode();
  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;

  @override
  void initState() {
    super.initState();

    if (_isUpdateMode) {
      dynamic myJSON;
      if (_noteDetailsJSON != null) {
        myJSON = jsonDecode(_noteDetailsJSON!);
      } else {
        myJSON = [
          jsonDecode(jsonEncode({'insert': '$_noteDetails\n'}))
        ];
      }
      _quillController = quill.QuillController(
        document: quill.Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = quill.QuillController.basic();
    }
  }

  @override
  void didChangeDependencies() {
    _initializeEditor();
    super.didChangeDependencies();
  }

  void _saveNote() {
    if (_noteTitle!.isNotEmpty) {
      String json = jsonEncode(_quillController.document.toDelta().toJson());
      _noteDetails = _quillController.plainTextEditingValue.text;

      var id = const Uuid().v4();
      Note newNote = Note(
        id: _isUpdateMode ? widget.note!.id : id,
        title: _noteTitle,
        details: _noteDetails,
        category: _noteCat,
        dateTime: DateTime.now().toString(),
        ownerId: loggedInUserId,
        detailsJSON: json,
      );

      if (_isUpdateMode) {
        HiveService().updateNote(note: newNote);
      } else {
        HiveService().addNote(newNote);
      }

      Navigator.pop(context);
    } else {
      showErrorSnackbar(context,
          title: 'note_add_note'.tr(), message: 'note_add_note_message'.tr());
    }
  }

  final _categories = [
    {'name': 'note_cat_uncategorized'.tr(), 'value': "Uncategorized"},
    {'name': 'note_cat_study'.tr(), 'value': "Study"},
    {'name': 'note_cat_personal'.tr(), 'value': "Personal"},
    {'name': 'note_cat_work'.tr(), 'value': "Work"},
    {'name': 'note_cat_todo'.tr(), 'value': "Todo"},
  ];

  List<PopupMenuEntry> _buildPopUpMenuItems(BuildContext context) {
    return _categories
        .map(
          (cat) => PopupMenuItem(
            value: cat['value'],
            height: 30.0,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10.0,
                  backgroundColor: categoryColor(cat['value']),
                ),
                const SizedBox(width: 6.0),
                Text(
                  cat['name']!,
                  style: TextStyle(
                    color: categoryColor(cat['value']),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get _isDesktop => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

  Future<String> _onImagePaste(Uint8List imageBytes) async {
    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
            '${appDocDir.path}/${path.basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);
    return file.path.toString();
  }

  bool _onTripleClickSelection() {
    final controller = _quillController;

    _selectAllTimer?.cancel();
    _selectAllTimer = null;

    // If you want to select all text after paragraph, uncomment this line
    // if (_selectionType == _SelectionType.line) {
    //   final selection = TextSelection(
    //     baseOffset: 0,
    //     extentOffset: controller.document.length,
    //   );

    //   controller.updateSelection(selection, ChangeSource.REMOTE);

    //   _selectionType = _SelectionType.none;

    //   return true;
    // }

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      _startTripleClickTimer();
      return false;
    }

    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );

      controller.updateSelection(selection, quill.ChangeSource.REMOTE);

      // _selectionType = _SelectionType.line;

      _selectionType = _SelectionType.none;

      _startTripleClickTimer();

      return true;
    }

    return false;
  }

  void _startTripleClickTimer() {
    _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
      _selectionType = _SelectionType.none;
    });
  }

  Future<String?> openFileSystemPickerForDesktop(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      return file.path;
    }
    return null;
  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    if (_checkFileSize(file)) {
      FirebaseStorageService imageFSS = FirebaseStorageService();
      await imageFSS.uploadFile(
        uid: loggedInUserId!,
        file: file,
        imageName: path.basename(file.path),
      );

      if (imageFSS.url != null) {
        return imageFSS.url!;
      }
    }

    return '';
  }

  Future<String?> _webImagePickImpl(
      OnImagePickCallback onImagePickCallback) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    // Take first, because we don't allow picking multiple files.
    final fileName = result.files.first.name;
    final file = File(fileName);

    return onImagePickCallback(file);
  }

  bool _checkFileSize(File file) {
    double sizeInMB = file.lengthSync() / (1024 * 1024);
    if (sizeInMB > 20) {
      if (context.mounted) {
        showErrorSnackbar(context,
            title: 'error_uploading_file'.tr(),
            message: 'file_exceeds_limit'.tr(namedArgs: {
              'limit': "20 MB",
            }));
      }

      return false;
    }

    return true;
  }

  // // Renders the video picked by imagePicker from local file storage
  // // You can also upload the picked video to any server (eg : AWS s3
  // // or Firebase) and then return the uploaded video URL.
  // Future<String> _onVideoPickCallback(File file) async {
  //   if (_checkFileSize(file)) {
  //     FirebaseStorageService videoFSS = FirebaseStorageService();
  //     await videoFSS.uploadFile(
  //       uid: loggedInUserId!,
  //       file: file,
  //       imageName: path.basename(file.path),
  //     );

  //     if (videoFSS.url != null) {
  //       return videoFSS.url!;
  //     }
  //   }
  //   return '';
  // }

  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.collections),
                label: Text(
                  'gallery'.tr(),
                  style: kInputTextStyle,
                ),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
              ),
              TextButton.icon(
                icon: const Icon(Icons.link),
                label: Text('link'.tr()),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
              )
            ],
          ),
        ),
      );

  Future<MediaPickSetting?> _selectCameraPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera),
                label: Text('capture_a_photo'.tr()),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Camera),
              ),
              TextButton.icon(
                icon: const Icon(Icons.video_call),
                label: Text('capture_a_video'.tr()),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Video),
              )
            ],
          ),
        ),
      );

  _initializeEditor() {
    quillEditor = quill.QuillEditor(
      controller: _quillController,
      scrollController: ScrollController(),
      scrollable: true,
      locale: context.locale,
      focusNode: _focusNode,
      autoFocus: false,
      readOnly: false,
      placeholder: 'note_add_details'.tr(),
      enableSelectionToolbar: _isMobile,
      expands: false,
      padding: EdgeInsets.zero,
      onImagePaste: _onImagePaste,
      onTapUp: (details, p1) {
        return _onTripleClickSelection();
      },
      customStyles: quill.DefaultStyles(
        h1: quill.DefaultTextBlockStyle(
            const TextStyle(
              fontSize: 32,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
            const quill.VerticalSpacing(16, 0),
            const quill.VerticalSpacing(0, 0),
            null),
        sizeSmall: const TextStyle(fontSize: 9),
      ),
      embedBuilders: [
        ...FlutterQuillEmbeds.builders(),
        TimeStampEmbedBuilderWidget()
      ],
    );
    if (kIsWeb) {
      quillEditor = quill.QuillEditor(
          controller: _quillController,
          locale: context.locale,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: _focusNode,
          autoFocus: false,
          readOnly: false,
          placeholder: 'note_add_details'.tr(),
          expands: false,
          padding: EdgeInsets.zero,
          onTapUp: (details, p1) {
            return _onTripleClickSelection();
          },
          customStyles: quill.DefaultStyles(
            h1: quill.DefaultTextBlockStyle(
                const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                const quill.VerticalSpacing(16, 0),
                const quill.VerticalSpacing(0, 0),
                null),
            sizeSmall: const TextStyle(fontSize: 9),
          ),
          embedBuilders: [
            ...defaultEmbedBuildersWeb,
            TimeStampEmbedBuilderWidget()
          ]);
    }
    toolbar = quill.QuillToolbar.basic(
      controller: _quillController,
      multiRowsDisplay: false,
      showFontFamily: false,
      embedButtons: FlutterQuillEmbeds.buttons(
        // provide a callback to enable picking images from device.
        // if omit, "image" button only allows adding images from url.
        // same goes for videos.
        showVideoButton: false,
        showFormulaButton: true,
        onImagePickCallback: _onImagePickCallback,
        // onVideoPickCallback: _onVideoPickCallback,
        // uncomment to provide a custom "pick from" dialog.
        mediaPickSettingSelector: _selectMediaPickSetting,
        // uncomment to provide a custom "pick from" dialog.
        cameraPickSettingSelector: _selectCameraPickSetting,
      ),
      showAlignmentButtons: true,
      afterButtonPressed: _focusNode.requestFocus,
    );
    if (kIsWeb) {
      toolbar = quill.QuillToolbar.basic(
        controller: _quillController,
        showFontFamily: false,
        embedButtons: FlutterQuillEmbeds.buttons(
          // ? COMMENTED THIS OUT FOR WEB BECAUSE WEB DOESN'T SUPPORT ADDING LOCAL FILES, ISSUE WITH DART IO AND PATH PROVIDER ON WEB, CHECK FOR WHEN QUILL IS NOW SUPPORTED ON WEB
          // onImagePickCallback: _onImagePickCallback,
          showVideoButton: false,
          showCameraButton: false,
          webImagePickImpl: _webImagePickImpl,
        ),
        showAlignmentButtons: true,
        afterButtonPressed: _focusNode.requestFocus,
      );
    }
    if (_isDesktop) {
      toolbar = quill.QuillToolbar.basic(
        controller: _quillController,
        showFontFamily: false,
        embedButtons: FlutterQuillEmbeds.buttons(
          onImagePickCallback: _onImagePickCallback,
          filePickImpl: openFileSystemPickerForDesktop,
          showVideoButton: false,
          showCameraButton: false,
        ),
        showAlignmentButtons: true,
        afterButtonPressed: _focusNode.requestFocus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool screenGreaterThan700 = MediaQuery.of(context).size.width > 700;

    return CustomScaffold(
      title: _isUpdateMode ? 'note_edit'.tr() : 'note_new'.tr(),
      hasTopBars: true,
      hasBottomBars: true,
      editMode: true,
      onTap: _saveNote,
      child: Container(
        margin: screenGreaterThan700
            ? null
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kCircularBorderRadius),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(2, 2),
              color: Color(0x40000000),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _noteTitle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'note_add_title'.tr(),
                      hintStyle: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      _noteTitle = value;
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 4.0),
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: categoryColor(_noteCat).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: PopupMenuButton(
                    itemBuilder: _buildPopUpMenuItems,
                    onSelected: (dynamic value) {
                      setState(() {
                        _noteCat = value;
                      });
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: categoryColor(_noteCat),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          getCategoryString(_noteCat),
                          style: TextStyle(
                            color: categoryColor(_noteCat),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  toolbar,
                  const SizedBox(
                    height: 16.0,
                  ),
                  Expanded(
                    child: quillEditor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SelectionType {
  none,
  word,
  // line,
}
