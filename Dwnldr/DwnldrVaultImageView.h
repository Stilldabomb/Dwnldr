//
//  DwnldrVaultImageView.h
//  Dwnldr
//
//  Created by Stilldabomb on 12/13/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DwnldrVaultViewController.h"

@interface DwnldrVaultImageView : UIImageView
@property (nonatomic,retain) NSString *videoPath;
@property (nonatomic,retain) NSString *imagePath;
@property (nonatomic,retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic,retain) UIImageView *selectedView;
@property (nonatomic,retain) UIImageView *unselectedView;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL editing;
@property (nonatomic) BOOL laidOut;

- (id)initWithVideo:(NSString*)video image:(NSString*)image;
- (void)deleteVideo;
- (void)tapped:(UITapGestureRecognizer*)gesture;
- (void)selected:(UITapGestureRecognizer*)gesture;
- (void)modifyVideo:(UILongPressGestureRecognizer*)gesture;

@end
