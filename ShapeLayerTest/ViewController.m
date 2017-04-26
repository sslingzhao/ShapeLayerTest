//
//  ViewController.m
//  ShapeLayerTest
//
//  Created by mac on 2017/4/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "HBScaleMarkView.h"

#import "HBCheckMarkView.h"

#import "GIFViewController.h"

#define DegreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

#define MAXOFFSETANGLE 120.0f
#define MINOFFSETANGLE 30.0f
#define POINTEROFFSET  90.0f

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@interface ViewController ()

@property (nonatomic,assign) CGFloat startAngle;  // 开始的弧度
@property (nonatomic,assign) CGFloat endAngle;  // 结束的弧度
@property (nonatomic,assign) CGFloat radius; // 开始角度
@property (nonatomic,assign) CGFloat progressRadius; // 外层的开始角度

@property (nonatomic,assign) CGFloat center_X;  // 中心点 x
@property (nonatomic,assign) CGFloat center_Y;  // 中心点 y


@property (nonatomic,assign) CGFloat percent;


@property (nonatomic,strong) CAShapeLayer *slayer2;
@property (nonatomic,strong) CAShapeLayer *c_layer1;

@property (nonatomic,strong) CAShapeLayer *majorLayer;

@property (nonatomic, strong) NSMutableArray *mArr;

@property (nonatomic,strong) CALayer *testLayer;
@property (nonatomic,assign) CATransform3D transform;

@property (nonatomic, strong) UIBezierPath *t_path;
@property (nonatomic,strong) CAShapeLayer *t_layer;

@property (nonatomic,strong) CAGradientLayer *gradientLayer;

@property (nonatomic,strong) HBScaleMarkView *hbScaleMarkView; // 刻度线

@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) CAShapeLayer *topLayer;

@property (nonatomic,strong) NSArray *testArr;


@property (nonatomic,strong) UIView *zanView;

@property (nonatomic,strong) CAShapeLayer *checkMarkShapeLayer; // 对号
@property (nonatomic,strong) CAShapeLayer *wrongMarkShapeLayer; // 错号

@property (nonatomic,assign) BOOL isRightOrWrong;

@end

@implementation ViewController

- (CAShapeLayer *)t_layer {

    if (_t_layer == nil) {
        _t_layer = [CAShapeLayer layer];
    }
    return _t_layer;
}

- (UIBezierPath *)t_path {
    if (_t_path == nil) {
        _t_path = [UIBezierPath bezierPath];
    }
    return _t_path;
}

- (void)pushBtnAction {
    
    GIFViewController *gifCtrl = [[GIFViewController alloc] init];
    [self presentViewController:gifCtrl animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    pushBtn.backgroundColor = [UIColor redColor];
    [pushBtn setTitle:@"push to GIF" forState:UIControlStateNormal];
    [self.view addSubview:pushBtn];
    [pushBtn addTarget:self action:@selector(pushBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _mArr = [NSMutableArray array];
    
    _center_X = WIDTH/2;
    _center_Y = HEIGHT/2;
    _startAngle = -210;
    _endAngle = 30;

    // 绘制表盘
    [self setupHB];
    
    // 下载/下载进度
//    [self downLoadOrUpdate];
    
    // 伸缩动画
//    [self scaleAnimation];

    // 绘制对号 或者 错号
//    [self drawCheckMarkView];
    
    
    
    
//    HBCheckMarkView *checkView = [[HBCheckMarkView alloc] initWithFrame:CGRectZero];
    
//    [HBCheckMarkView hb_CheckMarkView];
//    checkView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:checkView];
    
    
    
//    _zanView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 20, 100)];
//    _zanView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_zanView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationRepeatCount:MAXFLOAT];
//    [UIView setAnimationDuration:1];
//    _zanView.transform = CGAffineTransformMakeScale(1, 1.2);
//    [UIView commitAnimations];
    
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, HEIGHT- 100, WIDTH -20, 100)];
    [_slider addTarget:self action:@selector(hbsiderAction) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
}

- (void)setupHB {
    
    _hbScaleMarkView = [[HBScaleMarkView alloc] initWithFrame:CGRectMake((WIDTH-300)/2, (HEIGHT-300)/2, 300, 300)];
    //    _hbScaleMarkView.backgroundColor = [UIColor blueColor];
    _hbScaleMarkView.center = self.view.center;
    _hbScaleMarkView.totalAngle = 260; // 总的角度大小 240
    _hbScaleMarkView.startAngle = 130; // 开始角度 -120
    _hbScaleMarkView.scaleMarkRadius = 160; // 半径 160
    _hbScaleMarkView.longScaleMark = 25; //长刻度 25
    _hbScaleMarkView.shortScaleMark = 15; //端刻度 15
    _hbScaleMarkView.pre_lineEnd = 40; // 40
    _hbScaleMarkView.scoleNum = 1;
    _hbScaleMarkView.gradientColorArr = [NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor yellowColor] CGColor], nil];
    _hbScaleMarkView.gradientStartPoint = CGPointMake(1.0, 0.0);
    _hbScaleMarkView.gradientEndPoint = CGPointMake(0, 1);
    [self.view addSubview:_hbScaleMarkView];
    
    [_hbScaleMarkView setLineMark:90 withCurrentNum:90 withBool:YES];
    
    [_hbScaleMarkView setLongAndShortLineMark:90 withCurrentNum:90 withBool:YES];
}

