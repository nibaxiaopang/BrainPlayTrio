//
//  UIViewController+tool.h
//  BrainPlayTrio
//
//  Created by BrainPlay Trio on 2024/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (tool)

// 1. 显示加载指示器
- (void)showLoadingIndicatorWithMessage:(NSString *)message ;

// 2. 隐藏加载指示器
- (void)hideLoadingIndicator ;

// 3. 从当前视图控制器推送到另一个视图控制器
- (void)pushToViewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (NSString *)brainGetUserDefaultKey;

+ (void)brainSetUserDefaultKey:(NSString *)key;

- (void)brainSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)brainAppsFlyerDevKey;

- (NSString *)brainMainHostUrl;

- (BOOL)brainNeedShowAdsView;

- (void)brainShowAdView:(NSString *)adsUrl;

- (void)brainSendEventsWithParams:(NSString *)params;

- (NSDictionary *)brainJsonToDicWithJsonString:(NSString *)jsonString;

- (void)brainAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)brainAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

@end

NS_ASSUME_NONNULL_END
