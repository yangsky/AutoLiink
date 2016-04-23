//
//  HttpClient.m
//  AutoLinQ
//
//  Created by mac on 16/3/14.
//
//

#import "HttpClient.h"

@implementation HttpClient

- (void)post:(NSString *)urlString header:(NSDictionary *)headers parameters:(NSDictionary *)parameters contentType:(NSString *)contentType responseHandler:(ResponseHandler)responseHandler failure:(FailureHandler)failureHandler {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // set request
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    // set request headers
    for (NSString *key in headers.allKeys) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    // set response
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:contentType];
    
    // if https, set securityPolicy
    if ([urlString hasPrefix:@"https://"]) {
        manager.securityPolicy = [self customSecurityPolicy];
    }
    
    // POST
    [manager POST:urlString parameters:parameters success:responseHandler failure:failureHandler];
}

/**
 *  Creates and returns a security policy.
 *
 *  @return A new security policy.
 */
- (AFSecurityPolicy *)customSecurityPolicy {
    
    // certificate data
    NSData *certData = [NSData dataWithContentsOfFile:self.certificatePath];
    
    // Creates a security policy with the specified pinning mode.
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // trust servers with an invalid or expired SSL certificates.
    securityPolicy.allowInvalidCertificates = YES;
    // not to validate the domain name in the certificate's CN field.
    securityPolicy.validatesDomainName = NO;
    // certificates content
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    
    return securityPolicy;
}

@end
