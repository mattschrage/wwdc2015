//
//  MSDynamicWallpaperViewController.m
//  MattSchrage2
//
//  Created by Matt Schrage on 4/23/15.
//  Copyright (c) 2015 Matt Schrage. All rights reserved.
//

#import "MSDynamicWallpaperViewController.h"
#import "MSDynamicDot.h"

@interface MSDynamicWallpaperViewController (){
    NSArray *top;
    NSArray *middle;
    NSArray *bottom;
    
    UIVisualEffectView *primaryBlur;
    UIVisualEffectView *secondaryBlur;
}


@end

@implementation MSDynamicWallpaperViewController 

- (void)viewDidLoad{
    [super viewDidLoad];

    self.topDotRadius = 70;
    self.middleDotRadius = 50;
    self.bottomDotRadius = 30;
    
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    secondaryBlur = [[UIVisualEffectView alloc] initWithEffect:effect];
    secondaryBlur.frame = self.view.bounds;
    secondaryBlur.alpha = 0.9;

    [self.view addSubview:secondaryBlur];
    
    primaryBlur = [[UIVisualEffectView alloc] initWithEffect:effect];
    primaryBlur.frame = self.view.bounds;
    primaryBlur.alpha = 0.5;
    [self.view addSubview:primaryBlur];
    

    [self addDotsToWallpaperLayer:MSDynamicWallpaperLayerTop];
    [self addDotsToWallpaperLayer:MSDynamicWallpaperLayerMiddle];
    [self addDotsToWallpaperLayer:MSDynamicWallpaperLayerBottom];

    CMMotionManager* motionManager = [[CMMotionManager alloc] init];
    [motionManager startAccelerometerUpdates];
    
//    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//        NSLog(@"hi");
//        [self applyMotionVector:CGPointMake(accelerometerData.acceleration.x, accelerometerData.acceleration.y)];
//    }];
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        
        float x = motionManager.accelerometerData.acceleration.x;
        float y = motionManager.accelerometerData.acceleration.y;
        
        NSLog(@"X: %f, Y: %f", x, y);
        [self applyMotionVector:CGPointMake(accelerometerData.acceleration.x, -1*accelerometerData.acceleration.y - 0.7)];

    }];
}


- (void)addDotsToWallpaperLayer:(MSDynamicWallpaperLayer)layer{
    switch (layer) {
        case MSDynamicWallpaperLayerTop:{
            if (!top) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < 3; i++) {
                    MSDynamicDot *dot = [MSDynamicDot dotWithRadius:self.topDotRadius
                                                              color:[self colorForDot]];
                    dot.alpha = 0;
                    dot.center = [self randomCenterPoint];
                    [self.view addSubview:dot];
                    [self animateOpacityOfDot:dot toOpacity:0.6];
                    [array addObject:dot];
                }
                
                top = array;
            }
            break;
        }
        case MSDynamicWallpaperLayerMiddle:{
            if (!middle) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < 3; i++) {
                    MSDynamicDot *dot = [MSDynamicDot dotWithRadius:self.middleDotRadius
                                                              color:[self colorForDot]];
                    dot.alpha = 0;
                    dot.center = [self randomCenterPoint];
                    [self.view insertSubview:dot belowSubview:primaryBlur];
                    [self animateOpacityOfDot:dot toOpacity:0.6];

                    [array addObject:dot];
                }
                
                middle = array;
            }
            break;
        }
            
        case MSDynamicWallpaperLayerBottom:{
            if (!bottom) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < 8; i++) {
                    MSDynamicDot *dot = [MSDynamicDot dotWithRadius:self.bottomDotRadius
                                                              color:[self colorForDot]];
                    dot.alpha = 0;
                    dot.center = [self randomCenterPoint];
                    [self.view insertSubview:dot belowSubview:secondaryBlur];
                    [self animateOpacityOfDot:dot toOpacity:1];
                    [array addObject:dot];
                }
                
                bottom = array;
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - Motion

- (void)applyMotionVector:(CGPoint)vector{
    [self applyMotionVector:vector toWallpaperLayer:MSDynamicWallpaperLayerTop withDampening:1];
    [self applyMotionVector:vector toWallpaperLayer:MSDynamicWallpaperLayerMiddle withDampening:0.5];
    [self applyMotionVector:vector toWallpaperLayer:MSDynamicWallpaperLayerBottom withDampening:0.25];

}

- (void)applyMotionVector:(CGPoint)vector
         toWallpaperLayer:(MSDynamicWallpaperLayer)layer
            withDampening:(CGFloat)dampening
{
    NSArray *dots;
    
    switch (layer) {
        case MSDynamicWallpaperLayerTop:
            dots = top;
            break;
        case MSDynamicWallpaperLayerMiddle:
            dots = middle;
            break;
        case MSDynamicWallpaperLayerBottom:
            dots = bottom;
            break;
        default:
            break;
    }
    
    for (MSDynamicDot *dot in dots) {
        dot.center = CGPointMake(dot.center.x + vector.x*dampening*dot.multipler, dot.center.y + vector.y*dampening*dot.multipler);
        
        if (!CGRectIntersectsRect(self.view.frame, dot.frame)) {
            dot.alpha = 0;
            dot.center = [self randomCenterPoint];
            [self animateOpacityOfDot:dot toOpacity:(dot.radius == self.bottomDotRadius)?1:0.6];
            [dot randomize];

        } else if (!dot.isAnimating && abs([dot.timestamp timeIntervalSinceNow]) > dot.maxInterval){
            dot.isAnimating = YES;
            [UIView animateWithDuration:4 animations:^{
                dot.alpha = 0;
            } completion:^(BOOL finished) {
                dot.center = [self randomCenterPoint];
                [self animateOpacityOfDot:dot toOpacity:(dot.radius == self.bottomDotRadius)?1:0.6];
                [dot randomize];

            }];
        }
    }

}

#pragma mark - Utility

- (UIColor *)colorForDot{
    return [UIColor whiteColor];
}

- (CGPoint)randomCenterPoint{
    return CGPointMake(arc4random() % (int)CGRectGetWidth(self.view.bounds),
                       arc4random() % (int)CGRectGetHeight(self.view.bounds));
}

- (void)animateOpacityOfDot:(MSDynamicDot *)dot toOpacity:(CGFloat)opacity{
    dot.isAnimating = YES;

    [UIView animateWithDuration:2+(arc4random()%10)/10 animations:^{
        dot.alpha = opacity;
    } completion:^(BOOL finished) {
        dot.isAnimating = NO;
    }];
}

@end
