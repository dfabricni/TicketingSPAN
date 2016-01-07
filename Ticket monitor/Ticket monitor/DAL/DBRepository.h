//
//  DBRepository.h
//  Ticket monitor
//
//  Created by Administrator on 18/12/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DataModels.h"


@interface DBRepository : NSObject




@property(atomic,strong)  FMDatabase * DB;


-(NSMutableArray *) getAllCompanies;

-(NSMutableArray *) getAllSubjects;

-(NSMutableArray *) getAllServices;

-(NSMutableArray *) getAllRuleTypes;

-(void) saveSettings:(SLFSettings*) settings;

-(SLFSettings *) getSettings;



+(void) prepareSqlLiteFile;


@end
