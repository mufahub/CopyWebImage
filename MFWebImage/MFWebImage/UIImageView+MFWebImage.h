//
//  UIImageView+MFWebImage.h
//  MFWebImage
//
//  Created by MF on 16/8/1.
//  Copyright © 2016年 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MFWebImage)

@property (nonatomic, copy) NSString *urlString;

- (void)mf_webImageWithUrlstring:(NSString *)urlString placeHoldImage:(UIImage *)image;
@end
