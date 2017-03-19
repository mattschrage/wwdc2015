//
//  MSDynamicDot.h
//  MattSchrage2
//
//  Created by Matt Schrage on 4/23/15.
//  Copyright (c) 2015 Matt Schrage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSDynamicDot : UIView
@property (nonatomic, assign)CGFloat radius;
@property (nonatomic, assign)CGFloat multipler;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)NSDate *timestamp;
@property (nonatomic, assign)NSTimeInterval maxInterval;
@property (nonatomic, assign)BOOL isAnimating;


+ (MSDynamicDot *)dotWithRadius:(CGFloat)radius color:(UIColor*)color;
- (void)randomize;
@end
