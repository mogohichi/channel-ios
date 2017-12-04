//
//  CHClient.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/26/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHClient.h"
#import "CHDevice.h"
#import "EventSource.h"
#import "CHConstants.h"
#import "CHConfiguration.h"
#import "CHWebViewViewController.h"
#import "SystemServices.h"
#import "CHUser.h"
#import "CHConversation.h"


@interface CHClient()

@property (nonatomic) EventSource *source;
@property (nonatomic) NSString* currentSubscribedURL;
@end

@implementation CHClient
-(void)setClientID:(NSString *)clientID{
    [[NSUserDefaults standardUserDefaults] setValue:clientID forKey:[NSString stringWithFormat:@"CH_CHANNLE_ID_%@",[CHConfiguration sharedConfiguration].applicationId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)clientID{
    return [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"CH_CHANNLE_ID_%@",[CHConfiguration sharedConfiguration].applicationId]];
}

-(NSInteger)numberOfNewMessages{
    return [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"NUMBER_OF_NEW_MESSAGE_%@",self.clientID]];
}

-(id)copyWithZone:(__unused NSZone *)zone{
    CHClient *copy = [self.class new];
    copy.clientID = self.clientID;
    return copy;
}

+ (instancetype)currentClient {
    static CHClient *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });
    return shared;
}

-(CHSender *)asSender{
    CHSender* sender = [[CHSender alloc]init];
    sender.publicID = self.clientID;
    return sender;
}

-(void)applicationInfo:(DidGetApplicationInfo)block{
    [CHAPI get:@"/app/info" params:nil block:^(id data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil){
                block(nil,nil);
                return;
            }
            
            NSDictionary* applicationJson = [data valueForKey:@"application"];
            NSArray* agentsJson = [data valueForKey:@"agents"];
            
            CHApplication* application = [[CHApplication alloc]initWithJSON:applicationJson];
            NSMutableArray* agents = [[NSMutableArray alloc]init];
            for (NSDictionary* agentJson in agentsJson){
                CHAgent* agent = [[CHAgent alloc]initWithJSON:agentJson];
                [agents addObject:agent];
            }
            block(application, agents);
        });
    }];
}

+(void)connectClientwithUserID:(NSString*)userID userData:(NSDictionary*)userData block:(DidConnectClient)block {
    //call api to get client ID
    //then store it in keychain
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:[CHDevice info] forKey:@"deviceInfo"];
    if (userID != nil) {
        [params setValue:userID forKey:@"userID"];
    }
    
    if (userData != nil) {
        [params setValue:userData forKey:@"userData"];
    }
    
    [CHAPI post:@"/client" params:params block:^(id data, NSError *error) {
        if (error != nil){
            block(error);
            return;
        }
        NSString* clientID = [data valueForKey:@"clientID"];
        [CHClient currentClient].clientID = clientID;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(nil);
        });
    }];
}

+(void)connectClient:(DidConnectClient)block{
    [CHClient connectClientwithUserID:nil userData:nil block:block];
}

- (void)checkNewMessages:(DidCheckNewMessages)block{
    [CHAPI get:@"/client/newmessage" params:nil block:^(id data, NSError *error) {
        if (error != nil){
            block(0);
            return;
        }
        NSInteger numberOfNewMessages = [[data valueForKey:@"numberOfNewMessages"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(numberOfNewMessages);
        });
    }];
}

- (void)updateClientDataWithUserID:(NSString*)userID userData:(NSDictionary*)userData block:(DidConnectClient)block{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:[CHDevice info] forKey:@"deviceInfo"];
    [params setValue:userID forKey:@"userID"];
    [params setValue:userData forKey:@"userData"];
    [CHAPI put:@"/client" params:params block:^(id data, NSError *error) {
        if (error != nil){
            block(error);
            return;
        }
        NSString* clientID = [data valueForKey:@"clientID"];
        [CHClient currentClient].clientID = clientID;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(nil);
        });
    }];
}

-(void)sendMessage:(CHMessage *)message block:(DidSendMessage)block{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:[message toJSON]];
    [params setValue:data forKey:@"data"];
    [CHAPI post:@"/thread/messages" params:params block:^(id data, NSError *error) {
        
    }];
}

-(void)activeThread:(DidLoadActiveThread)block{
    [CHAPI get:@"/thread/messages" params:nil block:^(id data, NSError *error) {
        if (error != nil){
            block(nil,error);
            return;
        }
        
        CHThread* thread = [[CHThread alloc]init];
        NSArray* messages = data[@"messages"];
        thread.nextMessagesURL = data[@"next"];
        for (NSDictionary* m in messages){
            CHMessage* message = [[CHMessage alloc]initWithJSON:m];
            [thread addMessage:message];
        }
        block(thread,nil);
    }];
}

