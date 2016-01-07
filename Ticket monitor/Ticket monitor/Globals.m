//
//  Globals.m
//  Ticket monitor
//
//  Created by Administrator on 07/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import "Globals.h"
#import "DBRepository.h"

@implementation Globals


+ (id)instance {
    static Globals * shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared  = [[self alloc] init];
    });
    return shared;
}


- (id)init {
  if (self = [super init]) {
      
      // get settings
      
      DBRepository * repo =  [[DBRepository alloc] init];

      self.settings = [repo getSettings];
  
  }
  return self;
}


- (void) saveSettings {
   
    DBRepository * repo =  [[DBRepository alloc] init];
    [repo saveSettings:self.settings];
    
    
}


@end
