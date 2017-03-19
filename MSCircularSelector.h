//
//  MSCircularSelector.h
//  MattSchrage
//
//  Created by Matt Schrage on 4/12/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSCircularSelector;
@protocol MSCircularSelectorDelegate <NSObject>
- (void)selectionDidBegin:(MSCircularSelector *)picker;
- (void)positionDidChange:(MSCircularSelector *)picker;
- (void)selectionDidEnd:(MSCircularSelector *)picker;

@end

@interface MSCircularSelector : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, assign)NSUInteger radius;
@property (nonatomic, assign)CGPoint initialCenter;
@property (nonatomic, assign)BOOL shouldResize;
@property (nonatomic, weak)id <MSCircularSelectorDelegate>delegate;

- (id)initWithRadius:(NSUInteger)radius andCenter:(CGPoint)initialCenter andImage:(UIImage *)image;

@end
