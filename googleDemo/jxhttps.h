//
//  jxhttps.h
//  googleDemo
//
//  Created by 166 on 2017/6/1.
//  Copyright © 2017年 166. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHNetwrok.h"
@interface jxhttps : NSObject

/**
 *  路径规划数据
 */
+(void)getPathWihtParams:(id)categoryID success:(void(^)(id returnSucc))succ failure:(void(^)(NSError *error))failed;



@end
