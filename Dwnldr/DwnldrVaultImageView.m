//
//  DwnldrVaultImageView.m
//  Dwnldr
//
//  Created by Stilldabomb on 12/13/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import "DwnldrVaultImageView.h"

@implementation DwnldrVaultImageView

- (id)initWithVideo:(NSString*)video image:(NSString*)image {
    if (self = [super init]) {
        _videoPath = video;
        _imagePath = image;
        self.userInteractionEnabled = YES;
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    if (_laidOut)return;
    CGSize selectSize = CGSizeMake(self.frame.size.width * 0.3, self.frame.size.height * 0.3);
    
    _selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-selectSize.width-2, 2, selectSize.width, selectSize.height)];
    _unselectedView = [[UIImageView alloc] initWithFrame:_selectedView.frame];
    
    [_selectedView setAlpha:0];
    [_selectedView setImage:[[Dwnldr sharedInstance] selectedImage]];
    [_selectedView setUserInteractionEnabled:YES];
    [_unselectedView setAlpha:0];
    [_unselectedView setImage:[[Dwnldr sharedInstance] unselectedImage]];
    [_unselectedView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *selectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected:)];
    UITapGestureRecognizer *unselectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected:)];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(modifyVideo:)];
    
    [_selectedView addGestureRecognizer:selectGesture];
    [_unselectedView addGestureRecognizer:unselectGesture];
    [self addGestureRecognizer:longPressGesture];
    
    [self addSubview:_unselectedView];
    [self addSubview:_selectedView];
    
    _laidOut = YES;
}

- (void)deleteVideo {
    [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:_imagePath error:nil];
    [self removeFromSuperview];
    [[Dwnldr sharedInstance] uncacheVideo:[_videoPath substringFromIndex:kVideosDirectory.length + 1] withPlaceHolder:[_imagePath substringFromIndex:kVideosDirectory.length + 1]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[DwnldrVaultViewController sharedInstance] scrollView] videos] removeObject:self];
    });
}

- (void)_deleteVideo {
    [self deleteVideo];
    [[[DwnldrVaultViewController sharedInstance] scrollView] videosDeleted];
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    NSURL *videoURL = [NSURL fileURLWithPath:_videoPath];
    //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    //[playerViewController.player play];//Used to Play On start
    [[DwnldrVaultViewController sharedInstance] presentViewController:playerViewController animated:YES completion:^{
        [player play];
    }];
}

- (void)selected:(UITapGestureRecognizer *)gesture {
    _selected = !_selected;
    [UIView animateWithDuration:0.2 animations:^{
        [_unselectedView setAlpha:_selected ? 0 : 1];
        [_selectedView setAlpha:_selected ? 1 : 0];
    }];
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    _selected = NO;
    [_tapGesture setEnabled:!_editing];
    [UIView animateWithDuration:0.2 animations:^{
        [_unselectedView setAlpha:_editing ? 1 : 0];
        [_selectedView setAlpha:0];
    }];
}

- (void)exportVideoFromVault:(NSString *)video {
    NSURL *url = [NSURL URLWithString:video];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
    } completionHandler:^(BOOL success, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"I'm sorry, but it looks like exporting the video from the vault didn't work, please report this error to me!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [[DwnldrVaultViewController sharedInstance] presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)modifyVideo:(UILongPressGestureRecognizer *)gesture {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraRoll = [UIAlertAction actionWithTitle:@"Export to Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self exportVideoFromVault:[self videoPath]];
    }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self _deleteVideo];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cameraRoll];
    [alert addAction:delete];
    [alert addAction:cancel];
    
    if ([alert respondsToSelector:@selector(popoverPresentationController)]) {
        alert.popoverPresentationController.sourceView = self;
        CGPoint loc = [gesture locationInView:self];
        alert.popoverPresentationController.sourceRect = CGRectMake(loc.x, loc.y, 1, 1);
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
    }
    
    [[DwnldrVaultViewController sharedInstance] presentViewController:alert animated:YES completion:nil];
}

@end
