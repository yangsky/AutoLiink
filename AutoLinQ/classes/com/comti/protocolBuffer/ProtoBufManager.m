//
//  ProtoBufManager.m
//  AutoLinQ
//
//  Created by mac on 16/3/14.
//
//

#import "ProtoBufManager.h"
#import "ContiMessage.pb.h"

#define kAppId        @"appId"
#define kCategoryId   @"categoryId"
#define kFuncId       @"funcId"
#define kAppVersion   @"appVersion"
#define kTimeStamp    @"timeStamp"
#define kIsencryption @"isencryption"
#define kData         @"data"

@implementation ProtoBufManager

- (void)output:(NSString *)outputFile withData:(NSDictionary *)dict {

    ContiMessageBuilder *builder = [ContiMessage builder];

    [builder setAppId:[dict objectForKey:kAppId]];
    [builder setCategoryId:[dict objectForKey:kCategoryId]];
    [builder setFuncId:[dict objectForKey:kFuncId]];
    [builder setAppVersion:[dict objectForKey:kAppVersion]];
    [builder setTimeStamp:[dict objectForKey:kTimeStamp]];
    [builder setIsencryption:[[dict objectForKey:kIsencryption] intValue]];
    [builder setData:[dict objectForKey:kData]];
    
    ContiMessage *contiMessage = [builder build];

    NSData *messageData = [contiMessage data];
    if (![messageData writeToFile:outputFile atomically:YES]) {
        NSLog(@"ProtoBufManager writeToFile failure! %@, %@", outputFile, dict);
    }
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
        [contentDict setValue:contiMessage.appId forKey:kAppId];
        [contentDict setValue:contiMessage.categoryId forKey:kCategoryId];
        [contentDict setValue:contiMessage.funcId forKey:kFuncId];
        [contentDict setValue:contiMessage.appVersion forKey:kAppVersion];
        [contentDict setValue:contiMessage.timeStamp forKey:kTimeStamp];
        [contentDict setValue:[NSNumber numberWithInt:contiMessage.isencryption] forKey:kIsencryption];
        [contentDict setValue:contiMessage.data forKey:kData];
    }
    
    return contentDict;
}

@end
