//
//  SLFSubjectsResponse.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFSubjectsResponse.h"
#import "SLFSubject.h"


NSString *const kSLFSubjectsResponseSubjects = @"subjects";
NSString *const kSLFSubjectsResponseMaxtimestamp = @"maxtimestamp";


@interface SLFSubjectsResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFSubjectsResponse

@synthesize subjects = _subjects;
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
    NSObject *receivedSLFSubjects = [dict objectForKey:kSLFSubjectsResponseSubjects];
    NSMutableArray *parsedSLFSubjects = [NSMutableArray array];
    if ([receivedSLFSubjects isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSLFSubjects) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSLFSubjects addObject:[SLFSubject modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSLFSubjects isKindOfClass:[NSDictionary class]]) {
       [parsedSLFSubjects addObject:[SLFSubject modelObjectWithDictionary:(NSDictionary *)receivedSLFSubjects]];
    }

    self.subjects = [NSArray arrayWithArray:parsedSLFSubjects];
            self.maxtimestamp = [[self objectOrNilForKey:kSLFSubjectsResponseMaxtimestamp fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForSubjects = [NSMutableArray array];
    for (NSObject *subArrayObject in self.subjects) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForSubjects addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForSubjects addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSubjects] forKey:kSLFSubjectsResponseSubjects];
    [mutableDict setValue:[NSNumber numberWithDouble:self.maxtimestamp] forKey:kSLFSubjectsResponseMaxtimestamp];

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

    self.subjects = [aDecoder decodeObjectForKey:kSLFSubjectsResponseSubjects];
    self.maxtimestamp = [aDecoder decodeDoubleForKey:kSLFSubjectsResponseMaxtimestamp];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_subjects forKey:kSLFSubjectsResponseSubjects];
    [aCoder encodeDouble:_maxtimestamp forKey:kSLFSubjectsResponseMaxtimestamp];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFSubjectsResponse *copy = [[SLFSubjectsResponse alloc] init];
    
    if (copy) {

        copy.subjects = [self.subjects copyWithZone:zone];
        copy.maxtimestamp = self.maxtimestamp;
    }
    
    return copy;
}


@end
