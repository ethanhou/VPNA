//
//  UserModel.h
//
//  Created by HouYuShen  on 17/2/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, assign) double createTime;
@property (nonatomic, strong) NSString *terminal;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
