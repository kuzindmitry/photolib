//
//  ViewController.m
//  photoLibrary
//
//  Created by kuzindmitry on 13.04.17.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    DKPhotos *photos = [[DKPhotos alloc] init];
    photos.limit = 50;
    photos.imageSize = CGSizeMake(150, 150);
    photos.imageCamera = [UIImage imageNamed:@"camera"];
    photos.titleBar = @"Фото";
    photos.navigationBar.barStyle = UIBarStyleBlack;
    photos.navigationBar.translucent = NO;
    photos.navigationBar.tintColor = [UIColor whiteColor];
    photos.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:112.0/255.0 blue:160.0/255.0 alpha:1.0];
    [self presentViewController:photos animated:YES completion:nil];
}


@end
