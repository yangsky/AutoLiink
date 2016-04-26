//
//  Message.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/17.
//
//

#import "Message.h"
#import <UIKit/UIKit.h>
#import "IndexGenerator.h"
#import "Hmac.h"
#import "Des.h"
#import "ZipUtil.h"

#define kFuncIDLogon @"Logon"

#define kCategoryIDAccount @"Account"
#define kCategoryIDNormal @"Normal"

#define kAppID @"AppID"
#define kCategoryID @"CategoryID"
#define kFuncID @"FuncID"
#define kAppVersion @"AppVersion"
#define kTimeStamp @"TimeStamp"
#define kToken @"Token"
#define kPkgID @"PkgID"
#define kPkgIndex @"PkgIndex"
#define kPkgNum @"PkgNum"
#define kIsEncryption @"IsEncryption"
#define kIsCompress @"IsCompress"
#define kData @"Data"

@interface Message ()

@property (nonatomic, copy) NSDictionary *infoDictionary;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@end

@implementation Message

+ (Message *)messageWithDictionary:(NSDictionary *)dictionary {
    
    Message *message = [[Message alloc] init];
    
    message.appID = [dictionary objectForKey:kAppID];
    message.categoryID = [dictionary objectForKey:kCategoryID];
    message.funcID = [dictionary objectForKey:kFuncID];
    message.appVersion = [dictionary objectForKey:kAppVersion];
    message.timeStamp = [dictionary objectForKey:kTimeStamp];
    message.token = [dictionary objectForKey:kToken];
    message.pkgID = [dictionary objectForKey:kPkgID];
    message.pkgIndex = [dictionary objectForKey:kPkgIndex];
    message.pkgNum = [dictionary objectForKey:kPkgNum];
    message.isEncryption = [dictionary objectForKey:kIsEncryption];
    message.isCompress = [dictionary objectForKey:kIsCompress];
    message.data = [dictionary objectForKey:kData];
    
    return message;
}

- (NSString *)toJson {
    
    NSDictionary *jsonDict = [self toDictionary];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)toDictionary {
    
    NSDictionary *dictionary = @{kAppID:self.appID,
                                 kCategoryID:self.categoryID,
                                 kFuncID:self.funcID,
                                 kAppVersion:self.appVersion,
                                 kTimeStamp:self.timeStamp,
                                 kToken:self.token,
                                 kPkgID:self.pkgID,
                                 kPkgIndex:self.pkgIndex,
                                 kPkgNum:self.pkgNum,
                                 kIsEncryption:self.isEncryption,
                                 kIsCompress:self.isCompress,
                                 kData:self.data
                                 };
    
    return dictionary;
}

#pragma mark - getter
- (NSString *)appID {
    
    return @"music"; // 测试数据
    //    return [NSString stringWithFormat:@"%@", [self.infoDictionary objectForKey:@"CFBundleName"]];
}

- (NSString *)categoryID {
    
    if ([self.funcID isEqualToString:kFuncIDLogon]) {
        
        _categoryID = kCategoryIDAccount;
    } else {
        
        _categoryID = kCategoryIDNormal;
    }
    
    return _categoryID;
}

- (NSString *)appVersion {
    
    return [NSString stringWithFormat:@"V%@", [self.infoDictionary objectForKey:@"CFBundleShortVersionString"]];
}

- (NSString *)timeStamp {
    
    if (!_timeStamp) {
        
        NSString *timeStamp = [self.dateFormatter stringFromDate:[NSDate date]];
        _timeStamp = [NSString stringWithFormat:@"%@%02d", timeStamp, [[IndexGenerator sharedGenerator] timeStampIndex:timeStamp]];
    }
    
    return _timeStamp;
}

- (NSString *)token {
    
    NSString *text = [NSString stringWithFormat:@"%@%@%@", self.appID, self.funcID, self.timeStamp];
    //    NSString *key = @"appkey";
    
    // HMAC
    return [Hmac encrypt2HMAC:text key:text];
}

- (NSString *)pkgID {
    
    return [NSString stringWithFormat:@"%@", [[UIDevice currentDevice].identifierForVendor UUIDString]];
}

- (NSString *)pkgIndex {
    
    return [NSString stringWithFormat:@"%@", @"0"];
}

- (NSString *)data {
    
    if (!_data) {
        
        return nil;
    }
    
    // DES encrypt
    if ([self.isEncryption isEqualToString:@"1"]) {
        
        NSString *tempStr = _data;
        tempStr = [Des encrypt2DES:_data key:@""];
        _data = tempStr;
    }
    
    // data compress
    if ([self.isCompress isEqualToString:@"1"]) {
        
        NSData *data = [_data dataUsingEncoding:NSUTF8StringEncoding];
        NSData *compressedData = [ZipUtil compresszip:data];
        _data = [[NSString alloc] initWithData:compressedData encoding:NSUTF8StringEncoding];
    }
    
    // base64
    NSData *tempData = [_data dataUsingEncoding:NSUTF8StringEncoding];
    _data = [tempData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    return _data;
}

- (NSDictionary *)infoDictionary {
    
    if (!_infoDictionary) {
        
        _infoDictionary = [[NSBundle mainBundle] infoDictionary];
    }
    
    return _infoDictionary;
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    }
    
    return _dateFormatter;
}

@end