-(void)loadMoreMessage:(CHThread *)thread block:(DidLoadMessages)block{
    if ([thread.nextMessagesURL isEqualToString:@""] || thread.nextMessagesURL == nil){
        block(nil,nil,nil);
        return;
    }
    
    NSString* omitAPI = [thread.nextMessagesURL stringByReplacingOccurrencesOfString:@"/api" withString:@""];
    [CHAPI get:omitAPI params:nil block:^(id data, NSError *error) {
        if (error != nil){
            block(nil,nil,error);
            return;
        }
        
        NSArray* messages = data[@"messages"];
        thread.nextMessagesURL = data[@"next"];
        NSMutableArray* list = [NSMutableArray new];
        for (NSDictionary* m in messages){
            CHMessage* message = [[CHMessage alloc]initWithJSON:m];
            [list addObject:message];
        }
        block(thread,list,nil);
    }];
}

- (void)startTyping{
    [CHAPI post:@"/typing" params:nil block:^(id data, NSError *error) {
    }];
}

- (void)sse {
    //avoid double connection
    if (self.source != nil) {
        return;
    }
    NSURL *serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/subscribe",kChannel_Base_API]];
    self.source = [EventSource eventSourceWithURL:serverURL];
    [self.source onMessage:^(Event *e) {
        //we watch only for the message event
        if (![e.event isEqualToString:@""]){
            NSData* data = [e.data dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            CHMessage* message = [[CHMessage alloc]initWithJSON:obj];
            //always notify the observers
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidReceiveRealtimeMessage" object:nil userInfo:@{@"message":message}];
            if ([self.delegate respondsToSelector:@selector(client:messageFromServer:)]){
                [self.delegate client:self messageFromServer:message];
            }
            
            return;
        }
    }];
    
    [self.source addEventListener:@"typing" handler:^(Event *event) {
        
    }];
    [self.source addEventListener:@"message" handler:^(Event *event) {
        
    }];
    
    [self.source onError:^(Event *event) {
        
    }];
    
    [self.source onOpen:^(Event *event) {
        
    }];
}

- (void)subscribeUpdateFromServerWithNSNotification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sse];
    });
}

- (void)subscribeUpdateFromServerWithDelegate:(id<CHClientDelegate>)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.delegate = delegate;
        [self sse];
    });
}

- (void)unsubscribe{
    self.delegate = nil;
    [self.source close];
}

- (void)uploadImage:(UIImage*)image block:(DidFinishUploadImage)block{
    NSString* base64String = [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:base64String forKey:@"imageBase64"];
    
    [CHAPI post:@"/thread/messages/upload" params:params block:^(id data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil){
                block(nil, error);
                return;
            }
            if (data == nil){
                block(nil, [NSError errorWithDomain:kError_Domain code:400 userInfo:@{NSLocalizedDescriptionKey:@"Data is null"}] );
                return;
            }
            NSString* urlString = data[@"url"];
            block([NSURL URLWithString:urlString], nil);
        });
    }];
}

- (void)updateActiveStatus:(Boolean)active{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:[NSNumber numberWithBool:active] forKey:@"active"];
    
    [CHAPI put:@"/client/status" params:params block:^(id data, NSError *error) {
        
    }];
}

- (void)loadCardTemplate:(CHCardPayloadTemplate*)payload block:(DidLoadCardTemplate)block{
    NSString* url = [NSString stringWithFormat:@"/cards/%@",payload.templateType];
    [CHAPI get:url params:nil block:^(id data, NSError *error) {
        if (error != nil) {
            block(nil);
            return;
        }
        NSString* template = data[@"template"];
        block(template);
    }];
}

- (void)checkNewNotification:(DidCheckNotification)block{
    [CHAPI get:@"/notification" params:nil block:^(id data, NSError *error) {
        if (error != nil) {
            block(nil,error);
            return;
        }
        NSDictionary* json = data;
        
        CHNotification* notification = [[CHNotification alloc]initWithJSON:json];
        
        block(notification,nil);
    }];
    
}

- (void)postbackNotification:(CHNotification*)notification button:(CHNotificationButton*)button {
    NSString* url = [NSString stringWithFormat:@"/notification/%@", notification.publicID];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    
    [params setValue:[button toJSON] forKey:@"data"];
    [CHAPI post:url params:params block:^(id data, NSError *error) {
        
    }];
}

