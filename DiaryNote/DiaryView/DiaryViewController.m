//
//  DiaryViewController.m
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/28.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import "DiaryViewController.h"
#import "Constant.h"
#import "PhotoViewCell.h"

@import Photos;

@interface DiaryViewController ()<PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHFetchResult *assetResult;
@property (nonatomic, strong) PHAssetCollection *assetCollect;
@property (nonatomic, strong) NSMutableArray *assets;

@property (strong) PHCachingImageManager *imageManager;
@property CGRect previousPreheatRect;

@end

@implementation DiaryViewController

static CGSize AssetGridThumbnailSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showImage];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)readImage {
    // PHAssetCollection を取得します
    PHAssetCollection * myAlbum = [self getMyAlbum];
    
    // PHAsset をフェッチします
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:myAlbum options:nil];
    
    // フェッチ結果から assets を取り出します
    NSArray * assetArray = [self getAssets:assets];
    
    // asset を使って、UIImageView をランダムに更新します
    [self updateImageViewWithAsset:assetArray[arc4random() % assets.count]];
}

- (PHAssetCollection *)getMyAlbum {
    // ユーザ作成のアルバム一覧を指定して、PHAssetCollection をフェッチします
    PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                               subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                               options:nil];
    
    // [My Album]の AssetCollection を取得します
    __block PHAssetCollection * myAlbum;
    [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection *album, NSUInteger idx, BOOL *stop) {
        if ([album.localizedTitle isEqualToString:@"My Album"]) {
            myAlbum = album;
            *stop = YES;
        }
    }];
    
    return myAlbum;
}

- (NSArray *)getAssets:(PHFetchResult *)fetch {
    // フェッチ結果を配列に格納します
    __block NSMutableArray * assetArray = NSMutableArray.new;
    [fetch enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        [assetArray addObject:asset];
    }];
    return assetArray;
}

- (void)updateImageViewWithAsset:(PHAsset *)asset {
    //typeof(self) __weak wself = self;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(300,300)
                                              contentMode:PHImageContentModeAspectFill
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (result) {
                                                    // imageVivew を更新します
                                                    //wself.imageView.image = result;
                                                }
                                            }];
}

- (void) showImage{
    //PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *topLevelUserCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    self.assets = [NSMutableArray array];
    
    for(PHAsset * asset in topLevelUserCollections)
    {
        if ([[self generateViewDateValue: asset.creationDate]
             isEqualToString:[self generateViewDateValue:[self.diaryItem objectForKey:DATE_TAG]]])
        {
            [self.assets addObject:asset];
        }
    }
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
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
    
    return cell;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        // check if there are changes to the assets (insertions, deletions, updates)
//        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
//        if (collectionChanges) {
//            
//            // get the new fetch result
//            self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
//            
//            UICollectionView *collectionView = self.collectionView;
//            
//            if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
//                // we need to reload all if the incremental diffs are not available
//                [collectionView reloadData];
//                
//            } else {
//                // if we have incremental diffs, tell the collection view to animate insertions and deletions
//                [collectionView performBatchUpdates:^{
//                    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
//                    if ([removedIndexes count]) {
//                        [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                    }
//                    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
//                    if ([insertedIndexes count]) {
//                        [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                    }
//                    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
//                    if ([changedIndexes count]) {
//                        [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                    }
//                } completion:NULL];
//            }
//            
//            [self resetCachedAssets];
//        }
//    });
}


- (NSString *) generateViewDateValue:(NSDate *) _date{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DATE_VIEW_FORMAT];
    
    return [dateFormat stringFromDate:_date];
}

@end