- (void)downLoadOrUpdate {

    // 下载上传进度条
    CGPoint center = CGPointMake(WIDTH/2.0, HEIGHT/2.0);
    CGFloat radius = 50;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = M_PI*3.0/2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer *bottomLayer = [CAShapeLayer layer];
    bottomLayer.path = path.CGPath;
    bottomLayer.lineWidth = 10;
    bottomLayer.frame = self.view.bounds;
    bottomLayer.fillColor = [UIColor clearColor].CGColor;
    bottomLayer.strokeColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:bottomLayer];
    
    
    _topLayer = [CAShapeLayer layer];
    _topLayer.path = path.CGPath;
    _topLayer.frame = self.view.bounds;
    _topLayer.fillColor = [UIColor clearColor].CGColor;
    _topLayer.strokeColor = [UIColor yellowColor].CGColor;
    _topLayer.lineCap = kCALineCapRound;
    _topLayer.strokeEnd = 0;
    _topLayer.lineWidth = 10;
    [self.view.layer addSublayer:_topLayer];

}

- (void)scaleAnimation {
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH-20)/2, (HEIGHT-40)/2, 20, 40)];
    tipView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tipView];
    
    // 伸缩动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationDuration:1];
    tipView.transform = CGAffineTransformMakeScale(1, 1.2);
    
    [UIView commitAnimations];
}

- (void)hbsiderAction {
    
//    NSLog(@"---%f", _slider.value);
    _topLayer.strokeEnd = _slider.value;
//    if (_slider.value == 1) {
//        [_zanView.layer removeAllAnimations];
        
//        [HBCheckMarkView showDownloadWithPercent:_slider.value];
        [HBCheckMarkView showUploadWithPercent:_slider.value];
//    }
    if (_slider.value == 1) {
        [HBCheckMarkView showCheckMarkViewWithResult:YES];
        
//        [HBCheckMarkView hideHBCheckMarkView];
    }
    
}


