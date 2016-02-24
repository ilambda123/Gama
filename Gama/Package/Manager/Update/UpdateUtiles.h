//
//  UpdateUtiles.h
//  Gama
//
//  Created by Paul on 16/1/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUtiles : NSObject
+ (void) needUpdateVersion:(NSString *)version;
+ (void) needForceUpdeateVersion:(NSString *)version;
+ (void) cancelUpdate;

+ (BOOL) needUpdate;
+ (BOOL) needForceUpdate;

@end
