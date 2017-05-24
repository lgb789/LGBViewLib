//
//  ZADisplayController.m
//  Common
//
//  Created by lgb789 on 2017/3/13.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import "ZADisplayController.h"

#define kMaskColorLight      [UIColor clearColor]
#define kMaskColorDark       [[UIColor blackColor] colorWithAlphaComponent:0.2]



static const CGFloat __maxZoomScale = 3.0;
static const CGFloat __minZoomScale = 1.0;

//static const CGFloat __scaleAnimationDuration = 0.3;

static const CGFloat __animationDuration = 0.2;
static const CGFloat __snapshotScale = 0.9;
static const CGFloat __blurValue = 5.0;

@interface ZADisplayController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *displayView;
@property (nonatomic, weak) UIViewController *targetController;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *snapshotView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) BOOL dismissed;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) CGRect displayViewNewFrame;
@property (nonatomic, assign) CGRect displayViewOldFrame;
@property (nonatomic, assign) CGRect displayViewOriginFrame;
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic, strong) NSArray *oldGestures;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isScaled;

/**
 单击次数
 */
@property (nonatomic, assign) NSInteger tapCount;

@property (nonatomic, assign) UIDeviceOrientation currentOrientation;

@property (nonatomic, assign) CGFloat displayViewWidth;
@property (nonatomic, assign) CGFloat displayViewHeight;
@end

@implementation ZADisplayController

#pragma mark ------------------------------------------------- 成员变量 -------------------------------------------------

-(UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor blackColor];
        //        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

-(UIImageView *)snapshotView
{
    if (_snapshotView == nil) {
        _snapshotView = [UIImageView new];
        //        [self.backgroundView addSubview:_snapshotView];
    }
    return _snapshotView;
}

-(UIView *)maskView
{
    if (_maskView == nil) {
        _maskView = [UIView new];
        //        [self.view insertSubview:_maskView aboveSubview:self.backgroundView];
        _maskView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMaskView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        //        _scrollView.scrollEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.maximumZoomScale = __maxZoomScale;
        _scrollView.minimumZoomScale = __minZoomScale;
        //        [self.view insertSubview:_scrollView aboveSubview:self.maskView];
    }
    return _scrollView;
}

#pragma mark ------------------------------------------------- 生命周期 -------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self didTapMaskView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark ------------------------------------------------- 代理方法 -------------------------------------------------

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.displayView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.isScaled = scale > __minZoomScale ? YES : NO;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //缩小的时候，设置displayview居中
    CGRect frame = self.displayView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    if (CGRectGetWidth(frame) < CGRectGetWidth(self.scrollView.bounds)) {
        frame.origin.x = floor((CGRectGetWidth(self.scrollView.bounds) - CGRectGetWidth(frame)) / 2);
    }
    if (CGRectGetHeight(frame) < CGRectGetHeight(self.scrollView.bounds)) {
        frame.origin.y = floor((CGRectGetHeight(self.scrollView.bounds) - CGRectGetHeight(frame)) / 2);
    }
    self.displayView.frame = frame;
}

#pragma mark ------------------------------------------------- 公有方法 -------------------------------------------------

-(void)dismissFromParentAnimated:(BOOL)animated duration:(CGFloat)duration
{
    if (!self.dismissed) {
        self.dismissed = YES;
        
        //dismiss时，恢复scroll最小zoom scale
        if (_scrollView) {
            [self.scrollView setZoomScale:__minZoomScale animated:NO];
        }
        //移除手势
        [self removeGesturesForDisplayView];
        
        if (animated) {
            //如果动画时间为0，设置为默认动画时间
            [UIView animateWithDuration:(duration ? duration : __animationDuration) delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                //恢复快照大小
                if (self.shrink) {
                    self.snapshotView.transform = CGAffineTransformIdentity;
                }
                
                self.maskView.alpha = 0;
                
                if (!CGRectIsEmpty(self.displayViewNewFrame)) {
                    self.displayView.frame = self.displayViewNewFrame;
                    [UIApplication sharedApplication].statusBarHidden = NO;
                }else{
                    self.displayView.alpha = 0;
                }
                
            } completion:^(BOOL finished) {
                [self cleanUp];
            }];
        }else{
            [self cleanUp];
        }
        
    }
}

