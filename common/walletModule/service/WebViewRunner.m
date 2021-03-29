//
//  WebViewRunner.m
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "WebViewRunner.h"
#import "WeakScriptMessageDelegate.h"
#import "NSObject+jsonExtention.h"

@interface WebViewRunner ()<WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, copy) void(^onLaunched) (void);
@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(_Nullable id data)> *msgHandlers;
@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(_Nullable id data)> *msgCompleters;
@property (nonatomic ,strong) NSDate *date;

@end

@implementation WebViewRunner

- (void)launchWithKeyring:(ServiceKeyring *)keyring
           keyringStorage:(Keyring *)keyringStorage
                    block:(void (^)(void))onLaunched
                   jsCode:(NSString *)jsCode
{
    self.msgHandlers = [[NSMutableDictionary alloc] init];
    self.msgCompleters = [[NSMutableDictionary alloc] init];
    self.evalJavascriptUID = 0;
    self.onLaunched = onLaunched;
    
    self.web = [[WalletWebView alloc] init];
    
    self.web.navigationDelegate = self;
    
    //本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.web loadHTMLString:htmlCont baseURL:baseURL];
    self.date = [NSDate new];
}

- (NSInteger)evalJavascriptUID
{
    return _evalJavascriptUID++;
}

- (void)evalJavascriptWithCode:(NSString *)code
                successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    NSString *method = [NSString stringWithFormat:@"uid=%ld;%@", self.evalJavascriptUID, [code componentsSeparatedByString:@"("][0]];
    NSString *script = [NSString stringWithFormat:@"%@.then(function(res) {"
                        "  webkit.messageHandlers.callbackHandler.postMessage(JSON.stringify({ path: \"%@\", data: res }));"
                        "}).catch(function(err) {"
                        "  webkit.messageHandlers.callbackHandler.postMessage(JSON.stringify({ path: \"log\", data: err.message }));"
                        "})", code, method];
    self.msgCompleters[method] = successHandler;
    [self.web evaluateJavaScript:script completionHandler:nil];
}
//successHandler    void (^)(id)    0x00000001053fd7b0
- (void)connectNode:(NSArray<NetworkParams *> *)nodes
     successHandler:(void (^ _Nullable)(NetworkParams *data))successHandler
{
    NSMutableArray *endpoints = [[NSMutableArray alloc] init];
    for (NetworkParams *data in nodes) {
        [endpoints addObject:data.endpoint];
    }
    [self evalJavascriptWithCode:[NSString stringWithFormat:@"settings.connect(%@)", jsonEncodeWithValue(endpoints)] successHandler:^(id  _Nullable data) {
        if (data) {
            //wss://kusama-1.polkawallet.io:9944/
            for (NetworkParams *node in nodes) {
                if ([node.endpoint isEqualToString:(NSString *)data]) {
                    successHandler(data);
                    return;;
                }
            }
        }else{
            successHandler(nil);
        }
    }];
    
}

- (void)subscribeMessageWithCode:(NSString *)code
                         channel:(NSString *)channel
                        callback:(void (^ _Nullable)(_Nullable id data))callback
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self addMsgHandlerWithChannel:channel onMessage:callback];
    [self evalJavascriptWithCode:code successHandler:successHandler];
}

- (void)unsubscribeMessageWithChannel:(NSString *)channel
{
    NSLog(@"unsubscribe %@", channel);
    NSString *unsubCall = [@"unsub" stringByAppendingString:channel];
    [self.web evaluateJavaScript:[NSString stringWithFormat:@"%@ && %@()", unsubCall, unsubCall] completionHandler:nil];
}

- (void)addMsgHandlerWithChannel:(NSString *)channel
                       onMessage:(void (^)(_Nullable id data))onMessage
{
    self.msgHandlers[channel] = onMessage;
}

- (void)removeMsgHandlerWithChannel:(NSString *)channel
{
    [self.msgHandlers removeObjectForKey:channel];
}

#pragma mark WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载js时间：%.2fs", [[NSDate new] timeIntervalSinceDate:self.date]);
    [[webView configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"callbackHandler"];
    self.onLaunched();
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"JS 调用了: \n%@ 方法\n传回参数: \n%@",message.name,message.body);
    
    NSMutableDictionary *msgDict = jsonDecodeWithString(message.body);
    if ([msgDict.allKeys containsObject:@"path"] && [msgDict.allKeys containsObject:@"data"]) {
        NSString *path = msgDict[@"path"];
        if (self.msgCompleters[path] != nil) {
            if (![msgDict[@"data"] isKindOfClass:NSNull.class]) self.msgCompleters[path](msgDict[@"data"]);
            [self.msgCompleters removeObjectForKey:path];
        }
        if ([self.msgHandlers.allKeys containsObject:@"path"]) {
            if (self.msgHandlers[@"path"]) {
                self.msgHandlers[path](msgDict[@"data"]);
            }
        }
    }
}

@end
