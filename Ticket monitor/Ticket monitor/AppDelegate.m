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

#import "Synchronizer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    	UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
		UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
       [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
       [[UIApplication sharedApplication]  registerForRemoteNotifications];
    
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

    
    
    SLFNotification * notification   =[[SLFNotification alloc] initWithDictionary:userInfo];
    
    SLFHttpClient * httpClient = [SLFHttpClient sharedSLFHttpClient];
    
    [httpClient getDetailID:notification.detailID];
    
    
    //************************************************************
    // I only want this called if the user opened from swiping the push notification. 
    // Otherwise I just want to update the local model
    //************************************************************
    if(application.applicationState == UIApplicationStateActive) {
        
        
        //MPOOpenViewController *openVc = [[MPOOpenViewController alloc] init];
       // [self.navigationController pushViewController:openVc animated:NO];
        
        
    } else {
        
        ///Update local model
        
        
        
    }

    completionHandler(UIBackgroundFetchResultNewData);
}



@end
