//
//  UIButton+CXDCategory.m
//  AgentApplication
//
//  Created by 陈雪丹 on 2017/4/13.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "UIButton+CXDCategory.h"
#import <objc/runtime.h>
#import "UIView+CXDAdd.h"

static void *indexPathKey = &indexPathKey;

@implementation UIButton (CXDCategory)

@dynamic cxd_hitTestEdgeInsets;

static const NSString *KEY_CXDIM_HIT_TEST_EDGE_INSETS = @"CXDIMHitTestEdgeInsets";
static NSTimeInterval const cxdim_default_interval = 0.6;

#pragma mark - 扩展点击区域
- (void)setCxd_hitTestEdgeInsets:(UIEdgeInsets)cxd_hitTestEdgeInsets {
    NSValue *value = [NSValue value:&cxd_hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_CXDIM_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)cxd_hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_CXDIM_HIT_TEST_EDGE_INSETS);
    if (value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.cxd_hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.cxd_hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

#pragma mark - 限制点击间隔
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("UIButton");
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(cxdim_customSendAction:to:forEvent:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)cxdim_customSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSStringFromClass([self class]) isEqualToString:@"UIButton"]) {
        self.cxd_timeInterval = (self.cxd_timeInterval == 0) ? cxdim_default_interval : self.cxd_timeInterval;
        if (self.cxd_isIgnoreEvent) {
            return;
        }else if (self.cxd_timeInterval > 0) {
            [self performSelector:@selector(cxdim_resetState) withObject:nil afterDelay:self.cxd_timeInterval];
        }
    }
    self.cxd_isIgnoreEvent = YES;
    [self cxdim_customSendAction:action to:target forEvent:event];
}

- (void)setCxd_timeInterval:(NSTimeInterval)cxd_timeInterval {
    return objc_setAssociatedObject(self, @selector(cxd_timeInterval), @(cxd_timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)cxd_timeInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setCxd_isIgnoreEvent:(BOOL)cxd_isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(cxd_isIgnoreEvent), @(cxd_isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)cxd_isIgnoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)cxdim_resetState {
    [self setCxd_isIgnoreEvent:NO];
}


- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, indexPathKey);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, indexPathKey, indexPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setLeftSideRadius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, self.height) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.width, self.height);
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [self.layer setMasksToBounds:YES];
}
- (void)setRightSideRadius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, self.height) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.width, self.height);
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [self.layer setMasksToBounds:YES];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
