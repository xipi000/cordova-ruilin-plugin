//
//  RuiLin_Plugin.h
//  RuiLin
//
//  Created by IRIGI on 9/26/16.
//
//

#import <Cordova/CDV.h>

@interface RuiLin_Plugin : CDVPlugin

// ------ 验证密码
- (void)verifyPassword:(CDVInvokedUrlCommand *)command;

// ------ 获取真实的地理位置
- (void)getRealAddress:(CDVInvokedUrlCommand *)command;

@property (strong, nonatomic) NSString *callBackId;

@end
