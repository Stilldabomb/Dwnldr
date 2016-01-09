//
//  Dwnldr.m
//  Dwnldr
//
//  Created by Stilldabomb on 12/9/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import "DwnldrVideoOverlayView.h"

@implementation Dwnldr

+ (void)load {
    [self sharedInstance];
}

+ (id)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Dwnldr alloc] init];
    });
    return instance;
}

+ (void)downloadVideo:(NSURL *)URL withPlaceHolder:(NSURL *)placeHolderURL videoIndex:(NSInteger)videoIndex {
    [[self sharedInstance] downloadVideo:URL withPlaceHolder:placeHolderURL videoIndex:videoIndex];
}

+ (void)cacheVideos {
    [[self sharedInstance] cacheVideos];
}

+ (void)cacheVideo:(NSString*)video withPlaceHolder:(NSString*)placeHolder {
    [[self sharedInstance] cacheVideo:video withPlaceHolder:placeHolder];
}

+ (void)exportVideo:(NSString*)video {
    [[self sharedInstance] exportVideo:video];
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (id) init {
    if (self = [super init]) {
        [self cacheVideos];
        _cachedOverlays = [NSMutableDictionary dictionary];
        _unselectedImage = [UIImage imageWithContentsOfFile:asset(@"unselected.png")];
        _selectedImage = [UIImage imageWithContentsOfFile:asset(@"selected.png")];
        _playImage = [UIImage imageWithContentsOfFile:asset(@"play.png")];
    }
    return self;
}

- (void)downloadVideo:(NSURL* _Nonnull)URL withPlaceHolder:(NSURL* _Nullable)placeHolderURL videoIndex:(NSInteger)index {
    // Start animating for the downloading
    DwnldrVideoOverlayView *overlay = [[self cachedOverlays] objectForKey:@(index)];
    [[overlay indicatorView] startAnimating];
    [[overlay indicatorView] setAlpha:0];
    [UIView animateWithDuration:0.2 animations:^{
        [[overlay indicatorView] setAlpha:1];
    }];
    
    // Make sure home and temp directories exists
    [[NSFileManager defaultManager] createDirectoryAtPath:kVideosDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:kTempDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Get date for saving the file
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-mm-YYYY_hh:mm:ssa"];
    
    // File names
    __block NSString *video;
    __block NSString *placeholder;
    
    // Download video
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        video = [NSString stringWithFormat:@"%@.%@", [dateFormatter stringFromDate:date], [[response suggestedFilename] pathExtension]];
        
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:placeHolderURL ? kVideosDirectory : kTempDirectory];
        NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:video];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:documentURL error:nil];
        
        // Export video if placeholder doesn't exist
        if (!placeHolderURL) {
            [self exportVideo:video videoIndex:index];
            return;
        }
        
        if (placeholder) {
            [Dwnldr cacheVideo:video withPlaceHolder:placeholder];
            NSLog(@"%@", [overlay indicatorView]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    [[overlay indicatorView] setAlpha:0];
                } completion:^(BOOL completed){
                    if (completed) {
                        [[overlay indicatorView] stopAnimating];
                        [[overlay indicatorView] setHidden:YES];
                        [[overlay indicatorView] setAlpha: 1];
                    }
                }];
            });
        }
    }];
    [downloadTask resume];
    
    // Return if placeholder isn't there
    if (!placeHolderURL)
        return;
    
    // Download placeholder image
    NSURLRequest *placeHolderRequest = [NSURLRequest requestWithURL:placeHolderURL];
    
    NSURLSession *placeHolderSession = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *placeHolderDownloadTask = [placeHolderSession downloadTaskWithRequest:placeHolderRequest completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        placeholder = [NSString stringWithFormat:@"%@.%@", [dateFormatter stringFromDate:date], [[response suggestedFilename] pathExtension]];
        
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:kVideosDirectory];
        NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:placeholder];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:documentURL error:nil];
        
        if (video) {
            [Dwnldr cacheVideo:video withPlaceHolder:placeholder];
            NSLog(@"%@", [overlay indicatorView]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    [[overlay indicatorView] setAlpha:0];
                } completion:^(BOOL completed){
                    if (completed) {
                        [[overlay indicatorView] stopAnimating];
                        [[overlay indicatorView] setHidden:YES];
                        [[overlay indicatorView] setAlpha: 1];
                    }
                }];
            });
        }
    }];
    [placeHolderDownloadTask resume];
}

- (void)cacheVideos {
    [self setCachedVideos:[NSMutableArray array]];
    [self setCachedPlaceHolders:[NSMutableDictionary dictionary]];
    NSArray *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:kVideosDirectory error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"avi"] || [extension isEqualToString: @"mov"] || [extension isEqualToString: @"qt"] || [extension isEqualToString: @"mp4"] || [extension isEqualToString: @"m4v"]) {
            [[self cachedVideos] addObject:filename];
            return;
        } else if ([extension isEqualToString:@"jpg"] || [extension isEqualToString: @"jpeg"] || [extension isEqualToString: @"png"]) {
            [[self cachedPlaceHolders] setObject:filename forKey:[filename stringByDeletingPathExtension]];
        }
    }];
}

- (void)cacheVideo:(NSString*)video withPlaceHolder:(NSString*)placeHolder {
    if ([[self cachedVideos] containsObject:video] || [[self cachedPlaceHolders] objectForKey:placeHolder])
        return;
    [[self cachedVideos] addObject:video];
    [[self cachedPlaceHolders] setObject:placeHolder forKey:[video stringByDeletingPathExtension]];
}

- (void)uncacheVideo:(NSString *)video {
    if (!([[self cachedVideos] containsObject:video] && [[self cachedPlaceHolders] objectForKey:video]))
        return;
    [[self cachedVideos] removeObject:video];
    [[self cachedPlaceHolders] removeObjectForKey:[video stringByDeletingPathExtension]];
}

- (void)exportVideo:(NSString *)video videoIndex:(NSInteger)index {
    NSURL *url = [NSURL URLWithString:filefrom(kTempDirectory,video)];
    DwnldrVideoOverlayView *overlay = [[self cachedOverlays] objectForKey:@(index)];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                [[overlay indicatorView] setAlpha:0];
            } completion:^(BOOL completed){
                if (completed) {
                    [[overlay indicatorView] stopAnimating];
                    [[overlay indicatorView] setHidden:YES];
                    [[overlay indicatorView] setAlpha: 1];
                }
            }];
            [[NSFileManager defaultManager] removeItemAtPath:[url absoluteString] error:nil];
        });
    }];
}

- (NSInteger)newTag {
    if (_newTag == 0)_newTag++;
    return _newTag++;
}


@end
