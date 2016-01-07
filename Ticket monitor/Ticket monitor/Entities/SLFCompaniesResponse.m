//
//  SLFCompaniesResponse.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFCompaniesResponse.h"
#import "SLFCompany.h"


NSString *const kSLFCompaniesResponseCompanies = @"companies";
NSString *const kSLFCompaniesResponseMaxtimestamp = @"maxtimestamp";


@interface SLFCompaniesResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFCompaniesResponse

@synthesize companies = _companies;
@synthesize maxtimestamp = _maxtimestamp;


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
    NSObject *receivedSLFCompanies = [dict objectForKey:kSLFCompaniesResponseCompanies];
    NSMutableArray *parsedSLFCompanies = [NSMutableArray array];
    if ([receivedSLFCompanies isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSLFCompanies) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSLFCompanies addObject:[SLFCompany modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSLFCompanies isKindOfClass:[NSDictionary class]]) {
       [parsedSLFCompanies addObject:[SLFCompany modelObjectWithDictionary:(NSDictionary *)receivedSLFCompanies]];
    }

    self.companies = [NSArray arrayWithArray:parsedSLFCompanies];
            self.maxtimestamp = [[self objectOrNilForKey:kSLFCompaniesResponseMaxtimestamp fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForCompanies = [NSMutableArray array];
    for (NSObject *subArrayObject in self.companies) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCompanies addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCompanies addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCompanies] forKey:kSLFCompaniesResponseCompanies];
    [mutableDict setValue:[NSNumber numberWithDouble:self.maxtimestamp] forKey:kSLFCompaniesResponseMaxtimestamp];

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

    self.companies = [aDecoder decodeObjectForKey:kSLFCompaniesResponseCompanies];
    self.maxtimestamp = [aDecoder decodeDoubleForKey:kSLFCompaniesResponseMaxtimestamp];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_companies forKey:kSLFCompaniesResponseCompanies];
    [aCoder encodeDouble:_maxtimestamp forKey:kSLFCompaniesResponseMaxtimestamp];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFCompaniesResponse *copy = [[SLFCompaniesResponse alloc] init];
    
    if (copy) {

        copy.companies = [self.companies copyWithZone:zone];
        copy.maxtimestamp = self.maxtimestamp;
    }
    
    return copy;
}


@end
