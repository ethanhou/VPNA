//
//  YWObject+Utils.h
//  YWUIKitTool
//
//  Created by yangyanan on 15/5/20.
//  Copyright (c) 2015年 yangyanan. All rights reserved.
//

  
//
//
//
//  Copyright 2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

// ============================================================================
#import <Foundation/Foundation.h>
#include <AvailabilityMacros.h>
#include <TargetConditionals.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
#define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
#define MAC_OS_X_VERSION_10_6 1060
#endif

// ----------------------------------------------------------------------------
// CPP symbols that can be overridden in a prefix to control how the toolbox
// is compiled.
// ----------------------------------------------------------------------------


// By setting the GTM_CONTAINERS_VALIDATION_FAILED_LOG and
// GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
// when a validation fails. If you implement your own validators, you may want
// to control their internals using the same macros for consistency.
#ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
#define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
#endif

// Give ourselves a consistent way to do inlines.  Apple's macros even use
// a few different actual definitions, so we're based off of the foundation
// one.
#if !defined(GTM_INLINE)
#if defined (__GNUC__) && (__GNUC__ == 4)
#define GTM_INLINE static __inline__ __attribute__((always_inline))
#else
#define GTM_INLINE static __inline__
#endif
#endif

// Give ourselves a consistent way of doing externs that links up nicely
// when mixing objc and objc++
#if !defined (GTM_EXTERN)
#if defined __cplusplus
#define GTM_EXTERN extern "C"
#else
#define GTM_EXTERN extern
#endif
#endif

// Give ourselves a consistent way of exporting things if we have visibility
// set to hidden.
#if !defined (GTM_EXPORT)
#define GTM_EXPORT __attribute__((visibility("default")))
#endif

// _GTMDevLog & _GTMDevAssert
//
// _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
// developer level errors.  This implementation simply macros to NSLog/NSAssert.
// It is not intended to be a general logging/reporting system.
//
// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
// for a little more background on the usage of these macros.
//
//    _GTMDevLog           log some error/problem in debug builds
//    _GTMDevAssert        assert if conditon isn't met w/in a method/function
//                           in all builds.
//
// To replace this system, just provide different macro definitions in your
// prefix header.  Remember, any implementation you provide *must* be thread
// safe since this could be called by anything in what ever situtation it has
// been placed in.
//

// We only define the simple macros if nothing else has defined this.
#ifndef _GTMDevLog

#ifdef DEBUG
#define _GTMDevLog(...) NSLog(__VA_ARGS__)
#else
#define _GTMDevLog(...) do { } while (0)
#endif

#endif // _GTMDevLog

// Declared here so that it can easily be used for logging tracking if
// necessary. See GTMUnitTestDevLog.h for details.
@class NSString;
GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);

#ifndef _GTMDevAssert
// we directly invoke the NSAssert handler so we can pass on the varargs
// (NSAssert doesn't have a macro we can use that takes varargs)
#if !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _GTMDevAssert

// _GTMCompileAssert
// _GTMCompileAssert is an assert that is meant to fire at compile time if you
// want to check things at compile instead of runtime. For example if you
// want to check that a wchar is 4 bytes instead of 2 you would use
// _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
// Note that the second "arg" is not in quotes, and must be a valid processor
// symbol in it's own right (no spaces, punctuation etc).

// Wrapping this in an #ifndef allows external groups to define their own
// compile time assert scheme.
#ifndef _GTMCompileAssert
// We got this technique from here:
// http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

#define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
#define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
#define _GTMCompileAssert(test, msg) \
typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _GTMCompileAssert

