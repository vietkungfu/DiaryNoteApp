//
//  DiaryViewController.m
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import "DiaryViewController.h"
#import "PresentViewController.h"
#import "Constant.h"
#import "PhotoViewCell.h"

@import Photos;

@interface DiaryViewController ()

@property (nonatomic, strong) PHFetchResult *assetResult;
@property (nonatomic, strong) PHAssetCollection *assetCollect;
@property (nonatomic, strong) NSMutableArray *assets;

@property (strong) PHCachingImageManager *imageManager;
@property CGRect previousPreheatRect;

@end

@implementation DiaryViewController

static CGSize AssetGridThumbnailSize;

- (void)awakeFromNib
{
    self.imageManager = [[PHCachingImageManager alloc] init];
    //[self resetCachedAssets];
    [self.imageManager stopCachingImagesForAllAssets];
    //[[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc
{
    //[[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView flashScrollIndicators];
//    [self.collectionView setShowsHorizontalScrollIndicator:YES];
//    [self.collectionView setShowsVerticalScrollIndicator:YES];
    self.navigationItem.title = [self.diaryItem objectForKey:TITLE_TAG];
    
    self.navigationItem.prompt = [self generateViewDateValue:[self.diaryItem objectForKey:DATE_TAG]];
    self.note.text = [self.diaryItem objectForKey:DESCRIPTION_TAG];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    [self showImage];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:EDIT_DIARY_ACTION]){
        PresentViewController *viewController = (PresentViewController *)[[segue destinationViewController] topViewController];
        [viewController setDiary:self.diary];
        //viewController.diaryItem = self.diaryItem;
        
        DiarySpec * diarySpec = [[DiarySpec alloc] initWithItemKey:[self.diaryItem objectForKey:ITEM_KEY_TAG]];
        
        diarySpec.title = [self.diaryItem objectForKey:TITLE_TAG];
        diarySpec.date = [self.diaryItem objectForKey:DATE_TAG];
        diarySpec.note = [self.diaryItem objectForKey:DESCRIPTION_TAG];
        
        viewController.diaryReturn = diarySpec;
        
        viewController.viewMode = MODE_EDIT;
    }
}

- (IBAction)unwindToList:(UIStoryboardSegue *) segue{
    
    if([[segue identifier] isEqualToString:SAVE_DIARY_ACTION])
    {
        
        PresentViewController * source = [segue sourceViewController];
        
        DiarySpec *diarySpec = source.diaryReturn;
        
        if(diarySpec != nil){
            
            NSMutableDictionary* diaryData = [NSMutableDictionary dictionary];
            
            NSString * itemKey = diarySpec.itemKey;
            
            [diaryData setObject:itemKey forKey:ITEM_KEY_TAG];
            [diaryData setObject:diarySpec.title forKey:TITLE_TAG];
            [diaryData setObject:diarySpec.date forKey:DATE_TAG];
            [diaryData setObject:diarySpec.note forKey:DESCRIPTION_TAG];
            
            [self.diary
             addDictionaryIntoDiaryDic:diaryData
             withKey:itemKey];
            
            self.diaryItem[TITLE_TAG] = diarySpec.title;
            self.diaryItem[DATE_TAG] = diarySpec.date;
            self.diaryItem[DESCRIPTION_TAG] = diarySpec.note;
            
            [self viewDidLoad];
            [self viewWillAppear:YES];
            [self viewDidAppear:YES];
        }
    }
    
}

- (void) showImage{

    PHFetchResult *results = [PHAsset fetchAssetsWithOptions:nil];
    //PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    self.assets = [NSMutableArray array];
    
    for(PHAsset * asset in results)
    {
        if ([[self generateViewDateValue: asset.creationDate]
             isEqualToString:[self generateViewDateValue:[self.diaryItem objectForKey:DATE_TAG]]])
        {
            [self.assets addObject:asset];
        }
    }
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.assets.count;
    
    collectionView.contentSize = CGSizeMake(AssetGridThumbnailSize.height * count,AssetGridThumbnailSize.width);
    return count;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    // Increment the cell's tag
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;
    
    PHAsset *asset = self.assets[indexPath.item];
    
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  
                                  // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
                                  if (cell.tag == currentTag) {
                                      cell.thumbnailImage = result;
                                  }
                              }];
    //[cell setSelected:true];
    //[cv selectItemAtIndexPath:indexPath animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.assets[indexPath.item];
    
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  
                                  // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
                                  //if (cell.tag == currentTag) {
                                      self.imageView.image = result;
                                  //}
                              }];
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
        self.imageView.image = nil;
}

- (NSString *) generateViewDateValue:(NSDate *) _date{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DATE_VIEW_FORMAT];
    
    return [dateFormat stringFromDate:_date];
}

@end
