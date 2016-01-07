//
//  SLFCompanies.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFCompany.h"


NSString *const kSLFCompaniesId = @"Id";
NSString *const kSLFCompaniesName = @"Name";


@interface SLFCompany ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFCompany

@synthesize ID = _companiesIdentifier;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.ID = [[self objectOrNilForKey:kSLFCompaniesId fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kSLFCompaniesName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ID] forKey:kSLFCompaniesId];
    [mutableDict setValue:self.name forKey:kSLFCompaniesName];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.ID = [aDecoder decodeDoubleForKey:kSLFCompaniesId];
    self.name = [aDecoder decodeObjectForKey:kSLFCompaniesName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_companiesIdentifier forKey:kSLFCompaniesId];
    [aCoder encodeObject:_name forKey:kSLFCompaniesName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFCompany *copy = [[SLFCompany alloc] init];
    
    if (copy) {

        copy.ID = self.ID;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