// Macro to allow fast enumeration when building for 10.5 or later, and
// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
// does keys, so pick the right thing, nothing is done on the FastEnumeration
// side to be sure you're getting what you wanted.
#ifndef GTM_FOREACH_OBJECT
#if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (element in enumeration)
#define GTM_FOREACH_OBJECT(element, collection) \
for (element in collection)
#define GTM_FOREACH_KEY(element, collection) \
for (element in collection)
#else
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (NSEnumerator *_ ## element ## _enum = enumeration; \
(element = [_ ## element ## _enum nextObject]) != nil; )
#define GTM_FOREACH_OBJECT(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
#define GTM_FOREACH_KEY(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
#endif
#endif

// ============================================================================

// ----------------------------------------------------------------------------
// CPP symbols defined based on the project settings so the GTM code has
// simple things to test against w/o scattering the knowledge of project
// setting through all the code.
// ----------------------------------------------------------------------------

// Provide a single constant CPP symbol that all of GTM uses for ifdefing
// iPhone code.
#if TARGET_OS_IPHONE // iPhone SDK
// For iPhone specific stuff
#define GTM_IPHONE_SDK 1
#if TARGET_IPHONE_SIMULATOR
#define GTM_IPHONE_SIMULATOR 1
#else
#define GTM_IPHONE_DEVICE 1
#endif  // TARGET_IPHONE_SIMULATOR
#else
// For MacOS specific stuff
#define GTM_MACOS_SDK 1
#endif

// Some of our own availability macros
#if GTM_MACOS_SDK
#define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
#define GTM_AVAILABLE_ONLY_ON_MACOS
#else
#define GTM_AVAILABLE_ONLY_ON_IPHONE
#define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
#endif

// Provide a symbol to include/exclude extra code for GC support.  (This mainly
// just controls the inclusion of finalize methods).
#ifndef GTM_SUPPORT_GC
#if GTM_IPHONE_SDK
// iPhone never needs GC
#define GTM_SUPPORT_GC 0
#else
// We can't find a symbol to tell if GC is supported/required, so best we
// do on Mac targets is include it if we're on 10.5 or later.
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#define GTM_SUPPORT_GC 0
#else
#define GTM_SUPPORT_GC 1
#endif
#endif
#endif

// To simplify support for 64bit (and Leopard in general), we provide the type
// defines for non Leopard SDKs
#if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
// NSInteger/NSUInteger and Max/Mins
#ifndef NSINTEGER_DEFINED
#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif
#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX
#define NSINTEGER_DEFINED 1
#endif  // NSINTEGER_DEFINED
// CGFloat
#ifndef CGFLOAT_DEFINED
#if defined(__LP64__) && __LP64__
// This really is an untested path (64bit on Tiger?)
typedef double CGFloat;
#define CGFLOAT_MIN DBL_MIN
#define CGFLOAT_MAX DBL_MAX
#define CGFLOAT_IS_DOUBLE 1
#else /* !defined(__LP64__) || !__LP64__ */
typedef float CGFloat;
#define CGFLOAT_MIN FLT_MIN
#define CGFLOAT_MAX FLT_MAX
#define CGFLOAT_IS_DOUBLE 0
#endif /* !defined(__LP64__) || !__LP64__ */
#define CGFLOAT_DEFINED 1
#endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5


#pragma mark - base64
@interface GTMBase64 : NSObject

//
// Standard Base64 (RFC) handling
//

// encodeData:
//
/// Base64 encodes contents of the NSData object.
//
/// Returns:
///   A new autoreleased NSData with the encoded payload.  nil for any error.
//
+(NSData *)encodeData:(NSData *)data;

// decodeData:
//
/// Base64 decodes contents of the NSData object.
//
/// Returns:
///   A new autoreleased NSData with the decoded payload.  nil for any error.
//
+(NSData *)decodeData:(NSData *)data;

// encodeBytes:length:
//
/// Base64 encodes the data pointed at by |bytes|.
//
/// Returns:
///   A new autoreleased NSData with the encoded payload.  nil for any error.
//
+(NSData *)encodeBytes:(const void *)bytes length:(NSUInteger)length;

// decodeBytes:length:
//
/// Base64 decodes the data pointed at by |bytes|.
//
/// Returns:
///   A new autoreleased NSData with the encoded payload.  nil for any error.
//
+(NSData *)decodeBytes:(const void *)bytes length:(NSUInteger)length;

// stringByEncodingData:
//
/// Base64 encodes contents of the NSData object.
//
/// Returns:
///   A new autoreleased NSString with the encoded payload.  nil for any error.
//
+(NSString *)stringByEncodingData:(NSData *)data;

// stringByEncodingBytes:length:
//
/// Base64 encodes the data pointed at by |bytes|.
//
/// Returns:
///   A new autoreleased NSString with the encoded payload.  nil for any error.
//
+(NSString *)stringByEncodingBytes:(const void *)bytes length:(NSUInteger)length;

// decodeString:
//
/// Base64 decodes contents of the NSString.
//
/// Returns:
///   A new autoreleased NSData with the decoded payload.  nil for any error.
//
+(NSData *)decodeString:(NSString *)string;

//
// Modified Base64 encoding so the results can go onto urls.
//
// The changes are in the characters generated and also allows the result to
// not be padded to a multiple of 4.
// Must use the matching call to encode/decode, won't interop with the
// RFC versions.
//

// webSafeEncodeData:padded:
//
/// WebSafe Base64 encodes contents of the NSData object.  If |padded| is YES
/// then padding characters are added so the result length is a multiple of 4.
//
/// Returns:
///   A new autoreleased NSData with the encoded payload.  nil for any error.
//
+(NSData *)webSafeEncodeData:(NSData *)data
                      padded:(BOOL)padded;

// webSafeDecodeData:
//
/// WebSafe Base64 decodes contents of the NSData object.
//
/// Returns:
///   A new autoreleased NSData with the decoded payload.  nil for any error.
//
+(NSData *)webSafeDecodeData:(NSData *)data;

// webSafeEncodeBytes:length:padded:
//
/// WebSafe Base64 encodes the data pointed at by |bytes|.  If |padded| is YES
/// then padding characters are added so the result length is a multiple of 4.
//
/// Returns:
///   A new autoreleased NSData with the encoded payload.  nil for any error.
//
+(NSData *)webSafeEncodeBytes:(const void *)bytes
                       length:(NSUInteger)length
                       padded:(BOOL)padded;

// webSafeDecodeBytes:length:
//
/// WebSafe Base64 decodes the data pointed at by |bytes|.
//
/// Returns:
///   A new autoreleased NSData with the encoded payload.  nil for any error.
//
+(NSData *)webSafeDecodeBytes:(const void *)bytes length:(NSUInteger)length;

// stringByWebSafeEncodingData:padded:
//
/// WebSafe Base64 encodes contents of the NSData object.  If |padded| is YES
/// then padding characters are added so the result length is a multiple of 4.
//
/// Returns:
///   A new autoreleased NSString with the encoded payload.  nil for any error.
//
+(NSString *)stringByWebSafeEncodingData:(NSData *)data
                                  padded:(BOOL)padded;

// stringByWebSafeEncodingBytes:length:padded:
//
/// WebSafe Base64 encodes the data pointed at by |bytes|.  If |padded| is YES
/// then padding characters are added so the result length is a multiple of 4.
//
/// Returns:
///   A new autoreleased NSString with the encoded payload.  nil for any error.
//
+(NSString *)stringByWebSafeEncodingBytes:(const void *)bytes
                                   length:(NSUInteger)length
                                   padded:(BOOL)padded;

// webSafeDecodeString:
//
/// WebSafe Base64 decodes contents of the NSString.
//
/// Returns:
///   A new autoreleased NSData with the decoded payload.  nil for any error.
//
+(NSData *)webSafeDecodeString:(NSString *)string;

@end




inline static NSString* StringValue(id obj);
inline static NSAttributedString* AttributedStringValue(id obj);
inline static NSNumber* NumberValue(id obj);
inline static NSArray* ArrayValue(id obj);
inline static NSDictionary* DictionaryValue(id obj);
inline static NSString *StringValue(id obj)
{
    if([obj isKindOfClass:[NSString class]]){
        return (NSString *)obj;
    }else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @"";
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        return  [NSString stringWithFormat:@"%@",[obj description]];
    } else{
        return @"";
    }
    return @"";
}

inline static NSAttributedString *AttributedStringValue(id obj)
{
    if([obj isKindOfClass:[NSAttributedString class]]){
        return (NSAttributedString *)obj;
    }else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return [[NSAttributedString alloc] initWithString:@""];
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        NSString *strObj = [NSString stringWithFormat:@"%@",[obj description]];
        return [[NSAttributedString alloc] initWithString:strObj];
    } else{
        return [[NSAttributedString alloc] initWithString:@""];
    }
    return [[NSAttributedString alloc] initWithString:@""];
}

inline static NSNumber *NumberValue(id obj)
{
    if([obj isKindOfClass:[NSNumber class]]){
        NSNumber *num = nil;
        
        if (strcmp([obj objCType], @encode(char)) == 0) {
            num = [NSNumber numberWithChar:[obj charValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned char)) == 0) {
            num = [NSNumber numberWithUnsignedChar:[obj unsignedCharValue]];
        }
        else if (strcmp([obj objCType], @encode(short)) == 0) {
            num = [NSNumber numberWithShort:[obj shortValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned short)) == 0) {
            num = [NSNumber numberWithUnsignedShort:[obj unsignedShortValue]];
        }
        else if (strcmp([obj objCType], @encode(int)) == 0) {
            num = [NSNumber numberWithInt:[obj intValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned int)) == 0) {
            num = [NSNumber numberWithUnsignedInt:[obj unsignedIntValue]];
        }
        else if (strcmp([obj objCType], @encode(long)) == 0) {
            num = [NSNumber numberWithLong:[obj longValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned long)) == 0) {
            num = [NSNumber numberWithUnsignedLong:[obj unsignedLongValue]];
        }
        else if (strcmp([obj objCType], @encode(long long)) == 0) {
            num = [NSNumber numberWithLongLong:[obj longLongValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned long long)) == 0) {
            num = [NSNumber numberWithUnsignedLongLong:[obj unsignedLongLongValue]];
        }
        else if (strcmp([obj objCType], @encode(float)) == 0) {
            num = [NSNumber numberWithFloat:[obj floatValue]];
        }
        else if (strcmp([obj objCType], @encode(double)) == 0) {
            num = [NSNumber numberWithDouble:[obj doubleValue]];
        }
        else if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            num = [NSNumber numberWithBool:[obj boolValue]];
        }
        else {
            //To-Do  unkown num type ,num is nil
        }
        
        return num;
    }else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @(0);
    }else if ([obj isKindOfClass:[NSString class]]) {
        float fv  = [(NSString *)obj floatValue];
        if (fv <0) {
            return [NSNumber numberWithFloat:fv];
        }
        return @([(NSString *)obj doubleValue]);
    }else{
        return @(0);
    }
    
    return @(0);
}
inline static NSArray* ArrayValue(id obj)
{
    if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @[];
    }
    else if([obj isKindOfClass:[NSArray class]])
    {
        return (NSArray *)obj;
    }else{
        
        return @[];
    }
    return @[];
}
inline static NSDictionary* DictionaryValue(id obj)
{
    if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
        return  @{};
    }else if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    }else{
        return  @{};
    }
    return @{};
}
#pragma mark - string json
@interface NSString(json)
- (NSArray *)arrayValue;
- (NSDictionary *)dictionaryValue;
@end
#pragma mark - array json
@interface NSArray(json)
- (NSString *)jsonString;
- (NSString *)jsonPrettyPrintedString;
@end
#pragma mark - dictionary json
@interface NSDictionary(json)
- (NSString *)jsonString;
- (NSString *)jsonPrettyPrintedString;
@end
#pragma mark  - string utitls
@interface NSString(Utils)
- (NSString *)md5Sum;
+ (NSString *)encodeBase64:(NSString*)input;
+ (NSString *)encodeBase64WithData:(NSData *)input;
+ (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text;
- (NSString *)urlEncode;
- (NSString *)urlDecode;
+ (NSString *)generateTimestamp;
+ (NSString *)generateNonce;
- (NSString *)gtm_stringByUnescapingFromHTML;
+ (NSDictionary *)params:(NSString *)str;
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;
- (NSString *)trim;
- (NSString *)encodeUnicode;
- (NSString *)decodeUnicode;
- (NSString *)hexRepresentationWithSpaces_AS:(BOOL)spaces;
+ (NSDictionary *)stringFileToDic:(NSString *)path;
@end


#define IFPGA_NAMESTRING				@"iFPGA"

#define IPHONE_1G_NAMESTRING			@"iPhone 1G"
#define IPHONE_3G_NAMESTRING			@"iPhone 3G"
#define IPHONE_3GS_NAMESTRING			@"iPhone 3GS"
#define IPHONE_4_NAMESTRING				@"iPhone4"
#define IPHONE_4s_NAMESTRING			@"iPhone4s"
#define IPHONE_5_NAMESTRING				@"iPhone5"
#define IPHONE_5c_NAMESTRING			@"iPhone5c"
#define IPHONE_5s_NAMESTRING			@"iPhone5s"
#define IPHONE_6_NAMESTRING             @"iPhone6"
#define IPHONE_6_P_NAMESTRING			@"iPhone6 Plus"
#define IPHONE_6s_NAMESTRING			@"iPhone6s"
#define IPHONE_6s_P_NAMESTRING			@"iPhone6s Plus"
#define IPHONE_UNKNOWN_NAMESTRING		@"Unknown iPhone"

#define IPOD_1G_NAMESTRING				@"iPod touch 1G"
#define IPOD_2G_NAMESTRING				@"iPod touch 2G"
#define IPOD_3G_NAMESTRING				@"iPod touch 3G"
#define IPOD_4G_NAMESTRING				@"iPod touch 4G"
#define IPOD_5G_NAMESTRING				@"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING			@"Unknown iPod"

#define IPAD_1G_NAMESTRING				@"iPad1"
#define IPAD_2G_NAMESTRING				@"iPad2"
#define IPAD_3G_NAMESTRING				@"iPad3"
#define IPAD_4G_NAMESTRING				@"iPad4"
#define IPAD_Air_NAMESTRING				@"iPad Air"
#define IPAD_Air2_NAMESTRING			@"iPad Air 2"
#define IPAD_Mini_NAMESTRING			@"iPad mini"
#define IPAD_Mini2_NAMESTRING			@"iPad mini 2"
#define IPAD_Mini3_NAMESTRING			@"iPad mini 3"
#define IPAD_Mini4_NAMESTRING			@"iPad mini 4"
#define IPAD_UNKNOWN_NAMESTRING			@"Unknown iPad"

// Nano? Apple TV?
#define APPLETV_2G_NAMESTRING			@"Apple TV 2G"
#define APPLETV_3G_NAMESTRING			@"Apple TV 3G"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceiPhoneSimulator,
    UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
    UIDeviceiPhoneSimulatoriPad,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4siPhone,
    UIDevice5iPhone,
    UIDevice5cPhone,
    UIDevice5siPhone,
    UIDevice6iPhone,
    UIDevice6PiPhone,
    UIDevice6siPhone,
    UIDevice6sPiPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    UIDevice5GiPod,
    
    UIDevice1GiPad, // both regular and 3G
    UIDevice2GiPad,
    UIDevice3GiPad,
    UIDevice4GiPad,
    UIDeviceAirGiPad,
    UIDeviceAir2GiPad,
    UIDeviceiPadMini,
    UIDeviceiPadMini2,
    UIDeviceiPadMini3,
    UIDeviceiPadMini4,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceIFPGA,
    
} UIDevicePlatform;
#pragma mark - Device
@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSString *) platformString;
- (NSString *) platformCode;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;

