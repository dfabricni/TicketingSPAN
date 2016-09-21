;//
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
    
   // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   // [userDefaults setObject:nil forKey:@"SLFRefreshToken"];
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

-(void) slfHTTPClient:(SLFHttpClient *)client didFinishedWithPullingAndUpdatingFromBackgroundTask:(id)object taskID:(UIBackgroundTaskIdentifier)taskID
{
    
    UIApplication  *app = [UIApplication sharedApplication];
    client.delegate = nil;
    [app endBackgroundTask:taskID];
    
}
-(void) slfHTTPClient:(SLFHttpClient *)client didFailWithErrorFromBackgroundTask:(NSError *)error taskID:(UIBackgroundTaskIdentifier)taskID
{
    UIApplication  *app = [UIApplication sharedApplication];
    client.delegate = nil;
    [app endBackgroundTask:taskID];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

   
     UIApplicationState state = application.applicationState;
    
    SLFNotification * notification   =[[SLFNotification alloc] initWithDictionary:userInfo];
    
    
    
    
   
    if(state == UIApplicationStateBackground)
    {
        /*
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // just download it
             
             [httpClient getDetailByGUID:notification.GUID];
             
         });
        
           */
        UIBackgroundTaskIdentifier bgTask;

            UIApplication  *app = [UIApplication sharedApplication];

            bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
                
                NSLog(@"Timeout for background process");
            }];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * username = [userDefaults objectForKey:@"SLFUsername"];
        
        SLFHttpClient * httpClient = [SLFHttpClient createSLFHttpClient];
        httpClient.delegate = self;
        [httpClient getDetailByGUIDFromBackgroundTask:notification.GUID username:username  taskID:bgTask];
        

        
    } else if(state == UIApplicationStateInactive)
    {
        // download it  and  show it
        
        // [httpClient getDetailID:notification.detailID];
        
     //   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1), dispatch_get_main_queue(), ^{
   
            
        

        // maybe first show view controller
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        TicketDetaillViewController *vc = (TicketDetaillViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TicketDetail"];
        [vc initWithTicketDetailID:notification.GUID];
        UITabBarController * tabBarController =  (UITabBarController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
       // TicketDetaillViewController * ticketDetailVC = nil;
       // [tabBarController.navigationController pushViewController:vc animated:true];
       
        // then cehck DB
        // if does not exists then dwnload it
       UINavigationController * navController = (UINavigationController*)[tabBarController.viewControllers objectAtIndex:0];
        
        long count = [navController.viewControllers count];
        
        if([[navController.viewControllers objectAtIndex:count-1] isKindOfClass:[TicketDetaillViewController class]])
        {
            TicketDetaillViewController *vcExisting = (TicketDetaillViewController*)[navController.viewControllers objectAtIndex:count-1];
            [vcExisting initWithTicketDetailID:notification.GUID];
        
        }else
        {
            [navController pushViewController:vc animated:TRUE];
        }
      
        
        
    }
    else if(state == UIApplicationStateActive)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * username = [userDefaults objectForKey:@"SLFUsername"];
        SLFHttpClient * httpClient = [SLFHttpClient createSLFHttpClient];
        // download it and refresh Firstview screen (table)
        [httpClient getDetailByGUID:notification.GUID username:username];
        
        
    }
    
    
    
  
    completionHandler(UIBackgroundFetchResultNewData);
}



@end
