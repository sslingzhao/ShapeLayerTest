//
//  HBScaleMarkView.m
//  ShapeLayerTest
//
//  Created by mac on 2017/4/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HBScaleMarkView.h"


#define MAX_OFFSET_ANGLE 120.0f
#define MIN_OFFSET_ANGLE 30.0f
#define POINTER_OFFSET  90.0f
#define DEFLUAT_SIZE 300

@interface HBScaleMarkView()

//@property(nonatomic, strong) UIBezierPath *t_path;
@property (nonatomic,strong) CAShapeLayer *t_layer;

@property (nonatomic,strong) CAGradientLayer *gradientLayer;


@property(nonatomic, strong) NSMutableArray *mArr;

@end

@implementation HBScaleMarkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _mArr = [NSMutableArray array];
        
        // 默认值
        _scoleNum = DEFLUAT_SIZE / frame.size.width;
        _totalAngle = 240;
        _startAngle = -120;
        _scaleMarkRadius = 160;
        _longScaleMark = 25;
    }
    return self;
}


- (CAShapeLayer *)t_layer {
    
    if (_t_layer == nil) {
        _t_layer = [CAShapeLayer layer];
    }
    return _t_layer;
}

- (void)removeShapeLayer {
    
    for (CAShapeLayer *layer in _mArr) {
        [layer removeFromSuperlayer];
    }
    [_mArr removeAllObjects];
}

- (void)setLineMark:(NSInteger)labelNum withCurrentNum:(NSInteger)currentNum withBool:(BOOL)isFirst {
    
//    self.percent = currentNum;
    
    CGFloat angelDis = _totalAngle/labelNum;
    CGFloat radius = _scaleMarkRadius;//self.center.x;
    CGFloat value1 = isFirst ? _longScaleMark : _shortScaleMark;
    CGFloat currentAngle;
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
//    CGFloat scoleNum = 1;
    
    UIBezierPath *t_path = [UIBezierPath bezierPath];
    for(int i = 0; i <= currentNum; i ++) {
        
        currentAngle = -_startAngle + i * angelDis - POINTER_OFFSET;
        
        CGFloat lineEnd_x = centerPoint.x+[self parseToX:radius - _pre_lineEnd*_scoleNum Angle:currentAngle];
        CGFloat lineStart_y = centerPoint.y+[self parseToY:radius - _pre_lineEnd*_scoleNum Angle:currentAngle];
        
        if(i==currentNum) {
        
            CGFloat x_max1 = centerPoint.x+[self parseToX:radius-value1*_scoleNum Angle:currentAngle];
            CGFloat y_max1 = centerPoint.y+[self parseToY:radius-value1*_scoleNum Angle:currentAngle];
            
            [t_path moveToPoint:CGPointMake(x_max1, y_max1)];
            [t_path addLineToPoint:CGPointMake(lineEnd_x, lineStart_y)];
            
        }else{
            
            CGFloat x_i1 = centerPoint.x+[self parseToX:radius-_longScaleMark*_scoleNum Angle:currentAngle];
            CGFloat y_i1 = centerPoint.y+[self parseToY:radius-_longScaleMark*_scoleNum Angle:currentAngle];
            
//            CGFloat x_i2 = centerPoint.x+[self parseToX:radius-40*scoleNum Angle:currentAngle];
//            CGFloat y_i2 = centerPoint.y+[self parseToY:radius-40*scoleNum Angle:currentAngle];
            
            [t_path moveToPoint:CGPointMake(x_i1, y_i1)];
            [t_path addLineToPoint:CGPointMake(lineEnd_x, lineStart_y)];
        }
        
        self.t_layer = [CAShapeLayer layer];
        self.t_layer.path = t_path.CGPath;
        self.t_layer.strokeColor = isFirst ? [UIColor lightGrayColor].CGColor : [UIColor redColor].CGColor;
//        self.t_layer.strokeStart = 0;
//        self.t_layer.strokeEnd = 0;
        self.t_layer.allowsEdgeAntialiasing = YES;
        self.t_layer.contentsScale = [[UIScreen mainScreen] scale];
        
        
        if (_gradientLayer) {
            [_gradientLayer removeFromSuperlayer];
        }
        _gradientLayer =  [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_gradientLayer setColors:_gradientColorArr];
//        _gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
        [_gradientLayer setStartPoint:_gradientStartPoint];
        [_gradientLayer setEndPoint:_gradientEndPoint];
        
        if (isFirst) {
            [self.layer addSublayer:self.t_layer];
        }else {
            
            [_gradientLayer setMask:self.t_layer];
            [self.layer addSublayer:_gradientLayer];
        }

        if (!isFirst) {
            
            [_mArr addObject:self.t_layer];
        }        
    }
}


