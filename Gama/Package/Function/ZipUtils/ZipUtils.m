//
//  ZipUtils.m
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "ZipUtils.h"
#import "ZipArchive.h"

#define kDefaultFile @"File"
#define kDefaultFail @"解压失败"

@implementation ZipUtils
+ (void) zipFileData:(NSString *)rootPath fileName:(NSString *)fileName zipName:(NSString *)zipName block:(ZipBlock)block
{
    if (![zipName hasSuffix:@".zip"])
    {
        zipName = [zipName stringByAppendingString:@".zip"];
    }
    
    NSLog(@"\n\n%@\n%@\n\n",rootPath,zipName);
    NSString *zipPath = [rootPath stringByAppendingPathComponent:zipName];
    NSString *path = [rootPath stringByAppendingPathComponent:fileName];
    
    ZipArchive *data = [[ZipArchive alloc] init];
    BOOL create = [data CreateZipFile2:zipPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPaths = [fileManager subpathsAtPath:path];// 关键是subpathsAtPath方法
    for(NSString *subPath in subPaths)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:subPath];
        BOOL isDir;
        if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)// 只处理文件
        {
            [data addFileToZip:fullPath newname:subPath];
        }    
    }
    if (block)
    {
        block(create, zipPath);
    }
}

+ (void) zipFileDefaultData:(NSString *)path block:(ZipBlock)block
{
    [self zipFileData:path fileName:kDefaultFile zipName:kDefaultFile block:block];
}


#pragma mark - 解压
+ (void) unzipFileData:(NSString *)rootPath
               zipName:(NSString *)zipName
                toName:(NSString *)name
                 block:(ZipBlock)block
{
    if (![zipName hasSuffix:@".zip"])
    {
        zipName = [zipName stringByAppendingString:@".zip"];
    }

    NSString *zipPath = [rootPath stringByAppendingPathComponent:zipName];
    NSString *toPath = [rootPath stringByAppendingPathComponent:name];

    if (![[NSFileManager defaultManager] fileExistsAtPath:zipPath])
    {
        if (block)
        {
            block(false, @"不存在文件");
        }
        return;
    }
    
    NSString *key = @"解压失败";
    ZipArchive *data = [[ZipArchive alloc] init];
    if ([data UnzipOpenFile:zipPath])
    {
        if ([data UnzipFileTo:toPath overWrite:true])
        {
            key = toPath;
        }
        [data UnzipCloseFile];
    }
    if (block)
    {
        block((![key isEqualToString:kDefaultFail]), key);
    }
    [[NSFileManager defaultManager] removeItemAtPath:zipPath error:nil];
}

+ (void) unzipFileDefaultData:(NSString *)path block:(ZipBlock)block
{
    [self unzipFileData:path zipName:kDefaultFile toName:kDefaultFile block:block];
}


@end
