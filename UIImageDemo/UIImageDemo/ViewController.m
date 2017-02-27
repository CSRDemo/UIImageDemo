//
//  ViewController.m
//  UIImageDemo
//
//  Created by User on 2017/2/27.
//  Copyright © 2017年 LeoAiolia. All rights reserved.
//

#import "ViewController.h"
@import ImageIO;
@import MobileCoreServices;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)jpgToPng
{
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    //png图片是无损的，因此没有质量银子
    NSData *data = UIImagePNGRepresentation(image);
    UIImage *pngImage = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(pngImage, nil, nil, nil);
}

- (void)jpgToJpg
{
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    //png图片是有损的，有质量银子,改变质量因子，可以改变图片的清晰度，相应的图片的大小也会改变
    NSData *data = UIImageJPEGRepresentation(image, 1);
    UIImage *jpgImage = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(jpgImage, nil, nil, nil);

}
//保存gif的每一帧图片
//1.拿到数据
//2.分解成每一帧
//3.将单帧转化为UIImage
//4.将image写入本地
- (void)saveSingleGifPic
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //将gif分解成每一帧
    size_t count = CGImageSourceGetCount(source);
    //帧数
//    NSLog(@"count = %zu",count);
    NSMutableArray *temImageArr = [NSMutableArray arrayWithCapacity:0];
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        //将单帧imageRef转化为image
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [temImageArr addObject:image];
        CGImageRelease(imageRef);
        
    }
    CFRelease(source);
    //单帧图片的保存
    NSInteger i = 0;
    for (UIImage *image in temImageArr) {
        NSData *data = UIImagePNGRepresentation(image);
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
        NSString *gifPath = path[0];
        NSString *pathName = [gifPath stringByAppendingString:[NSString stringWithFormat:@"%ld.png",i]];
        i ++;
        [data writeToFile:pathName atomically:NO];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
