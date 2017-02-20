//
//  UserModel.m
//
//  Created by HouYuShen  on 17/2/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "UserModel.h"


NSString *const kUserModelPassword = @"password";
NSString *const kUserModelId = @"id";
NSString *const kUserModelMobile = @"mobile";
NSString *const kUserModelDeviceId = @"deviceId";
NSString *const kUserModelCreateTime = @"createTime";
NSString *const kUserModelTerminal = @"terminal";


@interface UserModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserModel

@synthesize password = _password;
@synthesize internalUserModelIdentifier = _internalUserModelIdentifier;
@synthesize mobile = _mobile;
@synthesize deviceId = _deviceId;
@synthesize createTime = _createTime;
@synthesize terminal = _terminal;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.password = [self objectOrNilForKey:kUserModelPassword fromDictionary:dict];
            self.internalUserModelIdentifier = [[self objectOrNilForKey:kUserModelId fromDictionary:dict] doubleValue];
            self.mobile = [self objectOrNilForKey:kUserModelMobile fromDictionary:dict];
            self.deviceId = [self objectOrNilForKey:kUserModelDeviceId fromDictionary:dict];
            self.createTime = [[self objectOrNilForKey:kUserModelCreateTime fromDictionary:dict] doubleValue];
            self.terminal = [self objectOrNilForKey:kUserModelTerminal fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.password forKey:kUserModelPassword];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalUserModelIdentifier] forKey:kUserModelId];
    [mutableDict setValue:self.mobile forKey:kUserModelMobile];
    [mutableDict setValue:self.deviceId forKey:kUserModelDeviceId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.createTime] forKey:kUserModelCreateTime];
    [mutableDict setValue:self.terminal forKey:kUserModelTerminal];

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

    self.password = [aDecoder decodeObjectForKey:kUserModelPassword];
    self.internalUserModelIdentifier = [aDecoder decodeDoubleForKey:kUserModelId];
    self.mobile = [aDecoder decodeObjectForKey:kUserModelMobile];
    self.deviceId = [aDecoder decodeObjectForKey:kUserModelDeviceId];
    self.createTime = [aDecoder decodeDoubleForKey:kUserModelCreateTime];
    self.terminal = [aDecoder decodeObjectForKey:kUserModelTerminal];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_password forKey:kUserModelPassword];
    [aCoder encodeDouble:_internalUserModelIdentifier forKey:kUserModelId];
    [aCoder encodeObject:_mobile forKey:kUserModelMobile];
    [aCoder encodeObject:_deviceId forKey:kUserModelDeviceId];
    [aCoder encodeDouble:_createTime forKey:kUserModelCreateTime];
    [aCoder encodeObject:_terminal forKey:kUserModelTerminal];
}

- (id)copyWithZone:(NSZone *)zone {
    UserModel *copy = [[UserModel alloc] init];
    
    
    
    if (copy) {

        copy.password = [self.password copyWithZone:zone];
        copy.internalUserModelIdentifier = self.internalUserModelIdentifier;
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.deviceId = [self.deviceId copyWithZone:zone];
        copy.createTime = self.createTime;
        copy.terminal = [self.terminal copyWithZone:zone];
    }
    
    return copy;
}


@end
