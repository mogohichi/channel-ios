//
//  CHTableViewController.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/6/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHTableViewController.h"
#import "CHMessageTableViewCell.h"
#import "CHCardTypeImageTableViewCell.h"
#import "CHInputBar.h"
#import "CHClient.h"
#import "CHThread.h"
#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"
#import "NYTPhotosViewController.h"
#import "CHPhoto.h"
#import "CHWebViewViewController.h"
#import "CHCardWebViewTableViewCell.h"
#import "CHCardPayload.h"
#import "CHButtonListToolbar.h"
#import "CHHalfSizePresentationController.h"
#import "CHAgentListCollectionViewController.h"
#import "CHUtilities.h"

@protocol CHTableViewController <NSObject>

@optional
- (void)didDismissChannelThreadView;

@end

@interface CHTableViewController ()<CHInputBarDelegate, CHThreadDelegate, TTTAttributedLabelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CHCardTypeImageTableViewCellDelegate, CHButtonListToolbarDelegate, CHClientDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerContainerView;
@property (strong, nonatomic) IBOutlet UILabel *headerTitleLabel;

@property (weak, nonatomic) id<CHTableViewController> delegate;
@property (strong, nonatomic) CHInputBar *inputBar;
@property (strong, nonatomic) CHButtonListToolbar *buttonListBar;
@property (nonatomic, strong) CHThread *thread;
@property (nonatomic, strong) CHApplication *currentApplication;
@property (nonatomic, strong) NSMutableDictionary* heightAtIndexPath;
@property (nonatomic, strong) UIImagePickerController* imagePickerController;
@property (nonatomic, strong) id observerAppTermination;
@property (strong, nonatomic) dispatch_queue_t insertTableQueue;
@end

@implementation CHTableViewController

#pragma mark -
-(dispatch_queue_t)insertTableQueue{
    if (_insertTableQueue == nil) {
        _insertTableQueue = dispatch_queue_create("co.getchannel.queue.table.message", NULL);
    }
    return _insertTableQueue;
}

#pragma mark -

- (void)scrollToBottom{
    if (self.thread.messages.count == 0){
        return;
    }
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.thread.messages.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)loadActiveThread{
    __unsafe_unretained CHTableViewController *weakSelf = self;
    [[CHClient currentClient] activeThread:^(CHThread *thread, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.thread = thread;
            weakSelf.thread.delegate = self;
            weakSelf.tableView.delegate = self;
            weakSelf.tableView.dataSource = self;
            [weakSelf.tableView reloadData];
            [weakSelf scrollToBottom];
            [weakSelf becomeFirstResponder];
            [weakSelf reloadInputViews];
        });
    }];
}

- (void)loadMessages{
    __unsafe_unretained CHTableViewController *weakSelf = self;
    [[CHClient currentClient] loadMoreMessage:self.thread block:^(CHThread *thread,NSArray<CHMessage*>* messages, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.refreshControl endRefreshing];
            if (messages == nil || messages.count == 0){
                return;
            }
            weakSelf.thread.nextMessagesURL = thread.nextMessagesURL;
            
            weakSelf.heightAtIndexPath = [NSMutableDictionary new];
            
            //insert into a first row
            for (CHMessage* m in [[messages reverseObjectEnumerator] allObjects]){
                [self.thread.messages insertObject:m atIndex:0];
            }
            [weakSelf.tableView reloadData];
            NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:messages.count inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }];
}

- (void)setupEventSource{
    
}
- (void)clientActiveStatus:(Boolean)active{
    [[CHClient currentClient] updateActiveStatus:active];
}

#pragma mark -

- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [[CHClient currentClient] unsubscribe];
        [[NSNotificationCenter defaultCenter] removeObserver: self.observerAppTermination];
        [self clientActiveStatus:false];
    }
}

