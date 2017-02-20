//
//  VpOrder.h
//
//  Created by HouYuShen  on 17/2/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VpOrder : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *vpOrderIdentifier;
@property (nonatomic, strong) NSString *serviceId;
@property (nonatomic, strong) NSString *payNumber;
@property (nonatomic, strong) NSString *payTime;
@property (nonatomic, strong) NSString *p12;
@property (nonatomic, strong) NSString *paid;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *orderPrice;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
