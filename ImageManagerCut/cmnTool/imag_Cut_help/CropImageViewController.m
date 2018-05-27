//
//  CropImageViewController.m
//  ImageTailor
//
//  Created by yinyu on 15/10/10.
//  Copyright © 2015年 yinyu. All rights reserved.
//

#import "CropImageViewController.h"
#import "CropResultViewController.h"
#import "TKImageView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define CROP_PROPORTION_IMAGE_WIDTH 30.0f
#define CROP_PROPORTION_IMAGE_SPACE 48.0f
#define CROP_PROPORTION_IMAGE_PADDING 20.0f

@interface CropImageViewController () {
    
    NSArray *proportionImageNameArr;
    NSArray *proportionImageNameHLArr;
    NSArray *proportionArr;
    NSMutableArray *proportionBtnArr; // 尺寸选择的按钮
    CGFloat currentProportion;

}
@property (weak, nonatomic) IBOutlet UIScrollView *cropProportionScrollView; //联排按钮
@property (weak, nonatomic) IBOutlet TKImageView *tkImageView;

@end

@implementation CropImageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpTKImageView];
    [self setUpCropProportionView];
//    [self clickProportionBtn: proportionBtnArr[0]];
//    currentProportion = 0;
    // 默认的剪切方式
    
    NSLog(@"默认的剪切方式");
    
    NSLog(@"%zd",_jianQieFangShi);
    
    [self clickProportionBtn: proportionBtnArr[_jianQieFangShi]];
    currentProportion = _jianQieFangShi;
     NSLog(@"隐藏延时切换按钮");
    _cropProportionScrollView.hidden = YES;
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}
- (void)setUpTKImageView {
    
    _tkImageView.toCropImage = _image;
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
//    _tkImageView.minSpace = 0;
    // 四周边框颜色
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 4;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 6;
    // 内部网格颜色
    _tkImageView.cropAreaMidLineColor = [UIColor clearColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor clearColor];
    _tkImageView.cropAreaCrossLineWidth = 4;
    _tkImageView.initialScaleFactor = .8f;
    NSLog(@"设置内容占全屏比例");
    
    if (_jianQieFangShi == 0) {
        _tkImageView.initialScaleFactor = .8f;
    }else{
        _tkImageView.initialScaleFactor = 1;
    }
    

    
}








- (void)setUpCropProportionView {
    // 5个按钮
    proportionBtnArr = [NSMutableArray array];
    proportionImageNameArr = @[@"crop_free", @"crop_1_1", @"crop_4_3", @"crop_3_4", @"crop_16_9", @"crop_9_16"];
    proportionImageNameHLArr = @[@"cropHL_free", @"cropHL_1_1", @"cropHL_4_3", @"cropHL_3_4", @"cropHL_16_9", @"cropHL_9_16"];
    proportionArr = @[@0, @1, @(4.0/3.0), @(3.0/4.0), @(16.0/9.0), @(9.0/16.0)];
    
    // 更多按钮
    proportionImageNameArr = @[@"crop_free", @"crop_1_1", @"crop_4_3", @"crop_3_4", @"crop_16_9", @"crop_9_16",@"crop_9_16",@"crop_9_16"];
    proportionImageNameHLArr = @[@"cropHL_free", @"cropHL_1_1", @"cropHL_4_3", @"cropHL_3_4", @"cropHL_16_9", @"cropHL_9_16",@"cropHL_9_16",@"cropHL_9_16"];
    
    
    
    
     proportionArr = @[@0, @1, @(4.0/3.0), @(3.0/4.0), @(16.0/9.0), @(9.0/16.0),@(5.0/16.0),@(16.0/5.0)];
    
    
    self.cropProportionScrollView.contentSize = CGSizeMake(CROP_PROPORTION_IMAGE_PADDING * 2 + CROP_PROPORTION_IMAGE_WIDTH * proportionArr.count + CROP_PROPORTION_IMAGE_SPACE * (proportionArr.count - 1), CROP_PROPORTION_IMAGE_WIDTH);
    for(int i = 0; i < proportionArr.count; i++) {
        UIButton *proportionBtn = [[UIButton alloc]initWithFrame: CGRectMake(CROP_PROPORTION_IMAGE_PADDING + (CROP_PROPORTION_IMAGE_SPACE + CROP_PROPORTION_IMAGE_WIDTH) * i, 0, CROP_PROPORTION_IMAGE_WIDTH, CROP_PROPORTION_IMAGE_WIDTH)];
        [proportionBtn setBackgroundImage:
         [UIImage imageNamed: proportionImageNameArr[i]]
                                 forState: UIControlStateNormal];
        [proportionBtn setBackgroundImage:
         [UIImage imageNamed: proportionImageNameHLArr[i]]
                                 forState: UIControlStateSelected];
        [proportionBtn addTarget:self action:@selector(clickProportionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.cropProportionScrollView addSubview:proportionBtn];
        [proportionBtnArr addObject:proportionBtn];
    }
    
}
- (void)clickProportionBtn: (UIButton *)proportionBtn {
    
//    NSLog(@"点击事件");
    
    for(UIButton *btn in proportionBtnArr) {
        btn.selected = NO;
    }
    proportionBtn.selected = YES;
    NSInteger index = [proportionBtnArr indexOfObject:proportionBtn];
    currentProportion = [proportionArr[index] floatValue];
    _tkImageView.cropAspectRatio = currentProportion;
    
    
    NSLog(@"点击事件=%.2f",currentProportion);
    
//    _tkImageView.cropAspectRatio = 1.6;
    
}

#pragma mark ————————— 取消 —————————————
- (IBAction)clickCancelBtn:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark ————————— 确认 —————————————
- (IBAction)clickOkBtn:(id)sender {
    
    
    NSLog(@"选中图片了");
    
    if (self.blockImage) {
        
        NSLog(@"准备回传回传图片=%@",[_tkImageView currentCroppedImage]);
        
        self.blockImage([_tkImageView currentCroppedImage]);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
//    CropResultViewController *cropResultViewController = [[CropResultViewController alloc] initWithNibName: @"CropResultViewController" bundle: nil];
//    cropResultViewController.cropResultImage = [_tkImageView currentCroppedImage];
//
//
//    [self presentViewController:cropResultViewController animated:YES completion:nil];
    
    /////// [self.navigationController pushViewController: cropResultViewController animated: YES];
    
}
@end