-(void)presentWebViewWithURL:(NSURL *)url inViewController:(UIViewController*)viewController{
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.mogohichi.Channel"];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:bundle];
    UINavigationController* nav = [storyboard instantiateViewControllerWithIdentifier:@"CHWebViewViewController"];
    CHWebViewViewController* vc = nav.viewControllers.firstObject;
    vc.url = url;
    [viewController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)saveDeviceToken:(NSData*)deviceToken{
    NSString* url = @"/client/device";
    
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
    [data setValue:hexToken forKey:@"token"];
    NSMutableDictionary* deviceInfo = [[NSMutableDictionary alloc]init];
    [deviceInfo setValue:[[SystemServices sharedServices] deviceModel] forKey:@"deviceModel"];
    [deviceInfo setValue:[[SystemServices sharedServices] systemDeviceTypeFormatted] forKey:@"systemDeviceTypeFormatted"];
    [deviceInfo setValue:[[SystemServices sharedServices] systemName] forKey:@"systemName"];
    [deviceInfo setValue:[[SystemServices sharedServices] systemsVersion] forKey:@"systemsVersion"];
    [data setValue:deviceInfo forKey:@"info"];
    
    
    [CHAPI post:url params:data block:^(id data, NSError *error) {
        
    }];
}

- (void)markOpenFromPushNotification:(NSString*)notificationPublicID{
    NSString* url = [NSString stringWithFormat:@"/notification/%@/open/push", notificationPublicID];
    [CHAPI post:url params:nil block:^(id data, NSError *error) {
        
    }];
}

- (void)pushNotificationEnabled:(BOOL)enabled{
    NSString* url = @"/client/device/notifications";
    NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
    [data setValue:[NSNumber numberWithBool:enabled] forKey:@"enable"];
    [CHAPI post:url params:data block:^(id data, NSError *error) {
        
    }];
}

- (void)appendTags:(NSDictionary*)tags{
    NSString* url = @"/client/data";
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:tags forKey:@"data"];
    [CHAPI post:url params:params block:^(id data, NSError *error) {
        
    }];
}


- (void)subscribeToTopic:(NSString*)topic block:(DidSubscribeToTopic)block{
    
    if ([topic isEqualToString:@""] == true) {
        return;
    }
    
    NSString* url = @"/client/topics";
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:topic forKey:@"topic"];
    [CHAPI post:url params:params block:^(id data, NSError *error) {
        if (error != nil) {
            block(nil,error);
            return;
        }
        NSDictionary* json = data;
        CHTopic* obj = [[CHTopic alloc]initWithJSON:json];
        block(obj,nil);
        
    }];
}


- (void)unsubscribeFromTopic:(NSString*)topic block:(DidUnsubscribeFromTopic)block {
    if ([topic isEqualToString:@""] == true) {
        return;
    }
    
    NSString* url = @"/client/topics";
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:topic forKey:@"topic"];
    [CHAPI del:url params:params block:^(id data, NSError *error) {
        if (error != nil) {
            block(nil,error);
            return;
        }
        NSDictionary* json = data;
        CHTopic* obj = [[CHTopic alloc]initWithJSON:json];
        block(obj,nil);
        
    }];
}

- (void)subscribedTopicsWithBlock:(DidLoadSubscribedTopics)block {
    NSString* url = @"/client/topics";
    
    [CHAPI get:url params:nil block:^(id data, NSError *error) {
        if (error != nil){
            block(nil,error);
            return;
        }
        
        NSArray* topicLists = data;
        
        NSMutableArray* list = [NSMutableArray new];
        for (NSDictionary* json in topicLists){
            CHTopic* obj = [[CHTopic alloc]initWithJSON:json];
            [list addObject:obj];
        }
        block(list,nil);
    }];
}
//POST  /api/conversation/search/{appUserID}
//GET "/api/conversations"
//POST "/api/conversations"
//POST "/api/conversation/{threadID}/join"
//POST "/api/conversation/{threadID}/leave"

- (void)searchUserByID:(NSString*)query block:(DidSearchUser)block {
    NSString* url =  [NSString stringWithFormat:@"/search/client?q=%@",query];
    [CHAPI get:url params:nil block:^(id data, NSError *error) {
        if (error != nil) {
            block(nil,error);
            return;
        }
        NSDictionary* json = data;
        CHUser* obj = [[CHUser alloc]initWithJSON:json];
        block(obj,nil);
    }];
}

- (void)conversations:(DidLoadConversations)block {
    NSString* url = @"/conversations";
    [CHAPI get:url params:nil block:^(id data, NSError *error) {
        if (error != nil){
            block(nil,error);
            return;
        }
        NSArray* dataList = data;
        NSMutableArray* list = [NSMutableArray new];
        for (NSDictionary* json in dataList){
            CHConversation* obj = [[CHConversation alloc]initWithJSON:json];
            [list addObject:obj];
        }
        block(list,nil);
    }];
}

