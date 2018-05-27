//
//  ZmjPickView.m
//  ZmjPickView
//
//  Created by XLiming on 17/1/16.
//  Copyright © 2017年 郑敏捷. All rights reserved.
//

#import "cmnCityPick.h"

#define MainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]
// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface cmnCityPick()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView   *pickerView;

@property (strong, nonatomic) UIButton       *cancelBtn;

@property (strong, nonatomic) UIButton       *DetermineBtn;

@property (strong, nonatomic) UILabel        *addressLb;

@property (strong, nonatomic) UIView         *darkView;

@property (strong, nonatomic) UIView         *backView;

@property (strong, nonatomic) UIBezierPath   *bezierPath;

@property (strong, nonatomic) CAShapeLayer   *shapeLayer;



@property(strong,nonatomic)NSArray           *aryAreaCodes;
@property(assign,nonatomic)NSInteger         idxProv;
@property(assign,nonatomic)NSInteger         idxCity;
@property(assign,nonatomic)NSInteger         idxCountry;
@end

@implementation cmnCityPick

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 300);
        
        [self initData];
        [self initGesture];
    }
    return self;
}

- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}
- (void)show:(UIView*)view{
    [self initView:view];
}

- (void)initView:(UIView*)topView {
    //UIView *topView1 = [[UIApplication sharedApplication].windows lastObject];
    //[self showInView:[[UIApplication sharedApplication].windows lastObject]];
    [self showInView:topView];
    
    [self addSubview:self.darkView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.cancelBtn];
    [self.backView addSubview:self.DetermineBtn];
    [self.backView addSubview:self.addressLb];
    [self.backView addSubview:self.pickerView];
    
    [self bezierPath];
    [self shapeLayer];
    
    NSArray *aryCity = (NSArray*)_aryAreaCodes[0][@"citys"];
    NSArray *aryCountry = aryCity[0][@"country"];
    _addressLb.text = [NSString stringWithFormat:@"%@%@%@",_aryAreaCodes[0][@"name"],
                       aryCity.count > 0? aryCity[_idxCity][@"name"]:0,
                       aryCountry.count > 0? aryCountry[0][@"name"]:0];
}

- (void)initData {
    _aryAreaCodes = [self JsonObject:@"ssx.json"];
    _idxProv      = 0;
    _idxCity      = 0;
    _idxCountry   = 0;
}


- (void)initGesture {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}

- (void)showInView:(UIView *)view {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGPoint point = self.center;
        point.y      -= 250;
        self.center   = point;
        
    } completion:^(BOOL finished) {
    }];
    
    [view addSubview:self];
}

