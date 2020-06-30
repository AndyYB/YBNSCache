//
//  YBCacheManage.m
//  FBSnapshotTestCase
//
//  Created by 曹雁彬 on 2020/6/30.
//

#import "YBNSCacheManage.h"

static YBNSCacheManage *manager = nil;
static dispatch_once_t onceToken;

@implementation YBNSCacheManage
+ (instancetype)share {
    dispatch_once(&onceToken, ^{
        manager = [[YBNSCacheManage alloc]init];
    });
    return manager;
}

+ (void)clean {
    onceToken = 0;
    manager = nil;
}

- (id)fileToResponseObjectWithName:(NSString *)name {
    NSString *newPath = [self isHaveFilePathWithName:name];
    if (newPath == nil) {return nil;}
    NSData *aData = [NSData dataWithContentsOfFile:newPath];
    id responseObject = [NSJSONSerialization JSONObjectWithData:aData
                                                        options:0
                                                          error:nil];
    return responseObject;
}

- (BOOL)responseObjectToFileWithResponseObject:(id)responseObject
                                      fileName:(NSString *)fileName {
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject
                                                   options:0
                                                     error:nil];
    NSString *newPath = [self cresteNewPathWithName:fileName];
    return [data writeToFile:newPath atomically:YES];
}



- (NSDictionary*)objectForFileKey:(NSString *)fileKey {
    NSString *newPath = [self isHaveFilePathWithName:fileKey];
    if (newPath == nil) {return nil;}
    NSData *aData = [NSData dataWithContentsOfFile:newPath];
    NSDictionary *dict  = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
    return dict;
}

- (BOOL)cacheFileWithObjectValue:(NSDictionary*)dic
                         fileKey:(NSString *)fileKey {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString *newPath = [self cresteNewPathWithName:fileKey];
    return [data writeToFile:newPath atomically:YES];
}


// 设置文件名
- (NSString *)newFilePath {
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                 NSUserDomainMask,
                                                 YES)firstObject] stringByAppendingPathComponent:@"YBNSCore"];
}

- (void)cleanData {
       NSString *documentsPath = [self newFilePath];
       NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsPath];
       NSString *fileName;
       while (fileName= [dirEnum nextObject]) {
           [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@",documentsPath,fileName] error:nil];
       }
}

// 创建文件
- (NSString *)cresteNewPathWithName:(NSString *)name {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:[self newFilePath]]) {
        // 创建文件夹
        [manager createDirectoryAtPath:[self newFilePath]
           withIntermediateDirectories:YES
                            attributes:nil error:nil];
        
    }
    // 在文件夹下创建 文档 用来存储数组
    NSString *newPath = [[self newFilePath]stringByAppendingPathComponent:name];
    if (![manager fileExistsAtPath:newPath]) {
        [manager createFileAtPath:newPath contents:nil attributes:nil];
    }
    return newPath;
}

- (NSString *)isHaveFilePathWithName:(NSString *)name {
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([manage fileExistsAtPath:[self newFilePath]]) {
        NSString *newPath = [[self newFilePath] stringByAppendingPathComponent:name];
        if ([manage fileExistsAtPath:newPath]) {
            return newPath;
        } else {
            return nil;
        }
    }else {
        return nil;
    }
}

+ (NSString *)arrayToJSONString:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString=[[NSString alloc]initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)pathDocumentDirectoryWithPathComponents:(NSString *)pathComponents {
    static NSString *documentsDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES);
            documentsDirectory = [paths objectAtIndex:0];
        }
    });
    
    if (!pathComponents) {
        return nil;
    }
    NSString *path = [documentsDirectory stringByAppendingPathComponent:pathComponents];
    return path;
}

//存储路径
- (NSString *)filePathWithUniqueFlagString:(NSString *)uniqueFlag {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES)
                         lastObject];
    NSString *detailPath = [NSString stringWithFormat:@"%@_%@",uniqueFlag,
                                                               [NSString stringWithUTF8String:object_getClassName(self)]];
    NSString *path = [docPath stringByAppendingPathComponent:detailPath];
    return path;
}

//保存对象数据到本地
- (void)saveDataToLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey {
    [NSKeyedArchiver archiveRootObject:self
                                toFile:[self filePathWithUniqueFlagString:uniqueFlagKey]];
}


//清空本地存储的对象数据
- (id)getDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathWithUniqueFlagString:uniqueFlagKey]];
}


//从本地获取对象数据
- (BOOL)removeDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self filePathWithUniqueFlagString:uniqueFlagKey]
                                               error:&error];
    if (!error) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
