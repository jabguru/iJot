import 'package:image_picker/image_picker.dart' as package;

/// Specifies the source where the picked image should come from.
enum ImageSource {
  /// Opens up the device camera, letting the user to take a new picture.
  camera,

  /// Opens the user's photo gallery.
  gallery,
}

enum CameraDevice {
  /// Use the rear camera.
  ///
  /// In most of the cases, it is the default configuration.
  rear,

  /// Use the front camera.
  ///
  /// Supported on all iPhones/iPads and some Android devices.
  front,
}

abstract class ImagePickerInterface {
  const ImagePickerInterface();
  Future<package.XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  });
  Future<package.XFile?> pickMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
  });
  Future<package.XFile?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  });
}

class ImagePickerPackageImpl extends ImagePickerInterface {
  const ImagePickerPackageImpl();
  package.ImagePicker get _picker {
    return package.ImagePicker();
  }

  @override
  Future<package.XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) {
    return _picker.pickImage(
      source: source.toImagePickerPackage(),
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice.toImagePickerPackage(),
      requestFullMetadata: requestFullMetadata,
    );
  }

  @override
  Future<package.XFile?> pickMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
  }) {
    return _picker.pickMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
    );
  }

  @override
  Future<package.XFile?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) {
    return _picker.pickVideo(
      source: source.toImagePickerPackage(),
      preferredCameraDevice: preferredCameraDevice.toImagePickerPackage(),
      maxDuration: maxDuration,
    );
  }
}

extension ImageSoureceExt on ImageSource {
  package.ImageSource toImagePickerPackage() {
    switch (this) {
      case ImageSource.camera:
        return package.ImageSource.camera;
      case ImageSource.gallery:
        return package.ImageSource.gallery;
    }
  }
}

extension CameraDeviceExt on CameraDevice {
  package.CameraDevice toImagePickerPackage() {
    switch (this) {
      case CameraDevice.rear:
        return package.CameraDevice.rear;
      case CameraDevice.front:
        return package.CameraDevice.front;
    }
  }
}

/// A service used for packing images in the extensions package
class ImagePickerService extends ImagePickerInterface {
  final ImagePickerInterface _impl = ImagePickerPackageImpl();
  @override
  Future<package.XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) =>
      _impl.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
        requestFullMetadata: requestFullMetadata,
      );

  @override
  Future<package.XFile?> pickMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
  }) =>
      _impl.pickMedia(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        requestFullMetadata: requestFullMetadata,
      );

  @override
  Future<package.XFile?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) =>
      _impl.pickVideo(
        source: source,
        preferredCameraDevice: preferredCameraDevice,
        maxDuration: maxDuration,
      );
}
