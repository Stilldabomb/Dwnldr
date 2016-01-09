//
//  TMTabBarController.m
//  Dwnldr
//
//  Created by Stilldabomb on 12/11/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

ZKSwizzleInterface($_TMTabBarController, TMTabBarController, UITabBarController)

@implementation $_TMTabBarController

- (id)initWithBackgroundFetchDistributor:(id)arg1 dataServiceFactory:(id)arg2 requestSenderFactory:(id)arg3 formTokenRequest:(id)arg4 liveUpdaterManager:(id)arg5 coreDataController:(id)arg6 applicationCoordinator:(id)arg7 {
    self = ZKOrig(id,arg1,arg2,arg3,arg4,arg5,arg6,arg7);
    [[Dwnldr sharedInstance] setTumblrTabBarController:self];
    return self;
}

@end

ZKSwizzleInterface($_TMSplitViewController, TMSplitViewController, UISplitViewController)

@implementation $_TMSplitViewController

- (id)initWithBackgroundFetchDistributor:(id)arg1 dataServiceFactory:(id)arg2 requestSenderFactory:(id)arg3 formTokenRequest:(id)arg4 coreDataController:(id)arg5 applicationCoordinator:(id)arg6 liveUpdaterManager:(id)arg7 {
    self = ZKOrig(id,arg1,arg2,arg3,arg4,arg5,arg6,arg7);
    [[Dwnldr sharedInstance] setTumblrSplitViewController:self];
    return self;
}

@end
