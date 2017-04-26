//
//  HBCheckMarkView.h
//  ShapeLayerTest
//
//  Created by mac on 2017/4/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBCheckMarkView : UIView

/**
 展示下载进度提示、

 @param percent 下载进度
 */
+ (void)showDownloadWithPercent:(CGFloat)percent;

/**
 展示上传进度提示

 @param percent 上传进度
 */
+ (void)showUploadWithPercent:(CGFloat)percent;

/**
 展示下载/上传结果

 @param rightOrWrong 绘制对号 错号
 */
+ (void)showCheckMarkViewWithResult:(BOOL)rightOrWrong;

/**
 隐藏进度条
 */
+ (void)hideHBCheckMarkView;


@end
