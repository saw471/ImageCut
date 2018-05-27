//
//  ZFScanViewController.m
//  ZFScan
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "cmnScanVC.h"
#import "cmnMaskView.h"
#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface cmnScanVC ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;
/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
/** 遮罩层 */
@property (nonatomic, strong) cmnMaskView * maskView;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *btnBack;
@property(nonatomic,strong)UILabel     *barTitle;
@property(nonatomic,copy)NSString      *strTitle;
@property(nonatomic,strong)AVAudioPlayer *avAudioPlayer;

@end

@implementation cmnScanVC

+(instancetype)scan:(NSString*)strTitle{
    cmnScanVC *scan = [[cmnScanVC alloc] init];
    scan.barTitle.text = strTitle;
    return scan;
}

-(UILabel*)barTitle{
    if ( _barTitle == nil ){
        _barTitle = [[UILabel alloc] init];
        _barTitle.textAlignment = NSTextAlignmentCenter;
        _barTitle.textColor = [UIColor whiteColor];
        _barTitle.font = [UIFont boldSystemFontOfSize:18];
    }
    return _barTitle;
}

- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    
    return _metadataObjectTypes;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.maskView removeAnimation];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ( [self checkAuthor] ){
        [self capture];
        [self addUI];
    } else {
        [self addUI];
        [self.maskView removeAnimation];
        NSString *tip = @"请在iPhone的“设置-隐私-相机”选项中，允许福抱抱访问你的相机。";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tip
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"好"
                                               otherButtonTitles:nil,nil];
        [alert show];
    }
    
    NSString *string = [[NSBundle mainBundle] pathForResource:@"scan" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_avAudioPlayer prepareToPlay];
    
}



/**
 *  添加遮罩层
 */
- (void)addUI{
    self.maskView = [[cmnMaskView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.maskView];
    
    CGRect rtTitle = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    UIView  *barMask = [[UIView alloc] initWithFrame:rtTitle];
    barMask.backgroundColor = [UIColor blackColor];
    barMask.alpha = 0.3;
    
    rtTitle.origin.y = 20;
    rtTitle.size.height = 44;
    UILabel *barTitle = self.barTitle;
    barTitle.frame = rtTitle;

    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(15, 20, 40, 40);
    [btnBack setImage:[UIImage imageNamed:@"ScanBack"] forState:UIControlStateNormal];
    btnBack.backgroundColor = [UIColor blackColor];
    btnBack.layer.cornerRadius = btnBack.frame.size.width/2;
    [btnBack addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.maskView addSubview:barMask];
    [self.maskView addSubview:barTitle];
    [self.maskView addSubview:btnBack];
}

/**
 *  扫描初始化
 */
- (void)capture{
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    [self.session addInput:input];
    [self.session addOutput:output];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = self.metadataObjectTypes;
    
    //开始捕获
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        [_avAudioPlayer play];
        self.returnScanBarCodeValue(metadataObject.stringValue);
        
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - 取消事件
/**
 * 取消事件
 */
- (void)cancelAction{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(BOOL)checkAuthor{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //去设置
    //if ( buttonIndex == 1 ){
    //    NSURL *url = [NSURL URLWithString:@"prefs:root=MUSIC"];
    //    if ([[UIApplication sharedApplication] canOpenURL:url]){
    //        [[UIApplication sharedApplication] openURL:url];
    //    }
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
    //}
    [self cancelAction];
}


@end
