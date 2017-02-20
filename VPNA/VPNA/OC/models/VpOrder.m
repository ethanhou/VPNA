//
//  VpOrder.m
//
//  Created by HouYuShen  on 17/2/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "VpOrder.h"


NSString *const kVpOrderDeviceId = @"deviceId";
NSString *const kVpOrderUserId = @"userId";
NSString *const kVpOrderId = @"id";
NSString *const kVpOrderServiceId = @"serviceId";
NSString *const kVpOrderPayNumber = @"payNumber";
NSString *const kVpOrderPayTime = @"payTime";
NSString *const kVpOrderP12 = @"p12";
NSString *const kVpOrderPaid = @"paid";
NSString *const kVpOrderCreateTime = @"createTime";
NSString *const kVpOrderOrderPrice = @"orderPrice";


@interface VpOrder ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation VpOrder

@synthesize deviceId = _deviceId;
@synthesize userId = _userId;
@synthesize orderId = _orderId;
@synthesize serviceId = _serviceId;
@synthesize payNumber = _payNumber;
@synthesize payTime = _payTime;
@synthesize p12 = _p12;
@synthesize paid = _paid;
@synthesize createTime = _createTime;
@synthesize orderPrice = _orderPrice;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.deviceId = [self objectOrNilForKey:kVpOrderDeviceId fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kVpOrderUserId fromDictionary:dict];
            self.orderId = [self objectOrNilForKey:kVpOrderId fromDictionary:dict];
            self.serviceId = [self objectOrNilForKey:kVpOrderServiceId fromDictionary:dict];
            self.payNumber = [self objectOrNilForKey:kVpOrderPayNumber fromDictionary:dict];
            self.payTime = [self objectOrNilForKey:kVpOrderPayTime fromDictionary:dict];
            self.p12 = [self objectOrNilForKey:kVpOrderP12 fromDictionary:dict];
            self.paid = [self objectOrNilForKey:kVpOrderPaid fromDictionary:dict];
            self.createTime = [self objectOrNilForKey:kVpOrderCreateTime fromDictionary:dict];
            self.orderPrice = [self objectOrNilForKey:kVpOrderOrderPrice fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.deviceId forKey:kVpOrderDeviceId];
    [mutableDict setValue:self.userId forKey:kVpOrderUserId];
    [mutableDict setValue:self.orderId forKey:kVpOrderId];
    [mutableDict setValue:self.serviceId forKey:kVpOrderServiceId];
    [mutableDict setValue:self.payNumber forKey:kVpOrderPayNumber];
    [mutableDict setValue:self.payTime forKey:kVpOrderPayTime];
    [mutableDict setValue:self.p12 forKey:kVpOrderP12];
    [mutableDict setValue:self.paid forKey:kVpOrderPaid];
    [mutableDict setValue:self.createTime forKey:kVpOrderCreateTime];
    [mutableDict setValue:self.orderPrice forKey:kVpOrderOrderPrice];

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

    self.deviceId = [aDecoder decodeObjectForKey:kVpOrderDeviceId];
    self.userId = [aDecoder decodeObjectForKey:kVpOrderUserId];
    self.orderId = [aDecoder decodeObjectForKey:kVpOrderId];
    self.serviceId = [aDecoder decodeObjectForKey:kVpOrderServiceId];
    self.payNumber = [aDecoder decodeObjectForKey:kVpOrderPayNumber];
    self.payTime = [aDecoder decodeObjectForKey:kVpOrderPayTime];
    self.p12 = [aDecoder decodeObjectForKey:kVpOrderP12];
    self.paid = [aDecoder decodeObjectForKey:kVpOrderPaid];
    self.createTime = [aDecoder decodeObjectForKey:kVpOrderCreateTime];
    self.orderPrice = [aDecoder decodeObjectForKey:kVpOrderOrderPrice];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_deviceId forKey:kVpOrderDeviceId];
    [aCoder encodeObject:_userId forKey:kVpOrderUserId];
    [aCoder encodeObject:_orderId forKey:kVpOrderId];
    [aCoder encodeObject:_serviceId forKey:kVpOrderServiceId];
    [aCoder encodeObject:_payNumber forKey:kVpOrderPayNumber];
    [aCoder encodeObject:_payTime forKey:kVpOrderPayTime];
    [aCoder encodeObject:_p12 forKey:kVpOrderP12];
    [aCoder encodeObject:_paid forKey:kVpOrderPaid];
    [aCoder encodeObject:_createTime forKey:kVpOrderCreateTime];
    [aCoder encodeObject:_orderPrice forKey:kVpOrderOrderPrice];
}

- (id)copyWithZone:(NSZone *)zone {
    VpOrder *copy = [[VpOrder alloc] init];
    
    
    
    if (copy) {

        copy.deviceId = [self.deviceId copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.serviceId = [self.serviceId copyWithZone:zone];
        copy.payNumber = [self.payNumber copyWithZone:zone];
        copy.payTime = [self.payTime copyWithZone:zone];
        copy.p12 = [self.p12 copyWithZone:zone];
        copy.paid = [self.paid copyWithZone:zone];
        copy.createTime = [self.createTime copyWithZone:zone];
        copy.orderPrice = [self.orderPrice copyWithZone:zone];
    }
    
    return copy;
}


@end