-(void)displayView:(UIView *)view inViewController:(UIViewController *)controller
{
    if (!view) {
        return;
    }
    
    if (!view.superview) {
        [self displayView:view inViewController:controller position:ZADisplayViewPositionCenter];
        return;
    }
    
    self.displayView = view;
    self.targetController = controller;
    self.parentView = view.superview;
    self.displayViewOldFrame = view.frame;
    
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.snapshotView];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.scrollView];
    
    UIView *superView = controller ? controller.view : view.superview;
    self.displayView.frame = [superView convertRect:view.frame toView:nil]; //转换到window坐标系统
    self.displayViewNewFrame = self.displayView.frame;
    self.displayViewOriginFrame = self.displayView.frame;
    
    [self.displayView removeFromSuperview];
    
    //移除手势
    self.oldGestures = [self removeGesturesForDisplayView];
    
    [self addGesturesToDisplayView];
    
    self.maskView.backgroundColor = (self.maskType == ZADisplayMaskTypeLight ? kMaskColorLight : [UIColor blackColor]);
    
    UIImage *snapshot = [self createSnapshotFromController:self.targetController];
    
    if (self.blur) {
        snapshot = [self blurFromImage:snapshot blurValue:__blurValue];
    }
    self.snapshotView.image = snapshot;
    
    [self.scrollView addSubview:self.displayView];
    
    CGFloat snapshotScale = 1.0;
    
    if (self.shrink) {
        snapshotScale = __snapshotScale;
    }
    
    //注册orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    self.currentOrientation = [UIDevice currentDevice].orientation;
    
    //设置frame
    self.backgroundView.frame = self.view.bounds;
    self.maskView.frame = self.view.bounds;
    self.snapshotView.frame = self.backgroundView.bounds;
    self.scrollView.frame = self.view.bounds;
    self.scrollView.delegate = self;
    
    self.maskView.alpha = 0;
    
    CGAffineTransform baseTransform = [self transformForOrientation:self.currentOrientation];
    self.scrollView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, baseTransform);
    
    if (UIDeviceOrientationIsPortrait(self.currentOrientation)) {
        self.scrollView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.superview.bounds), CGRectGetHeight(self.scrollView.superview.bounds));
    }else if (UIDeviceOrientationIsLandscape(self.currentOrientation)){
        self.scrollView.bounds = CGRectMake(0, 0, CGRectGetHeight(self.scrollView.superview.bounds), CGRectGetWidth(self.scrollView.superview.bounds));
    }
    
    CGFloat scaleWidth = CGRectGetWidth(self.scrollView.bounds) / CGRectGetWidth(self.displayViewOldFrame);
    CGFloat scaleHeight = CGRectGetHeight(self.scrollView.bounds) / CGRectGetHeight(self.displayViewOldFrame);
    CGFloat scale = MIN(scaleWidth, scaleHeight);
    CGFloat width = scale * CGRectGetWidth(self.displayViewOldFrame);
    CGFloat height = scale * CGRectGetHeight(self.displayViewOldFrame);
    self.displayViewWidth = width;
    self.displayViewHeight = height;
    
    self.scrollView.contentSize = CGSizeMake(self.displayViewWidth, self.displayViewHeight);
    self.displayViewNewFrame = [self.view convertRect:self.displayViewOriginFrame toView:self.scrollView];
    self.displayView.frame = self.displayViewNewFrame;
    
    [UIView animateWithDuration:__animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.maskView.alpha = 1;
        self.snapshotView.transform = CGAffineTransformMakeScale(snapshotScale, snapshotScale);
        self.displayView.frame = CGRectMake(CGRectGetMidX(self.displayView.superview.bounds) - self.displayViewWidth / 2, CGRectGetMidY(self.displayView.superview.bounds) - self.displayViewHeight / 2, self.displayViewWidth, self.displayViewHeight);
        
    } completion:^(BOOL finished) {
        if (self.targetController) {
            [self didMoveToParentViewController:self.targetController];
        }
        
    }];
}

-(void)displayView:(UIView *)view inViewController:(UIViewController *)controller position:(ZADisplayViewPosition)position
{
    if (!view) {
        return;
    }
    
    self.displayView = view;
    self.targetController = controller;
    
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.snapshotView];
    [self.view addSubview:self.maskView];
    
    //蒙板
    self.maskView.backgroundColor = (self.maskType == ZADisplayMaskTypeLight ? kMaskColorLight : kMaskColorDark);
    
    //快照
    UIImage *snapshot = [self createSnapshotFromController:self.targetController];
    
    //模糊
    if (self.blur) {
        snapshot = [self blurFromImage:snapshot blurValue:__blurValue];
    }
    
    self.snapshotView.image = snapshot;
    
    //是否缩小快照图片
    CGFloat snapshotScale = 1.0;
    //保存状态栏样式
    UIStatusBarStyle statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.statusBarStyle = statusBarStyle;
    if (self.shrink) {
        snapshotScale = __snapshotScale;
        statusBarStyle = UIStatusBarStyleLightContent; //当缩小快照时，设置状态栏为白色
    }
    
    [self.view addSubview:self.displayView];
    
    [self updatePosition:position];
    
    self.maskView.alpha = 0;
