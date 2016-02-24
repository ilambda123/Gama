//
//  SearchUtils.m
//  Gama
//
//  Created by Paul on 16/1/15.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SearchUtils.h"
#import "FileUtils.h"

#define kSearch @"Search.plist"

@implementation SearchUtils
#pragma mark - Search
+ (void) recodeSearch:(NSString *)key
{
    NSArray *searchList = [self recodeSearchList];
    NSMutableArray *list = [[NSMutableArray alloc] initWithArray:searchList];
    if ([list containsObject:key])
    {
        [list removeObject:key];
    }
    [list insertObject:key atIndex:0];
    [list writeToFile:[self _searchPath] atomically:YES];
}

+ (void) removeSearch:(NSString *)key
{
    NSArray *searchList = [self recodeSearchList];
    NSMutableArray *list = [[NSMutableArray alloc] initWithArray:searchList];
    [list removeObject:key];
    [list writeToFile:[self _searchPath] atomically:YES];
}

+ (NSArray *) recodeSearchList
{
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:[self _searchPath]];
    NSRange range = NSMakeRange(0, MIN(3, [arr count]));
    return [arr subarrayWithRange:range];
}

+ (NSString *) _searchPath
{
    NSString *sysPath = [FileUtils sysDocumentPath];
    NSString *searchPath = [NSString stringWithFormat:@"%@/%@",sysPath,kSearch];
    return searchPath;
}
@end
