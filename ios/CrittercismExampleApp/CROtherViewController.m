/*
 * Copyright 2015 Crittercism
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#import "CROtherViewController.h"
#import <Crittercism/Crittercism.h>
#import "GlobalLog.h"

#define kUsernameSection 0
#define kMetaDataSection 1
#define kBreadcrumbsSection 2
#define kOutOutStatus 3

@interface CROtherViewController ()
@property (nonatomic, strong) NSArray *usernames;
@property (nonatomic, strong) NSArray *metadata;
@property (nonatomic, strong) NSArray *breadcrumbs;
@property (nonatomic, strong) NSArray *optOut;
@end

@implementation CROtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernames = @[ @"Bob", @"Jim", @"Sue" ];
    _metadata = @[ @"5", @"30", @"50" ];
    _breadcrumbs = @[ @"hello world", @"abc", @"123" ];
    _optOut = @[ @"Opt Out", @"Opt In" ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kUsernameSection) {
        return _usernames.count;
    } else if (section == kMetaDataSection) {
        return _metadata.count;
    } else if (section == kBreadcrumbsSection) {
        return _breadcrumbs.count;
    } else if(section == kOutOutStatus) {
        return _optOut.count;
    }
    
    assert(NO);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell" forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor blueColor];
    
    if(indexPath.section == kUsernameSection) {
        NSString *username = _usernames[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Set Username: %@", username];
    } else if(indexPath.section == kMetaDataSection) {
        NSString *gameLevel = _metadata[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Set Level: %@", gameLevel];
    } else if(indexPath.section == kBreadcrumbsSection) {
        NSString *breadcrumb = _breadcrumbs[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Leave: '%@'", breadcrumb];
    } else if(indexPath.section == kOutOutStatus) {
        cell.textLabel.text = _optOut[indexPath.row];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == kUsernameSection) {
        return @"Set Username:";
    } else if(section == kMetaDataSection) {
        return @"Set Metadata:";
    } else if(section == kBreadcrumbsSection) {
        return @"Leave Breadcrumb:";
    } else if(section == kOutOutStatus) {
        BOOL isOptedOut = [Crittercism getOptOutStatus];
        return [NSString stringWithFormat:@"Opt-out Status: %@", isOptedOut ? @"YES" : @"NO" ];
    }
    
    assert(NO);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kUsernameSection) {
        [Crittercism setUsername:_usernames[indexPath.row]];
    } else if (indexPath.section == kMetaDataSection) {
        [Crittercism setValue:_metadata[indexPath.row] forKey:@"Game Level"];
    } else if (indexPath.section == kBreadcrumbsSection) {
        [Crittercism leaveBreadcrumb:_breadcrumbs[indexPath.row]];
    } else if (indexPath.section == kOutOutStatus) {
        if (indexPath.row == 0) {
            [Crittercism setOptOutStatus:YES];
        } else {
            [Crittercism setOptOutStatus:NO];
        }

        [tableView reloadData];
    }

    [self performSelector:@selector(fadeSelection:)
               withObject:@(YES)
               afterDelay:0.3];
}

- (void)fadeSelection:(BOOL)animated
{
    NSIndexPath *selection = [self.tView indexPathForSelectedRow];
    if (selection) {
        [self.tView deselectRowAtIndexPath:selection animated:animated];
    }
}

@end
