//
//  WebWindow.h
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebBlock.h"

@interface WebWindow : UIWindow
@property (nonatomic, copy) WebBlock block;
+ (instancetype) showWebWindow:(NSString *)url finish:(WebBlock)block;
@end
