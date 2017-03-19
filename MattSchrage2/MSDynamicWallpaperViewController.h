//
//  MSDynamicWallpaperViewController.h
//  MattSchrage2
//
//  Created by Matt Schrage on 4/23/15.
//  Copyright (c) 2015 Matt Schrage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

typedef NS_ENUM(NSUInteger, MSDynamicWallpaperLayer){
    MSDynamicWallpaperLayerTop,
    MSDynamicWallpaperLayerMiddle,
    MSDynamicWallpaperLayerBottom,
};


@interface MSDynamicWallpaperViewController : UIViewController
@property (nonatomic, assign)CGFloat topDotRadius;
@property (nonatomic, assign)CGFloat middleDotRadius;
@property (nonatomic, assign)CGFloat bottomDotRadius;

- (UIColor *)colorForDot;
- (void)applyMotionVector:(CGPoint)vector;
@end
