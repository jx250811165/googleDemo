//
//  MHAsiNetworkItem.m
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "MHAsiNetworkItem.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#define sysToken  @"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjRiOTM4NDJmYmM0NGIyOTBiYTNhNjE1MzhkMDYzODQ1ODg3YzUwZGVlNmQ0OTk3MTg2Mjc4OWI5M2NiMzU1ZTkzODk0YTM3NjJmMzYxYmYwIn0.eyJhdWQiOiIxIiwianRpIjoiNGI5Mzg0MmZiYzQ0YjI5MGJhM2E2MTUzOGQwNjM4NDU4ODdjNTBkZWU2ZDQ5OTcxODYyNzg5YjkzY2IzNTVlOTM4OTRhMzc2MmYzNjFiZjAiLCJpYXQiOjE0NzkyMDEwMzksIm5iZiI6MTQ3OTIwMTAzOSwiZXhwIjo0NjM0ODc0NjM5LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.fig-HkeAaZASzOz6Y2cm9dKpkOTrMamHd66ZUIOk7Z2JocnxaeHH5pDp_cJyc8W4WS1cNXw1WemQxNfZrcEMDAYg0AkQtI-uMf0m5Q7cjveq3uZ9kSa-KXb0qhTz3crRVtWfU1YGbO4vIoDJsiG3nZaPz_qiXHWU-6tvX86MJ4jV7jbhuvnQEw3HWUmERwTCXGkbesJl1Q7Wg13KGJFH712sXqcSgdfnAA2tV2FRgYOnneSvEutBeSxPpoKxQk6IanaTfGdwCsp0jEugaDtckp57L2jV2uLgU0Ib9of5MkkJjlULUX-AnoTi6w12IMLJeccLKuIJkf-otmeX-_xoMURPSB1ZWmYw7juAIDA64x-BsVp-j-HMxJv4W0wPr7S_KZm72NkQNSj_xhn8p85gBMFtksaa761cCLPhf5T4-udoQwyx5iSsUsNLbe5KLzuYF5XQYOxUE70GX-jzgowUJIOCy0oIze3daE8rAw7z-bLTbpwfC6H9Wml6lKgIIUrYuSjXJ5xe-8L7ZqDcxClsmeRvw-aEGVIYzeZN8QqkBLd4zpEzuwFLEqPOrP3HriQdzBAQeRzaIBUCaCJF7g_mhpjO4kl7zdDgQEghsIerEwN4-rtby-j_s09T70DvRIZOeKDqkCkQomx1vJS2kbN4d5B_RHZV83M9sJZavymqcuA"




@interface MHAsiNetworkItem ()

//@property (nonatomic,strong) BR_HUDView *customHudView;

@property (nonatomic,strong) UIView *bgview;

@end

@implementation MHAsiNetworkItem


//- (BR_HUDView *)customHudView
//{
//    if (!_customHudView) {
//        
//        _customHudView = [[BR_HUDView alloc] init];
//        _customHudView.backLeft = _customHudView.backRight = _customHudView.backTop = _customHudView.backBottom = 20;
//        _customHudView.centerHeight = 10;
//        _customHudView.backColor = [UIColor grayColor];
//        
//        ;
//        self.bgview =(UIView*)[[[UIApplication sharedApplication]delegate]window];
//        _customHudView.bgViewCenter = self.bgview.center;
//        
//    }
//    return _customHudView;
//}




#pragma mark - 创建一个网络请求项，开始请求网络
/**
 *  创建一个网络请求项，开始请求网络
 *
 *  @param networkType  网络请求方式
 *  @param url          网络请求URL
 *  @param params       网络请求参数
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param hashValue    网络请求的委托delegate的唯一标示
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return MHAsiNetworkItem对象
 */
