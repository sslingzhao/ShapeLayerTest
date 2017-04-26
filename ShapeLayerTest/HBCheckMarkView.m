//
//  HBCheckMarkView.m
//  ShapeLayerTest
//
//  Created by mac on 2017/4/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HBCheckMarkView.h"



#define ProgressViewWidth 100.0f
#define ProgressLayerRadius 40.0f
#define ResultLayerWidth 60.0f
#define ResultLayerHeight 60.0f

@interface HBCheckMarkView()

@property(nonatomic, assign) CGFloat percent; // 下载或上传百分比
@property(nonatomic, assign) BOOL isRightOrWrong; // 绘制对号或者错号
@property(nonatomic, assign) BOOL isUploadOrDownload; // 上传或者下载

@property(nonatomic, assign) BOOL isSuccessed; // 标记上传/下载是否成功

@property (nonatomic,strong) CAShapeLayer *bottomLayer; // 进度条底层layer
@property (nonatomic,strong) CAShapeLayer *topLayer;   // 进度条顶层layer
@property (nonatomic,strong) CAShapeLayer *arrowLayer;  //箭头layer

@property (nonatomic,strong) UIView *checkMarkView;
@property (nonatomic,strong) CAShapeLayer *checkMarkShapeLayer; // 对号
@property (nonatomic,strong) CAShapeLayer *wrongMarkShapeLayer; // 错号

@property (nonatomic,strong) UIView *contentView;

//+ (id)hb_CheckMarkView;

@end

@implementation HBCheckMarkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ProgressLayerRadius, ProgressLayerRadius)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.alpha = 1;
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        _contentView.center = keyWindow.center;
        [keyWindow  addSubview:_contentView];
    }
    return self;
}

+ (id)hb_CheckMarkView {
        
    static dispatch_once_t onceToken;
    static HBCheckMarkView *checkMarkView = nil;
    dispatch_once(&onceToken, ^{
        checkMarkView = [[HBCheckMarkView alloc] init];
    });
    return checkMarkView;
}

+ (void)hideHBCheckMarkView {

    [[HBCheckMarkView hb_CheckMarkView] hideHBCheckMarkView];
}

+ (void)showDownloadWithPercent:(CGFloat)percent {
    [[HBCheckMarkView hb_CheckMarkView] showDownloadWithPercent:percent];
}

+ (void)showUploadWithPercent:(CGFloat)percent {
    [[HBCheckMarkView hb_CheckMarkView] showUploadWithPercent:percent];
}

+ (void)showCheckMarkViewWithResult:(BOOL)rightOrWrong {
    [[HBCheckMarkView hb_CheckMarkView] drawCheckMarkViewWithResult:rightOrWrong];
}

- (void)showDownloadWithPercent:(CGFloat)percent {

    // 绘制下载进度条
    [self downLoadOrUploadWithStatus:YES];
    // 绘制下载箭头
    [self drawArrowLayerWithStatus:YES];
    
    self.percent = percent;
}

- (void)showUploadWithPercent:(CGFloat)percent {
    
    // 绘制上传进度条
    [self downLoadOrUploadWithStatus:NO];
    // 绘制上传箭头
    [self drawArrowLayerWithStatus:NO];
    
    self.percent = percent;
}

- (void)downLoadOrUploadWithStatus:(BOOL)downOrUp {
    
    if (_topLayer) {
        [_topLayer removeFromSuperlayer];
    }
    if (_bottomLayer) {
        [_bottomLayer removeFromSuperlayer];
    }
    
    // 下载上传进度条
    CGPoint center = CGPointMake(_contentView.frame.size.width/2.0, _contentView.frame.size.height/2.0);
    CGFloat radius = ProgressLayerRadius;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = M_PI*3.0/2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    _bottomLayer = [CAShapeLayer layer];
    _bottomLayer.path = path.CGPath;
    _bottomLayer.lineWidth = 3;
    _bottomLayer.frame = _contentView.bounds;
    _bottomLayer.fillColor = [UIColor clearColor].CGColor;
    _bottomLayer.strokeColor = [UIColor greenColor].CGColor;
    [_contentView.layer addSublayer:_bottomLayer];
    
    _topLayer = [CAShapeLayer layer];
    _topLayer.path = path.CGPath;
    _topLayer.frame = _contentView.bounds;
    _topLayer.fillColor = [UIColor clearColor].CGColor;
    _topLayer.strokeColor = [UIColor yellowColor].CGColor;
    _topLayer.lineCap = kCALineCapRound;
    _topLayer.strokeEnd = 0;
    _topLayer.lineWidth = 3;
    [_contentView.layer addSublayer:_topLayer];
    
}

