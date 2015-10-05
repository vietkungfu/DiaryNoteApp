//
//  DiarySpec.h
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiarySpec : NSObject

@property (strong, nonatomic) NSString * itemKey;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSDate * date;
@property (strong, nonatomic) NSString * note;

- (id) initWithItemKey: (NSString *) itemKey;

@end
