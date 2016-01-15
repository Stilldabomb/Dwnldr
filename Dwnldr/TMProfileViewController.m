//
//  TMSettingsViewController.m
//  Dwnldr
//
//  Created by Stilldabomb on 12/9/15.
//  Copyright © 2015 Stilldabomb. All rights reserved.
//

#import "DwnldrVaultViewController.h"
#import "DwnldrVaultNavigationController.h"

ZKSwizzleInterface($_TMProfileViewController, TMProfileViewController, UITableViewController)

@implementation $_TMProfileViewController

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if ([indexPath section] != 0) {
        return ZKOrig(UITableViewCell*, tableView, indexPath);
    }
    
    if ([indexPath row] == 0) {
        cell = ZKOrig(UITableViewCell*, tableView, indexPath);
        cell.textLabel.text = @"Dwnlder Video Vault";
        cell.imageView.image = nil;
        [[Dwnldr sharedInstance] setTrim:cell.textLabel.textColor];
        
        //cell.image = [UIImage imageWithContentsOfFile:asset(@"padlock.png")];
        for (UIView *view in cell.contentView.subviews) {
            if ([view class] != NSClassFromString(@"UITableViewLabel"))
                continue;
            UILabel *label = (UILabel*)view;
            NSString *ltext = [[[label text] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
            if ([[[NSNumberFormatter alloc] init] numberFromString:ltext] != nil || [ltext isEqualToString:@""]) {
                NSString *text = [NSString stringWithFormat:@"%lu", (unsigned long)[[[Dwnldr sharedInstance] cachedVideos] count]];
                label.text = [text isEqualToString:@"0"] ? @"" : text;
                [[Dwnldr sharedInstance] setTrim2:label.textColor];
            }
        }
    } else {
        cell = ZKOrig(UITableViewCell*, tableView, [NSIndexPath indexPathForRow:([indexPath row] - 1) inSection:0]);
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = ZKOrig(NSInteger, tableView, section);
    
    if (section == 0) {
        return rows+1;
    }
    
    return rows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] != 0) {
        ZKOrig(void, tableView, indexPath);
        return;
    }
    
    if ([indexPath row] == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DwnldrVaultNavigationController *vault = [[DwnldrVaultNavigationController alloc] init];
        DwnldrVaultViewController *vvc = [[DwnldrVaultViewController alloc] initWithColor:self.tableView.backgroundColor trim:[[Dwnldr sharedInstance] trim] trim:[[Dwnldr sharedInstance] trim2]];
        vault.viewControllers = @[vvc];
        
        [self presentViewController:vault animated:YES completion:nil];
    } else {
        ZKOrig(void, tableView, [NSIndexPath indexPathForRow:[indexPath row] - 1 inSection:0]);
    }
}

@end
