//
//  PayService.m
//
//  Created by HouYuShen  on 17/2/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "PayService.h"


NSString *const kPayServiceServiceType = @"serviceType";
NSString *const kPayServiceId = @"id";
NSString *const kPayServiceSupportContent = @"supportContent";
NSString *const kPayServicePrice = @"price";
NSString *const kPayServicePeriod = @"period";
NSString *const kPayServiceServiceName = @"serviceName";


@interface PayService ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PayService

@synthesize serviceType = _serviceType;
@synthesize payServiceIdentifier = _payServiceIdentifier;
@synthesize supportContent = _supportContent;
@synthesize price = _price;
@synthesize period = _period;
@synthesize serviceName = _serviceName;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.serviceType = [self objectOrNilForKey:kPayServiceServiceType fromDictionary:dict];
            self.payServiceIdentifier = [self objectOrNilForKey:kPayServiceId fromDictionary:dict];
            self.supportContent = [self objectOrNilForKey:kPayServiceSupportContent fromDictionary:dict];
            self.price = [self objectOrNilForKey:kPayServicePrice fromDictionary:dict];
            self.period = [self objectOrNilForKey:kPayServicePeriod fromDictionary:dict];
            self.serviceName = [self objectOrNilForKey:kPayServiceServiceName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.serviceType forKey:kPayServiceServiceType];
    [mutableDict setValue:self.payServiceIdentifier forKey:kPayServiceId];
    [mutableDict setValue:self.supportContent forKey:kPayServiceSupportContent];
    [mutableDict setValue:self.price forKey:kPayServicePrice];
    [mutableDict setValue:self.period forKey:kPayServicePeriod];
    [mutableDict setValue:self.serviceName forKey:kPayServiceServiceName];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.serviceType = [aDecoder decodeObjectForKey:kPayServiceServiceType];
    self.payServiceIdentifier = [aDecoder decodeObjectForKey:kPayServiceId];
    self.supportContent = [aDecoder decodeObjectForKey:kPayServiceSupportContent];
    self.price = [aDecoder decodeObjectForKey:kPayServicePrice];
    self.period = [aDecoder decodeObjectForKey:kPayServicePeriod];
    self.serviceName = [aDecoder decodeObjectForKey:kPayServiceServiceName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_serviceType forKey:kPayServiceServiceType];
    [aCoder encodeObject:_payServiceIdentifier forKey:kPayServiceId];
    [aCoder encodeObject:_supportContent forKey:kPayServiceSupportContent];
    [aCoder encodeObject:_price forKey:kPayServicePrice];
    [aCoder encodeObject:_period forKey:kPayServicePeriod];
    [aCoder encodeObject:_serviceName forKey:kPayServiceServiceName];
}

- (id)copyWithZone:(NSZone *)zone {
    PayService *copy = [[PayService alloc] init];
    
    
    
    if (copy) {

        copy.serviceType = [self.serviceType copyWithZone:zone];
        copy.payServiceIdentifier = [self.payServiceIdentifier copyWithZone:zone];
        copy.supportContent = [self.supportContent copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.period = [self.period copyWithZone:zone];
        copy.serviceName = [self.serviceName copyWithZone:zone];
    }
    
    return copy;
}


@end
