//
//  CloudManager.m
//  Gama
//
//  Created by Paul on 16/1/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CloudManager.h"
#import <CloudKit/CloudKit.h>

#import "FileUtils+Gama.h"

static CloudManager *s_cloudManager = nil;

@implementation CloudManager
+ (CloudManager *)shareInstance
{
    @synchronized(self)
    {
        if (!s_cloudManager)
        {
            s_cloudManager = [[self alloc] init];
        }
    }
    return s_cloudManager;
}

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

@end
