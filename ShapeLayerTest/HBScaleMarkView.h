//
//  HBScaleMarkView.h
//  ShapeLayerTest
//
//  Created by mac on 2017/4/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBScaleMarkView : UIView

@property(nonatomic, assign) CGFloat totalAngle; // 总的角度大小 240
@property(nonatomic, assign) CGFloat startAngle; // 开始角度 -120
@property(nonatomic, assign) CGFloat endAngle; // 结束角度

@property(nonatomic, assign) CGFloat scaleMarkRadius; // 最大半径 160

@property(nonatomic, assign) CGFloat longScaleMark; //长刻度 25
@property(nonatomic, assign) CGFloat shortScaleMark; //端刻度 15
@property(nonatomic, assign) CGFloat pre_lineEnd; // 40

@property(nonatomic, assign) CGFloat scoleNum;

@property(nonatomic, strong) NSArray *gradientColorArr;

@property(nonatomic, assign) CGPoint gradientStartPoint;
@property(nonatomic, assign) CGPoint gradientEndPoint;

@property (nonatomic,assign) CGFloat percent;



- (void)setLineMark:(NSInteger)labelNum withCurrentNum:(NSInteger)currentNum withBool:(BOOL)isFirst;

- (void)setLongAndShortLineMark:(NSInteger)labelNum withCurrentNum:(NSInteger)currentNum withBool:(BOOL)isFirst;

- (void)removeShapeLayer;


@end
