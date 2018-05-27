//
//  cmnCityPick.h
//  cmnCityPick
//
//  Created by Harry on 17/1/16.
//  Copyright © 2017年 CNTek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^determineBtnActionBlock)(NSInteger shengId, NSInteger shiId, NSInteger xianId, NSString *shengName, NSString *shiName, NSString *xianName);

@interface cmnCityPick : UIView
@property (copy, nonatomic) determineBtnActionBlock determineBtnBlock;
- (void)show:(UIView*)view;
- (void)dismiss;
@end