- (void)startConversation:(NSArray<CHUser*>*)users block:(DidStartConversationThread)block{
    NSString* url = @"/conversations";
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSMutableArray* clientList = [[NSMutableArray alloc]init];
    for (CHUser* u in users) {
        [clientList addObject:u.publicID];
    }
    [params setValue:clientList forKey:@"clients"];
    [CHAPI post:url params:params block:^(id data, NSError *error) {
        if (error != nil) {
            block(nil,error);
            return;
        }
        NSDictionary* json = data;
        CHConversation* obj = [[CHConversation alloc]initWithJSON:json];
        block(obj,nil);
        
    }];
}

- (void)loadConversationThread:(CHThread*)thread block:(DidLoadConversationThread)block {
    NSString* url =  [NSString stringWithFormat:@"/thread/messages?threadID=%@", thread.publicID];
    [CHAPI get:url params:nil block:^(id data, NSError *error) {
        if (error != nil){
            block(nil,error);
            return;
        }
        
        NSArray* messages = data[@"messages"];
        thread.nextMessagesURL = data[@"next"];
        thread.messages = [[NSMutableArray alloc]init];
        for (NSDictionary* m in messages){
            CHMessage* message = [[CHMessage alloc]initWithJSON:m];
            [thread addMessage:message];
        }
        block(thread, nil);
    }];
}

- (void)sendMessage:(CHMessage*)message thread:(CHThread*)thread block:(DidSendMessage)block{
    NSString* url =  [NSString stringWithFormat:@"/thread/messages?threadID=%@", thread.publicID];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:[message toJSON]];
    [params setValue:data forKey:@"data"];
    [CHAPI post:url params:params block:^(id data, NSError *error) {
        block(thread, message, error);
    }];
}

- (void)joinThread:(CHThread*)thread block:(DidJoinConversationThread)block {
    NSString* url =  [NSString stringWithFormat:@"/conversation/%@/join", thread.publicID];
    [CHAPI post:url params:nil block:^(id data, NSError *error) {
    }];
}

- (void)leaveThread:(CHThread*)thread block:(DidLeaveConversationThread)block {
    NSString* url =  [NSString stringWithFormat:@"/conversation/%@/leave", thread.publicID];
    [CHAPI post:url params:nil block:^(id data, NSError *error) {
    }];
}


- (void)subscribeToThreadUpdate:(CHThread*)thread {
    NSURL *serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/subscribe?threadID=%@",kChannel_Base_API, thread.publicID]];
    if (self.currentSubscribedURL != nil && ![self.currentSubscribedURL isEqualToString:serverURL.absoluteString]) {
        [self.source close];
        self.source = nil;
    }
    //avoid double connection
    if (self.source != nil) {
        return;
    }
    self.currentSubscribedURL = serverURL.absoluteString;
    self.source = [EventSource eventSourceWithURL:serverURL];
    [self.source onMessage:^(Event *e) {
        //we watch only for the message event
        if (![e.event isEqualToString:@""]){
            NSData* data = [e.data dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            CHMessage* message = [[CHMessage alloc]initWithJSON:obj];
            //always notify the observers
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidReceiveRealtimeMessage" object:nil userInfo:@{@"message":message}];
            if ([self.delegate respondsToSelector:@selector(client:messageFromServer:)]){
                [self.delegate client:self messageFromServer:message];
            }
            
            return;
        }
    }];
    
    [self.source addEventListener:@"typing" handler:^(Event *event) {
        
    }];
    [self.source addEventListener:@"message" handler:^(Event *event) {
        
    }];
    
    [self.source onError:^(Event *event) {
        
    }];
    
    [self.source onOpen:^(Event *event) {
        
    }];
}

- (void)inviteUsers:(NSArray<CHUser*>*)users thread:(CHThread*)thread block:(DidInviteToConversation)block {
    NSString* url = [NSString stringWithFormat:@"/conversation/%@", thread.publicID];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSMutableArray* clientList = [[NSMutableArray alloc]init];
    for (CHUser* u in users) {
        [clientList addObject:u.publicID];
    }
    [params setValue:clientList forKey:@"clients"];
    [CHAPI post:url params:params block:^(id data, NSError *error) {
        if (error != nil) {
            block(nil,error);
            return;
        }
        NSDictionary* json = data;
        CHConversation* obj = [[CHConversation alloc]initWithJSON:json];
        block(obj,nil);
        
    }];
    
}


@end
