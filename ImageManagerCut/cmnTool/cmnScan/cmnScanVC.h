//
//  ZFScanViewController.h
//  ZFScan
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

/*
 
 ZFScanViewController * vc = [[ZFScanViewController alloc] init];
 vc.returnScanBarCodeValue = ^(NSString * barCodeString){
 self.resultLabel.text = [NSString stringWithFormat:@"扫描结果:\n%@",barCodeString];
 NSLog(@"扫描结果的字符串======%@",barCodeString);
 };
 
 [self.navigationController pushViewController:vc animated:YES];
 
 */
#import <UIKit/UIKit.h>

@interface cmnScanVC : UIViewController

+(instancetype)scan:(NSString*)strTitle;
/** 扫描结果 */
@property (nonatomic, copy) void (^returnScanBarCodeValue)(NSString * barCodeString);

@end
