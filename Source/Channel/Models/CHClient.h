//
//  CHClient.h
//  Channel
//
//  Created by Apisit Toompakdee on 1/26/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Channel/Channel.h>
#import "CHAPI.h"
#import "CHThread.h"
#import "CHMessage.h"
#import "CHNotification.h"
#import "CHApplication.h"
#import "CHAgent.h"
#import "CHTopic.h"
#import "CHConversation.h"
#import "CHUser.h"

@class CHClient;
@class CHConversation;
@class CHSender;

@protocol CHClientDelegate <NSObject>

- (void)client:(CHClient*)client messageFromServer:(CHMessage*)message;

@end

typedef void (^DidCheckNewMessages)(NSInteger numberOfNewMesages);
typedef void (^DidConnectClient)(NSError* error);
typedef void (^DidLoadActiveThread)(CHThread* thread,NSError* error);
typedef void (^DidSendMessage)(CHThread* thread,CHMessage* sentMessage,NSError* error);
typedef void (^DidLoadMessages)(CHThread* thread, NSArray<CHMessage*>* messages,NSError* error);
typedef void (^DidFinishUploadImage)(NSURL* imageURL, NSError* error);
typedef void (^DidGetUpdateFromServer)();
typedef void (^DidLoadCardTemplate)(NSString* templateString);
typedef void (^DidGetApplicationInfo) (CHApplication* application, NSArray<CHAgent *>* agents);
typedef void (^DidCheckNotification) (CHNotification* notification, NSError* error);
typedef void (^DidLoadSubscribedTopics) (NSArray<CHTopic*>* topics, NSError* error);
typedef void (^DidSubscribeToTopic) (CHTopic* topics, NSError* error);
typedef void (^DidUnsubscribeFromTopic) (CHTopic* topics, NSError* error);

typedef void (^DidSearchUser) (CHUser* user, NSError* error);
typedef void (^DidLoadConversations) (NSArray<CHConversation*>* conversations, NSError* error);
typedef void (^DidLoadConversationThread) (CHThread* thread, NSError* error);
typedef void (^DidStartConversationThread) (CHConversation* conversation, NSError* error);
typedef void (^DidJoinConversationThread) (NSError* error);
typedef void (^DidLeaveConversationThread) (NSError* error);
typedef void (^DidInviteToConversation) (CHConversation* conversation, NSError* error);
typedef void (^DidSubscribeToConversationsUpdate) (CHConversation* conversation, NSError* error);

@interface CHClient : CHBase

@property (nonatomic, strong) NSString* clientID;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSDictionary* userData;
@property (nonatomic) id<CHClientDelegate> delegate;
@property (nonatomic, readonly) CHSender* asSender;

+(void)connectClientwithUserID:(NSString*)userID userData:(NSDictionary*)userData block:(DidConnectClient)block;
+ (void)connectClient:(DidConnectClient)block;

+ (CHClient*)currentClient;

-(void)updateClientDataWithUserID:(NSString*)userID userData:(NSDictionary*)userData block:(DidConnectClient)block;

- (void)applicationInfo:(DidGetApplicationInfo)block;

- (void)sendMessage:(CHMessage*)message block:(DidSendMessage)block;
- (void)activeThread:(DidLoadActiveThread)block;
- (void)loadMoreMessage:(CHThread*)thread block:(DidLoadMessages)block;

- (void)startTyping;

- (void)subscribeUpdateFromServerWithDelegate:(id<CHClientDelegate>)delegate;

- (void)subscribeUpdateFromServerWithNSNotification;

- (void)unsubscribe;
- (void)uploadImage:(UIImage*)image block:(DidFinishUploadImage)block;

- (void)checkNewMessages:(DidCheckNewMessages)block;

- (void)updateActiveStatus:(Boolean)active;

- (void)loadCardTemplate:(CHCardPayloadTemplate*)payload block:(DidLoadCardTemplate)block;

- (void)checkNewNotification:(DidCheckNotification)block;

- (void)postbackNotification:(CHNotification*)notification button:(CHNotificationButton*)button;

- (void)presentWebViewWithURL:(NSURL*)url inViewController:(UIViewController*)viewController;

- (void)saveDeviceToken:(NSData*)deviceToken;

- (void)markOpenFromPushNotification:(NSString*)notificationPublicID;

- (void)pushNotificationEnabled:(BOOL)enabled;

- (void)appendTags:(NSDictionary*)tags;

- (void)subscribeToTopic:(NSString*)topic block:(DidSubscribeToTopic)block;

- (void)unsubscribeFromTopic:(NSString*)topic block:(DidUnsubscribeFromTopic)block;

- (void)subscribedTopicsWithBlock:(DidLoadSubscribedTopics)block;


//New APIs added for User <--> User communication
- (void)searchUserByID:(NSString* _Nonnull)query block:(DidSearchUser _Nonnull)block;
- (void)conversations:(DidLoadConversations _Nonnull)block;
- (void)sendMessage:(CHMessage* _Nonnull)message thread:(CHThread* _Nonnull)thread block:(DidSendMessage _Nonnull)block;
- (void)startConversation:(NSArray<CHUser*>* _Nonnull)users data:(NSDictionary* _Nullable)data block:(DidStartConversationThread _Nonnull)block;
- (void)loadConversationThread:(CHThread* _Nonnull)thread block:(DidLoadConversationThread _Nonnull)block;
- (void)joinThread:(CHThread* _Nonnull)thread block:(DidJoinConversationThread _Nonnull)block;
- (void)leaveThread:(CHThread* _Nonnull)thread block:(DidLeaveConversationThread _Nonnull)block;
- (void)inviteUsers:(NSArray<CHUser*>* _Nonnull)users thread:(CHThread* _Nonnull)thread block:(DidInviteToConversation _Nonnull)block;
- (void)subscribeToThreadUpdate:(CHThread* _Nonnull)thread;
- (void)subscribeToConversationsUpdate:(DidSubscribeToConversationsUpdate _Nonnull)block;

@end
