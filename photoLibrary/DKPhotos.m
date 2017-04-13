//
//  DKPhotos.m
//  photoLibrary
//
//  Created by kuzindmitry on 13.04.17.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import "DKPhotos.h"
#import "DKPhotoViewController.h"

@interface DKPhotos ()
@property (nonatomic, retain) DKPhotoViewController *viewController;
@end

@implementation DKPhotos

-(instancetype)init {
    if (self = [super init]) {
        self.viewController = [[DKPhotoViewController alloc] init];
        [self setViewControllers:@[self.viewController]];
    }
    return self;
}

-(void)setLimit:(NSUInteger)limit {
    _viewController.limit = limit;
}

-(void)setImageSize:(CGSize)imageSize {
    _viewController.imageSize = imageSize;
}

-(void)setImageCamera:(UIImage *)imageCamera {
    _viewController.imageCamera = imageCamera;
}

-(void)setTitleBar:(NSString *)titleBar {
    _viewController.title = titleBar;
}

@end
