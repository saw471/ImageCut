//
//  ZmjPickView.m
//  ZmjPickView
//
//  Created by XLiming on 17/1/16.
//  Copyright © 2017年 郑敏捷. All rights reserved.
//

#import "cmnImagePick.h"
//#import "cmnToolMac.h"
#import "cmnToolCamera.h"
#import "UIImage+Ext.h"
//#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "CropImageViewController.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#define K_WEAK_SELF                 __weak __typeof(&*self)weakSelf = self

/**  iphone和ipad的宏定义  */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)



@interface cmnImagePicker()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,assign)UIViewController    *parentVC;
@property(copy, nonatomic)cmnImagePickerBlock  imgBlock;
@end

@implementation cmnImagePicker

+(instancetype)imageTool{
    static dispatch_once_t pred = 0;
    __strong static cmnImagePicker  *_tool = nil;
    dispatch_once(&pred, ^{
        _tool = [[self alloc]init];
    });
    return _tool;
}

-(instancetype)init{
    if ( self = [super init] ){
        _imgH = Main_Screen_Width;
        _clrFrame = [UIColor blackColor];
    }
    return self;
}


-(void)picker:(cmnImagePickerBlock)block   parentVc:(UIViewController*)parentVc{
    _imgBlock = block;
    _parentVC = parentVc;
    //return;
    K_WEAK_SELF;
    UIAlertController *actVC = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    if( IS_IPAD ) {
        // ipad处理
        actVC.popoverPresentationController.sourceView = _parentVC.view;
        actVC.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    }
    

    

    [actVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([cmnToolCamera isCameraAvailable] && [cmnToolCamera doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
//            if ([cmnToolCamera isFrontCameraAvailable]) {
//                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;//UIImagePickerControllerCameraDeviceRear
//                //UIImagePickerControllerCameraDeviceFront
//            }
            
             controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = weakSelf;
            [_parentVC presentViewController:controller  animated:YES completion:^(void){
                NSLog(@"Picker View Controller is presented");
            }];
                
        }
        
    }]];
        
    
    [actVC addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([cmnToolCamera isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [_parentVC presentViewController:controller  animated:YES  completion:^(void){
                NSLog(@"picker View Controller is presented");
            }];
                
        }
    }]];
        
    [actVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
        
    
    [_parentVC presentViewController:actVC animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    K_WEAK_SELF;
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [portraitImg imageByScalingToMaxSize:portraitImg];
        
        
        
//        if (_imgH > 0) {
//            // 老裁剪
//            CGFloat ftScrnW = Main_Screen_Width;
//            CGFloat ftScrnH = Main_Screen_Height;
//            if ( _imgH <= 0 ){
//                _imgH = ftScrnW;
//            }
//            CGRect rtImg = CGRectMake(0, (ftScrnH-_imgH)/2, ftScrnW, _imgH);
//            VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:rtImg limitScaleRatio:3.0];
//            imgEditorVC.delegate = weakSelf;
//            imgEditorVC.cropClr  = _clrFrame;
//            [_parentVC presentViewController:imgEditorVC animated:YES completion:^{
//            }];
//
//        }else{
            // 新裁剪
            CropImageViewController *cropImageViewController = [[CropImageViewController alloc]initWithNibName:@"CropImageViewController" bundle:nil];
            cropImageViewController.image = portraitImg;
        
        cropImageViewController.jianQieFangShi = _jianqiefanshi;
            cropImageViewController.blockImage = ^(UIImage *imageBlock) {
                NSLog(@"回传图片=%@",imageBlock);
                
                if ( _imgBlock ){
                    _imgBlock(imageBlock);
                }
                
                
                
            };
            
            [_parentVC presentViewController:cropImageViewController animated:YES completion:nil];
//        }
    }];
}





//#pragma mark VPImageCropperDelegate
//- (void)imageCropper:(VPImageCropperViewController *)cropVC didFinished:(UIImage *)editedImage {
//
//    if ( _imgBlock )
//        _imgBlock(editedImage);
//    [cropVC dismissViewControllerAnimated:YES completion:^{}];
//}

//
//- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
//}



@end
