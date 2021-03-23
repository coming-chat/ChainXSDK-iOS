//
//  WebViewRunner.m
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "WebViewRunner.h"
#import "WeakScriptMessageDelegate.h"

@interface WebViewRunner ()<WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, copy) void(^onLaunched) (void);
@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(_Nullable id data)> *msgHandlers;
@property (nonatomic ,strong) NSDate *date;

@end

@implementation WebViewRunner

- (void)launchWithKeyring:(ServiceKeyring *)keyring
                  Keyring:(Keyring *)keyringStorage
                    block:(void (^)(void))onLaunched
                   jsCode:(NSString *)jsCode
{
    self.msgHandlers = [[NSMutableDictionary alloc] init];
    self.evalJavascriptUID = 0;
    self.onLaunched = onLaunched;
    
    self.web = [[ChainXWebView alloc] init];
    
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
    self.msgHandlers[method] = successHandler;
    [self.web evaluateJavaScript:script completionHandler:nil];
}

- (NSString *)connectNode:(NSArray<NetworkParams *> *)nodes
           successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    if (nodes.count < 1) {
        return @"";
    }
    [self evalJavascriptWithCode:[NSString stringWithFormat:@"settings.connect(%@)", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@[nodes.firstObject.endpoint] options:kNilOptions error:nil] encoding:NSUTF8StringEncoding]] successHandler:successHandler];
    return nodes.firstObject.endpoint;
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
    
    NSDictionary *msgDict = [NSJSONSerialization JSONObjectWithData:[message.body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if ([msgDict.allKeys containsObject:@"path"] && [msgDict.allKeys containsObject:@"data"]) {
        NSString *path = msgDict[@"path"];
        if (self.msgHandlers[path] != nil) {
            self.msgHandlers[path](msgDict[@"data"]);
            [self.msgHandlers removeObjectForKey:path];
        }
    }
}

@end
