//
//  cmnCameraTool.h
//  ubinNaviShip
//
//  Created by Harry on 15/7/5.
//  Copyright (c) 2015年 chinatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cmnToolCamera : NSObject

+ (BOOL) isCameraAvailable;
+ (BOOL) isRearCameraAvailable;
+ (BOOL) isFrontCameraAvailable;
+ (BOOL) doesCameraSupportTakingPhotos;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickVideosFromPhotoLibrary;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;
@end
