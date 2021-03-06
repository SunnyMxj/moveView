//
//  UIView+move.m
//  QFMoveView
//
//  Created by QianFan_Ryan on 16/8/23.
//  Copyright © 2016年 QianFan. All rights reserved.
//

#import "UIView+move.h"
#import <objc/runtime.h>

@interface UIView()

@property (nonatomic, strong)UIPanGestureRecognizer *panGesture;

@end

@implementation UIView (move)

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.moveDelegate respondsToSelector:@selector(view:beginToMove:)]) {
                [self.moveDelegate view:self beginToMove:gesture];
            }
            break;
        case UIGestureRecognizerStateChanged:
            if ([self.moveDelegate respondsToSelector:@selector(view:isMoving:)]) {
                [self.moveDelegate view:self isMoving:gesture];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if ([self.moveDelegate respondsToSelector:@selector(view:endMove:)]) {
                [self.moveDelegate view:self endMove:gesture];
            }
            break;
        default:
            break;
    }
}



- (id<UIViewMoveDelegate>)moveDelegate{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMoveDelegate:(id<UIViewMoveDelegate>)moveDelegate{
    if (!self.panGesture) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:panGesture];
        self.panGesture = panGesture;
    }
    objc_setAssociatedObject(self, @selector(moveDelegate), moveDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (UIPanGestureRecognizer *)panGesture{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPanGesture:(UIPanGestureRecognizer *)panGesture{
    objc_setAssociatedObject(self, @selector(panGesture), panGesture, OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)tagId{
    return  ((NSNumber *)objc_getAssociatedObject(self, _cmd)).unsignedIntegerValue;
}

- (void)setTagId:(NSUInteger)tagId{
    objc_setAssociatedObject(self, @selector(tagId), @(tagId), OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)originCenter{
    NSNumber *originCenterX = objc_getAssociatedObject(self, @"originCenterX");
    NSNumber *originCenterY = objc_getAssociatedObject(self, @"originCenterY");
    return CGPointMake(originCenterX.floatValue, originCenterY.floatValue);
}

- (void)setOriginCenter:(CGPoint)originCenter{
    objc_setAssociatedObject(self, @"originCenterX", [NSNumber numberWithFloat:originCenter.x], OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, @"originCenterY", [NSNumber numberWithFloat:originCenter.y], OBJC_ASSOCIATION_COPY);
}

@end
