//
//  MSIntroductionViewController.m
//  MattSchrage2
//
//  Created by Matt Schrage on 4/24/15.
//  Copyright (c) 2015 Matt Schrage. All rights reserved.
//

#import "MSIntroductionViewController.h"
#import "MattSchrage2-Swift.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MSIntroductionViewController () <UIScrollViewDelegate>{
    UIToolbar *statusBarView;
    
    UIScrollView *contentScrollview;
    UIScrollView *backgroundScrollview;
}

@end

@implementation MSIntroductionViewController

#pragma mark - UIViewController -

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setNeedsStatusBarAppearanceUpdate];

    self.sections = 7;
    
    self.picker = [[MSCircularSelector alloc] initWithRadius:35.0f andCenter:CGPointMake(20+35, self.view.center.y) andImage:[UIImage imageNamed:@"matt.png"]];
    self.picker.userInteractionEnabled = NO;
    //self.picker.shouldResize = NO;
    //self.picker.delegate = self;
    //[self.view addSubview:self.picker];
    
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.picker addMotionEffect:group];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picker.frame)+10, 0, CGRectGetWidth(self.view.frame) - CGRectGetMaxX(self.picker.frame) - 20, 40)];
    title.center = CGPointMake(title.center.x, self.view.center.y);
    title.font = [UIFont fontWithName:@"Avenir-Heavy" size:33];
    title.text = @"Matt Schrage";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    
    UILabel *scrollDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 30, CGRectGetWidth(self.view.frame), 30)];
    scrollDownLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
    scrollDownLabel.text = @"Scroll down to see more ↓";
    scrollDownLabel.textAlignment = NSTextAlignmentCenter;
    scrollDownLabel.textColor = [UIColor whiteColor];
    
    contentScrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    contentScrollview.pagingEnabled = YES;
    contentScrollview.showsVerticalScrollIndicator = NO;
    contentScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * self.sections);
    contentScrollview.backgroundColor = [UIColor clearColor];
    contentScrollview.delegate = self;
    [contentScrollview addSubview:self.picker];
    [contentScrollview addSubview:scrollDownLabel];
    [contentScrollview addSubview:title];
    [self.view addSubview:contentScrollview];
    
    UIView *color1 = [[UIView alloc] initWithFrame:self.view.bounds];
    color1.backgroundColor = [UIColor redColor];

    
    backgroundScrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    backgroundScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * self.sections);
    [backgroundScrollview addSubview:color1];
//    [backgroundScrollview addSubview:color2];
    
    for (int i = 1; i < self.sections; i++) {
        
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)*i, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        
        MSInformationView *informationView = [[MSInformationView alloc] initWithFrame:frame];
        informationView.color = [self backgroundColorForSection:[self sectionForIndex:i]];
        informationView.text = [self textForSection:[self sectionForIndex:i]];
        UIView *backgroundView = informationView.backgroundView;
        backgroundView.frame = frame;
        [contentScrollview addSubview:informationView];
        [backgroundScrollview addSubview:backgroundView];
        
    }
    
    [self.view insertSubview:backgroundScrollview atIndex:0];


    self.currentSection = MSIntroductionSectionName;
    
    statusBarView = [[UIToolbar alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [statusBarView setBarStyle:UIBarStyleBlack];
    statusBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:statusBarView];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIColor *)colorForDot{
    return [self dotColorForSection:self.currentSection];
    //[UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1];
}

#pragma mark - UIScrollView Delegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:contentScrollview]) {
        backgroundScrollview.contentOffset = scrollView.contentOffset;
    }
    
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:self.view];
    
    [self applyMotionVector:CGPointMake(0, velocity.y*0.5)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:contentScrollview]) {
        NSUInteger index = (int)scrollView.contentOffset.y % (int)scrollView.frame.size.height;
        
        self.currentSection = [self sectionForIndex:index];
    }
}

- (MSIntroductionSection)sectionForIndex:(NSUInteger)index{

    switch (index) {
        case 1:
            return MSIntroductionSectionName;
            break;
        case 2:
            return MSIntroductionSectionAboutMe;
            break;
        case 3:
            return MSIntroductionSectionEducation;
            break;
        case 4:
            return MSIntroductionSectionApps;
            break;
        case 5:
            return MSIntroductionSectionProjects;
            break;
        case 6:
            return MSIntroductionSectionWork;
            break;

        default:
            break;
    }
    
    return MSIntroductionSectionName;
}

#pragma mark - Customize Colors For Sections -

- (UIColor *)backgroundColorForSection:(MSIntroductionSection)section{
    switch (section) {
        case MSIntroductionSectionName:
            return [UIColor redColor];
            break;
        case MSIntroductionSectionAboutMe:
            return [UIColor purpleColor];
            break;
        case MSIntroductionSectionEducation:
            return UIColorFromRGB(0x19B5FE);
            break;
        case MSIntroductionSectionApps:
            return [UIColor blackColor];
            break;
        case MSIntroductionSectionProjects:
            return [UIColor orangeColor];
            break;
        case MSIntroductionSectionWork:
            return [UIColor blueColor];
            break;
            
        default:
            return [UIColor redColor];
            break;
    }
}

- (UIColor *)dotColorForSection:(MSIntroductionSection)section{
    
    return [UIColor whiteColor];
}

- (NSString *)textForSection:(MSIntroductionSection)section{
    switch (section) {
        case MSIntroductionSectionName:
            return @"Hello! My name is Matt Schrage and I am a 17 year old iOS developer. I live in San Francisco. I enjoying playing soccer\n\nI have been programming since I was in 6th grade when I took and HTML and Webdesign class offered by my middle school.\n\niOS has been my creative outlet. I love being able to have a real impact and to help solve problems for those around me.";
            break;
        case MSIntroductionSectionAboutMe:
            return @"I am a finalist for the Thiel Fellowship and hope to take a gap year to perhaps start a company before I go to college. Furthermore, I will be attending Harvard University next year. If I hadn't learned to program there is no way that I would have been able to accomplish as much as I have.";
            break;
        case MSIntroductionSectionEducation:
            return @"I go to San Francisco University High School. I am a currently a Senior.  In high school, I have taken numerous independent studies in topics ranging from Journalism to Robotics.\nLast year I was the T.A. for the AP Computer Science class and had the opportunity to help teach students to program for the first time.";
            break;
        case MSIntroductionSectionApps:
            return @"I've developed a number of iOS application that together have been downloaded over 250,000 times! From Aura, a minimalistic weather app, to Inkwell, a gesture based text editor, with every app I've developed I've learned more about programming.";
            break;
        case MSIntroductionSectionProjects:
            return @"Last year I built a mobile learning platform built on iOS that teaches basic web coding skills with an integrated code editor that can be used anytime and anywhere. The project, called TimeToCode, helped over 20,000 people learn to code and was recognized by Representative Nancy Pelosi in the US House App Challenge competition.";
            break;
        case MSIntroductionSectionWork:
            return @"I was a Software Engineer at a startup called Rockmelt last summer (June - July 2013). Yahoo bought the company, while I was there so the internship was cut a little short.😜\nLast summer, I was offered an internship at Pocket to help them with their iOS app. I was one of two iOS developers at Pocket and together we supported and app used by ~13 million!";
            break;
            
        default:
            return @"";
            break;
    }
}

@end
