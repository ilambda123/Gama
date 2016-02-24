//
//  HomeTypeWindow.h
//  Gama
//
//  Created by Paul on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeType.h"

typedef void (^TypeBlock)(HomeType type);
@interface HomeTypeWindow : UIWindow
@property (nonatomic, copy) TypeBlock block;
+ (instancetype) showWebWindow:(HomeType)curType
                             y:(NSInteger)y
                        finish:(TypeBlock)block;
@end
