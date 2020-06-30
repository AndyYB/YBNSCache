//
//  YBCacheManage.h
//  FBSnapshotTestCase
//
//  Created by 曹雁彬 on 2020/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBNSCacheManage : NSObject
//初始化
+(instancetype)share;
//释放
+ (void)clean;
//取对象
- (NSDictionary*)objectForFileKey:(NSString *)fileKey;
//存对象
- (BOOL)cacheFileWithObjectValue:(NSDictionary*)dic
                         fileKey:(NSString *)fileKey;
@end

NS_ASSUME_NONNULL_END
