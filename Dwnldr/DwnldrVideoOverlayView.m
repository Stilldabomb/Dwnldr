//
//  DwnldrVideoOverlayView.m
//  Dwnldr
//
//  Created by Stilldabomb on 12/14/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import "DwnldrVideoOverlayView.h"

@implementation DwnldrVideoOverlayView

- (void)layoutSubviews {
    if (_laidOut)return;
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    CGRect frame = _indicatorView.frame;
    frame.origin = CGPointMake(self.frame.size.width - frame.size.width - 5, 5);
    
    _indicatorView.frame = frame;
    
    _anchorView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2, 1, 1)];
    
    [self addSubview:_indicatorView];
    [self addSubview:_anchorView];
    self.userInteractionEnabled = NO;
    
    _laidOut = YES;
}

@end