- (void)dismiss {

    [UIView animateWithDuration:0.3 animations:^{
        
        CGPoint point = self.center;
        point.y      += 250;
        self.center   = point;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

// 返回选择器有几列.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

// 返回每组有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
            
        case 0:{
            return _aryAreaCodes.count;
        }
            //return _shengArray.count;
            break;
            
        case 1:{
            NSArray *aryCity = (NSArray*)_aryAreaCodes[_idxProv][@"citys"];
            return aryCity.count;
            //return _shiArr.count;
        }
        break;
            
        case 2:{
            NSArray *aryCity = (NSArray*)_aryAreaCodes[_idxProv][@"citys"];
            NSArray *aryCountry = aryCity[_idxCity][@"country"];
            return aryCountry.count;
            //return _shiArr.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

// 返回第component列第row行的内容（标题）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
            
        case 0:{
            
            return _aryAreaCodes[row][@"name"];
            //return _shengArray[row][@"name"];
        }
            break;
            
        case 1:{
            NSArray *aryCity = (NSArray*)_aryAreaCodes[_idxProv][@"citys"];
            return aryCity[row][@"name"];
            //return _shiArr[row][@"name"];
        }
            break;
            
        case 2:{
            NSArray *aryCity = (NSArray*)_aryAreaCodes[_idxProv][@"citys"];
            NSArray *aryCountry = aryCity[_idxCity][@"country"];
            return aryCountry[row][@"name"];
            //return _xianArr[row][@"name"];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

// 设置row字体，颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel            = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel                 = [[UILabel alloc] init];
        pickerLabel.textAlignment   = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font            = [UIFont systemFontOfSize:16.0];
    }
    
    pickerLabel.text                = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
            
        case 0:{

            _idxProv = row;
            _idxCity = 0;
            _idxCountry = 0;
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            [_pickerView reloadComponent:2];
            
        }
            break;
            
        case 1:{
            
            _idxCity = row;
            _idxCountry = 0;
            
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            [_pickerView reloadComponent:2];
        }
            break;
            
        default:
            break;
    }
    
    _idxProv = [_pickerView selectedRowInComponent:0];
    _idxCity = [_pickerView selectedRowInComponent:1];
    _idxCountry = [_pickerView selectedRowInComponent:2];
    

    NSArray *aryCity = (NSArray*)_aryAreaCodes[_idxProv][@"citys"];
    NSArray *aryCountry = aryCity[_idxCity][@"country"];
    _addressLb.text = [NSString stringWithFormat:@"%@%@%@",
                       _aryAreaCodes[_idxProv][@"name"],
                       aryCity.count > 0 ? aryCity[_idxCity][@"name"]:0,
                       aryCountry.count > 0 ? aryCountry[_idxCountry][@"name"]:0];
    ;
}

- (id)JsonObject:(NSString *)jsonStr {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonStr ofType:nil];
    NSData *jsonData   = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error;
    id JsonObject      = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    return JsonObject;
}

- (UIView *)darkView {
    if (!_darkView) {
        _darkView                 = [[UIView alloc]init];
        _darkView.frame           = self.frame;
        _darkView.backgroundColor = [UIColor blackColor];
        _darkView.alpha           = 0.3;
    }
    return _darkView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 250);
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    }
    return _bezierPath;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = _backView.bounds;
        _shapeLayer.path = _bezierPath.CGPath;
        _backView.layer.mask = _shapeLayer;
    }
    return _shapeLayer;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView                 = [[UIPickerView alloc]init];
        _pickerView.frame           = CGRectMake(0, 50, ScreenWidth, 200);
        _pickerView.delegate        = self;
        _pickerView.dataSource      = self;
        _pickerView.backgroundColor = MainBackColor;
    }
    return _pickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(0, 0, 50, 50);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)DetermineBtn {
    if (!_DetermineBtn) {
        _DetermineBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _DetermineBtn.frame = CGRectMake(ScreenWidth - 50, 0, 50, 50);
        [_DetermineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_DetermineBtn addTarget:self action:@selector(determineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _DetermineBtn;
}

- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [[UILabel alloc]init];
        _addressLb.frame = CGRectMake(50, 0, ScreenWidth - 100, 50);
        _addressLb.textAlignment = NSTextAlignmentCenter;
        _addressLb.font = [UIFont systemFontOfSize:16.0];
    }
    return _addressLb;
}

- (void)determineBtnAction:(UIButton *)button {
    
    NSInteger shengRow = [_pickerView selectedRowInComponent:0];
    NSInteger shiRow   = [_pickerView selectedRowInComponent:1];
    NSInteger xianRow  = [_pickerView selectedRowInComponent:2];
    
    if (self.determineBtnBlock) {
        
        NSArray *aryCity = (NSArray*)_aryAreaCodes[shengRow][@"citys"];
        NSArray *aryCountry = aryCity[shiRow][@"country"];
        
        self.determineBtnBlock([_aryAreaCodes[shengRow][@"id"] integerValue],
                               aryCity.count > 0?  [aryCity[shiRow][@"id"] integerValue]:0,
                               aryCountry.count > 0? [aryCountry[xianRow][@"id"] integerValue]:0,
                               _aryAreaCodes[shengRow][@"name"],
                               aryCity.count > 0?  aryCity[shiRow][@"name"]:@"",
                               aryCountry.count > 0? aryCountry[xianRow][@"name"]:@"");
    }
    
    [self dismiss];
}


@end
