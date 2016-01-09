//
//  DwnldrVaultViewController.h
//  Dwnldr
//
//  Created by Stilldabomb on 12/12/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DwnldrVaultScrollView.h"
#import "DwnldrVaultImageView.h"

@interface DwnldrVaultViewController : UIViewController
@property (nonatomic)BOOL editing;
@property (nonatomic,retain)DwnldrVaultScrollView *scrollView;
@property (nonatomic,retain)UIBarButtonItem *closeButton;
@property (nonatomic,retain)UIBarButtonItem *deleteButton;
@property (nonatomic,retain)UIColor *color;
@property (nonatomic,retain)UIColor *trim;
@property (nonatomic,retain)UIColor *trim2;

+(instancetype)sharedInstance;
-(id)initWithColor:(UIColor*)color trim:(UIColor*)trim trim:(UIColor*)trim2;
-(void)backButtonPressed:(UIBarButtonItem*)item;
-(void)editButtonPressed:(UIBarButtonItem*)item;
-(void)deleteSelected:(UIBarButtonItem*)item;

@end
