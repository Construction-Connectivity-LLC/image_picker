// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  dartTestOut: 'test/test_api.g.dart',
  objcHeaderOut: 'ios/Classes/messages.g.h',
  objcSourceOut: 'ios/Classes/messages.g.m',
  objcOptions: ObjcOptions(
    prefix: 'FLT',
  ),
  copyrightHeader: 'pigeons/copyright.txt',
))
class MaxSize {
  MaxSize(this.width, this.height);
  double? width;
  double? height;
}

class MediaSelectionOptions {
  MediaSelectionOptions({
    required this.maxSize,
    this.imageQuality,
    this.defaultCoordinates,
    required this.requestFullMetadata,
    required this.allowMultiple,
  });

  MaxSize maxSize;
  int? imageQuality;
  Coordinates? defaultCoordinates;
  bool requestFullMetadata;
  bool allowMultiple;
}

// Corresponds to `CameraDevice` from the platform interface package.
enum SourceCamera { rear, front }

// Corresponds to `ImageSource` from the platform interface package.
enum SourceType { camera, gallery }

class SourceSpecification {
  SourceSpecification(this.type, this.camera);
  SourceType type;
  SourceCamera? camera;
}

class Coordinates {
  Coordinates(this.latitude, this.longitude);
  double latitude;
  double longitude;
}


@HostApi(dartHostTestHandler: 'TestHostImagePickerApi')
abstract class ImagePickerApi {
  @async
  @ObjCSelector('pickImageWithSource:maxSize:quality:fullMetadata:defaultCoordinates:')
  String? pickImage(SourceSpecification source, MaxSize maxSize,
      int? imageQuality, bool requestFullMetadata, Coordinates? defaultCoordinates);
  @async
  @ObjCSelector('pickMultiImageWithMaxSize:quality:fullMetadata:defaultCoordinates:')
  List<String?> pickMultiImage(
      MaxSize maxSize, int? imageQuality, bool requestFullMetadata, Coordinates? defaultCoordinates);
  @async
  @ObjCSelector('pickVideoWithSource:maxDuration:defaultCoordinates:')
  String? pickVideo(SourceSpecification source, int? maxDurationSeconds, Coordinates? defaultCoordinates);

  /// Selects images and videos and returns their paths.
  @async
  @ObjCSelector('pickMediaWithMediaSelectionOptions:')
  List<String?> pickMedia(MediaSelectionOptions mediaSelectionOptions);
}
