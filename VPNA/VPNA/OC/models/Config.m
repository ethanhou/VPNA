//
//  Config.m
//
//  Created by HouYuShen  on 17/2/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Config.h"


NSString *const kConfigAnyConnectUrl = @"anyConnectUrl";
NSString *const kConfigDefaultPassword = @"defaultPassword";
NSString *const kConfigVpnHost = @"vpn_host";


@interface Config ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Config

@synthesize anyConnectUrl = _anyConnectUrl;
@synthesize defaultPassword = _defaultPassword;
@synthesize vpnHost = _vpnHost;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.anyConnectUrl = [self objectOrNilForKey:kConfigAnyConnectUrl fromDictionary:dict];
            self.defaultPassword = [self objectOrNilForKey:kConfigDefaultPassword fromDictionary:dict];
            self.vpnHost = [self objectOrNilForKey:kConfigVpnHost fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.anyConnectUrl forKey:kConfigAnyConnectUrl];
    [mutableDict setValue:self.defaultPassword forKey:kConfigDefaultPassword];
    [mutableDict setValue:self.vpnHost forKey:kConfigVpnHost];

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

    self.anyConnectUrl = [aDecoder decodeObjectForKey:kConfigAnyConnectUrl];
    self.defaultPassword = [aDecoder decodeObjectForKey:kConfigDefaultPassword];
    self.vpnHost = [aDecoder decodeObjectForKey:kConfigVpnHost];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_anyConnectUrl forKey:kConfigAnyConnectUrl];
    [aCoder encodeObject:_defaultPassword forKey:kConfigDefaultPassword];
    [aCoder encodeObject:_vpnHost forKey:kConfigVpnHost];
}

- (id)copyWithZone:(NSZone *)zone {
    Config *copy = [[Config alloc] init];
    
    
    
    if (copy) {

        copy.anyConnectUrl = [self.anyConnectUrl copyWithZone:zone];
        copy.defaultPassword = [self.defaultPassword copyWithZone:zone];
        copy.vpnHost = [self.vpnHost copyWithZone:zone];
    }
    
    return copy;
}


@end
