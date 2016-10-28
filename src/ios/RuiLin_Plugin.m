//
//  RuiLin_Plugin.m
//  RuiLin
//
//  Created by IRIGI on 5/16/16.
//
//

#import "RuiLin_Plugin.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@implementation RuiLin_Plugin

- (void)verifyPassword:(CDVInvokedUrlCommand *)command {
    
    // ------ 获得回调的CallBack,JS层在调用时会将CallBack函数传递给到原生;
    self.callBackId = command.callbackId;
    
    NSString *userName = command.arguments[0];
    NSString *password = command.arguments[1];
    
    // ------ 创建插件结果对象，Cordova通过此对象回调Web层的JS。
    __block CDVPluginResult *result = [[CDVPluginResult alloc] init];
    
    if (password == nil || [password isEqualToString:@""] || userName == nil || [userName isEqualToString:@""]) {
        
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"用户名或密码不能为空"];
        // ------ 发送result
        [self.commandDelegate sendPluginResult:result callbackId:self.callBackId];
    
    } else {
        
        NSString *postString = [NSString stringWithFormat:@"%@%@",Base_Url,@"login/"];
        NSURL *postUrl = [NSURL URLWithString:postString];
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:@{@"username":userName,@"password":password,@"source":@1} options:NSJSONWritingPrettyPrinted error:nil];
        
        [NETWORK postNetworkByUrl:postUrl data:postData callback:^(NSDictionary *obj) {
            
            NSLog(@"返回的结果:%@",obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *ec = [NSString stringWithFormat:@"%@",obj[@"ec"]];
                if ([ec isEqualToString:@"0"]) {
                    
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                    UINavigationController *nav =  (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    
                    [nav pushViewController:[NSClassFromString(@"RLTestViewController") new] animated:YES];

                } else {
                    
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[RLErrorCode onResp:[obj[@"ec"] integerValue]]];
                }
                
                [self.commandDelegate sendPluginResult:result callbackId:self.callBackId];
            });
            
            
        } network:^(NSString *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
                [self.commandDelegate sendPluginResult:result callbackId:self.callBackId];
            });
            
            RLLog(@"error",error);
        }];
    }
  
}


- (void)getRealAddress:(CDVInvokedUrlCommand *)command {
    
    self.callBackId = command.callbackId;
    
    NSString *laititude = command.arguments[0];
    NSString *longitude = command.arguments[1];
    
    CLGeocoder *gecoder = [CLGeocoder new];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[laititude doubleValue] longitude:[longitude doubleValue]];
    
    __block CDVPluginResult *result = [[CDVPluginResult alloc] init];
    
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                [self.commandDelegate sendPluginResult:result callbackId:self.callBackId];
            });
            
        } else {
            
            CLPlacemark *p = placemarks[0];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:p.name];
                [self.commandDelegate sendPluginResult:result callbackId:self.callBackId];
            });
            
        }
    }];
    
}
@end
