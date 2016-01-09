//
//  DwnldrVaultViewController.m
//  Dwnldr
//
//  Created by Stilldabomb on 12/12/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import "DwnldrVaultViewController.h"

@implementation DwnldrVaultViewController

static id instance;

+ (instancetype)sharedInstance {
    if (!instance) return [[DwnldrVaultViewController alloc] init];
    return instance;
}

- (id)initWithColor:(UIColor *)color trim:(UIColor *)trim trim:(UIColor *)trim2 {
    if (self = [super init]) {
        _color = color;
        _trim = trim;
        _trim2 = trim2;
    }
    instance = self;
    return self;
}

- (void)loadView {
    [super loadView];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarStyle:)]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
#pragma GCC diagnostic pop
    [[self view] setBackgroundColor:_color];
    [[[self navigationController] navigationBar] setBarTintColor:_color];
    [[[self navigationController] navigationBar] setTintColor:_trim2];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName : _trim}];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
    _closeButton = self.navigationItem.rightBarButtonItem;
    _deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteSelected:)];
    
    self.navigationItem.title = @"Dwnldr Video Vault";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        _scrollView = [[DwnldrVaultScrollView alloc] initWithFrame:frame];
        [self.view addSubview:_scrollView];
    });
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationItem.leftBarButtonItem.title = _editing ? @"Done" : @"Edit";
        self.navigationItem.leftBarButtonItem.style = _editing ? UIBarButtonItemStyleDone : UIBarButtonItemStylePlain;
    }];
    self.navigationItem.rightBarButtonItem = _editing ? _deleteButton : _closeButton;
    for (DwnldrVaultImageView *im in _scrollView.videos) {
        [im setEditing:_editing];
    }
}

- (void)backButtonPressed:(UIBarButtonItem *)item {
    [[[Dwnldr sharedInstance] tumblrProfileViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)editButtonPressed:(UIBarButtonItem*)item {
    if ([item.title isEqualToString:@"Edit"]) {
        [self setEditing:YES];
    } else if ([item.title isEqualToString:@"Done"]) {
        [self setEditing:NO];
    }
}

- (void)deleteSelected:(UIBarButtonItem *)item {
    for (DwnldrVaultImageView *im in _scrollView.videos) {
        if ([im selected]) {
            [im deleteVideo];
        }
    }
    [_scrollView videosDeleted];
    [self setEditing:NO];
}

@end
