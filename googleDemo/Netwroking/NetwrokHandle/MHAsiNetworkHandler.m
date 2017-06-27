//
//  MHAsiNetworkHandler.m
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "MHAsiNetworkHandler.h"
#import "MHAsiNetworkItem.h"
#import "AFNetworking.h"

@interface MHAsiNetworkHandler ()<MHAsiNetworkDelegate>

@end;

@implementation MHAsiNetworkHandler

+ (MHAsiNetworkHandler *)sharedInstance
{
    static MHAsiNetworkHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[MHAsiNetworkHandler alloc] init];
    });
    
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkError = NO;
    }
    return self;
}

#pragma mark - 创建一个网络请求项
/**
 *  创建一个网络请求项
 *
 *  @param url          网络请求URL
 *  @param networkType  网络请求方式
 *  @param params       网络请求参数
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return 根据网络请求的委托delegate而生成的唯一标示
 */
- (MHAsiNetworkItem*)conURL:(NSString *)url
                networkType:(MHAsiNetWorkType)networkType
                     params:(NSMutableDictionary *)params
                   delegate:(id)delegate
                    showHUD:(BOOL)showHUD
                     target:(id)target
                     action:(SEL)action
               successBlock:(MHAsiSuccessBlock)successBlock
               failureBlock:(MHAsiFailureBlock)failureBlock
{
 
    
    if (self.networkError == YES) {
        
//        SHOW_ALERT(@"Notice",@"Network connection failed, please check the network!");
        return nil;
    }
    /// 如果有一些公共处理，可以写在这里
    NSUInteger hashValue = [delegate hash];
   self.netWorkItem = [[MHAsiNetworkItem alloc]initWithtype:networkType url:url params:params delegate:delegate target:target action:action hashValue:hashValue showHUD:showHUD successBlock:successBlock failureBlock:failureBlock];
    self.netWorkItem.delegate = self;
    [self.items addObject:self.netWorkItem];
    return self.netWorkItem;
    
}

#pragma makr - 开始监听网络连接

+ (BOOL)startMonitoring
{

  __block  BOOL isNet ;
    // 1.获得网络监控的管理者
    __block  NSInteger i=0;
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                [MHAsiNetworkHandler sharedInstance].networkError = NO;
                isNet = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                NSLog(@"没网");
                [MHAsiNetworkHandler sharedInstance].networkError = YES;
                isNet = NO;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                [MHAsiNetworkHandler sharedInstance].networkError = NO;
                isNet = YES;
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [MHAsiNetworkHandler sharedInstance].networkError = NO;
                isNet = YES;
                NSLog(@"WIFI");
                break;
            default:
                break;
        }
      
        i++;
        NSLog(@"有没有网%ld",i);
    }];

    [mgr startMonitoring];
    return isNet;
}
/**
 *   懒加载网络请求项的 items 数组
 *
 *   @return 返回一个数组
 */
- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
/**
 *   取消所有正在执行的网络请求项
 */
+ (void)cancelAllNetItems
{
    MHAsiNetworkHandler *handler = [MHAsiNetworkHandler sharedInstance];
    [handler.items removeAllObjects];
    handler.netWorkItem = nil;
}

- (void)netWorkWillDealloc:(MHAsiNetworkItem *)itme
{

    [self.items removeObject:itme];
    self.netWorkItem = nil;
    
    NSLog(@"-----%@",self.items);

}
@end
