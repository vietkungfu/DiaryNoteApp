//
//  PresentViewController.m
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import "PresentViewController.h"

@interface PresentViewController ()

@end

@implementation PresentViewController

@synthesize diary;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if(sender != self.finishButton){
        return;
    }
    
    if(self.diaryDate != nil){
        self.diaryReturn = [[DiarySpec alloc] init];
        [self.diaryReturn setTitle:self.diaryTitle.text];
        [self.diaryReturn setDate:self.diaryDate.date];
        [self.diaryReturn setNote:self.diaryNote.text];
    }
}


@end
