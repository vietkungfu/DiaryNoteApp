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

//@synthesize DiaryDic = scopeDiaryDic;
//@synthesize DiaryList = scopeDiaryList;

// -------- Max Index --------------------
- (int) MaxIndex{
    
    int maxIndex = 0;
    
    for (NSString * key in scopeDiaryDic){
        int indexKey = [key intValue];
        if(indexKey > maxIndex)
        {
            maxIndex = indexKey;
        }
    }
    
    return maxIndex;
}

// -------- Diary Dictionary -------------

- (NSMutableDictionary *) DiaryDic{
    
    if (scopeDiaryDic == nil) {

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:DIARY_FILENAME];
        
        NSMutableData * data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        scopeDiaryDic = [decoder decodeObjectForKey:DIARY_TAG];
        
        if (scopeDiaryDic == nil) {
            scopeDiaryDic = [NSMutableDictionary dictionary];
        }
    }
    
    return scopeDiaryDic;
    
}

- (void) setDiaryDic:(NSMutableDictionary *)DiaryDic{
    scopeDiaryDic = DiaryDic;
}

- (BOOL) removeDictionaryForKeyOfDiaryDic:(NSString *)_key{
    
    BOOL returnValue = true;
    
    @try {
        for(NSString *key in self.DiaryDic){
            if([key isEqualToString:_key]){
                [self.DiaryDic removeObjectForKey:key];
            }
        }
        [self writeToFile];
        scopeDiaryDic = nil;
    }
    @catch (NSException *e) {
        NSLog(@"Exception : %@" ,e);
        returnValue = false;
    }
    
    return returnValue;
    
}

- (BOOL) addDictionaryIntoDiaryDic:(NSMutableDictionary *) _dic withKey:(NSString *) _key{
    
    BOOL returnValue = true;
    
    @try{
        
        [self.DiaryDic setObject:_dic forKey:_key];
        [self writeToFile];
        scopeDiaryDic = nil;
    }@catch (NSException *e){
        NSLog(@"Exception: %@", e);
        returnValue = false;
    }
    
    return returnValue;
}

-(BOOL) updateDictionaryForKeyOfDiaryDic:(NSMutableDictionary *) _dic withKey:(NSString *) _key{
    
    BOOL returnValue = true;
    BOOL itemFoundFlag = false;
    
    @try {
        for (NSString * key in self.DiaryDic )
        {
            if([key isEqualToString:_key]){
                self.DiaryDic[key] = _dic;
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

- (BOOL) isDateExisted:(NSDate *)_date withOriginDate: (NSDate *) _originDate{
    
    BOOL returnValue = false;
    
    NSString * _stringDate = [self generateDateValue:_date];
    NSString * _stringOriginDate = [self generateDateValue:_originDate];
    
    for (NSString * key in self.DiaryDic){
        
        NSMutableDictionary * dic = self.DiaryDic[key];
        NSDate * date = [dic objectForKey:DATE_TAG];
        
        NSString * stringDate = [self generateDateValue:date];
        
        if([stringDate isEqualToString:_stringDate]
        && ![stringDate isEqualToString:_stringOriginDate])
        {
            returnValue = true;
            break;
        }
        
    }
    return returnValue;
}

- (NSString *) generateDateValue:(NSDate *) _date{
    
    if(_date == nil){return nil;}
    
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DATE_FORMAT];
    
    return [dateFormat stringFromDate:_date];
}

- (NSString *) generateViewDateValue:(NSDate *) _date{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DATE_VIEW_FORMAT];

    return [dateFormat stringFromDate:_date];
}

// -------- Write to File ----------

-(BOOL) writeToFile{
    
    BOOL returnValue = TRUE;
    
    @try
    {

        NSMutableData *data = [NSMutableData data];
        
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        //self.DiaryDic = [NSMutableDictionary dictionary];
        
        [archiver encodeObject:self.DiaryDic forKey:DIARY_TAG];
        [archiver finishEncoding];
        
        NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectoryPath = [path objectAtIndex:0];
        NSString * filePath = [documentsDirectoryPath stringByAppendingPathComponent:DIARY_FILENAME];
        
        [data writeToFile:filePath atomically:YES];
    }@catch(NSException * ex){
        NSLog(@"Exception: %@", ex);
        returnValue = FALSE;
    }
    return returnValue;
}

// -------- Diary List -------------

-(NSMutableArray *) DiaryList{
    
    scopeDiaryList = [NSMutableArray array];
    
    for (NSString* key in self.DiaryDic) {
        [scopeDiaryList addObject:[self.DiaryDic objectForKey:key]];
    }
    
    [scopeDiaryList sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate * date1 = [(NSMutableDictionary *)a objectForKey:DATE_TAG];
        NSDate * date2 = [(NSMutableDictionary *)b objectForKey:DATE_TAG];
        return [date2 compare:date1];
    }];
    
    return scopeDiaryList;
}

- (void) setDiaryList:(NSMutableArray *)DiaryList{
    scopeDiaryList = DiaryList;
}

@end

