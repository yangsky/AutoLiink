//
//  ProtoBufManager.m
//  AutoLinQ
//
//  Created by com.conti on 16/4/17.
//  Copyright (c) 2016年 com.conti. All rights reserved.
//

#import "ProtoBufManager.h"
#import "ContiMessage.pb.h"

#import "Const.h"

@implementation ProtoBufManager

- (void)output:(NSString *)outputFile withData:(NSDictionary *)dict {

    ContiMessageBuilder *builder = [ContiMessage builder];

    [builder setAppId:[dict objectForKey:ContiMessage_appID]];
    [builder setCategoryId:[dict objectForKey:ContiMessage_categoryID]];
    [builder setFuncId:[dict objectForKey:ContiMessage_funcID]];
    [builder setAppVersion:[dict objectForKey:ContiMessage_appVersion]];
    [builder setTimeStamp:[dict objectForKey:ContiMessage_timeStamp]];
    [builder setToken:[dict objectForKey:ContiMessage_token]];
    [builder setPkgId:[dict objectForKey:ContiMessage_pkgID]];
    [builder setPkgIndex:[[dict objectForKey:ContiMessage_pkgIndex] intValue]];
    [builder setPkgNum:[[dict objectForKey:ContiMessage_pkgNum] intValue]];
    [builder setIsencryption:[[dict objectForKey:ContiMessage_isencryption] intValue]];
    [builder setIscompress:[[dict objectForKey:ContiMessage_iscompress] intValue]];
    [builder setDataStr:[dict objectForKey:ContiMessage_dataStr]];
    
    ContiMessage *contiMessage = [builder build];

    NSData *messageData = [contiMessage data];
    if (![messageData writeToFile:outputFile atomically:YES]) {
        NSLog(@"ProtoBufManager writeToFile failure! %@, %@", outputFile, dict);
    }
}

+ (NSData *)dictionaryToData:(NSDictionary *)dict {
    
    ContiMessageBuilder *builder = [ContiMessage builder];
    
    [builder setAppId:[dict objectForKey:ContiMessage_appID]];
    [builder setCategoryId:[dict objectForKey:ContiMessage_categoryID]];
    [builder setFuncId:[dict objectForKey:ContiMessage_funcID]];
    [builder setAppVersion:[dict objectForKey:ContiMessage_appVersion]];
    [builder setTimeStamp:[dict objectForKey:ContiMessage_timeStamp]];
    [builder setToken:[dict objectForKey:ContiMessage_token]];
    [builder setPkgId:[dict objectForKey:ContiMessage_pkgID]];
    [builder setPkgIndex:[[dict objectForKey:ContiMessage_pkgIndex] intValue]];
    [builder setPkgNum:[[dict objectForKey:ContiMessage_pkgNum] intValue]];
    [builder setIsencryption:[[dict objectForKey:ContiMessage_isencryption] intValue]];
    [builder setIscompress:[[dict objectForKey:ContiMessage_iscompress] intValue]];
    [builder setDataStr:[dict objectForKey:ContiMessage_dataStr]];
    
    ContiMessage *contiMessage = [builder build];
    
    NSData *messageData = [contiMessage data];
    NSLog(@"ProtoBuf%@", [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding]);

    return messageData;
}

+ (NSDictionary *)dataToDictionary:(NSData *)data {
    
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    
    ContiMessage *contiMessage = [ContiMessage parseFromData:data];
    if (contiMessage) {
        
        [contentDict setObject:contiMessage.appId forKey:ContiMessage_appID];
        [contentDict setObject:contiMessage.categoryId forKey:ContiMessage_categoryID];
        [contentDict setObject:contiMessage.funcId forKey:ContiMessage_funcID];
        [contentDict setObject:contiMessage.appVersion forKey:ContiMessage_appVersion];
        [contentDict setObject:contiMessage.timeStamp forKey:ContiMessage_timeStamp];
        
        [contentDict setObject:contiMessage.token forKey:ContiMessage_token];
        [contentDict setObject:contiMessage.pkgId forKey:ContiMessage_pkgID];
        [contentDict setObject:[NSNumber numberWithInt:contiMessage.pkgIndex] forKey:ContiMessage_pkgIndex];
        [contentDict setObject:[NSNumber numberWithInt:contiMessage.pkgNum] forKey:ContiMessage_pkgNum];
        
        [contentDict setObject:[NSNumber numberWithInt:contiMessage.isencryption] forKey:ContiMessage_isencryption];
        [contentDict setObject:[NSNumber numberWithInt:contiMessage.iscompress] forKey:ContiMessage_iscompress];
        [contentDict setObject:contiMessage.dataStr forKey:ContiMessage_dataStr];
    }
    
    return contentDict;
}

- (NSDictionary *)read:(NSString *)dataFile {
    
    // if .proto file not exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
        return nil;
    }
    
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    NSData *data = [NSData dataWithContentsOfFile:dataFile];

    ContiMessage *contiMessage = [ContiMessage parseFromData:data];
    if (contiMessage) {

        [contentDict setObject:contiMessage.appId forKey:ContiMessage_appID];
        [contentDict setObject:contiMessage.categoryId forKey:ContiMessage_categoryID];
        [contentDict setObject:contiMessage.funcId forKey:ContiMessage_funcID];
        [contentDict setObject:contiMessage.appVersion forKey:ContiMessage_appVersion];
        [contentDict setObject:contiMessage.timeStamp forKey:ContiMessage_timeStamp];
        
        [contentDict setObject:contiMessage.token forKey:ContiMessage_token];
        [contentDict setObject:contiMessage.pkgId forKey:ContiMessage_pkgID];
        [contentDict setObject:[NSNumber numberWithInt:contiMessage.pkgIndex] forKey:ContiMessage_pkgIndex];
        [contentDict setObject:[NSNumber numberWithInt:contiMessage.pkgNum] forKey:ContiMessage_pkgNum];
        
        [contentDict setObject:[NSNumber numberWithInt:contiMessage.isencryption] forKey:ContiMessage_isencryption];
        [contentDict setObject:[NSNumber numberWithInt:contiMessage.iscompress] forKey:ContiMessage_iscompress];
        [contentDict setObject:contiMessage.dataStr forKey:ContiMessage_dataStr];
    }
    
    return contentDict;
}

@end
