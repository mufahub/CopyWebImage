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
#import "MFAppinfoCell.h"

@interface ViewController ()

@property (nonatomic, strong)NSMutableArray *appinfos;

@property (nonatomic, strong)NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    self.queue = [[NSOperationQueue alloc] init];
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
//        NSLog(@"%@",self.appinfos);
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"加载失败");
    }];
}

#pragma mark --UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appinfos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MFAppinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    MFAppinfo *info = self.appinfos[indexPath.row];
    cell.nameLabel.text = info.name;
    cell.downloadLabel.text = info.download;
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:4];
        NSURL *url = [NSURL URLWithString:info.icon];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            cell.iconView.image = image;
        }];
    }];
    
    [self.queue addOperation:op];
    
    return cell;
}

@end