- (void)loadApplicationInfo{
    __unsafe_unretained CHTableViewController *weakSelf = self;
    [[CHClient currentClient] applicationInfo:^(CHApplication *application, NSArray<CHAgent *> *agents) {
        if (application == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.currentApplication = application;
           // weakSelf.headerTitleLabel.text = [NSString stringWithFormat:@"%@ Team", application.name];
            weakSelf.title = application.name;
//            CHAgentListCollectionViewController* agentViewController = (CHAgentListCollectionViewController*)weakSelf.childViewControllers.firstObject;
//            agentViewController.agents = agents;
            
            if (application.settings != nil) {
                NSString* backgroundImageURL = application.settings.publicChat[@"backgroundImage"];
                if (backgroundImageURL != nil) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:backgroundImageURL]];
                        UIImage* backgroundImage = [UIImage imageWithData:imageData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
                        });
                    });
                }
            }
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    // self.title = @"Your Appliation Name";
    __unsafe_unretained CHTableViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf loadApplicationInfo];
        [[CHClient currentClient] updateClientDataWithUserID:[CHClient currentClient].userID userData:[CHClient currentClient].userData block:^(NSError *error) {
            [weakSelf loadActiveThread];
            [weakSelf clientActiveStatus:true];
        }];
    });
    
    
    self.heightAtIndexPath = [NSMutableDictionary new];
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.mogohichi.Channel"];
    
    if ([self isModal] == YES){
        UIImage* closeImage = [UIImage imageNamed:@"close" inBundle:bundle compatibleWithTraitCollection:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(didDismiss:)];
    }
    
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMessages) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Loading history..."];
    
    //self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    [[CHClient currentClient] subscribeUpdateFromServerWithDelegate:self];
    
    self.observerAppTermination = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[CHClient currentClient] unsubscribe];
        [weakSelf clientActiveStatus:false];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.observerAppTermination = nil;
    [self.inputBar resignTextViewResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[CHClient currentClient] unsubscribe];
    self.thread.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}


#pragma mark -
-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (UIView *)inputAccessoryView{
    if (self.thread.messages.lastObject.isFromBusiness == true && self.thread.messages.lastObject.content.buttons != nil){
        self.buttonListBar.buttons = self.thread.messages.lastObject.content.buttons;
        return self.buttonListBar;
    }
    return self.inputBar;
}

- (CHInputBar *)inputBar{
    if (_inputBar != nil){
        return _inputBar;
    }
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    _inputBar = [[CHInputBar alloc]initWithFrame:CGRectMake(0, 0, width, 44)];
    _inputBar.inputBarDelegate = self;
    return _inputBar;
}

- (CHButtonListToolbar *)buttonListBar{
    if (_buttonListBar != nil){
        return _buttonListBar;
    }
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    _buttonListBar = [[CHButtonListToolbar alloc]initWithFrame:CGRectMake(0, 0, width, 60)];
    _buttonListBar.toolbarDelegate = self;
    return _buttonListBar;
}


#pragma mark - Actions
- (IBAction)didTapToDismissKeyboard:(id)sender{
    [self.inputBar resignTextViewResponder];
}

- (IBAction)didDismiss:(id)sender{
    [[NSNotificationCenter defaultCenter] removeObserver: self.observerAppTermination];
    
    [self clientActiveStatus:false];
    [[CHClient currentClient] unsubscribe];
    [self.inputBar resignTextViewResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissChannelThreadView)]){
            [self.delegate didDismissChannelThreadView];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.thread.messages.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height) {
        return height.floatValue;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMessage* message = [self.thread.messages objectAtIndex:indexPath.row];
    if (message.content.card == nil) {
        return [self configureMessageCell:indexPath message:message];
    }  if (message.content.card != nil) {
        return [self configureCardCell:indexPath message:message];
    }
    
    return nil;
}

