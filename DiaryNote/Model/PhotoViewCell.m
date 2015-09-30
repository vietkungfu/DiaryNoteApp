//
//  PhotoViewCell.m
//  DiaryNote
//
//  Created by IC経営戦略室App開発用 on 2015/09/30.
//  Copyright (c) 2015年 ic-net. All rights reserved.
//

#import "PhotoViewCell.h"

@interface PhotoViewCell ()
@property (strong) IBOutlet UIImageView *imageView;
@end


@implementation PhotoViewCell

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

@end
