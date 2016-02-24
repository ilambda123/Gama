//
//  ZipUtils.h
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZipBlock)(BOOL finish, NSString *filePath);
@interface ZipUtils : NSObject
+ (void) zipFileDefaultData:(NSString *)path block:(ZipBlock)block;
+ (void) zipFileData:(NSString *)rootPath
            fileName:(NSString *)fileName
             zipName:(NSString *)zipName
               block:(ZipBlock)block;

+ (void) unzipFileDefaultData:(NSString *)path block:(ZipBlock)block;
+ (void) unzipFileData:(NSString *)rootPath
               zipName:(NSString *)zipName
                toName:(NSString *)name
                 block:(ZipBlock)block;
@end
