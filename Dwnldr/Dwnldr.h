//
//  Dwnldr.h
//  Dwnldr
//
//  Created by Stilldabomb on 12/9/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import "DwnldrVideoOverlayView.h"

@interface Dwnldr : NSObject
@property (nonatomic,retain)NSMutableArray *cachedVideos;
@property (nonatomic,retain)NSMutableDictionary *cachedPlaceHolders;
@property (nonatomic,retain)NSMutableDictionary<NSNumber*,DwnldrVideoOverlayView*> *cachedOverlays;
@property (nonatomic,retain)UIImage *unselectedImage;
@property (nonatomic,retain)UIImage *selectedImage;
@property (nonatomic,retain)UIImage *playImage;
@property (nonatomic)NSInteger newTag;
@property (nonatomic)UIColor *trim;
@property (nonatomic)UIColor *trim2;
+(id)sharedInstance;
+(void)downloadVideo:(NSURL*)URL withPlaceHolder:(NSURL*)placeHolderURL videoIndex:(NSInteger)index;
+(void)cacheVideos;
+(void)cacheVideo:(NSString*)video withPlaceHolder:(NSString*)placeHolder;
+(void)exportVideo:(NSString*)video;
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

-(void)downloadVideo:(NSURL*)URL withPlaceHolder:(NSURL*)placeHolderURL videoIndex:(NSInteger)index;
-(void)cacheVideos;
-(void)cacheVideo:(NSString*)video withPlaceHolder:(NSString*)placeHolder;
-(void)uncacheVideo:(NSString*)video;
-(void)exportVideo:(NSString*)video videoIndex:(NSInteger)index;
@end
