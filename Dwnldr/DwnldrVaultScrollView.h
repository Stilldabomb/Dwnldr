//
//  DwnldrVaultScrollView.h
//  Dwnldr
//
//  Created by Stilldabomb on 12/13/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DwnldrVaultScrollView : UIScrollView
@property (nonatomic,retain)NSMutableArray *videos;
@property (nonatomic)BOOL laidOut;

-(void)videosDeleted;
@end