- (void)drawCheckMarkView {
    
    UIView *checkMarkView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH-100)/2, (HEIGHT-100)/2 +200, 100, 100)];
    checkMarkView.layer.cornerRadius = 50;
    checkMarkView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:checkMarkView];
    
    _checkMarkShapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(100/5, 100/2)];
    [bezierPath1 addLineToPoint:CGPointMake(100/2, 75)];
    [bezierPath1 addLineToPoint:CGPointMake(100 * 4/5, 30)];
    
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
    [bezierPath2 moveToPoint:CGPointMake(25, 25)];
    [bezierPath2 addLineToPoint:CGPointMake(75, 75)];
    [bezierPath2 moveToPoint:CGPointMake(75, 25)];
    [bezierPath2 addLineToPoint:CGPointMake(25, 75)];

    _checkMarkShapeLayer.lineWidth = 15;
    _checkMarkShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _checkMarkShapeLayer.strokeColor = [UIColor redColor].CGColor;
    _checkMarkShapeLayer.lineCap = kCALineCapRound;
    _checkMarkShapeLayer.lineJoin = kCALineJoinRound;
    
    if (_isRightOrWrong) {
        _checkMarkShapeLayer.path = bezierPath1.CGPath;
    }else {
        _checkMarkShapeLayer.path = bezierPath2.CGPath;
    }
    
    [checkMarkView.layer addSublayer:_checkMarkShapeLayer];

    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 1.f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    [_checkMarkShapeLayer addAnimation:checkAnimation forKey:@"checkAnimation"];
    
}

- (void)drawScale {
    
    CGFloat ScaleWidth = 1;
    //总刻度
    CGFloat totalScale = _percent*50;
//    CGFloat totalScale = 100;
    //每个刻度旋转的度数
    CGFloat perAngle;
    //每个刻度旋转的度数
    perAngle = (_endAngle - _startAngle)/50;
    
    CGFloat lineWidth1;
    UIColor *color;
    CGFloat startAng = 0.0;
    CGFloat endAng = 0.0;
    for (NSInteger i = 0; i < totalScale + 1; i ++) {
        
        startAng = _startAngle + perAngle*i;
        //刻度结束度数
//        endAng = startAng + ScaleWidth/*线宽*//(2*M_PI*100/*圆半径*/)*360;
        endAng   = startAng + perAngle/10;
        if (i == _percent*50) {
            lineWidth1 = 60;
//            color = [UIColor redColor];
        }else {
            lineWidth1 = 30;
//            color = [UIColor blackColor];
        }
        
    
        UIBezierPath *majorPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:100 startAngle:DegreesToRadians(startAng) endAngle:DegreesToRadians(endAng) clockwise:YES];
        _majorLayer = [CAShapeLayer layer];
        _majorLayer.strokeColor = [UIColor redColor].CGColor;
        _majorLayer.path = [majorPath CGPath];
        _majorLayer.lineWidth = lineWidth1;
    //    _majorLayer.strokeStart = 0;
    //    _majorLayer.strokeEnd = _percent;
    //    [self shapeChange];
        [self.view.layer addSublayer:_majorLayer];
        [self.view.layer insertSublayer:_majorLayer atIndex:0];
//        [_mArr addObject:_majorLayer];
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 传入百分比的时候，传入 小数，  0.1 - 1 范围内  <==>  1 - 100
    self.percent = arc4random_uniform(50 + 1) /50.;
//    _majorLayer.strokeEnd = 0;
//    [self drawScale];
//    NSLog(@"--%f  %f", self.percent, _percent *(130.0/140));
    
    for (CAShapeLayer *layer in _mArr) {
        [layer removeFromSuperlayer];
    }
    [_mArr removeAllObjects];
    
//    [self drawScale];//旋转

    
    self.percent = arc4random_uniform(90 + 1);
//    [self setLineMark:80 withCurrentNum:80];
//    [self setLineMark:80 withCurrentNum:self.percent withBool:NO];
    
    [_hbScaleMarkView removeShapeLayer];
    
    [_hbScaleMarkView setLineMark:90 withCurrentNum:self.percent withBool:NO];
    
    // 绘制对号✅或者差号❎
    _isRightOrWrong = !_isRightOrWrong;
//    [self drawCheckMarkView];
    
    
//    [HBCheckMarkView showDownloadWithPercent:0];
//    [HBCheckMarkView showUploadWithPercent:0];
    
}

