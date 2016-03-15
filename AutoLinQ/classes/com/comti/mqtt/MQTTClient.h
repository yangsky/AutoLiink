//
//  MQTTClient.h
//  MQTTClient
//
//  Created by mac on 16/3/14.
//
//

#import <Foundation/Foundation.h>

typedef enum MQTTConnectionReturnCode : NSUInteger {
    ConnectionAccepted,
    ConnectionRefusedUnacceptableProtocolVersion,
    ConnectionRefusedIdentiferRejected,
    ConnectionRefusedServerUnavailable,
    ConnectionRefusedBadUserNameOrPassword,
    ConnectionRefusedNotAuthorized
} MQTTConnectionReturnCode;

typedef enum MQTTQualityOfService : NSUInteger {
    AtMostOnce,
    AtLeastOnce,
    ExactlyOnce
} MQTTQualityOfService;

#pragma mark - MQTT Message

@interface MQTTMessage : NSObject

@property (readonly, assign) unsigned short mid;
@property (readonly, copy) NSString *topic;
@property (readonly, copy) NSData *payload;
@property (readonly, assign) BOOL retained;

- (NSString *)payloadString;

@end

typedef void (^MQTTSubscriptionCompletionHandler)(NSArray *grantedQos);
typedef void (^MQTTMessageHandler)(MQTTMessage *message);

#pragma mark - MQTT Client

@class MQTTClient;

@interface MQTTClient : NSObject {
    struct mosquitto *mosq;
}

// unique client ID
@property (readwrite, copy) NSString *clientID;
// Server IP
@property (readwrite, copy) NSString *host;
// Server port
@property (readwrite, assign) unsigned short port;
// client username
@property (readwrite, copy) NSString *username;
// client password
@property (readwrite, copy) NSString *password;
// keep connection time (seconds)
@property (readwrite, assign) unsigned short keepAlive;
// whether or not to clean session.
@property (readwrite, assign) BOOL cleanSession;
// a block object to handler message.
@property (nonatomic, copy) MQTTMessageHandler messageHandler;

+ (void) initialize;
+ (NSString*) version;

// create the client with a unique client ID
- (MQTTClient*) initWithClientId: (NSString *)clientId;

/**
 *  retry send message
 *
 *  @param seconds           retry send message after seconds
 */
- (void) setMessageRetry: (NSUInteger)seconds;

#pragma mark - Connection

/**
 *  connect to server
 *
 *  @param completionHandler A block object to be executed when the task finishes successfully. 
           This block has no return value and takes a argument: MQTTConnectionReturnCode.
 */
- (void) connectWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler;

/**
 *  connect to server
 *
 *  @param host              Server IP
 *  @param completionHandler A block object to be executed when the task finishes successfully. 
                             This block has no return value and takes a argument: MQTTConnectionReturnCode.
 */
- (void) connectToHost: (NSString*)host
     completionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler;

/**
 *  disconnect to server
 *
 *  @param completionHandler A block object to be executed when the task finishes successfully.  
           This block has no return value and takes a argument: MQTTConnectionReturnCode.
 */
- (void) disconnectWithCompletionHandler:(void (^)(NSUInteger code))completionHandler;

/**
 *  reconnect to server
 *
 */
- (void) reconnect;

/**
 *  will publish a payload
 *
 *  @param payload           the payload that will publish
 *  @param topic             the payload belongs to the topic
 *  @param retain            retain
 *  @param qos               Quality Of Service
 */
- (void)setWillData:(NSData *)payload
            toTopic:(NSString *)willTopic
            withQos:(MQTTQualityOfService)willQos
             retain:(BOOL)retain;

/**
 *  will publish a payload
 *
 *  @param payload           the payload that will publish
 *  @param topic             the payload belongs to the topic
 *  @param retain            retain
 *  @param qos               Quality Of Service
 */
- (void)setWill:(NSString *)payload
        toTopic:(NSString *)willTopic
        withQos:(MQTTQualityOfService)willQos
         retain:(BOOL)retain;

/**
 *  clear will
 *
 */
- (void)clearWill;

#pragma mark - Publish

/**
 *  publish a payload
 *
 *  @param payload           the payload that will publish
 *  @param topic             the payload belongs to the topic
 *  @param retain            retain
 *  @param qos               Quality Of Service
 *  @param completionHandler A block object to be executed when the task finishes successfully. 
                             This block has no return value and takes a argument: message id.
 */
- (void)publishData:(NSData *)payload
            toTopic:(NSString *)topic
            withQos:(MQTTQualityOfService)qos
             retain:(BOOL)retain
  completionHandler:(void (^)(int mid))completionHandler;

/**
 *  publish a payload
 *
 *  @param payload           the payload that will publish
 *  @param topic             the payload belongs to the topic
 *  @param retain            retain
 *  @param qos               Quality Of Service
 *  @param completionHandler A block object to be executed when the task finishes successfully. 
                             This block has no return value and takes a argument: message id.
 */
- (void)publishString:(NSString *)payload
              toTopic:(NSString *)topic
              withQos:(MQTTQualityOfService)qos
               retain:(BOOL)retain
    completionHandler:(void (^)(int mid))completionHandler;

#pragma mark - Subscribe

/**
 *  subscribe a topic
 *
 *  @param topic             the topic that will subscribe
 *  @param completionHandler A block object to be executed when the task finishes successfully. 
                             This block has no return value and takes a argument: NSArray *grantedQos.
 */
- (void)subscribe:(NSString *)topic
withCompletionHandler:(MQTTSubscriptionCompletionHandler)completionHandler;

/**
 *  subscribe a topic
 *
 *  @param topic             the topic that will subscribe
 *  @param qos               Quality Of Service
 *  @param completionHandler A block object to be executed when the task finishes successfully. 
                             This block has no return value and takes a argument: NSArray *grantedQos.
 */
- (void)subscribe:(NSString *)topic
          withQos:(MQTTQualityOfService)qos
completionHandler:(MQTTSubscriptionCompletionHandler)completionHandler;

/**
 *  unsubscribe a topic
 *
 *  @param topic             the topic that will unsubscribe
 *  @param completionHandler A block object to be executed when the task finishes successfully. 
                             This block has no return value and takes a argument: NSArray *grantedQos.
 */
- (void)unsubscribe: (NSString *)topic
withCompletionHandler:(void (^)(void))completionHandler;

@end
