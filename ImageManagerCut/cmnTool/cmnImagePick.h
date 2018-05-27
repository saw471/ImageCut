//
//  cmnCityPick.h
//  cmnCityPick
//
//  Created by Harry on 17/1/16.
//  Copyright © 2017年 CNTek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropImageViewController.h"
//================枚举=======================
//typedef NS_ENUM(NSUInteger, CutType) {
//    CutType0_0,  // 自由选择
//    CutType1_1,  // 1:1
//    CutType4_3,  // 4：3
//    CutType3_4,  // 3：4
//    CutType16_9, // 16：9
//    CutType9_16,  // 9:16
//    CutType5_16,
//    CutType16_5
//};


#define CMNImagePickerTool    [cmnImagePicker imageTool]

typedef void(^cmnImagePickerBlock)(UIImage* img);

@interface cmnImagePicker : NSObject
@property(nonatomic,strong)UIColor             *clrFrame;
@property(nonatomic,assign)CGFloat             imgH;

+(instancetype)imageTool;
-(void)picker:(cmnImagePickerBlock)block   parentVc:(UIViewController*)parentVc;

@property (nonatomic,assign)CutType jianqiefanshi;
@end



#if 0

CGSize s1 = CGSizeMake(145, 145);
UIImage *imgSelected = [editedImage scaleToSize:s1];

//1.显示当前头像到界面上
_headerIcon.imgInter.image = imgSelected;

//2.保存到当前临时对象中
_dataUser.imgUpdated = imgSelected;
#endif
