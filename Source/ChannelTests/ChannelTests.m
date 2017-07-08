//
//  ChannelTests.m
//  ChannelTests
//
//  Created by Apisit Toompakdee on 1/30/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CHClient.h"
#import "Channel.h"

@interface ChannelTests : XCTestCase

@end

@implementation ChannelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [Channel setupWithPublishableKey:@"bfb523ee-e448-4e50-a5d6-20f11eb7cc80" detectScreenshot:NO detectShake:NO];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testInitClient{
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    [CHClient newClient:^(NSError *error) {
        XCTAssertNil(error, "error should be nil");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:nil];
}


- (void)testSendFirstMessage{
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    CHMessage* message = [[CHMessage alloc]initWithText:@"hello someone there?"];
   [[CHClient sharedClient] sendMessage:message block:^(CHThread *thread, CHMessage *sentMessage, NSError *error) {
       XCTAssertNil(error, "error should be nil");
       [expectation fulfill];
   }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:nil];
}

- (void)testLoadActiveThread{
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    CHMessage* message = [[CHMessage alloc]initWithText:@"hello someone there?"];
    [[CHClient sharedClient] activeThread:^(CHThread *thread, NSError *error) {
        XCTAssertNil(error, "error should be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:nil];
}

@end
