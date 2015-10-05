//
//  PresentViewController.h
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DiarySpec.h"
#import "Diary.h"

@interface PresentViewController : UIViewController

@property (copy, nonatomic) NSString *viewMode;
@property (strong, nonatomic) Diary * diary;
//@property (copy, nonatomic) NSMutableDictionary * diaryItem;
@property (weak, nonatomic) IBOutlet UITextField *diaryTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *diaryDate;
@property (weak, nonatomic) IBOutlet UITextView *diaryNote;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishButton;

@property(strong,nonatomic) DiarySpec * diaryReturn;

@end