//    self.displayView.alpha = 0;
    //快照 蒙板动画
    [UIView animateWithDuration:__animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [UIApplication sharedApplication].statusBarStyle = statusBarStyle;
        self.displayView.alpha = 1;
        self.maskView.alpha = 1;
        self.snapshotView.transform = CGAffineTransformMakeScale(snapshotScale, snapshotScale);
    } completion:^(BOOL finished) {
        if (self.targetController) {
            [self didMoveToParentViewController:self.targetController];
        }
        
    }];
}

#pragma mark ------------------------------------------------- 事件处理 -------------------------------------------------

-(void)didTapMaskView
{
    self.tapCount = 0;
    
    if (self.tapBackground) {
        self.tapBackground();
    }
    //    [self dismissFromParentAnimated:YES duration:__animationDuration];//自己调用self释放不了
}

-(void)handleSingleTapDisplayView:(UITapGestureRecognizer *)recognizer
{
    self.tapCount++;
    switch (self.tapCount) {
        case 1://单击
            //delay时间后执行单击操作
            [self performSelector:@selector(didTapMaskView) withObject:nil afterDelay:0.2];
            break;
        case 2://双击
            //取消之前的单击操作
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTapMaskView) object:nil];
            [self handleDoubleTapDisplayView:recognizer];
        default:
            break;
    }
    if (self.tapCount > 2) {
        self.tapCount = 0;
    }
    //    [self didTapMaskView];
}

-(void)handleDoubleTapDisplayView:(UITapGestureRecognizer *)recognizer
{
    self.tapCount = 0;
    
    self.isScaled = !self.isScaled;
    
    if (self.isScaled) {
        CGPoint point = [recognizer locationInView:self.displayView];
        
        [self zoomToPoint:point withScale:__maxZoomScale animated:YES];
        
    }else{
        
        [self.scrollView setZoomScale:__minZoomScale animated:YES];
    }
    
}
//放大某个点
-(void)zoomToPoint:(CGPoint)zoomPoint withScale:(CGFloat)scale animated:(BOOL)animated
{
    scale = MIN(scale, self.scrollView.maximumZoomScale);
    scale = MAX(scale, self.scrollView.minimumZoomScale);
    
    CGPoint translatedZoomPoint = CGPointZero;
    translatedZoomPoint.x = zoomPoint.x + self.scrollView.contentOffset.x;
    translatedZoomPoint.y = zoomPoint.y + self.scrollView.contentOffset.y;
    
    CGFloat zoomFactor = 1.0f / self.scrollView.zoomScale;
    
    translatedZoomPoint.x *= zoomFactor;
    translatedZoomPoint.y *= zoomFactor;
    
    CGRect destinationRect = CGRectZero;
    destinationRect.size.width = CGRectGetWidth(self.scrollView.frame) / scale;
    destinationRect.size.height = CGRectGetHeight(self.scrollView.frame) / scale;
    destinationRect.origin.x = translatedZoomPoint.x - (CGRectGetWidth(destinationRect) * 0.5f);
    destinationRect.origin.y = translatedZoomPoint.y - (CGRectGetHeight(destinationRect) * 0.5f);
    
    [self.scrollView zoomToRect:destinationRect animated:animated];
}

-(void)deviceOrientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (self.currentOrientation != orientation) {
        self.currentOrientation = orientation;
        [self rotateDisplayView:YES];
    }
}

#pragma mark ------------------------------------------------- 私有方法 -------------------------------------------------

-(UIImage *)blurFromImage:(UIImage *)image blurValue:(CGFloat)blurValue
{
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    //因为在模糊的时候，边缘会变成半透明的状态，所以理想状况是可以对原图像进行适当放大，选择使用CIAffineClamp在模糊之前对图像进行处理
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
    
    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
    
    //模糊滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:extendedImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blurValue] forKey:@"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    //ARC不会释放CGImageRef，需要手动释放
    CGImageRelease(cgImage);
    
    return returnImage;
}

-(UIImage *)snapshotFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }else{
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

-(void)cleanUp
{
    if (self.parentView) {
        [self.displayView removeFromSuperview];
        self.displayView.frame = self.displayViewOldFrame;
        [self.parentView addSubview:self.displayView];
        
        //添加之前的手势
        for (UIGestureRecognizer *gesture in self.oldGestures) {
            [self.displayView addGestureRecognizer:gesture];
        }
        
        //移除orientation change
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    if (self.targetController) {
        //从controller移除
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }else{
        //从keywindow移除
        [self.view removeFromSuperview];
    }
    
    [UIApplication sharedApplication].statusBarStyle = self.statusBarStyle;
    
}

-(void)updatePosition:(ZADisplayViewPosition)position
{
    self.backgroundView.frame = self.view.bounds;
    self.maskView.frame = self.view.bounds;
    self.snapshotView.frame = self.backgroundView.bounds;
    //display view 位置
    switch (position) {
        case ZADisplayViewPositionCenter:
            self.displayView.center = self.view.center;
            break;
        case ZADisplayViewPositionTop:
            self.displayView.center = CGPointMake(self.view.center.x, CGRectGetMidY(self.displayView.bounds));
            break;
        case ZADisplayViewPositionBottom:
            self.displayView.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.view.bounds) - CGRectGetMidY(self.displayView.bounds));
            break;
        case ZADisplayViewPositionLeft:
            self.displayView.center = CGPointMake(CGRectGetMidX(self.displayView.bounds), self.view.center.y);
            break;
        case ZADisplayViewPositionRight:
            self.displayView.center = CGPointMake(CGRectGetMaxX(self.view.bounds) - CGRectGetMidX(self.displayView.bounds), self.view.center.y);
            break;
            
        default:
            self.displayView.center = self.view.center;
            break;
    }
}

