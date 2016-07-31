//
//  ViewController.m
//  MFWebImage
//
//  Created by MF on 16/7/31.
//  Copyright © 2016年 MF. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MFAppinfo.h"

@interface ViewController ()

@property (nonatomic, strong)NSMutableArray *appinfos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}


- (NSMutableArray *)appinfos {
    if (!_appinfos) {
        _appinfos = [[NSMutableArray alloc] init];
    }
    return _appinfos;
}
- (void)loadData {
    NSString *str = @"https://raw.githubusercontent.com/yinqiaoyin/SimpleDemo/master/apps.json";
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tempArray = responseObject;
        
        for (NSDictionary *dict in tempArray) {
            MFAppinfo *info = [[MFAppinfo alloc] init];
            [info setValuesForKeysWithDictionary:dict];
            [self.appinfos addObject:info];
        }
        NSLog(@"%@",self.appinfos);
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"加载失败");
    }];
}

@end
