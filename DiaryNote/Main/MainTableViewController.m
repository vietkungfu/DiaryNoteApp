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
@property (nonatomic, strong) NSMutableArray * cellNameList;
@property (nonatomic, strong) NSMutableArray * cellTagList;

@end

@implementation MainTableViewController

@synthesize diary;

- (NSMutableArray *)cellNameList{
    if(!_cellNameList){
        _cellNameList = [NSMutableArray array];
        
        [_cellNameList addObject:TITLE_CELL];
        [_cellNameList addObject:DATE_CELL];
        [_cellNameList addObject:ITEM_KEY_CELL];
    }
    
    return _cellNameList;
}

- (NSMutableArray *)cellTagList{
    
    if(!_cellTagList){
        _cellTagList = [NSMutableArray array];
        [_cellTagList addObject:TITLE_TAG];
        [_cellTagList addObject:DATE_TAG];
        [_cellTagList addObject:ITEM_KEY_TAG];
    }
    
    return _cellTagList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    diary = [[Diary alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
    // Return the number of sections.
    return [self.cellNameList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
    // Return the number of rows in the section.
    return [diary.DiaryList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    NSString * cellIdentifier = [[NSString alloc] initWithString:[self.cellNameList objectAtIndex:indexPath.section]];
    NSString * cellTag =[[NSString alloc] initWithString:[self.cellTagList objectAtIndex:indexPath.section]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier] ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary* diaryData = [diary.DiaryList objectAtIndex:indexPath.row];
    cell.textLabel.text = [diaryData objectForKey:cellTag];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.numberOfLines = 0;
    
    if ([cellIdentifier isEqualToString:TITLE_TAG]) {
        
    }else if([cellIdentifier isEqualToString:DATE_TAG]){
        
    }else if([cellIdentifier isEqualToString:ITEM_KEY_TAG]){
        cell.hidden = true;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSDictionary* rssData = [self.rssDataListArray objectAtIndex:indexPath.row];
    //if ([rssData objectForKey:@"link"]) {
    DiaryViewController* viewController = [[DiaryViewController alloc]initWithNibName:@"DiaryViewController" bundle:nil];
    //viewController.rssLinkUrl = [rssData objectForKey:@"link"];
    //viewController.rssLinkTitle = [rssData objectForKey:@"title"];
    [self.navigationController pushViewController:viewController animated:YES];
    //}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:VIEW_DIARY_ACTION]) {
        
        [[segue destinationViewController] setDiary:self.diary];
        [[segue destinationViewController] setViewMode: 0];
    }
}


- (IBAction) unwindToList:(UIStoryboardSegue *)segue{
    
    PresentViewController * source = [segue sourceViewController];
    
    DiarySpec *diarySpec = source.diaryReturn;
    
    if(diarySpec != nil){
        
        if (source.viewMode == 0) {
            [self.diary addDictionaryIntoDiaryDic:nil withKey:nil];
        }else{
            [self.diary updateDictionaryForKeyOfDiaryDic:nil withKey:nil];
        }
        
        [self.tableView reloadData];
    }
    
}

@end
