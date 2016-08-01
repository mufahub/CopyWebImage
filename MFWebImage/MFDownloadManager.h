//
//  MFDownloadManager.h
//  MFWebImage
//
//  Created by MF on 16/7/31.
//  Copyright © 2016年 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFDownloadManager : NSObject

/**
 *  单例，下载控制器
 */
+ (instancetype)shareManager;
/**
 *  一个对象方法，根据传进来的地址，加载网络图片
 */
- (void)downloadWebImageWithUrlString:(NSString *)urlString completion:(void(^)(UIImage *image))completion;

- (void)loadOperationWithUrlstring:(NSString *)urlString;
@end
