//
//  Company.h
//  Ticket monitor
//
//  Created by Administrator on 18/12/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property(nonatomic,assign) int ID;
@property(nonatomic,strong) NSString * name;

-(void) nesto;

@end
