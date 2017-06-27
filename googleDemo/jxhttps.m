//
//  jxhttps.m
//  googleDemo
//
//  Created by 166 on 2017/6/1.
//  Copyright © 2017年 166. All rights reserved.
//

#import "jxhttps.h"

@implementation jxhttps


/**
 *  路径规划数据
 */
+(void)getPathWihtParams:(id)categoryID success:(void(^)(id returnSucc))succ failure:(void(^)(NSError *error))failed{
    
//https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=Washington,DC&destinations=New+York+City,NY&key=YOUR_API_KEY

    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%g,%g&destination=%g,%g&sensor=false&mode=DRIVING",30.712433,114.222524,30.712433,114.222526]  params:nil successBlock:^(id returnData, int code, NSString *msg) {
        
        NSLog(@"路径规划返回数据：%@",returnData);
        
        if (succ) {
            succ(returnData);
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"----%@",error);
    } showHUD:YES];
    
    
    
    
    
}



@end
