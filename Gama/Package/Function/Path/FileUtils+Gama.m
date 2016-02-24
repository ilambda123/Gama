//
//  FileUtils+Gama.m
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "FileUtils+Gama.h"

@implementation FileUtils (Gama)

+ (void) createGamaNeedFilePath
{
    NSString *path = [FileUtils filePath];
    [FileUtils createFilePath:path];
    
    NSLog(@"根路径 %@", path);
}

+ (NSString *) filePath
{
    return [NSString stringWithFormat:@"%@/File",[FileUtils sysDocumentPath]];
}
@end
