//
//  DwnldrVaultScrollView.m
//  Dwnldr
//
//  Created by Stilldabomb on 12/13/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import "DwnldrVaultScrollView.h"
#import "DwnldrVaultImageView.h"
#define kColumns (iPad ? 5 : 4)
#define kSpacing (iPad ? 8 : 2)

@implementation DwnldrVaultScrollView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _videos = [NSMutableArray array];
        CGFloat videoSize = (self.frame.size.width / kColumns) - (kSpacing*1.25);
        __block CGFloat x = kSpacing;
        __block CGFloat y = kSpacing * 2;
        [[[Dwnldr sharedInstance] cachedVideos] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filename = (NSString*)obj;
            NSUInteger index = [[[Dwnldr sharedInstance] cachedVideos] indexOfObject:filename];
            NSString *imagePath = video([[[Dwnldr sharedInstance] cachedPlaceHolders] objectForKey:[filename stringByDeletingPathExtension]]);
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            DwnldrVaultImageView *imageView = [[DwnldrVaultImageView alloc] initWithVideo:video(filename) image:imagePath];
            imageView.image = image;
            imageView.frame = CGRectMake(x, y, videoSize, videoSize);
            x += videoSize + kSpacing;
            if ((index + 1) % kColumns == 0) {
                x = kSpacing;
                y += videoSize + kSpacing;
            }
            [self addSubview:imageView];
            [_videos addObject:imageView];
        }];
        self.alwaysBounceVertical = YES;
        self.contentSize = CGSizeMake(self.frame.size.width, (videoSize + kSpacing) * ceil((CGFloat)[[[Dwnldr sharedInstance] cachedVideos] count]/kColumns) + (kSpacing*1.5));
    }
    return self;
}

- (void)layoutSubviews {
    if (_laidOut)return;
    if (self.contentSize.height > self.frame.size.height) {
        self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
    }
    _laidOut = YES;
}

- (void)videosDeleted {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat videoSize = (self.frame.size.width / kColumns) - (kSpacing*1.25);
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat x = kSpacing;
            CGFloat y = (kSpacing*2);
            for (DwnldrVaultImageView *video in [self videos]) {
                NSUInteger index = [[self videos] indexOfObject:video];
                video.frame = CGRectMake(x, y, videoSize, videoSize);
                x += videoSize + kSpacing;
                if ((index + 1) % kColumns == 0) {
                    x = kSpacing;
                    y += videoSize + kSpacing;
                }
            }
        }];
        self.contentSize = CGSizeMake(self.frame.size.width, (videoSize + kSpacing) * ceil((CGFloat)[[[Dwnldr sharedInstance] cachedVideos] count]/kColumns) + (kSpacing*2));
    });
}

@end
