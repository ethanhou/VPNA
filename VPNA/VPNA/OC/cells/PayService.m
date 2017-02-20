//
//  PayService.m
//
//  Created by Peter  on 2017/2/20
//  Copyright (c) 2017 Developer. All rights reserved.
//

#import "PayService.h"


NSString *const kPayServiceServiceType = @"serviceType";
NSString *const kPayServiceId = @"id";
NSString *const kPayServiceSupportContent = @"supportContent";
NSString *const kPayServicePeriod = @"period";
NSString *const kPayServiceServiceName = @"serviceName";
NSString *const kPayServicePrice = @"price";


@interface PayService ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PayService

@synthesize serviceType = _serviceType;
@synthesize serviceIdentifier = _serviceIdentifier;
@synthesize supportContent = _supportContent;
@synthesize period = _period;
@synthesize serviceName = _serviceName;
@synthesize price = _price;


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
            self.serviceType = [[self objectOrNilForKey:kPayServiceServiceType fromDictionary:dict] doubleValue];
            self.serviceIdentifier = [[self objectOrNilForKey:kPayServiceId fromDictionary:dict] doubleValue];
            self.supportContent = [self objectOrNilForKey:kPayServiceSupportContent fromDictionary:dict];
            self.period = [self objectOrNilForKey:kPayServicePeriod fromDictionary:dict];
            self.serviceName = [self objectOrNilForKey:kPayServiceServiceName fromDictionary:dict];
            self.price = [[self objectOrNilForKey:kPayServicePrice fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.serviceType] forKey:kPayServiceServiceType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.serviceIdentifier] forKey:kPayServiceId];
    [mutableDict setValue:self.supportContent forKey:kPayServiceSupportContent];
    [mutableDict setValue:self.period forKey:kPayServicePeriod];
    [mutableDict setValue:self.serviceName forKey:kPayServiceServiceName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kPayServicePrice];

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

    self.serviceType = [aDecoder decodeDoubleForKey:kPayServiceServiceType];
    self.serviceIdentifier = [aDecoder decodeDoubleForKey:kPayServiceId];
    self.supportContent = [aDecoder decodeObjectForKey:kPayServiceSupportContent];
    self.period = [aDecoder decodeObjectForKey:kPayServicePeriod];
    self.serviceName = [aDecoder decodeObjectForKey:kPayServiceServiceName];
    self.price = [aDecoder decodeDoubleForKey:kPayServicePrice];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_serviceType forKey:kPayServiceServiceType];
    [aCoder encodeDouble:_serviceIdentifier forKey:kPayServiceId];
    [aCoder encodeObject:_supportContent forKey:kPayServiceSupportContent];
    [aCoder encodeObject:_period forKey:kPayServicePeriod];
    [aCoder encodeObject:_serviceName forKey:kPayServiceServiceName];
    [aCoder encodeDouble:_price forKey:kPayServicePrice];
}

- (id)copyWithZone:(NSZone *)zone
{
    PayService *copy = [[PayService alloc] init];
    
    if (copy) {

        copy.serviceType = self.serviceType;
        copy.serviceIdentifier = self.serviceIdentifier;
        copy.supportContent = [self.supportContent copyWithZone:zone];
        copy.period = [self.period copyWithZone:zone];
        copy.serviceName = [self.serviceName copyWithZone:zone];
        copy.price = self.price;
    }
    
    return copy;
}


@end
