//
//  DiaryViewController.h
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "Diary.h"

@interface DiaryViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) Diary *diary;
@property (strong, nonatomic) NSMutableDictionary * diaryItem;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *note;

- (IBAction)unwindToList:(UIStoryboardSegue *) segue;

@end