- (CHMessageTableViewCell*)configureMessageCell:(NSIndexPath*)indexPath message:(CHMessage*)message{
    NSString* cellPrefix = @"Text";
    NSString* cellIdentifier = message.isFromBusiness ? [NSString stringWithFormat:@"%@-Received",cellPrefix] : [NSString stringWithFormat:@"%@-Sent",cellPrefix];
    
    CHMessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.application = self.currentApplication;
    cell.message = message;
    cell.messageLabel.delegate = self;
    __unsafe_unretained CHTableViewController *weakSelf = self;
    if (message.sender.imageUrl != nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:message.sender.imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                CHMessageTableViewCell *toUpdateCell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                if (toUpdateCell != nil) {
                    toUpdateCell.profileImageView.image = [UIImage imageWithData:data];
                }
            });
        });
    }
    return cell;
}

- (CHCardTableViewCell*)configureCardCell:(NSIndexPath*)indexPath message:(CHMessage*)message{
    
    NSString* cellPrefix = @"Card";
    NSString* cellIdentifier = message.isFromBusiness ? [NSString stringWithFormat:@"%@-%@-Received",cellPrefix,message.content.card.type] : [NSString stringWithFormat:@"%@-%@-Sent", cellPrefix, message.content.card.type];
    CHCardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.message = message;
    __unsafe_unretained CHTableViewController *weakSelf = self;
    if (message.sender.imageUrl != nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:message.sender.imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                CHCardTypeImageTableViewCell *toUpdateCell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                if (toUpdateCell != nil) {
                    toUpdateCell.profileImageView.image = [UIImage imageWithData:data];
                }
            });
        });
    }
    
    if ([message.content.card.type isEqualToString:CardTypeImage]){
        CHCardTypeImageTableViewCell* imageCell = (CHCardTypeImageTableViewCell*)cell;
        imageCell.delegate = self;
        
        CHCardPayloadImage* imagePayload = (CHCardPayloadImage*)message.content.card.payload;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage* cachedImage = [UIImage imageFromCacheDirectory:imagePayload.imageURL.absoluteString.lastPathComponent];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cachedImage != nil){
                    imageCell.payloadImageView.image = cachedImage;
                }else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        NSData* data;
                        if ([imagePayload.imageURL.absoluteString hasPrefix:@"http"]){
                            data = [NSData dataWithContentsOfURL:imagePayload.imageURL];
                        }else{
                            data = [NSData dataWithContentsOfFile:imagePayload.imageURL.absoluteString];
                        }
                        if (data != nil){
                            UIImage* image = [UIImage imageWithData:data];
                            [image saveToCacheDirectory:imagePayload.imageURL.absoluteString.lastPathComponent];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                CHCardTypeImageTableViewCell *toUpdateCell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                                if (toUpdateCell != nil) {
                                    toUpdateCell.payloadImageView.image = image;
                                }
                                
                            });
                        }
                    });
                }
            });
        });
        
        
    }else if ([message.content.card.type isEqualToString:CardTypeTemplate]){
        CHCardPayloadTemplate* payload = (CHCardPayloadTemplate*)message.content.card.payload;
        CHCardWebViewTableViewCell *webCell = (CHCardWebViewTableViewCell*)cell;
        
        CGFloat ratio = 1.0;
        
        if (message.content.card.widthRatio != nil) {
            ratio = message.content.card.widthRatio.floatValue / message.content.card.heightRatio.floatValue;
        }
        [webCell setNeedsUpdateConstraints];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint
                                          constraintWithItem:webCell.containerView
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:webCell.containerView
                                          attribute:NSLayoutAttributeHeight
                                          multiplier:ratio
                                          constant:0.0f];
        
        
        [webCell.containerView addConstraint:constraint];
        [webCell layoutIfNeeded];
        [[CHClient currentClient] loadCardTemplate:payload block:^(NSString *templateString) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CHCardWebViewTableViewCell *webCell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                [webCell.webView loadHTMLString:templateString baseURL:nil];
            });
        }];
    }
    
    return cell;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.mogohichi.Channel"];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:bundle];
    UINavigationController* nav = [storyboard instantiateViewControllerWithIdentifier:@"CHWebViewViewController"];
    CHWebViewViewController* vc = nav.viewControllers.firstObject;
    vc.url = url;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - CHThreadDelegate

