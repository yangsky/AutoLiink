// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

// @@protoc_insertion_point(imports)

@class ContiMessage;
@class ContiMessageBuilder;



@interface ContiMessageRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

#define ContiMessage_appID @"appId"
#define ContiMessage_categoryID @"categoryId"
#define ContiMessage_funcID @"funcId"
#define ContiMessage_appVersion @"appVersion"
#define ContiMessage_timeStamp @"timeStamp"
#define ContiMessage_isencryption @"isencryption"
#define ContiMessage_data @"data"
@interface ContiMessage : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasIsencryption_:1;
  BOOL hasAppId_:1;
  BOOL hasCategoryId_:1;
  BOOL hasFuncId_:1;
  BOOL hasAppVersion_:1;
  BOOL hasTimeStamp_:1;
  BOOL hasData_:1;
  SInt32 isencryption;
  NSString* appId;
  NSString* categoryId;
  NSString* funcId;
  NSString* appVersion;
  NSString* timeStamp;
  NSString* data;
}
- (BOOL) hasAppId;
- (BOOL) hasCategoryId;
- (BOOL) hasFuncId;
- (BOOL) hasAppVersion;
- (BOOL) hasTimeStamp;
- (BOOL) hasIsencryption;
- (BOOL) hasData;
@property (readonly, strong) NSString* appId;
@property (readonly, strong) NSString* categoryId;
@property (readonly, strong) NSString* funcId;
@property (readonly, strong) NSString* appVersion;
@property (readonly, strong) NSString* timeStamp;
@property (readonly) SInt32 isencryption;
@property (readonly, strong, getter=dataString) NSString* data;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ContiMessageBuilder*) builder;
+ (ContiMessageBuilder*) builder;
+ (ContiMessageBuilder*) builderWithPrototype:(ContiMessage*) prototype;
- (ContiMessageBuilder*) toBuilder;

+ (ContiMessage*) parseFromData:(NSData*) data;
+ (ContiMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ContiMessage*) parseFromInputStream:(NSInputStream*) input;
+ (ContiMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ContiMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ContiMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ContiMessageBuilder : PBGeneratedMessageBuilder {
@private
  ContiMessage* resultContiMessage;
}

- (ContiMessage*) defaultInstance;

- (ContiMessageBuilder*) clear;
- (ContiMessageBuilder*) clone;

- (ContiMessage*) build;
- (ContiMessage*) buildPartial;

- (ContiMessageBuilder*) mergeFrom:(ContiMessage*) other;
- (ContiMessageBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ContiMessageBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasAppId;
- (NSString*) appId;
- (ContiMessageBuilder*) setAppId:(NSString*) value;
- (ContiMessageBuilder*) clearAppId;

- (BOOL) hasCategoryId;
- (NSString*) categoryId;
- (ContiMessageBuilder*) setCategoryId:(NSString*) value;
- (ContiMessageBuilder*) clearCategoryId;

- (BOOL) hasFuncId;
- (NSString*) funcId;
- (ContiMessageBuilder*) setFuncId:(NSString*) value;
- (ContiMessageBuilder*) clearFuncId;

- (BOOL) hasAppVersion;
- (NSString*) appVersion;
- (ContiMessageBuilder*) setAppVersion:(NSString*) value;
- (ContiMessageBuilder*) clearAppVersion;

- (BOOL) hasTimeStamp;
- (NSString*) timeStamp;
- (ContiMessageBuilder*) setTimeStamp:(NSString*) value;
- (ContiMessageBuilder*) clearTimeStamp;

- (BOOL) hasIsencryption;
- (SInt32) isencryption;
- (ContiMessageBuilder*) setIsencryption:(SInt32) value;
- (ContiMessageBuilder*) clearIsencryption;

- (BOOL) hasData;
- (NSString*) dataString;
- (ContiMessageBuilder*) setData:(NSString*) value;
- (ContiMessageBuilder*) clearData;
@end


// @@protoc_insertion_point(global_scope)