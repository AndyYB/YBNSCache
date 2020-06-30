//
//  YBNSModel.h
//  FBSnapshotTestCase
//
//  Created by 曹雁彬 on 2020/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBNSModel : NSObject<NSCoding>
@property (strong, nonatomic) NSString * ycz;

/// cjl1 as double value
@property (strong, nonatomic) NSString * nameCode;

@property (strong, nonatomic) NSString *gpName;

@property (nonatomic, strong) NSString *time;

@property (readwrite, nonatomic) double gpJG;

@property (readwrite, nonatomic) double newJG;

@property (assign, nonatomic) NSInteger showCount;
@end

NS_ASSUME_NONNULL_END
