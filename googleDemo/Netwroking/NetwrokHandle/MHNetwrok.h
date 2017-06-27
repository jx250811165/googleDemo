//
//  MHNetwrok.h
//  PersonalAssistant
//
//  Created by dabing on 15/10/23.
//  Copyright © 2015年 Mark. All rights reserved.
//

#ifndef MHNetwrok_h
#define MHNetwrok_h

#ifdef DEBUG
#   define DTLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define DTLog(...)
#endif

#import "MHAsiNetworkDefine.h"
#import "MHAsiNetworkDefine.h"
#import "MHAsiNetworkHandler.h"
#import "MHNetworkManager.h"
#import "MHAsiNetworkUrl.h"

#endif /* MHNetwrok_h */
