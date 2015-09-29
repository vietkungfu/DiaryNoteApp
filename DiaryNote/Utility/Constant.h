//
//  Constant.h
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

extern NSString * const DIARY_FILENAME ;
extern NSString * const DIARY_TAG ;
extern NSString * const ITEM_KEY_TAG ;
extern NSString * const TITLE_TAG ;
extern NSString * const DATE_TAG ;
extern NSString * const DESCRIPTION_TAG;
//extern NSString * const ITEM_KEY_CELL ;
//extern NSString * const TITLE_CELL ;
//extern NSString * const DATE_CELL ;
extern NSString * const EDIT_ITEM;
extern NSString * const CANCEL_ITEM;
extern NSString * const COMPLETE_ITEM;
extern NSString * const DIARY_CREATE_SCREEN;
extern NSString * const DIARY_EDIT_SCREEN;
extern NSString * const MAIN_SCREEN;
extern NSString * const DATE_FORMAT;
extern NSString * const DATE_VIEW_FORMAT;

extern NSString * const VIEW_DIARY_ACTION;

extern NSString * const MODE_EDIT;
extern NSString * const MODE_CREATE;

typedef enum {
    Create,
    Edit
} DiaryPresentViewMode;

#define INDICATORVIEW_TAG 9


@end