- (MHAsiNetworkItem *)initWithtype:(MHAsiNetWorkType)networkType
                               url:(NSString *)url
                            params:(NSDictionary *)params
                          delegate:(id)delegate
                            target:(id)target
                            action:(SEL)action
                         hashValue:(NSUInteger)hashValue
                           showHUD:(BOOL)showHUD
                      successBlock:(MHAsiSuccessBlock)successBlock
                      failureBlock:(MHAsiFailureBlock)failureBlock
{
    if (self = [super init])
    {
        self.networkType    = networkType;
        self.url            = url;
        self.params         = params;
        self.delegate       = delegate;
        self.showHUD        = showHUD;
        self.tagrget        = target;
        self.select         = action;
        if (showHUD==YES) {
            [MBProgressHUD showHUD];
        }
        __weak typeof(self)weakSelf = self;
        NSLog(@"--请求url地址--%@\n",url);
        NSLog(@"----请求参数%@\n",params);
        

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 30.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
      manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil];
                
        
        if (networkType==MHAsiNetWorkGET)
        {
            [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *json = @"[{\"nom\":\"Call of duty ghost\",\"date\":\"22 novembre\",\"image\":\"appicon.png\"},{\"nom\":\"Fifa 14\",\"date\":\"22 novembre\",\"image\":\"appicon.png\"}]\n<!-- Hosting24 Analytics Code -->\n<script type=\"text/javascript\" src=\"http://stats.hosting24.com/count.php\"></script>\n<!-- End Of Analytics Code -->";
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+<!--.*$"
                                                                                       options:NSRegularExpressionDotMatchesLineSeparators
                                                                                         error:nil];
                NSTextCheckingResult *result = [regex firstMatchInString:json
                                                                 options:0
                                                                   range:NSMakeRange(0, json.length)];
                
                
                
              
                if(result) {
                    NSRange range = [result rangeAtIndex:0];
                    json = [json stringByReplacingCharactersInRange:range withString:@""];
                    NSLog(@"json: %@", json);
                }
                
                [MBProgressHUD dissmiss];

                int code = 0;
                
                NSString *msg = nil;
                
//                if (responseObject) {
//                    NSString *success   = responseObject[@"success"];
//                    code                = success.intValue;
//                    msg                 = responseObject[@"msg"];
//                }
                
//                NSLog(@"\n\n----请求的返回结果 %@\n",responseObject);
                if (successBlock) {
                    successBlock(responseObject,code,msg);
                }
                
                if ([weakSelf.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                    [weakSelf.delegate requestDidFinishLoading:responseObject];
                }
                [weakSelf performSelector:@selector(finishedRequest: didFaild:) withObject:responseObject withObject:nil];
                [weakSelf removewItem];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD dissmiss];
                NSLog(@"---error==%@\n",error.localizedDescription);
                
                if ([error.localizedDescription isEqualToString:@"Unstable network connection, please retry later."]) {
//                    [self.customHudView showHUDWithImage:@"BR_Error.png" Prompt:error.localizedDescription  GifImageSize:CGSizeMake(35, 35) View:self.bgview];
//                    [self.customHudView hideHUDWithDelayed:3.0];
                }
                
                
                
                
                if (failureBlock) {
                    failureBlock(error);
                }
                if ([weakSelf.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                    [weakSelf.delegate requestdidFailWithError:error];
                }
                [weakSelf performSelector:@selector(finishedRequest: didFaild:) withObject:nil withObject:error];
                
                [weakSelf removewItem];
            }];
          
        }else if (networkType==MHAsiNetWorkPOST){
         
            [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD dissmiss];
                int code = 0;
                NSString *msg = nil;
//                if (responseObject) {
//                    NSString *success   = responseObject[@"success"];
//                    code                = success.intValue;
//                    msg                 = responseObject[@"msg"];
//                }
                NSLog(@"\n\n----请求的返回结果 %@\n",responseObject);
                if (successBlock) {
                    successBlock(responseObject,code,msg);
                }
                if ([weakSelf.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                    [weakSelf.delegate requestdidFailWithError:responseObject];
                }
                [weakSelf performSelector:@selector(finishedRequest: didFaild:) withObject:responseObject withObject:nil];
                [weakSelf removewItem];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD dissmiss];
                NSLog(@"---error==%@\n",error.localizedDescription);
                if ([error.localizedDescription isEqualToString:@"Unstable network connection, please retry later."]) {
//                    [self.customHudView showHUDWithImage:@"BR_Error.png" Prompt:error.localizedDescription  GifImageSize:CGSizeMake(35, 35) View:self.bgview];
//                    [self.customHudView hideHUDWithDelayed:3.0];
                }
                
                if (failureBlock) {
                    failureBlock(error);
                }
                if ([weakSelf.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                    [weakSelf.delegate requestdidFailWithError:error];
                }
                [weakSelf performSelector:@selector(finishedRequest: didFaild:) withObject:nil withObject:error];
                [weakSelf removewItem];
            }];
            
            
            
        }
    }
    return self;
}
/**
 *   移除网络请求项
 */
- (void)removewItem
{
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(netWorkWillDealloc:)]) {
            [weakSelf.delegate netWorkWillDealloc:weakSelf];
        }
    });
}

- (void)finishedRequest:(id)data didFaild:(NSError*)error
{
    if ([self.tagrget respondsToSelector:self.select]) {
        [self.tagrget performSelector:@selector(finishedRequest:didFaild:) withObject:data withObject:error];
    }
}

- (void)dealloc
{
    static int i = 0;
    
    NSLog(@"----%d",i);
    NSLog(@"网络请求项被移除了");
    
    i++;
}

@end
