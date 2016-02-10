//
//  AppDelegate.m
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import "AppDelegate.h"
#import "DBRepository.h"
#import "SLFHttpClient.h"
#import "Globals.h"
#import "DataModels.h"
#import "ADAuthenticationContext.h"
#import "DBRepository.h"
#import "TicketDetaillViewController.h"
#import "Synchronizer.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    	UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
		UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
       [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
       [[UIApplication sharedApplication]  registerForRemoteNotifications];
    
    
    // UITabBarController * tabBarController =  (UITabBarController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
     //tabBarController.tabBar.barTintColor = [UIColor blackColor];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
   // [[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];

//
    // this will give selected icons and text your apps tint color
    //tabBarController.tabBar.tintColor = [UIColor colorWithRed:226 green:34 blue:33 alpha:1]; ;  // appTintColor is a UIColor *

    [DBRepository prepareSqlLiteFile];
    
   
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    const uint64_t *tokenBytes = deviceToken.bytes;
    NSString *hex = [NSString stringWithFormat:@"%016llx%016llx%016llx%016llx",
                 ntohll(tokenBytes[0]), ntohll(tokenBytes[1]),
                 ntohll(tokenBytes[2]), ntohll(tokenBytes[3])];

    
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    
     Globals * globals = [Globals instance];
    globals.device = [[SLFDevice alloc] init];
    globals.device.deviceID = [NSString stringWithFormat:@"%@", hex];
    globals.device.deviceType = [NSString stringWithFormat:@"A"];
    
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

   
     UIApplicationState state = application.applicationState;
    
    SLFNotification * notification   =[[SLFNotification alloc] initWithDictionary:userInfo];
    
    SLFHttpClient * httpClient = [SLFHttpClient sharedSLFHttpClient];
    
    
   
    if(state == UIApplicationStateBackground)
    {
        // just download it
        [httpClient getDetailByGUID:notification.GUID];
        
        
    } else if(state == UIApplicationStateInactive)
    {
        // download it  and  show it
        
        // [httpClient getDetailID:notification.detailID];
        
        // maybe first show view controller
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        TicketDetaillViewController *vc = (TicketDetaillViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TicketDetail"];
        [vc initWithTicketDetailID:notification.GUID];
        UITabBarController * tabBarController =  (UITabBarController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
       // TicketDetaillViewController * ticketDetailVC = nil;
       // [tabBarController.navigationController pushViewController:vc animated:true];
        
        // then cehck DB
        // if does not exists then dwnload it
       UINavigationController * navController =(UINavigationController*)[tabBarController.viewControllers objectAtIndex:0];
        
        // check is that view already on the stack
        if([navController.viewControllers count] == 1)
        {
        
            [navController pushViewController:vc animated:TRUE];
        
        }else if( [[navController.viewControllers objectAtIndex:1] isKindOfClass:[TicketDetaillViewController class]])
        {
            
            TicketDetaillViewController *vcExisting =(TicketDetaillViewController*) [navController.viewControllers objectAtIndex:1];
            [vcExisting initWithTicketDetailID:notification.GUID];
        }
        
        
    }
    else if(state == UIApplicationStateActive)
    {
        
        // download it and refresh Firstview screen (table)
        [httpClient getDetailByGUID:notification.GUID];
        
        
    }
    
    
    
    
    //NSLog(application.ap );
    
   /*
    
    //************************************************************
    // I only want this called if the user opened from swiping the push notification. 
    // Otherwise I just want to update the local model
    //************************************************************
    if(application.applicationState == UIApplicationStateActive) {
        
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        TicketDetaillViewController *vc = (TicketDetaillViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TicketDetail"];
        
        UIViewController * unknownController =  [[[[UIApplication sharedApplication] delegate] window] rootViewController];
       // UITabBarController * tabBarController =  (UITabBarController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        int n = 5;
      //  UINavigationController * navController =(UINavigationController*)[tabBarController.tabBar.items objectAtIndex:0];
        
      //  [navController pushViewController:vc animated:TRUE];
        
        
        
        
    } else {
        
        ///Update local model
        
        
        
    }
    */

    completionHandler(UIBackgroundFetchResultNewData);
}



@end