-(UIImage *)createSnapshotFromController:(UIViewController *)controller
{
    UIImage *snapshot = nil;
    //如果controller为空，把self.view添加到keywindow
    if (controller) {
        snapshot = [self snapshotFromView:self.targetController.view];
        [self.targetController addChildViewController:self];
        [self.targetController.view addSubview:self.view];
        
    }else{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        snapshot = [self snapshotFromView:keyWindow];
        [keyWindow addSubview:self.view];
    }
    
    return snapshot;
}

-(void)addGesturesToDisplayView
{
    self.displayView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapDisplayView:)];
    singleTap.numberOfTapsRequired = 1;
    
    [self.displayView addGestureRecognizer:singleTap];
    
    //延时很大
    //    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapDisplayView:)];
    //    doubleTap.numberOfTapsRequired = 2;
    //
    //    [self.displayView addGestureRecognizer:doubleTap];
    //
    //    [singleTap requireGestureRecognizerToFail:doubleTap];
}

-(NSArray *)removeGesturesForDisplayView
{
    NSArray *arr = [self.displayView gestureRecognizers];
    for (UIGestureRecognizer *gesture in self.oldGestures) {
        [self.displayView removeGestureRecognizer:gesture];
    }
    
    return arr;
}

-(void)rotateDisplayView:(BOOL)animated
{
    if (![self setScrollViewBounds]) {
        return;
    }
    
    CGAffineTransform baseTransform = [self transformForOrientation:self.currentOrientation];
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    self.isScaled = NO;
    [self.scrollView setZoomScale:__minZoomScale animated:NO];
    
    [self calculateDisplayViewSize];
    
    self.scrollView.contentSize = CGSizeMake(self.displayViewWidth, self.displayViewHeight);
    
    self.displayView.frame = CGRectMake(CGRectGetMidX(self.displayView.superview.bounds) - self.displayViewWidth / 2, CGRectGetMidY(self.displayView.superview.bounds) - self.displayViewHeight / 2, self.displayViewWidth, self.displayViewHeight);
    
    
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            self.scrollView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, baseTransform);
            
        } completion:^(BOOL finished) {
            self.displayViewNewFrame = [self.view convertRect:self.displayViewOriginFrame toView:self.scrollView];
        }];
    }else{
        self.scrollView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, baseTransform);
        self.displayViewNewFrame = [self.view convertRect:self.displayViewOriginFrame toView:self.scrollView];
    }
    
}

-(BOOL)setScrollViewBounds
{
    if (UIDeviceOrientationIsPortrait(self.currentOrientation)) {
        self.scrollView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.superview.bounds), CGRectGetHeight(self.scrollView.superview.bounds));
    }else if (UIDeviceOrientationIsLandscape(self.currentOrientation)){
        self.scrollView.bounds = CGRectMake(0, 0, CGRectGetHeight(self.scrollView.superview.bounds), CGRectGetWidth(self.scrollView.superview.bounds));
    }else{
        return NO;
    }
    return YES;
}

-(void)calculateDisplayViewSize
{
    CGFloat scaleWidth = CGRectGetWidth(self.scrollView.bounds) / CGRectGetWidth(self.displayView.bounds);
    CGFloat scaleHeight = CGRectGetHeight(self.scrollView.bounds) / CGRectGetHeight(self.displayView.bounds);
    CGFloat scale = MIN(scaleWidth, scaleHeight);
    CGFloat width = scale * CGRectGetWidth(self.displayView.frame);
    CGFloat height = scale * CGRectGetHeight(self.displayView.frame);
    self.displayViewWidth = width;
    self.displayViewHeight = height;
}

-(CGAffineTransform)transformForOrientation:(UIDeviceOrientation)orientation
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        transform = CGAffineTransformMakeRotation(M_PI);
    }else if (orientation == UIDeviceOrientationLandscapeLeft){
        transform = CGAffineTransformMakeRotation(M_PI_2);
    }else if (orientation == UIDeviceOrientationLandscapeRight){
        transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    return transform;
}

@end
