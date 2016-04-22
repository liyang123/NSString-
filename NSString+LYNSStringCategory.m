//
//  NSString+LYNSStringCategory.m
//  LYNSStringCategory
//
//  Created by liyang on 16/3/29.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "NSString+LYNSStringCategory.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NSString (LYNSStringCategory)
#pragma mark - 利用正则表达式获取url中的参数对应的key
+ (instancetype)stringResolutionUrlStr:(NSString *)webaddress WithKey:(NSString *)CS
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];
        return tagValue;
    }
    return nil;
}

#pragma mark - 判断字符串中是否有中文
+ (BOOL)stringIsContainChineseWithStr:(NSString *)str
{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 把字符串用UTF-8编码下，返回url认识的字符串
- (instancetype)stringWithUTF8:(NSString *)string
{
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return string;
}

#pragma mark -- 时间戳转年龄
+ (instancetype)stringGetAgeByTime:(long)totoal
{
    NSDate *selectDate = [NSDate dateWithTimeIntervalSince1970:totoal];
    //选择的日期到现在日期的距离(算年龄)
    NSTimeInterval dateDiff = [selectDate timeIntervalSinceNow];
    int ageDate = trunc(dateDiff/(60*60*24))/365;
    NSString *ageString = [NSString stringWithFormat:@"%d",abs(ageDate)];
    return ageString;
}

#pragma mark -- 时间戳转星座
+ (instancetype)getConstellationByTime:(long)totoal
{
    
    NSDate *selectDate = [NSDate dateWithTimeIntervalSince1970:totoal];
    //算出选择的月份
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM"];//设置样式
    NSString *month = [monthFormatter stringFromDate:selectDate];//选择日期
    
    //算出选择的哪天
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"dd"];//设置样式
    NSString *day = [dayFormatter stringFromDate:selectDate];
    //根据年月日来判断星座
    NSString *constellation = @"魔羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座魔羯座";
    NSString *astroFormat = @"102123444543";
    NSString *result = [NSString stringWithFormat:@"%@",[constellation substringWithRange:NSMakeRange([month intValue] * 3 - ([day intValue] < [[astroFormat substringWithRange:NSMakeRange(([month intValue] - 1), 1)] intValue] - ( - 19)) * 3,3)]];
    return result;
}

#pragma mark -- 判断是否为QQ号
- (BOOL)stringIsQQNumber
{
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]{5,15}$" options:0 error:nil];
    if (regex) {
        NSTextCheckingResult * resulte = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        if (resulte) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

#pragma mark -- 判断是否为手机号
- (BOOL)stringIsPhoneNumber
{
    //手机号筛选
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"^[1][358][0-9]{9}" options:0 error:nil];
    if (regex) {
        NSTextCheckingResult * resulte = [regex firstMatchInString:self options:0 range:NSMakeRange(0,self.length)];
        if (resulte) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

#pragma mark -- 判断是否为数字
- (BOOL)stringIsNumber
{
    //设置筛选条件
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]*$" options:0 error:nil];
    if (regex) {
        NSTextCheckingResult * resulte = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        if (resulte) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}


/**
 *  md5加密
 *
 *  @param str 要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (instancetype)stringWithMD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

/**
 *  sha1加密
 *
 *  @param str 要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (instancetype)stringWithsha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

/**
 *  获取客户端网络IP
 *
 *  @return 返回客户端网络IP
 */
+ (instancetype)stringWithIP
{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

/**
 *  生成任意长度的随机数
 *
 *  @param bit 长度
 *
 *  @return 随机数
 */
+ (instancetype)stringWithRandomBit:(NSInteger)bit
{
    char data[bit];
    for (NSInteger i = 0; i < bit; i++) {
        data[i] = (char)('A' + (arc4random_uniform(26)));
    }
    return [[NSString alloc] initWithBytes:data length:bit encoding:NSUTF8StringEncoding];
}


/**
 *  返回url能识别的字符串
 */
- (instancetype)stringWithUrlFormatter:(NSString *)urlStr
{
    return [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
@end