- (void)drawArrowLayerWithStatus:(BOOL)starus {

    if (_arrowLayer) {
        [_arrowLayer removeFromSuperlayer];
    }
    // 绘制箭头
    UIBezierPath *arrowBezierPath = [UIBezierPath bezierPath];
    [arrowBezierPath moveToPoint:CGPointMake(_contentView.frame.size.width * 1 / 2, _contentView.frame.size.height * 1 /4)];
    [arrowBezierPath addLineToPoint:CGPointMake(_contentView.frame.size.width * 1  / 2, _contentView.frame.size.width * 3/4)];
    
    [arrowBezierPath moveToPoint:CGPointMake(_contentView.frame.size.width * 3/8, _contentView.frame.size.height * 1/2)];
    if (starus) {
        [arrowBezierPath addLineToPoint:CGPointMake(_contentView.frame.size.width *1/2, _contentView.frame.size.height * 1/4)];
    }else {
        [arrowBezierPath addLineToPoint:CGPointMake(_contentView.frame.size.width *1/2, _contentView.frame.size.height * 3/4)];
    }
    _arrowLayer = [CAShapeLayer layer];
    [arrowBezierPath addLineToPoint:CGPointMake(_contentView.frame.size.width * 5/8, _contentView.frame.size.height * 1/2)];
    
    _arrowLayer.lineWidth = 3;
    _arrowLayer.fillColor = [UIColor clearColor].CGColor;
    _arrowLayer.strokeColor = [UIColor greenColor].CGColor;
    _arrowLayer.lineCap = kCALineCapRound;
    _arrowLayer.lineJoin = kCALineJoinRound;
    
    _arrowLayer.path = arrowBezierPath.CGPath;
    
//    [_contentView.layer addSublayer:arrowLayer];
    [_contentView.layer insertSublayer:_arrowLayer atIndex:0];
}

- (void)drawCheckMarkViewWithResult:(BOOL)rightOrWrong {
    
    if (_checkMarkShapeLayer) {
        [_checkMarkShapeLayer removeFromSuperlayer];
    }
    if (_checkMarkView == nil) {        
        _checkMarkView = [[UIView alloc] initWithFrame:CGRectMake((_contentView.frame.size.width-60)/2, (_contentView.frame.size.height-60)/2, 60, 60)];
        _checkMarkView.layer.cornerRadius = 30;
        _checkMarkView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_checkMarkView];
        [_contentView bringSubviewToFront:_checkMarkView];
    }
    
    _checkMarkShapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(60/5, 60/2)];
    [bezierPath1 addLineToPoint:CGPointMake(60/2, 45)];
    [bezierPath1 addLineToPoint:CGPointMake(60 * 4/5, 15)];
    
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
    [bezierPath2 moveToPoint:CGPointMake(15, 15)];
    [bezierPath2 addLineToPoint:CGPointMake(45, 45)];
    [bezierPath2 moveToPoint:CGPointMake(45, 15)];
    [bezierPath2 addLineToPoint:CGPointMake(15, 45)];
    
    _checkMarkShapeLayer.lineWidth = 5;
    _checkMarkShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _checkMarkShapeLayer.strokeColor = [UIColor redColor].CGColor;
    _checkMarkShapeLayer.lineCap = kCALineCapRound;
    _checkMarkShapeLayer.lineJoin = kCALineJoinRound;
    _checkMarkShapeLayer.strokeEnd = 0;
    
    if (rightOrWrong) {
        _checkMarkShapeLayer.path = bezierPath1.CGPath;
    }else {
        _checkMarkShapeLayer.path = bezierPath2.CGPath;
    }
    
    [_checkMarkView.layer addSublayer:_checkMarkShapeLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = .5f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.removedOnCompletion = NO;
    checkAnimation.fillMode = kCAFillModeForwards;

    [_checkMarkShapeLayer addAnimation:checkAnimation forKey:@"checkAnimation"];
    
    
   
    
}

- (void)hideHBCheckMarkView {
    
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
    }];
}

- (void)setPercent:(CGFloat)percent {

    _percent = percent;
    
    _topLayer.strokeEnd = _percent;
    if (_percent >= 1 && _checkMarkShapeLayer == nil) {
        [self drawCheckMarkViewWithResult:YES];
    }
}












@end
