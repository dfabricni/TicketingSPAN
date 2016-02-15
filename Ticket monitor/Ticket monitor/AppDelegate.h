//
//  AppDelegate.h
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFHttpClient.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, SLFHttpClientDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

