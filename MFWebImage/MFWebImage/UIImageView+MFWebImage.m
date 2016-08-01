//
//  UIImageView+MFWebImage.m
//  MFWebImage
//
//  Created by MF on 16/8/1.
//  Copyright © 2016年 MF. All rights reserved.
//

#import "UIImageView+MFWebImage.h"
#import <objc/runtime.h>
#import "MFDownloadManager.h"

static NSString *kUrlString = @"kUrlString";
@implementation UIImageView (MFWebImage)


- (void)mf_webImageWithUrlstring:(NSString *)urlString placeHoldImage:(UIImage *)image {
//    判断操作是否存在，并且和和前一个操作不一样
    if (self.urlString != nil && ![self.urlString isEqualToString:urlString]) {
        [[MFDownloadManager shareManager] loadOperationWithUrlstring:urlString];        
    }
    
    [[MFDownloadManager shareManager] downloadWebImageWithUrlString:urlString completion:^(UIImage *image) {
        self.image = image;
    }];
    self.urlString = urlString;
}


-(void)setUrlString:(NSString *)urlString {
    
    objc_setAssociatedObject(self, (__bridge const void *)(kUrlString), urlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)urlString {
  return objc_getAssociatedObject(self, (__bridge const void *)(kUrlString));
}
@end
