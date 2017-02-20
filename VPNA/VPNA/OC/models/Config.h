//
//  Config.h
//
//  Created by HouYuShen  on 17/2/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Config : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *anyConnectUrl;
@property (nonatomic, strong) NSString *defaultPassword;
@property (nonatomic, strong) NSString *vpnHost;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