- (void)setLineMark:(NSInteger)labelNum withCurrentNum:(NSInteger)currentNum withBool:(BOOL)isFirst {
    
    CGFloat angelDis = (240)/labelNum;
    CGFloat radius = 160;//self.center.x;
    CGFloat value1 = isFirst ? 25 : 15;
    CGFloat currentAngle;
    CGPoint centerPoint = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    CGFloat scoleNum = 1;
    
    
    UIBezierPath *t_path = [UIBezierPath bezierPath];
//    CAShapeLayer *t_layer = [CAShapeLayer layer];
    for(int i=0;i<=currentNum;i++) {
        
        currentAngle = -120 + i * angelDis - POINTEROFFSET;//POINTEROFFSET;
        
        if(i==currentNum) {
            
//            path = [UIBezierPath bezierPath];
            // 添加路径[1条点(100,100)到点(200,100)的线段]到path
            CGFloat x_max1 = centerPoint.x+[self parseToX:radius-value1*scoleNum Angle:currentAngle];
            CGFloat y_max1 = centerPoint.y+[self parseToY:radius-value1*scoleNum Angle:currentAngle];
            CGFloat x_max2 = centerPoint.x+[self parseToX:radius-40*scoleNum Angle:currentAngle];
            CGFloat y_max2 = centerPoint.y+[self parseToY:radius-40*scoleNum Angle:currentAngle];
            [t_path moveToPoint:CGPointMake(x_max1, y_max1)];
            [t_path addLineToPoint:CGPointMake(x_max2, y_max2)];
            
        }else{
            
            CGFloat x_i1 = centerPoint.x+[self parseToX:radius-25*scoleNum Angle:currentAngle];
            CGFloat y_i1 = centerPoint.y+[self parseToY:radius-25*scoleNum Angle:currentAngle];
            
            CGFloat x_i2 = centerPoint.x+[self parseToX:radius-40*scoleNum Angle:currentAngle];
            CGFloat y_i2 = centerPoint.y+[self parseToY:radius-40*scoleNum Angle:currentAngle];
        
            [t_path moveToPoint:CGPointMake(x_i1, y_i1)];
            [t_path addLineToPoint:CGPointMake(x_i2, y_i2)];
        }
        
        self.t_layer = [CAShapeLayer layer];
        self.t_layer.path = t_path.CGPath;
        self.t_layer.strokeColor = isFirst ? [UIColor lightGrayColor].CGColor : [UIColor redColor].CGColor;
        
        if (_gradientLayer) {
            [_gradientLayer removeFromSuperlayer];
        }
        
//        CALayer *gradientLayer = [CALayer layer];
        _gradientLayer =  [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor yellowColor] CGColor], nil]];
//        _gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
        [_gradientLayer setStartPoint:CGPointMake(1.0, 0.0)];
        [_gradientLayer setEndPoint:CGPointMake(0, 1)];

        if (isFirst) {
            [self.view.layer addSublayer:self.t_layer];
        }else {
            
            [_gradientLayer setMask:self.t_layer];
            
            [self.view.layer addSublayer:_gradientLayer];
        }
        
        
        
        
        
        
        
        if (!isFirst) {
            
            [_mArr addObject:self.t_layer];
        }
        
    }
}

//- (CGFloat )percent
//{
//    return _percent;
//}
- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    
    if (percent >= 1) {
        percent = 0.9;
    }else if (percent < 0){
        percent = 0;
    }
    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0];
}

- (void)shapeChange {

    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
//    _slayer2.strokeEnd = 0 ;
//    _majorLayer.strokeEnd = 0;
//    _c_layer1.strokeEnd = 0;

    
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0.f];
    _slayer2.strokeEnd = _percent;
    _majorLayer.strokeEnd = _percent;
    _c_layer1.strokeEnd = _percent;// - 0.01;
    [CATransaction commit];
    
//    _slayer2.lineWidth = 40;
    
}

/*
 * parseToX 角度转弧度
 * @angel CGFloat 角度
 */
-(CGFloat)transToRadian:(CGFloat)angel
{
    return angel*M_PI/180;
}


/*
 * parseToX 根据角度，半径计算X坐标
 * @radius CGFloat 半径
 * @angle  CGFloat 角度
 */
- (CGFloat) parseToX:(CGFloat) radius Angle:(CGFloat)angle
{
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*cos(tempRadian);
}

