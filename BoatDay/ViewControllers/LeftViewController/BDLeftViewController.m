//
//  BDLeftViewController.m
//  BoatDay
//
//  Created by Diogo Nunes on 19/06/14.
//  Copyright (c) 2014 Rocksauce Studios LLC. All rights reserved.
//

#import "BDLeftViewController.h"
#import "BDHomeViewController.h"
#import "BDProfileViewController.h"
#import "BDLoginViewController.h"
#import "BDMyBoatsViewController.h"
#import "BDFindABoatDayViewController.h"
#import "BDMyEventsViewController.h"
#import "BDNotificationsViewController.h"
#import "BDBoatTowingViewController.h"
#import "BDSettingsViewController.h"
#import "BDHostRegistrationViewController.h"

#import "BDLeftMenuCell.h"

#define SELECTED_COLOR RGB(36, 154, 175)

@interface BDLeftViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *footerView;



@end

@implementation BDLeftViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoggedInNotification:)
                                                 name:@"userLoggedIn"
                                               object:nil];
    
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - Setup Methods

- (void) setupTableView {
    
    // setup table view
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = SELECTED_COLOR;
    self.tableView.delaysContentTouches = NO;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

#pragma mark - UITableView Datasource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (CGRectGetMaxY(self.tableView.frame) > CGRectGetMinY(self.footerView.frame)) {
      
        return (self.view.frame.size.height-20)/[BDLeftViewController sideMenuNumberOfRows];
//        return 48.0;
    }
    else {

        return 50.0;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [BDLeftViewController sideMenuNumberOfRows];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    BDLeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        
        cell = [[BDLeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont abelFontWithSize:17.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }
    
    cell.accessoryView = nil;
    
    SideMenu sideMenu = [BDLeftViewController convertSideMenuIndex:indexPath.row];
    
    if ([Session sharedSession].selectedSideMenu == sideMenu) {
        [self setCellColor:SELECTED_COLOR forCell:cell];
    }
    else {
        [self setCellColor:[UIColor clearColor] forCell:cell];
    }
    
    switch (sideMenu) {
        case SideMenuHome:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.home", nil);
            
            break;
        case SideMenuFindABoatDay:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.findABoatDay", nil);
            
            break;
        case SideMenuMyProfile:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.myProfile", nil);
            
            break;
        case SideMenuMyEvents:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.myEvents", nil);
            
            break;
        case SideMenuNotifications:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.notifications", nil);
            
            break;
        case SideMenuHostRegistration:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.hostRegistration", nil);
            
            break;
        case SideMenuMyBoats:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.myBoats", nil);
            
            break;
        case SideMenuEmergencyBoatTowing:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.emergencyBoatTowing", nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidemenu_call"]];
            
            break;
        case SideMenuSettings:
            cell.textLabel.text = NSLocalizedString(@"sideMenu.settings", nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidemenu_settings"]];
            
            break;
        default:
            break;
    }
    
    
    return cell;
}


- (void)setCellColor:(UIColor *)color forCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenu pressedSideMenu = [BDLeftViewController convertSideMenuIndex:indexPath.row];
    
    [self openViewController:pressedSideMenu];
    
    [self.tableView reloadData];
    
}

- (void) openViewController:(SideMenu)pressedSideMenu {
    
    [Session sharedSession].selectedSideMenu = pressedSideMenu;
    
    UIViewController *centerViewController;
    
    switch (pressedSideMenu) {
        case SideMenuHome:
        {
            [self openHomeView];
            return;
        }
            break;
        case SideMenuFindABoatDay:
            centerViewController = [[BDFindABoatDayViewController alloc] init];
            break;
        case SideMenuMyProfile:
            centerViewController = [[BDProfileViewController alloc] initWithUser:[User currentUser] andProfileType:ProfileTypeSelf];
            break;
        case SideMenuMyEvents:
            centerViewController = [[BDMyEventsViewController alloc] init];
            break;
        case SideMenuNotifications:
            centerViewController = [[BDNotificationsViewController alloc] init];
            break;
        case SideMenuHostRegistration:
            centerViewController = [[BDHostRegistrationViewController alloc] init];
            break;
        case SideMenuMyBoats:
            centerViewController = [[BDMyBoatsViewController alloc] init];
            break;
        case SideMenuEmergencyBoatTowing:
            centerViewController = [[BDBoatTowingViewController alloc] init];
            break;
        case SideMenuSettings:
            centerViewController = [[BDSettingsViewController alloc] init];
            break;
        default:
            break;
    }
    
    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:centerViewController];
    
    [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
    
}


#pragma mark - Methods

