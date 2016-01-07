//
//  Globals.h
//  Ticket monitor
//
//  Created by Administrator on 07/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModels.h"

@interface Globals : NSObject


@property (nonatomic, retain) NSString * oAuthAccessToken;
@property (nonatomic, retain) SLFSettings * settings;

@property (nonatomic, assign) long  servicesTimestamp;


+ (id)instance;

-(void) saveSettings;

@end
