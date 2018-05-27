//
//  UIImage+cmnExt.h
//  cmnBase
//
//  Created by Harry on 15/4/4.
//  Copyright (c) 2015年 com.chinatek.ubinNaviShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ext)
//NSData *imageData = UIImageJPEGRepresentation([self.imageViewNormal image], 0.0001);
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)getImageFromView:(UIView *)view;
+ (UIImage *)resizableImage:(NSString *)name;
- (UIImage *)scaleImg:(CGFloat)scale;

- (UIImage *)imageTintedToColor:(UIColor *)color;
- (UIImage *)subImage:(CGRect)subImageRect;
- (UIImage *)subImageV2:(CGRect)rect;
- (UIImage *)RadiusImage:(NSInteger)radius;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleToSizeV2:(CGSize)size;
- (UIImage*)RotatedByDegrees:(CGFloat)degrees;

- (UIImage *)circle:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;

- (UIImage *)imageByScalingToMaxSize:(UIImage *)srcImg;
@end


@interface UIImage (Effect)
// 0.0 to 1.0
- (UIImage*)blurredImage:(CGFloat)blurAmount;
- (UIImage*)blurByFilter;
@end

@interface UIImage (ImageEffects)

+ (UIImage*) createBlurBackground:(UIImage*)image blurRadius:(CGFloat)blurRadius;
+ (UIImage*) blurryImage:(UIImage*)image withBlurLevel:(CGFloat)blur;

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
