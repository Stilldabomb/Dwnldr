//
//  TMTumblrNativeVideoPostContentView.m
//  Dwnldr
//
//  Created by Stilldabomb on 12/9/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import "DwnldrVideoOverlayView.h"
ZKSwizzleInterface($_TMTumblrNativeVideoPostContentView, TMTumblrNativeVideoPostContentView, UIView)

@interface TMVideoPlayer : NSObject
@property (nonatomic,retain)NSURL *URL;
@property (nonatomic,retain)NSURL *placeholderImageURL;
@end

@interface TMDashboardVideoPlaybackView : UIView
@property (nonatomic,retain)TMVideoPlayer *player;
@end

@interface TMTumblrNativeVideoPostContentView : UIView
@property (nonatomic,retain)TMDashboardVideoPlaybackView *videoPlaybackView;
@end

@implementation $_TMTumblrNativeVideoPostContentView

- (void)layoutSubviews {
    ZKOrig(void);
    if (self.tag != 0) return;
    self.tag = [[Dwnldr sharedInstance] newTag];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [((TMTumblrNativeVideoPostContentView*)self).videoPlaybackView addGestureRecognizer:gesture];
    
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    DwnldrVideoOverlayView *overlay = [[DwnldrVideoOverlayView alloc] initWithFrame:frame];
    [self addSubview:overlay];
    [[[Dwnldr sharedInstance] cachedOverlays] setObject:overlay forKey:@(self.tag)];
}

- (BOOL)shouldAutoPlayVideo {
    return NO;
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    NSURL *videoURL = [[[(TMTumblrNativeVideoPostContentView*)self videoPlaybackView] player] URL];
    NSURL *placeHolderURL = [[[(TMTumblrNativeVideoPostContentView*)self videoPlaybackView] player] placeholderImageURL];
    NSLog(@"Hello, you called? (%@ -> %@)", videoURL, placeHolderURL);
    if(!videoURL || !placeHolderURL)return;
    for (UIGestureRecognizer *ge in self.gestureRecognizers) [ge setEnabled: NO];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Where would you like to save this video?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *vault = [UIAlertAction actionWithTitle:@"Video Vault" style:UIAlertActionStyleDefault handler:^void(UIAlertAction *action){
        [Dwnldr downloadVideo:videoURL withPlaceHolder:placeHolderURL videoIndex:self.tag];
    }];
    
    UIAlertAction *cameraRoll = [UIAlertAction actionWithTitle:@"Camera Roll" style:UIAlertActionStyleDefault handler:^void(UIAlertAction *action){
        [Dwnldr downloadVideo:videoURL withPlaceHolder:nil videoIndex:self.tag];
    }];
    
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSLog(@"Album");
    }];
    [album title];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:vault];
    [alert addAction:cameraRoll];
    //[alert addAction:album];
    [alert addAction:cancel];
    
    if ([alert respondsToSelector:@selector(popoverPresentationController)]) {
        alert.popoverPresentationController.sourceView = self;
        CGPoint loc = [gesture locationInView:self];
        alert.popoverPresentationController.sourceRect = CGRectMake(loc.x, loc.y, 1, 1);
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
    }
    [[[UIApplication sharedApplication] windows][0].rootViewController presentViewController:alert animated:YES completion:^{
        for (UIGestureRecognizer *ge in self.gestureRecognizers) [ge setEnabled: YES];
    }];
}

@end
