#import "Des.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "StringUitl.h"

@implementation Des

+ (NSString *) encrypt2DES:(NSString *)message key:(NSString *)key {

    return [Des encrypt:message encryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *) encrypt2DES:(Byte [])bytes withKey:(NSString *)key {
    
    // bytes to string
    NSString *message = [StringUitl bytes2String:bytes];
    
    return [Des encrypt:message encryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *) decrypt2DES:(NSString *)message key:(NSString *)key {
    
    return [Des encrypt:message encryptOrDecrypt:kCCDecrypt key:key];
}

+ (NSString *) decrypt2DES:(Byte [])bytes withKey:(NSString *)key {
    
    // bytes to string
    NSString *message = [StringUitl bytes2String:bytes];
    
    return [Des encrypt:message encryptOrDecrypt:kCCDecrypt key:key];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key {

    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt) {

        // base64 decrypt
        NSData *decryptData = [[NSData alloc] initWithBase64EncodedString:sText options:NSDataBase64DecodingIgnoreUnknownCharacters];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    } else {

        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    // CCCrypt
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    // CCCrypt
    ccStatus = CCCrypt(encryptOperation,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeDES,
                       iv,
                       dataIn,
                       dataInLength,
                       (void *)dataOut,
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt) {

        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    } else {

        // base64 encod
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    
    return result;
}

@end