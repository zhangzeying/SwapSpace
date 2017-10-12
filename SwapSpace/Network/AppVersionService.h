//
//  AppVersionService.h
//  SwapSpace
//
//  Created by zzy on 12/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppVersionService : NSObject
+ (void)getAppVersion:(void(^)(NSDictionary *dict))completion;
@end
