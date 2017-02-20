//
//  PayService.h
//
//  Created by Peter  on 2017/2/20
//  Copyright (c) 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PayService : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double serviceType;
@property (nonatomic, assign) double serviceIdentifier;
@property (nonatomic, strong) NSString *supportContent;
@property (nonatomic, strong) NSString *period;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, assign) double price;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
