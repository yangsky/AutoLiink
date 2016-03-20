//
//  Authorization.h
//  AutoLinQ
//
//  Created by steven_yang on 16/3/20.
//
//

#import <Foundation/Foundation.h>

@interface Authorization : NSObject

@property (nonatomic,strong) NSString *userEmail;   //uesr

@property (nonatomic,strong) NSString *userPassword;    //password

//get user Authorization Token

-(NSString *)getAuthenticationToken;

@end