- (void) openHomeView {
    
    UINavigationController *centerViewController = (UINavigationController *)self.mm_drawerController.centerViewController;
    
    if ([User currentUser]) {
        
        if ([[centerViewController.childViewControllers lastObject] isKindOfClass:[BDHomeViewController class]]) {
            [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
            
        } else {
            BDHomeViewController *homeViewController = [[BDHomeViewController alloc] init];
            UIViewController *viewController = [[MMNavigationController alloc] initWithRootViewController:homeViewController];
            
            [self.mm_drawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
        }
        
    }
    else {
        
        if ([[centerViewController.childViewControllers lastObject] isKindOfClass:[BDLoginViewController class]]) {
            [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        } else {
            BDLoginViewController *loginViewController = [[BDLoginViewController alloc] init];
            UIViewController *viewController = [[MMNavigationController alloc] initWithRootViewController:loginViewController];
            
            [self.mm_drawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
        }
        
    }
    
}

#pragma mark - Notification Methods

- (void) userLoggedInNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:@"userLoggedIn"]) {
        
        [UIView hideViewAnimated:self.tableView withAlpha:YES andDuration:0.2];
        
        UIActivityIndicatorView * activityindicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50, 50, 30, 30)];
        [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityindicator setColor:[UIColor whiteColor]];
        [self.view addSubview:activityindicator];
        
        activityindicator.center = self.view.center;
        setFrameY(activityindicator, activityindicator.frame.origin.y - 100.0);
        
        [activityindicator startAnimating];
        
        [self performSelector:@selector(stopActivity:) withObject:activityindicator afterDelay:1.0];
        
    }
    
}

- (void)stopActivity:(UIActivityIndicatorView*)activity {
    
    [activity removeFromSuperview];
    
    [self.tableView reloadData];
    
    [UIView showViewAnimated:self.tableView withAlpha:YES andDuration:0.2];
    
}

#pragma mark - Convert Arrays

+ (NSArray *) getCurrentConvertArray {
    
    NSArray *convertArray;
    
    if ([User currentUser] && [Session sharedSession].dataWasFechted) {
        
        if ([Session sharedSession].hostRegistration) {
            
            if ([[Session sharedSession].hostRegistration.status intValue] == HostRegistrationStatusAccepted) {
                
                convertArray = [BDLeftViewController hostRegistrationAccepted];
            }
            else {
                
                // last step of registration, otherwise it should be with HostRegistrationStatusPending
                if ([[Session sharedSession].hostRegistration.merchantStatus isEqualToString:@"active"]) {
                    
                    convertArray = [BDLeftViewController hostRegistrationPending];
                    
                }
                else {
                    
                    convertArray = [BDLeftViewController hostRegistrationNormal];
                    
                }
                
            }
            
        }
        else {
            
            convertArray = [BDLeftViewController hostRegistrationNormal];
            
        }
    }
    else {
        
        convertArray = [BDLeftViewController loggedOutArray];
        
    }
    
    return convertArray;
    
}

+ (SideMenu) convertSideMenuIndex:(NSInteger)index {
    
    NSArray *convertArray = [BDLeftViewController getCurrentConvertArray];
    
    return [convertArray[index] integerValue];
    
}

+ (NSInteger) sideMenuNumberOfRows {
    
    NSArray *convertArray = [BDLeftViewController getCurrentConvertArray];
    
    return convertArray.count;
    
}

+ (NSArray *)hostRegistrationAccepted {
    
    static NSArray *_convertArray;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _convertArray = @[@(SideMenuHome),
                          @(SideMenuNotifications),
                          @(SideMenuFindABoatDay),
                          @(SideMenuMyEvents),
                          @(SideMenuMyBoats),
                          @(SideMenuMyProfile),
                          @(SideMenuSettings),
                          @(SideMenuEmergencyBoatTowing)];
    });
    
    return _convertArray;
    
}

+ (NSArray *)hostRegistrationPending {
    
    static NSArray *_convertArray;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _convertArray = @[@(SideMenuHome),
                          @(SideMenuNotifications),
                          @(SideMenuFindABoatDay),
                          @(SideMenuMyEvents),
                          @(SideMenuMyBoats),
                          @(SideMenuMyProfile),
                          @(SideMenuSettings),
                          @(SideMenuEmergencyBoatTowing)];
    });
    
    return _convertArray;
    
}

+ (NSArray *)hostRegistrationNormal {
    
    static NSArray *_convertArray;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _convertArray = @[@(SideMenuHome),
                          @(SideMenuNotifications),
                          @(SideMenuFindABoatDay),
                          @(SideMenuMyEvents),
                          @(SideMenuMyProfile),
                          @(SideMenuHostRegistration),
                          @(SideMenuSettings),
                          @(SideMenuEmergencyBoatTowing)];
    });
    
    return _convertArray;
    
}

+ (NSArray *)loggedOutArray {
    
    static NSArray *_convertArray;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _convertArray = @[@(SideMenuHome),
                          @(SideMenuSettings),
                          @(SideMenuEmergencyBoatTowing)];
    });
    
    return _convertArray;
    
}

@end
