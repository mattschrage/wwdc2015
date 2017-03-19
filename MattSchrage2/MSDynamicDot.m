//
//  MSDynamicDot.m
//  MattSchrage2
//
//  Created by Matt Schrage on 4/23/15.
//  Copyright (c) 2015 Matt Schrage. All rights reserved.
//

#import "MSDynamicDot.h"
#import <QuartzCore/QuartzCore.h>

@implementation MSDynamicDot

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = self.radius = CGRectGetHeight(frame)/2;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = self.color;
    }
    
    return self;
}

+ (MSDynamicDot *)dotWithRadius:(CGFloat)radius color:(UIColor*)color{
    MSDynamicDot *dot = [[MSDynamicDot alloc] initWithFrame:CGRectMake(0, 0, 2*radius, 2*radius)];
    dot.backgroundColor = color;
    dot.multipler = (arc4random() % 200)/100 + 0.25;
    dot.timestamp = [NSDate date];
    dot.maxInterval =  20 - (arc4random() % 20) + 30;
    return dot;
}

- (void)randomize{
    self.multipler = (arc4random() % 200)/100 + 0.25;
    self.timestamp = [NSDate date];
    self.maxInterval =  10 - (arc4random() % 10) + 30;

}


@end
