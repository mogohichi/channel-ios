//
//  CHAPI.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/30/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHAPI.h"
#import "CHConfiguration.h"
#import "CHConstants.h"
#import "CHClient.h"

@interface CHAPI()

+ (void)request:(NSString*)path params:(NSDictionary*)params method:(METHOD)method block:(Completion)block;
+ (NSString*)methodToString:(METHOD)method;

@end

@implementation CHAPI

+ (NSString *)methodToString:(METHOD)method{
    
    switch (method) {
    case GET:
        return @"GET";
        break;
    case POST:
        return @"POST";
        break;
    case PUT:
        return @"PUT";
            break;
    case DELETE:
        return @"DEL";
        break;
    default:
        break;
    }
}

+ (void)request:(NSString*)path params:(NSDictionary*)params method:(METHOD)method block:(Completion)block{
    NSString* urlString = [NSString stringWithFormat:@"%@%@",kChannel_Base_API,path];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:[CHConfiguration sharedConfiguration].applicationId forHTTPHeaderField:@"X-Channel-Application-Key"];
    
    NSString* clientID = [CHClient currentClient].clientID;
    if (clientID != nil && ![clientID isEqualToString:@""]){
        [request addValue:clientID forHTTPHeaderField:@"X-Channel-Client-ID"];
    }else{
        [request addValue:@"TestClientIDGeneratedFromClient" forHTTPHeaderField:@"X-Channel-Client-ID"];
    }
    
    [request setHTTPMethod:[self methodToString:method]];
    

    if (params != nil){
        NSError* dataError = nil;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
        if (dataError != nil) {
            //NSLog(@"%@",dataError);
        }
        [request setHTTPBody:postData];
        
    }
//#if DEBUG
//    NSLog(@"%@",[self formatURLRequest:request]);
//#endif
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
//#if DEBUG
//        NSLog(@"%@ ",[self formatURLResponse:(NSHTTPURLResponse*)response withData:data]);
//#endif
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([httpResponse statusCode] != 200){
            block(nil, [NSError errorWithDomain:kError_Domain code:400 userInfo:@{NSLocalizedDescriptionKey:@"Unexpected Data"}]);
            return;
        }
        NSError* errorJson;
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        if (errorJson != nil) {
           // NSLog(@"%@",errorJson);
        }
        if (obj == nil){
            block(nil, [NSError errorWithDomain:kError_Domain code:400 userInfo:@{NSLocalizedDescriptionKey:@"Data is null"}]);
            return;
        }
        
        NSDictionary* result = [obj valueForKey:@"result"];
        NSDictionary* jsonData = [result valueForKey:@"data"];
        
        block(jsonData,nil);
    }];
    [task resume];
}

+(void)get:(NSString*)path params:(NSDictionary*)params block:(Completion)block{
    [self request:path params:params method:GET block:block];
}

+(void)post:(NSString*)path params:(NSDictionary*)params block:(Completion)block{
   [self request:path params:params method:POST block:block];
}

+(void)put:(NSString*)path params:(NSDictionary*)params block:(Completion)block{
    [self request:path params:params method:PUT block:block];
}

+(void)del:(NSString*)path params:(NSDictionary*)params block:(Completion)block{
    [self request:path params:params method:DELETE block:block];
}


+ (NSString *)formatURLRequest:(NSURLRequest *)request
{
    NSMutableString *message = [NSMutableString stringWithString:@"---REQUEST------------------\n"];
    [message appendFormat:@"URL: %@\n",[request.URL description] ];
    [message appendFormat:@"METHOD: %@\n",[request HTTPMethod]];
    for (NSString *header in [request allHTTPHeaderFields])
    {
        [message appendFormat:@"%@: %@\n",header,[request valueForHTTPHeaderField:header]];
    }
    [message appendFormat:@"BODY: %@\n",[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]];
    [message appendString:@"----------------------------\n"];
    return [NSString stringWithFormat:@"%@",message];
}

+ (NSString *)formatURLResponse:(NSHTTPURLResponse *)response withData:(NSData *)data
{
    NSString *responsestr = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    NSMutableString *message = [NSMutableString stringWithString:@"---RESPONSE------------------\n"];
    [message appendFormat:@"URL: %@\n",[response.URL description] ];
    [message appendFormat:@"MIMEType: %@\n",response.MIMEType];
    [message appendFormat:@"Status Code: %ld\n",(long)response.statusCode];
    for (NSString *header in [[response allHeaderFields] allKeys])
    {
        [message appendFormat:@"%@: %@\n",header,[response allHeaderFields][header]];
    }
    [message appendFormat:@"Response Data: %@\n",responsestr];
    [message appendString:@"----------------------------\n"];
    return [NSString stringWithFormat:@"%@",message];
}
@end