-(void)didAddMessage:(CHMessage *)message{
    //if the message was added by SSE meaning it's coming from admin
    //if the message was sent by client we then sendMessage
    if (message.isFromBusiness == NO){
        
        [[CHClient currentClient] sendMessage:message block:^(CHThread *thread, CHMessage *sentMessage, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadActiveThread];
            });
        }];
        
    }
    
    if (message.isFromBusiness == true && message.content.buttons != nil){
        [self.inputBar resignTextViewResponder];
        [self becomeFirstResponder];
        [self reloadInputViews];
    }
    
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.thread.messages.count - 1 inSection:0];
    // [self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
#pragma mark - CHInputBarDelegate
-(void)inputBar:(id)inputBar didTapLeftButton:(id)sender{
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    [alert addAction:library];
    
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    [alert addAction:camera];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    alert.popoverPresentationController.barButtonItem = sender;
    alert.popoverPresentationController.sourceView = self.view;
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)inputBar:(id)inputBar didTapSend:(CHMessage *)message{
    [self.thread addMessage:message];
}

-(void)inputBar:(id)inputBar didBegineEditing:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToBottom];
    });
}

-(void)inputBar:(id)inputBar didStartTyping:(id)sender{
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //        [[CHClient currentClient] startTyping];
    //    });
    //
}

#pragma mark - CHButtonListToolbarDelegate
-(void)buttonListToolbar:(id)butonListToolbar didTapButton:(CHButton *)sender{
    
    if ([sender.data.type isEqualToString:@"web_url"]){
        NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.mogohichi.Channel"];
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:bundle];
        UINavigationController* nav = [storyboard instantiateViewControllerWithIdentifier:@"CHWebViewViewController"];
        CHWebViewViewController* vc = nav.viewControllers.firstObject;
        
        nav.modalPresentationStyle = UIModalPresentationCustom;
        vc.url = [NSURL URLWithString:sender.data.url];
        nav.transitioningDelegate = self;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    } if ([sender.data.type isEqualToString:@"postback"]){
        CHMessage* message = [[CHMessage alloc]initWithText:sender.data.title postbackPayload:sender.data.payload];
        message.isFromBusiness = false;
        [self.thread addMessage:message];
        [self.inputBar resignTextViewResponder];
        [self becomeFirstResponder];
        [self reloadInputViews];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePickerController.delegate = nil;
    self.imagePickerController = nil;
    
    __unsafe_unretained CHTableViewController *weakSelf = self;
    UIImage* resizedImage = [originalImage scaledToMaxWidth:1000 maxHeight:1000];
    [[CHClient currentClient] uploadImage:resizedImage block:^(NSURL *imageURL, NSError *error) {
        if (error != nil){
            return;
        }
        //[self loadActiveThread];
        CHMessage* message = [[CHMessage alloc]initWithImageURL:imageURL];
        message.isFromBusiness = false;
        [weakSelf.thread addMessage:message];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePickerController.delegate = nil;
    self.imagePickerController = nil;
}


#pragma mark - CHCardTypeImageTableViewCellDelegate
-(void)cardTypeImageTableViewCell:(UITableViewCell *)cell imageView:(UIImageView *)imageView message:(CHMessage *)message{
    CHPhoto* photo = [[CHPhoto alloc]initWithImage:imageView.image];
    NYTPhotosViewController* photoViewer = [[NYTPhotosViewController alloc]initWithPhotos:@[photo] initialPhoto:nil];
    [self presentViewController:photoViewer animated:YES completion:nil];
}

#pragma mark - CHClientDelegate
-(void)client:(CHClient *)client messageFromServer:(CHMessage *)message{
    __unsafe_unretained CHTableViewController *weakSelf = self;
    dispatch_async(self.insertTableQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.thread addMessage:message];
        });
    });
}


#pragma mark - UIViewControllerTransitioningDelegate
-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[CHHalfSizePresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
