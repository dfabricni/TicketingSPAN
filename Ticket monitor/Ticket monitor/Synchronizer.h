//
//  Synchronizer.h
//  Ticket monitor
//
//  Created by Administrator on 11/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLFHttpClient.h"

@protocol SynchronizerDelegate;


@interface Synchronizer : NSObject<SLFHttpClientDelegate>

+ (id)instance;

-(void) Sync;
@property (nonatomic, weak) id<SynchronizerDelegate>delegate;

@end



@protocol SynchronizerDelegate <NSObject>


@optional
-(void) synchronizer:(Synchronizer*) sync  didFinishedSynchronizing:(id) object;

@optional
-(void) synchronizer:(Synchronizer*) sync  errorOccured:(NSError*) error;

@end