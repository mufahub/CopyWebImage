//
//  MFOperation.h
//  MFWebImage
//
//  Created by MF on 16/7/31.
//  Copyright © 2016年 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFOperation : NSOperation

//保存加载的网络图片
@property (nonatomic, strong)UIImage *image;
/**
 *  一个类方法，根据传进来的地址，创建操作
 */

+ (instancetype)operationWithUrlstring:(NSString *)urlString;
@end
