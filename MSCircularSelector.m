//
//  MSCircularSelector.m
//  MattSchrage
//
//  Created by Matt Schrage on 4/12/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import "MSCircularSelector.h"

@implementation MSCircularSelector

- (id)initWithRadius:(NSUInteger)radius andCenter:(CGPoint)initialCenter andImage:(UIImage *)image{
    self = [super init];
    if(self){
        self.initialCenter = initialCenter;
        self.radius = radius;
        self.shouldResize = YES;
        self.frame = CGRectMake(initialCenter.x - radius, initialCenter.y - radius, 2*radius, 2*radius);
        
        self.image = image;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame),  CGRectGetHeight(self.frame));
        imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview: imageView];
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = radius;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        
        UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
        pressGesture.minimumPressDuration = 0;
        pressGesture.delegate = self;
        [self addGestureRecognizer:pressGesture];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
        
    }
    return self;
}

- (void)press:(UILongPressGestureRecognizer *)recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [self.delegate selectionDidBegin:self];
           [UIView animateWithDuration:0.25 animations:^{
               [self setTransform:CGAffineTransformMakeScale (1.5, 1.5)];
            }];
            self.layer.shadowOpacity = 0.5;
            self.layer.shadowOffset = CGSizeMake(0, 4);
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self.delegate selectionDidEnd:self];
            
            self.layer.shadowOpacity = 0;
            self.layer.shadowOffset = CGSizeMake(0, 0);
            
            if(self.shouldResize){
                [UIView animateWithDuration:0.25 animations:^{
                    [self setTransform:CGAffineTransformMakeScale (1, 1)];
                }];
            }
            break;
        }
    
        default:
            break;
    }

}

- (void)pan:(UIPanGestureRecognizer *)recognizer{
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:{
            self.center = [recognizer locationInView:self.superview];
            [self.delegate positionDidChange:self];
            break;
        }
        default:
            break;
    }

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
