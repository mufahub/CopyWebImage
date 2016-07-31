//
//  MFDownloadManager.m
//  MFWebImage
//
//  Created by MF on 16/7/31.
//  Copyright © 2016年 MF. All rights reserved.
//

#import "MFDownloadManager.h"
#import "MFOperation.h"

@interface MFDownloadManager ()
//内存图片缓存
@property (nonatomic, strong)NSMutableDictionary *imageCache;
//操作字典
@property (nonatomic, strong)NSMutableDictionary *operationCache;
//队列
@property (nonatomic, strong)NSOperationQueue *queue;
@end

@implementation MFDownloadManager

/**
 *  单例
 */
+ (instancetype)shareManager {
    static MFDownloadManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        初始化两个字典和一个队列
        self.imageCache = [NSMutableDictionary dictionary];
        self.operationCache = [NSMutableDictionary dictionary];
        self.queue = [[NSOperationQueue alloc] init];
    }
    return self;
}
//加载网络图片
- (void)downloadWebImageWithUrlString:(NSString *)urlString completion:(void(^)(UIImage *image))completion {
//    判断内存中使是否有图片
    UIImage *cacheImage = self.imageCache[urlString];
    if (cacheImage != nil) {
        NSLog(@"从内存中加载");
        completion(cacheImage);
        return;
    }
//    判断沙盒中是否有图片
    NSString *cachePath = [self loadCacheDirectorWithUrlString:urlString];
    cacheImage = [UIImage imageWithContentsOfFile:cachePath];
    if (cacheImage != nil) {
        NSLog(@"从沙盒中加载");
//    图片放入内存中一份
        [self.imageCache setObject:cacheImage forKey:urlString];
        completion(cacheImage);
        return;
    }
    
//    判断是否有操作
    if (self.operationCache[urlString] != nil) {
        NSLog(@"操作已经存在，请稍等");
        return;
    }
//    创建一个自定义的操作
    MFOperation *op = [MFOperation operationWithUrlstring:urlString];
    
    __weak MFOperation *weakself = op;
    [op setCompletionBlock:^{
        
        UIImage *image = weakself.image;
        
        [self.imageCache setObject:image forKey:urlString];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.operationCache removeObjectForKey:urlString];
            completion(image);
        }];
        
        
    }];
    
    
    [self.queue addOperation:op];
    [self.operationCache setObject:op forKey:urlString];
    NSLog(@"创建一个操作，添到队列中");
////    如果没有操作，就创建一个自定义的操作
//    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//        
//        [NSThread sleepForTimeInterval:3];
//        NSURL *url = [NSURL URLWithString:urlString];
//        
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        
//        NSString *cachePath = [self loadCacheDirectorWithUrlString:urlString];
//        [data writeToFile:cachePath atomically:YES];
//
//        UIImage *image = [UIImage imageWithData:data];
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            
//            [self.operationCache removeObjectForKey:urlString];
//            completion(image);
//        }];
//        
//        
//        
//    }];
//    [self.operationCache setObject:op forKey:urlString];
//    [self.queue addOperation:op];
//    NSLog(@"创建一个操作，加入队列中");
    
}


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