- (BOOL)isIOS6;
- (BOOL)isIOS7OrLater;
- (BOOL)isIphone5;
- (BOOL)isMCOK;//麦克风ok
- (BOOL)isiPhone6;
- (BOOL)isiPhone6P;
- (float)matchiPhoneType:(float)f;

- (BOOL)isJailbroken;
@end
#pragma mark - RGB HEX Color
#if (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#define HXColor UIColor
#else
#import <Foundation/Foundation.h>
#define HXColor NSColor
#endif

@interface HXColor (HexColorAddition)

+ (HXColor *)colorWithHexString:(NSString *)hexString;
+ (HXColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (HXColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (HXColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
+ (NSString *)stringColor:(HXColor *)color;
@end




#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Utilities)
+ (NSCalendar *) currentCalendar; // avoid bottlenecks

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Short string utilities
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) stringWithFormat: (NSString *) format;
+ (NSString *) stringWithNowDate;
+ (NSString *) stringWithDate:(NSDate *)date formater:(NSString *)formaterString;
+ (NSString *) stringWithTimeInterval:(NSTimeInterval)time formater:(NSString *)formaterString;


@property (nonatomic, readonly) NSString *shortString;
@property (nonatomic, readonly) NSString *shortDateString;
@property (nonatomic, readonly) NSString *shortTimeString;
@property (nonatomic, readonly) NSString *mediumString;
@property (nonatomic, readonly) NSString *mediumDateString;
@property (nonatomic, readonly) NSString *mediumTimeString;
@property (nonatomic, readonly) NSString *longString;
@property (nonatomic, readonly) NSString *longDateString;
@property (nonatomic, readonly) NSString *longTimeString;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;

- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;

- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isNextMonth;
- (BOOL) isLastMonth;

- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;

- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingYears: (NSInteger) dYears;
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;

// Date extremes
- (NSDate *) dateAtStartOfDay;
- (NSDate *) dateAtEndOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
@end


@interface NSObject (Utils)

/**
 *  防止文件被备份到iCloud 和iTunes,加此方法后存入document里面的数据就不会被备份
 *   [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:filePath]];
 *
 **/
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end
