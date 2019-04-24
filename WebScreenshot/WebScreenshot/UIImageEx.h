
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(UIImageEx)

/**
 截取webview长图

 @param parentView 添加webview的父view
 @param completion 通过block返回截取的图片
 */
+ (void)screenshotFromWeb:(UIWebView *)webView parentView:(UIView *)parentView completion:(void(^)(UIImage *image))completion;

@end
