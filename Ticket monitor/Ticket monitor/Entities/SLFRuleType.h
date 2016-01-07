//
//  SLFRuleType.h
//  Ticket monitor
//
//  Created by Administrator on 07/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFRuleType : NSObject


@property (nonatomic, assign) int ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) BOOL active;

@end
