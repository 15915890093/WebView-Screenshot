
#import "UIImageEx.h"

@implementation UIImage(UIImageEx)

+ (void)screenshotFromWeb:(UIWebView *)webView parentView:(UIView *)parentView completion:(void(^)(UIImage *image))completion {
    
    UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:webView.frame];
    coverImageView.image = [self imageFromView:webView];
    [parentView addSubview:coverImageView];
    
    CGRect oldFrame = webView.frame;
    CGPoint oldOffset = webView.scrollView.contentOffset;
    
    CGRect newFrame = oldFrame;
    newFrame.size.height = webView.scrollView.contentSize.height;
    webView.frame = newFrame;
    
    [webView.scrollView setContentOffset:CGPointZero];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self screenView:webView.scrollView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView.scrollView setContentOffset:oldOffset];
            webView.frame = oldFrame;
            [coverImageView removeFromSuperview];
            if (image) {
                completion(image);
            }
        });
    });
}

//截取网页长图
+ (UIImage *)screenView:(UIScrollView *)view {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width,view.frame.size.height), YES, 0);//设置截屏大小
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    UIImageWriteToSavedPhotosAlbum(sendImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    return sendImage;
}

//保存截取的图片到相册
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存失败");
    }else{
        NSLog(@"保存成功");
    }
}

//截取当前屏幕覆盖视图滚动效果
+ (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    view.layer.contents = nil;
    UIGraphicsEndImageContext();
    
    return image;
}

@end
