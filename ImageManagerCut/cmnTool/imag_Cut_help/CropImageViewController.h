//
//  CropImageViewController.h
//  ImageTailor
//
//  Created by yinyu on 15/10/10.
//  Copyright © 2015年 yinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CutType) {
    CutType0_0,  // 自由选择
    CutType1_1,  // 1:1
    CutType4_3,  // 4：3
    CutType3_4,  // 3：4
    CutType16_9, // 16：9
    CutType9_16,  // 9:16
    CutType5_16,
    CutType16_5
};



typedef void(^jianQieImage)(UIImage * imageBlock) ;
@interface CropImageViewController : UIViewController
@property (strong, nonatomic) UIImage *image;

@property (nonnull,copy)jianQieImage blockImage;

@property (nonatomic,assign)CutType jianQieFangShi;
@end
