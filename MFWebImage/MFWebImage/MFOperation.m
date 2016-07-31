//
//  MFOperation.m
//  MFWebImage
//
//  Created by MF on 16/7/31.
//  Copyright © 2016年 MF. All rights reserved.
//

#import "MFOperation.h"

@interface MFOperation ()

@property (nonatomic, copy) NSString *urlString;
@end

@implementation MFOperation

/**
 *  根据传进来的地址创建一个操作
 *
 *  @param urlString URL地址
 *
 *  @return 实例对象
 */
+ (instancetype)operationWithUrlstring:(NSString *)urlString {
    MFOperation *op = [[MFOperation alloc] init];
    
    op.urlString = urlString;
    
    return op;
}

-(void)main {
    
    [NSThread sleepForTimeInterval:4];
    NSURL *url = [NSURL URLWithString:self.urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSString *cachePath = [self loadCacheDirectorWithUrlString:self.urlString];
//    把图片写进沙盒
//    [data writeToFile:cachePath atomically:YES];
    UIImage *image = [UIImage imageWithData:data];
    self.image = image;

}

//获取沙盒路径
- (NSString *)loadCacheDirectorWithUrlString:(NSString *)urlString {
    //    获取cache的路径
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    //    获取urlString的最后一个路径
    NSString *path = [urlString lastPathComponent];
    //    拼接路径
    NSString *cachePath = [cache stringByAppendingPathComponent:path];
    
    return cachePath;
    
}
@end
