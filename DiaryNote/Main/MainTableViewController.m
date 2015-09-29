//
//  MainTableViewController.m
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import "MainTableViewController.h"
#import "Diary.h"
#import "Constant.h"
#import "DiarySpec.h"
#import "DiaryViewController.h"
#import "PresentViewController.h"

@interface MainTableViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) Diary * diary;

@end

@implementation MainTableViewController

@synthesize diary;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    diary = [[Diary alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [diary.DiaryList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier] ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSMutableDictionary* diaryData = [diary.DiaryList objectAtIndex:indexPath.row];
    cell.textLabel.text = [diaryData objectForKey:TITLE_TAG];
    cell.detailTextLabel.text = [self.diary generateViewDateValue:[diaryData objectForKey:DATE_TAG]];

    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiaryViewController* viewController = [[DiaryViewController alloc]initWithNibName:@"DiaryViewController" bundle:nil];

    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:VIEW_DIARY_ACTION]) {
        
        PresentViewController * viewController =
        (PresentViewController *)[[segue destinationViewController] topViewController];
        
        [viewController setDiary:self.diary];
        [viewController setViewMode: MODE_CREATE];

    }
}


- (IBAction) unwindToList:(UIStoryboardSegue *)segue{
    
    
    PresentViewController * source = [segue sourceViewController];
    
    DiarySpec *diarySpec = source.diaryReturn;
    
    if(diarySpec != nil){
        
        NSMutableDictionary* diaryData = [NSMutableDictionary dictionary];
        
        NSString * itemKey = [NSString stringWithFormat:@"%d",self.diary.MaxIndex + 1];
        
        [diaryData setObject:itemKey forKey:ITEM_KEY_TAG];
        [diaryData setObject:diarySpec.title forKey:TITLE_TAG];
        [diaryData setObject:diarySpec.date forKey:DATE_TAG];
        [diaryData setObject:diarySpec.note forKey:DESCRIPTION_TAG];

        [self.diary
         addDictionaryIntoDiaryDic:diaryData
         withKey:itemKey];
        
        [self.tableView reloadData];
    }
    
}

@end