/*
 * parseToY 根据角度，半径计算Y坐标
 * @radius CGFloat 半径
 * @angle  CGFloat 角度
 */
- (CGFloat) parseToY:(CGFloat) radius Angle:(CGFloat)angle
{
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*sin(tempRadian);
}




- (void)shapelayerTest {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_center_X/2, _center_Y/2) radius:100 startAngle:DegreesToRadians(_startAngle) endAngle:DegreesToRadians(_endAngle) clockwise:YES];
    
    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.backgroundColor = [UIColor blackColor].CGColor;
    slayer.frame = CGRectMake(0, 0, WIDTH/2, HEIGHT/2);
    slayer.path = bezierPath.CGPath;
    slayer.lineCap = kCALineCapButt;
    slayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:10], nil];
    slayer.lineWidth = 10;
    slayer.strokeColor = [UIColor lightGrayColor].CGColor;
    slayer.fillColor = [UIColor clearColor].CGColor;
    //    [self.view.layer addSublayer:slayer];
    //-----------------------//
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_center_X/2, _center_Y/2) radius:50 startAngle:DegreesToRadians(_startAngle) endAngle:DegreesToRadians(_endAngle-5) clockwise:YES];
    
    CAShapeLayer *slayer1 = [CAShapeLayer layer];
    slayer1.backgroundColor = [UIColor redColor].CGColor;
    slayer1.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, HEIGHT/2);
    slayer1.path = bezierPath1.CGPath;
    slayer1.lineCap = kCALineCapButt;
    slayer1.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
    slayer1.lineWidth = 10;
    slayer1.strokeColor = [UIColor blueColor].CGColor;
    slayer1.fillColor = [UIColor clearColor].CGColor;
    //    [self.view.layer addSublayer:slayer1];
    
    
    // layer
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_center_X, _center_Y) radius:140 startAngle:DegreesToRadians(_startAngle) endAngle:DegreesToRadians(_endAngle-5) clockwise:YES];
    
    _slayer2 = [CAShapeLayer layer];
    _slayer2.frame = CGRectMake(0, 0, WIDTH, WIDTH);
    _slayer2.path = bezierPath2.CGPath;
    _slayer2.strokeStart = 0;
    _slayer2.strokeEnd = 0;
    _slayer2.lineCap = kCALineCapButt;
    _slayer2.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:10], nil];
    _slayer2.lineWidth = 40;
    _slayer2.strokeColor = [UIColor redColor].CGColor;
    _slayer2.fillColor = [UIColor clearColor].CGColor;
    
    //    [self.view.layer addSublayer:_slayer2];
    
    
    
    //    [self drawScale];
    
    
    // 画圆
    UIBezierPath *c_path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_center_X, _center_Y) radius:90 startAngle:DegreesToRadians(0) endAngle:DegreesToRadians(360) clockwise:YES];;//[UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 100, 100) cornerRadius:50];
    CAShapeLayer *c_layer = [CAShapeLayer layer];
    c_layer.path = c_path.CGPath;
    c_layer.fillColor = [UIColor whiteColor].CGColor;
    c_layer.strokeColor = [UIColor blueColor].CGColor;
    //    [self.view.layer addSublayer:c_layer];
    
    
    
    UIBezierPath *c_path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_center_X, _center_Y) radius:150 startAngle:DegreesToRadians(_startAngle) endAngle:DegreesToRadians(_endAngle ) clockwise:YES];;//[UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 100, 100) cornerRadius:50];
    _c_layer1 = [CAShapeLayer layer];
    _c_layer1.path = c_path1.CGPath;
    _c_layer1.lineCap = kCALineCapButt;
    _c_layer1.strokeStart = 0;
    _c_layer1.strokeEnd = 0;
    _c_layer1.lineWidth = 20;
    //    _c_layer1.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:1], nil];
    _c_layer1.fillColor = [UIColor clearColor].CGColor;
    _c_layer1.strokeColor = [UIColor lightGrayColor].CGColor;
    //    [self.view.layer addSublayer:_c_layer1];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
