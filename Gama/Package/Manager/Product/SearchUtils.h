//
//  SearchUtils.h
//  Gama
//
//  Created by Paul on 16/1/15.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchUtils : NSObject
+ (void) recodeSearch:(NSString *)key;
+ (void) removeSearch:(NSString *)key;
+ (NSArray *) recodeSearchList;
+ (NSString *) _searchPath;
@end
