//
//  GPXType.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXType.h"

#include <time.h>
#include <xlocale.h>

@implementation GPXType

+ (double)latitude:(NSString *)value
{
    @try {
        double f = [value doubleValue];
        if (-90.0 <= f && f <= 90.0) {
            return f;
        }
    }
    @catch (NSException *exception) {
    }
    
    return 0.0;
}

+ (NSString *)valueForLatitude:(double)latitude
{
    if (-90.0 <= latitude && latitude <= 90.0) {
        return [NSString stringWithFormat:@"%f", latitude];
    }
    
    return @"0";
}

+ (double)longitude:(NSString *)value
{
    @try {
        double f = [value doubleValue];
        if (-180.0 <= f && f <= 180.0) {
            return f;
        }
    }
    @catch (NSException *exception) {
    }
    
    return 0.0;
}

+ (NSString *)valueForLongitude:(double)longitude
{
    if (-180.0 <= longitude && longitude <= 180.0) {
        return [NSString stringWithFormat:@"%f", longitude];
    }
    
    return @"0";
}

+ (double)degress:(NSString *)value
{
    @try {
        double f = [value doubleValue];
        if (0.0 <= f && f <= 360.0) {
            return f;
        }
    }
    @catch (NSException *exception) {
    }
    
    return 0.0;    
}

+ (NSString *)valueForDegress:(double)degress
{
    if (0.0 <= degress && degress <= 360.0) {
        return [NSString stringWithFormat:@"%f", degress];
    }
    
    return @"0";
}

+ (GPXFix)fix:(NSString *)value
{
    if (value) {
        if ([value isEqualToString:@"2d"]) {
            return GPXFix2D;
        }
        if ([value isEqualToString:@"3d"]) {
            return GPXFix3D;
        }
        if ([value isEqualToString:@"dgps"]) {
            return GPXFixDgps;
        }
        if ([value isEqualToString:@"pps"]) {
            return GPXFixPps;
        }
    }
    
    return GPXFixNone;
}

+ (NSString *)valueForFix:(GPXFix)fix
{
    switch (fix) {
        case GPXFixNone:
            return @"none";
        case GPXFix2D:
            return @"2d";
        case GPXFix3D:
            return @"3d";
        case GPXFixDgps:
            return @"dgps";
        case GPXFixPps:
            return @"pps";
    }
}

+ (NSInteger)dgpsStation:(NSString *)value
{
    @try {
        NSInteger i = [value integerValue];
        if (0 <= i && i <= 1023) {
            return i;
        }
    }
    @catch (NSException *exception) {
    }
    
    return 0;   
}

+ (NSString *)valueForDgpsStation:(NSInteger)dgpsStation
{
    if (0 <= dgpsStation && dgpsStation <= 1023) {
        return [NSString stringWithFormat:@"%d", (int)dgpsStation];
    }
    
    return @"0";
}

+ (double)decimal:(NSString *)value
{
    @try {
        double f = [value doubleValue];
        return f;
    }
    @catch (NSException *exception) {
    }
    
    return 0;
}

+ (NSString *)valueForDecimal:(double)decimal
{
    return [NSString stringWithFormat:@"%f", decimal];
    
}

+ (NSDate *)dateTime:(NSString *)value
{
    NSDate *date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    // dateTime（YYYY-MM-DDThh:mm:ssZ）
    formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    date = [formatter dateFromString:value];
    if (date) {
        return date;
    }
    
    // dateTime（YYYY-MM-DDThh:mm:ss.SSSZ）
    formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'";
    date = [formatter dateFromString:value];
    if (date) {
        return date;
    }
    
    // dateTime（YYYY-MM-DDThh:mm:sszzzzzz）
    if (value.length >= 22) {
        formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'sszzzz";
        NSString *v = [value stringByReplacingOccurrencesOfString:@":" withString:@"" options:0 range:NSMakeRange(22, 1)];
        date = [formatter dateFromString:v];
        if (date) {
            return date;
        }
    }
    
    // date
    formatter.dateFormat = @"yyyy'-'MM'-'dd'";
    date = [formatter dateFromString:value];
    if (date) {
        return date;
    }
    
    // gYearMonth
    formatter.dateFormat = @"yyyy'-'MM'";
    date = [formatter dateFromString:value];
    if (date) {
        return date;
    }
    
    // gYear
    formatter.dateFormat = @"yyyy'";
    date = [formatter dateFromString:value];
    if (date) {
        return date;
    }
    
    return nil;
}

//+ (NSString *)valueForDateTime_slow:(NSDate *)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    
//    // dateTime（YYYY-MM-DDThh:mm:ssZ）
//    formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
//    
//    return [formatter stringFromDate:date];
//}
+ (NSString *)valueForDateTime:(NSDate *)date
{
    char buffer[128];
    
    time_t time = [date timeIntervalSince1970];
    struct tm timeStruct;
    gmtime_r(&time, &timeStruct);
    setlocale(LC_TIME, "C");
    strftime(buffer, sizeof(buffer), "%Y-%m-%dT%H:%M:%SZ", &timeStruct);
    
    NSString *str = [NSString stringWithUTF8String:buffer];
    return str;
}

+ (NSInteger)nonNegativeInteger:(NSString *)value
{
    @try {
        NSInteger i = [value integerValue];
        if (i >= 0) {
            return i;
        }
    }
    @catch (NSException *exception) {
    }
    
    return 0;
}

+ (NSString *)valueForNonNegativeInteger:(NSInteger)integer
{
    if (integer >= 0) {
        return [NSString stringWithFormat:@"%d", (int)integer];
    }
    
    return @"0";
}

@end
