//
//  DiaryModel.m
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import "Diary.h"
#import "Constant.h"

@interface Diary(){
    NSMutableDictionary *scopeDiaryDic;
    NSMutableArray *scopeDiaryList;
}

@end

@implementation Diary

@synthesize DiaryDic = scopeDiaryDic;
@synthesize DiaryList = scopeDiaryList;

// -------- Max Index --------------------
- (NSInteger *) MaxIndex{
    
    NSInteger * maxIndex = 0;
    
    for (NSString * key in scopeDiaryDic){
        NSInteger indexKey = [key integerValue];
        if(&indexKey > maxIndex)
        {
            maxIndex = &indexKey;
        }
    }
    
    return maxIndex;
}

// -------- Diary Dictionary -------------

- (NSMutableDictionary *) DiaryDic{
    
    if (!scopeDiaryDic) {
        scopeDiaryDic = [NSMutableDictionary dictionary];
    }
    
    // Load data from plist
    if ([[scopeDiaryDic allKeys] count] == 0) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:DIARY_FILENAME];
        
        NSMutableData * data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        scopeDiaryDic = [decoder decodeObjectForKey:DIARY_TAG];
        
    }
    return scopeDiaryDic;
    
}

- (void) setDiaryDic:(NSMutableDictionary *)DiaryDic{
    scopeDiaryDic = DiaryDic;
}

- (BOOL) removeDictionaryForKeyOfDiaryDic:(NSString *)_key{
    
    BOOL returnValue = true;
    
    @try {
        for(NSString *key in scopeDiaryDic){
            if([key isEqualToString:_key]){
                [scopeDiaryDic removeObjectForKey:key];
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"Exception : %@" ,e);
        returnValue = false;
    }
    
    return returnValue;
    
}

- (BOOL) addDictionaryIntoDiaryDic:(NSDictionary *) _dic withKey:(NSString *) _key{
    
    BOOL returnValue = true;
    
    @try{
        
        [scopeDiaryDic setObject:_dic forKey:_key];
        
    }@catch (NSException *e){
        NSLog(@"Exception: %@", e);
        returnValue = false;
    }
    
    return returnValue;
}

-(BOOL) updateDictionaryForKeyOfDiaryDic:(NSDictionary *) _dic withKey:(NSString *) _key{
    
    BOOL returnValue = true;
    BOOL itemFoundFlag = false;
    
    @try {
        for (NSString * key in scopeDiaryDic)
        {
            if([key isEqualToString:_key]){
                scopeDiaryDic[key] = _dic;
                itemFoundFlag = true;
            }
        }
    }@catch (NSException *e) {
        NSLog(@"Exeption: %@", e);
        returnValue = false;
    }
    
    if(!itemFoundFlag && returnValue)
    {
        returnValue = [self addDictionaryIntoDiaryDic: _dic withKey:_key];
    }
    
    return returnValue;
}

- (BOOL) isDateExisted:(NSString *)_date{
    
    BOOL returnValue = false;
    
    for (NSString * key in scopeDiaryDic){
        
        NSDictionary * dic = scopeDiaryDic[key];
        NSString * date = [dic objectForKey:DATE_TAG];
        
        if([date isEqualToString:_date])
        {
            returnValue = true;
            break;
        }
        
    }
    return returnValue;
}

- (NSString *) generateDateValue:(NSDate *) _date{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DATE_FORMAT];
    
    return [dateFormat stringFromDate:_date];
}

// -------- Diary List -------------

-(NSMutableArray *) DiaryList{
    if(!scopeDiaryList){
        scopeDiaryList = [NSMutableArray array];
    }
    
    if(scopeDiaryList.count == 0)
    {
        for (NSString* key in self.DiaryDic) {
            
            NSDictionary * dic = [self.DiaryDic objectForKey:key];
            [dic setValue:key forKey:ITEM_KEY_TAG];
            
            [scopeDiaryList setValuesForKeysWithDictionary:dic];
        }
    }
    
    return scopeDiaryList;
}

- (void) setDiaryList:(NSMutableArray *)DiaryList{
    scopeDiaryList = DiaryList;
}

@end

