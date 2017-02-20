//
//  PayService.h
//
//  Created by HouYuShen  on 17/2/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PayService : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *serviceId;
@property (nonatomic, strong) NSString *supportContent;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *period;
@property (nonatomic, strong) NSString *serviceName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
