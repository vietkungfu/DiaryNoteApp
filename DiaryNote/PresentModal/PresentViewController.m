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

//@synthesize diary, viewMode;

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

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(sender == self.finishButton)
    {
        if( self.diaryDate == nil || [self.diary isDateExisted:self.diaryDate.date])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"Date is existed !! Please input again..."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
            [alert show];
            
            return FALSE;
        }
    }
    return YES;
}

@end
