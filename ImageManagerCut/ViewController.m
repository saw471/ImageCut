//
//  ViewController.m
//  ImageManagerCut
//
//  Created by mac on 2018/2/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import "cmnImagePick.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CMNImagePickerTool.jianqiefanshi = CutType0_0;
    [CMNImagePickerTool picker:^(UIImage *img) {
        
        [self loadImageFinished:img];
        
    } parentVc:self];
}

 #pragma mark ————————— 保存图片到相册 —————————————
- (void)loadImageFinished:(UIImage *)image {
//    NSPhotoLibraryAddUsageDescription    plist 配置
    
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