- (void)setLongAndShortLineMark:(NSInteger)labelNum withCurrentNum:(NSInteger)currentNum withBool:(BOOL)isFirst {
    
    //    self.percent = currentNum;
    
    CGFloat angelDis = _totalAngle/labelNum;
    CGFloat radius = 140;//self.center.x;
    CGFloat value1 = isFirst ? _longScaleMark : _shortScaleMark;
    CGFloat currentAngle;
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //    CGFloat scoleNum = 1;
    
    CGFloat prelineEnd;
    UIBezierPath *t_path = [UIBezierPath bezierPath];
    for(int i = 0; i <= currentNum; i ++) {
        
        currentAngle = -_startAngle + i * angelDis - POINTER_OFFSET;
        
        prelineEnd = (i%9 == 0) ? 37 :35;
        
        CGFloat lineEnd_x = centerPoint.x+[self parseToX:radius - prelineEnd*_scoleNum Angle:currentAngle];
        CGFloat lineStart_y = centerPoint.y+[self parseToY:radius - prelineEnd*_scoleNum Angle:currentAngle];
        
        if(i%9 == 0) {
            
            CGFloat x_max1 = centerPoint.x+[self parseToX:radius-30*_scoleNum Angle:currentAngle];
            CGFloat y_max1 = centerPoint.y+[self parseToY:radius-30*_scoleNum Angle:currentAngle];
            
            [t_path moveToPoint:CGPointMake(x_max1, y_max1)];
            [t_path addLineToPoint:CGPointMake(lineEnd_x, lineStart_y)];
            
        }else{
            
            CGFloat x_i1 = centerPoint.x+[self parseToX:radius-32*_scoleNum Angle:currentAngle];
            CGFloat y_i1 = centerPoint.y+[self parseToY:radius-32*_scoleNum Angle:currentAngle];
            
            //            CGFloat x_i2 = centerPoint.x+[self parseToX:radius-40*scoleNum Angle:currentAngle];
            //            CGFloat y_i2 = centerPoint.y+[self parseToY:radius-40*scoleNum Angle:currentAngle];
            
            [t_path moveToPoint:CGPointMake(x_i1, y_i1)];
            [t_path addLineToPoint:CGPointMake(lineEnd_x, lineStart_y)];
        }
        
        self.t_layer = [CAShapeLayer layer];
        self.t_layer.path = t_path.CGPath;
        self.t_layer.strokeColor = isFirst ? [UIColor lightGrayColor].CGColor : [UIColor redColor].CGColor;
        //        self.t_layer.strokeStart = 0;
        //        self.t_layer.strokeEnd = 0;
        
//        self.t_layer.allowsEdgeAntialiasing = YES;
        self.t_layer.contentsScale = [[UIScreen mainScreen] scale];
        
//        self.t_layer.shouldRasterize = YES;
//        self.t_layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        
        if (_gradientLayer) {
            [_gradientLayer removeFromSuperlayer];
        }
        _gradientLayer =  [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_gradientLayer setColors:_gradientColorArr];
        //        _gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
        [_gradientLayer setStartPoint:_gradientStartPoint];
        [_gradientLayer setEndPoint:_gradientEndPoint];
        
        if (isFirst) {
            [self.layer addSublayer:self.t_layer];
        }else {
            
            [_gradientLayer setMask:self.t_layer];
            [self.layer addSublayer:_gradientLayer];
        }
        
        if (!isFirst) {
            
            [_mArr addObject:self.t_layer];
        }        
    }
}





- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    
    if (percent >= 1) {
        percent = 0.9;
    }else if (percent < 0){
        percent = 0;
    }
    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0];
}

// 动画效果 暂未完成
- (void)shapeChange {
    
    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
    self.t_layer.strokeEnd = 0;
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:2.f];
    self.t_layer.strokeEnd = _percent;
    [CATransaction commit];
    
}



/*
 * parseToX 角度转弧度
 * @angel CGFloat 角度
 */
-(CGFloat)transToRadian:(CGFloat)angel {
    
    return angel*M_PI/180;
}


/*
 * parseToX 根据角度，半径计算X坐标
 * @radius CGFloat 半径
 * @angle  CGFloat 角度
 */
- (CGFloat)parseToX:(CGFloat)radius Angle:(CGFloat)angle {
    
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*cos(tempRadian);
}

/*
 * parseToY 根据角度，半径计算Y坐标
 * @radius CGFloat 半径
 * @angle  CGFloat 角度
 */
- (CGFloat)parseToY:(CGFloat)radius Angle:(CGFloat)angle {
    
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*sin(tempRadian);
}


@end
