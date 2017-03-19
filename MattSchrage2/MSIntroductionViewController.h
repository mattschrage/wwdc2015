//
//  MSIntroductionViewController.h
//  MattSchrage2
//
//  Created by Matt Schrage on 4/24/15.
//  Copyright (c) 2015 Matt Schrage. All rights reserved.
//

#import "MSDynamicWallpaperViewController.h"
#import "MSCircularSelector.h"

typedef NS_ENUM(NSUInteger, MSIntroductionSection) {
    MSIntroductionSectionName,
    MSIntroductionSectionAboutMe,
    MSIntroductionSectionEducation,
    MSIntroductionSectionApps,
    MSIntroductionSectionProjects,
    MSIntroductionSectionWork,
};

@interface MSIntroductionViewController : MSDynamicWallpaperViewController
@property (nonatomic, strong)MSCircularSelector *picker;
@property (nonatomic, assign)NSUInteger sections;
@property (nonatomic, assign)MSIntroductionSection currentSection;

@end
