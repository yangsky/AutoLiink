//
//  ProtoBufManager.h
//  AutoLinQ
//
//  Created by mac on 16/3/14.
//
//

#import <Foundation/Foundation.h>

@interface ProtoBufManager : NSObject

/**
 *  output data to file
 *
 *  @param outputFile output file
 *  @param dict       data(For example, data from https request)
 */
- (void)output:(NSString *)outputFile withData:(NSDictionary *)dict;

/**
 *  read the .proto file
 *
 *  @param dataFile .proto file
 *
 *  @return The contents of the .proto file.(key-value pairs)
 */
- (NSDictionary *)read:(NSString *)dataFile;

@end
