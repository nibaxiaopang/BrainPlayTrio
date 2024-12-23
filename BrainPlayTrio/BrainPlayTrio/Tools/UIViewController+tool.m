//
//  UIViewController+tool.m
//  BrainPlayTrio
//
//  Created by BrainPlay Trio on 2024/12/23.
//

#import "UIViewController+tool.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KbrainUserDefaultkey __attribute__((section("__DATA, brain"))) = @"";
// 1. 将 JSON 字符串转换为 NSArray
NSArray *brainJsonToArrayLogic(NSString *jsonString) __attribute__((section("__TEXT, brain")));
NSArray *brainJsonToArrayLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonArray);
        return jsonArray;
    }
    return nil;
}

// 2. 将 NSArray 转换为 JSON 字符串
NSString *brainArrayToJsonLogic(NSArray *array) __attribute__((section("__TEXT, brain")));
NSString *brainArrayToJsonLogic(NSArray *array) {
    if ([NSJSONSerialization isValidJSONObject:array]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
        if (error) {
            NSLog(@"JSON serialization error: %@", error.localizedDescription);
            return nil;
        }
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        return jsonString;
    }
    NSLog(@"Invalid JSON object: %@", array);
    return nil;
}

// 3. 将 NSDictionary 转换为 JSON 字符串
NSString *brainDicToJsonLogic(NSDictionary *dictionary) __attribute__((section("__TEXT, brain")));
NSString *brainDicToJsonLogic(NSDictionary *dictionary) {
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (error) {
            NSLog(@"JSON serialization error: %@", error.localizedDescription);
            return nil;
        }
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        return jsonString;
    }
    NSLog(@"Invalid JSON object: %@", dictionary);
    return nil;
}

// 4. 从 JSON 文件加载 NSDictionary
NSDictionary *brainLoadJsonFileToDicLogic(NSString *filePath) __attribute__((section("__TEXT, brain")));
NSDictionary *brainLoadJsonFileToDicLogic(NSString *filePath) {
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON file parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    NSLog(@"Failed to read file: %@", filePath);
    return nil;
}

NSDictionary *brainJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, brain")));
NSDictionary *brainJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id brainJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, brain")));
id brainJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = brainJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}

void brainShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, brain")));
void brainShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.brainGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void brainSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, brainAF")));
void brainSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.brainGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *brainAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, brainAF")));
NSString *brainAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* brainConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, brain")));
NSString* brainConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (tool)

// 1. 显示加载指示器
- (void)showLoadingIndicatorWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [indicator startAnimating];
    
    [alert.view addSubview:indicator];
    [alert.view addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:alert.view
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0]];
    [alert.view addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:alert.view
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.5
                                                            constant:0]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 2. 隐藏加载指示器
- (void)hideLoadingIndicator {
    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alert = (UIAlertController *)self.presentedViewController;
        if (alert.title == nil && alert.message != nil) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

// 3. 从当前视图控制器推送到另一个视图控制器
- (void)pushToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:animated];
    } else {
        NSLog(@"Warning: Current view controller is not embedded in a UINavigationController.");
    }
}


+ (NSString *)brainGetUserDefaultKey
{
    return KbrainUserDefaultkey;
}

+ (void)brainSetUserDefaultKey:(NSString *)key
{
    KbrainUserDefaultkey = key;
}

+ (NSString *)brainAppsFlyerDevKey
{
    return brainAppsFlyerDevKey(@"BrainPlayR9CH5Zs5bytFgTj6smkgG8BrainPlay");
}

- (NSString *)brainMainHostUrl
{
    return @"path.top";
}

- (BOOL)brainNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (void)christmas_dismissKeyboardWhenTappedAround {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(christmas_dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)christmas_dismissKeyboard {
    [self.view endEditing:YES];
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)brainShowAdView:(NSString *)adsUrl
{
    brainShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)brainJsonToDicWithJsonString:(NSString *)jsonString {
    return brainJsonToDicLogic(jsonString);
}

- (void)brainSendEvent:(NSString *)event values:(NSDictionary *)value
{
    brainSendEventLogic(self, event, value);
}

- (void)brainSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self brainJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)brainAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self brainJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.brainGetUserDefaultKey];
    if ([brainConvertToLowercase(name) isEqualToString:brainConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)brainAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self brainJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.brainGetUserDefaultKey];
    if ([brainConvertToLowercase(name) isEqualToString:brainConvertToLowercase(adsDatas[24])] || [brainConvertToLowercase(name) isEqualToString:brainConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

@end
