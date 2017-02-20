//
//  PayModel.h
//
//  Created by Peter  on 2017/2/20
//  Copyright (c) 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PayModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *service;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
