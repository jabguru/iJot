import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_quill_extensions/services/image_picker/image_options.dart';
import 'package:flutter_quill_extensions/services/image_picker/s_image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:ijot/constants/category.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/services/account.dart';
import 'package:ijot/services/firebase_firestore.dart';
import 'package:ijot/services/firebase_storage.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/services/note.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/note/time_stamp_embed_widget.dart';
import 'package:ijot/widgets/note/universal_ui/universal_ui.dart';
import 'package:ijot/widgets/note/whatsapp_copy.dart';
import 'package:ijot/widgets/snackbar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class SingleNote extends StatefulWidget {
  final Note? note;

  const SingleNote({
    super.key,
    this.note,
  });

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
  late quill.QuillEditor quillEditor;
  late quill.QuillSimpleToolbar toolbar;
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
    if (_noteTitle != null && _noteTitle!.isNotEmpty) {
      String json = jsonEncode(_quillController.document.toDelta().toJson());
      _noteDetails = _quillController.plainTextEditingValue.text;

      var id = const Uuid().v4();
      Note newNote = Note(
        id: _isUpdateMode ? widget.note!.id : id,
        title: _noteTitle,
        details: _noteDetails,
        category: _noteCat,
        dateTime: DateTime.now().toString(),
        ownerId: AccountService.loggedInUserId,
        detailsJSON: json,
      );

      NoteService noteService = NoteService(
        hiveService: HiveService(),
        firebaseFirestoreService: FirebaseFirestoreService(),
        loggedInUserId: AccountService.loggedInUserId,
      );

      if (_isUpdateMode) {
        noteService.updateNote(note: newNote);
      } else {
        noteService.addNote(newNote);
      }

      context.pop();
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
                kHSpace6,
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
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
            '${appDocDir.path}/${path.basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);

    String fileURL = await _uploadImageToStorage(
      file,
      imageBytes.lengthInBytes,
      imageBytes,
    );

    return fileURL;
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

      controller.updateSelection(selection, quill.ChangeSource.remote);

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

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(
      BuildContext conrext, ImagePickerService imagePickerService) async {
    final pickedFile = await imagePickerService.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile == null) return '';
    int fileSize = await pickedFile.length();
    Uint8List fileContent = await pickedFile.readAsBytes();
    File file = File(pickedFile.path);
    return await _uploadImageToStorage(file, fileSize, fileContent);
  }

  Future<String> _uploadImageToStorage(
      File file, int fileSize, Uint8List fileContent) async {
    if (_checkFileSize(fileSize)) {
      FirebaseStorageService imageFSS = FirebaseStorageService();
      await imageFSS.uploadFile(
        uid: AccountService.loggedInUserId!,
        file: file,
        imageName: path
                .basenameWithoutExtension(file.path)
                .replaceAll(RegExp('[^A-Za-z0-9]'), '_') +
            path.extension(file.path),
        fileContent: fileContent,
      );

      if (imageFSS.url != null) {
        return imageFSS.url!;
      }
    }

    return '';
  }

  bool _checkFileSize(int fileSize) {
    double sizeInMB = fileSize / (1024 * 1024);
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

  _initializeEditor() {
    quillEditor = quill.QuillEditor(
      scrollController: ScrollController(),
      focusNode: _focusNode,
      configurations: quill.QuillEditorConfigurations(
        controller: _quillController,
        scrollable: true,
        sharedConfigurations: quill.QuillSharedConfigurations(
          locale: context.locale,
        ),
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
        customStyles: const quill.DefaultStyles(
          h1: quill.DefaultTextBlockStyle(
              TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              quill.VerticalSpacing(16, 0),
              quill.VerticalSpacing(0, 0),
              null),
          sizeSmall: TextStyle(fontSize: 9),
        ),
        embedBuilders: [
          ...FlutterQuillEmbeds.defaultEditorBuilders(),
          TimeStampEmbedBuilderWidget()
        ],
      ),
    );
    if (kIsWeb) {
      quillEditor = quill.QuillEditor(
        scrollController: ScrollController(),
        focusNode: _focusNode,
        configurations: quill.QuillEditorConfigurations(
          controller: _quillController,
          sharedConfigurations: quill.QuillSharedConfigurations(
            locale: context.locale,
          ),
          scrollable: true,
          autoFocus: false,
          readOnly: false,
          placeholder: 'note_add_details'.tr(),
          expands: false,
          padding: EdgeInsets.zero,
          onTapUp: (details, p1) {
            return _onTripleClickSelection();
          },
          customStyles: const quill.DefaultStyles(
            h1: quill.DefaultTextBlockStyle(
                TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                quill.VerticalSpacing(16, 0),
                quill.VerticalSpacing(0, 0),
                null),
            sizeSmall: TextStyle(fontSize: 9),
          ),
          embedBuilders: [
            ...defaultEmbedBuildersWeb,
            TimeStampEmbedBuilderWidget()
          ],
        ),
      );
    }
    toolbar = quill.QuillToolbar.simple(
      configurations: quill.QuillSimpleToolbarConfigurations(
        controller: _quillController,
        multiRowsDisplay: false,
        showFontFamily: false,
        embedButtons: FlutterQuillEmbeds.toolbarButtons(
          videoButtonOptions: null,
          imageButtonOptions: QuillToolbarImageButtonOptions(
            imageButtonConfigurations: QuillToolbarImageConfigurations(
              onRequestPickImage: _onImagePickCallback,
            ),
          ),
          // showFormulaButton: true,
        ),
        showAlignmentButtons: true,
        // afterButtonPressed: _focusNode.requestFocus,
      ),
    );
    if (kIsWeb) {
      toolbar = quill.QuillToolbar.simple(
        configurations: quill.QuillSimpleToolbarConfigurations(
          controller: _quillController,
          multiRowsDisplay: false,
          showFontFamily: false,
          embedButtons: FlutterQuillEmbeds.toolbarButtons(
            videoButtonOptions: null,
            cameraButtonOptions: null,
            imageButtonOptions: QuillToolbarImageButtonOptions(
              imageButtonConfigurations: QuillToolbarImageConfigurations(
                onRequestPickImage: _onImagePickCallback,
              ),
            ),
          ),
          showAlignmentButtons: true,
          // afterButtonPressed: _focusNode.requestFocus,
        ),
      );
    }
    if (_isDesktop) {
      toolbar = quill.QuillToolbar.simple(
          configurations: quill.QuillSimpleToolbarConfigurations(
        controller: _quillController,
        multiRowsDisplay: false,
        showFontFamily: false,
        embedButtons: FlutterQuillEmbeds.toolbarButtons(
          videoButtonOptions: null,
          cameraButtonOptions: null,
          imageButtonOptions: QuillToolbarImageButtonOptions(
            imageButtonConfigurations: QuillToolbarImageConfigurations(
              onRequestPickImage: _onImagePickCallback,
            ),
          ),
        ),
        showAlignmentButtons: true,
        // afterButtonPressed: _focusNode.requestFocus,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool screenGreaterThan700 = MediaQuery.of(context).size.width > 700;
    bool switchToTopSaveMode = !kIsWeb &&
        (Platform.isIOS || Platform.isAndroid) &&
        MediaQuery.of(context).viewInsets.bottom != 0;

    return CustomScaffold(
      title: _isUpdateMode ? 'note_edit'.tr() : 'note_new'.tr(),
      hasTopBars: true,
      showTopSaveButton: switchToTopSaveMode,
      hasBottomBars: switchToTopSaveMode ? false : true,
      editMode: true,
      onTap: _saveNote,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
              color: kBlackColor,
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
                        color: kPink1,
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
                kFullHSpace,
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 4.0),
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: categoryColor(_noteCat).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: PopupMenuButton<dynamic>(
                    itemBuilder: _buildPopUpMenuItems,
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
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
                        kHSpace6,
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
            kFullVSpace,
            Expanded(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      toolbar,
                      kFullVSpace,
                      Expanded(
                        child: quillEditor,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: WhatsappCopyButton(
                      quillController: _quillController,
                    ),
                  ),
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
