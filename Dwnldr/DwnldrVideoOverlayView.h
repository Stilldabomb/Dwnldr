//
//  DwnldrVideoOverlayView.h
//  Dwnldr
//
//  Created by Stilldabomb on 12/14/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface DwnldrVideoOverlayView : UIView
@property (nonatomic,retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic,retain) UIView *anchorView;
@property (nonatomic) BOOL laidOut;
@end
