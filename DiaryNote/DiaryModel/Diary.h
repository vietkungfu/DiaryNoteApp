//
//  DiaryModel.h
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Diary : NSObject

@property (strong, nonatomic) NSMutableArray *DiaryList;

@property (strong, nonatomic) NSMutableDictionary *DiaryDic;

@property (assign, nonatomic) NSInteger * MaxIndex;

- (BOOL) updateDictionaryForKeyOfDiaryDic:(NSMutableDictionary *) _dic withKey:(NSString *) _key;
- (BOOL) addDictionaryIntoDiaryDic:(NSMutableDictionary *) _dic withKey:(NSString *) _key;
- (BOOL) removeDictionaryForKeyOfDiaryDic:(NSString *)_key;
- (BOOL) isDateExisted:(NSString *)_date;
- (NSString *) generateDateValue:(NSDate *) _date;


@end
