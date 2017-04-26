//
//  GIFViewController.m
//  ShapeLayerTest
//
//  Created by mac on 2017/4/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GIFViewController.h"
#import <ImageIO/ImageIO.h>

@interface GIFViewController ()

@end

@implementation GIFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *dissmissBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    dissmissBtn.backgroundColor = [UIColor redColor];
    [dissmissBtn setTitle:@"dissmiss" forState:UIControlStateNormal];
    [self.view addSubview:dissmissBtn];
    [dissmissBtn addTarget:self action:@selector(dissmissBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImageView *gifView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width -100)/2, (self.view.frame.size.height -150)/2, 100, 150)];
    gifView.userInteractionEnabled = YES;
    NSString *gifStr = [[NSBundle mainBundle] pathForResource:@"hourglass.gif" ofType:nil];
    /** 使用ImageIO播放gif图片 */
    NSData *data = [NSData dataWithContentsOfFile:gifStr];
    CGImageSourceRef source =  CGImageSourceCreateWithData((CFDataRef)data, nil);
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *gifImgArray = [[NSMutableArray alloc] init];
    for (size_t i = 0; i < count; i ++) {
        CGImageRef cgImg = CGImageSourceCreateImageAtIndex(source, i, nil);
        UIImage *uiImg = [UIImage imageWithCGImage:cgImg];
        [gifImgArray addObject:uiImg];
    }
    UIImage *img = [UIImage animatedImageWithImages:gifImgArray duration:count * 0.1];
    gifView.image = img;
    [self.view addSubview:gifView];
//    self.gifImgView = gifView;
    
}

- (void)dissmissBtnAction {

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
