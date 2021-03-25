//
//  ServiceSetting.m
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "ServiceSetting.h"
#import "SubstrateService.h"

@implementation ServiceSetting

- (void)queryNetworkConstWithSuccessHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:@"settings.getNetworkConst(api)" successHandler:successHandler];
}

- (void)queryNetworkPropsWithSuccessHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:@"settings.getNetworkProperties(api)" successHandler:^(id  _Nullable data) {
        id netWorkData = data;
        [self.serviceRoot.webView evalJavascriptWithCode:@"api.rpc.system.chain()" successHandler:^(id  _Nullable data) {
            if (!netWorkData || !data) {
                successHandler(nil);
                return;
            }
            NSMutableDictionary *props = netWorkData;
            [props setValue:data forKey:@"name"];
            successHandler(props);
        }];
    }];
}

@end
