//
//  DKPhotoViewController.h
//  photoLibrary
//
//  Created by kuzindmitry on 13.04.17.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DKPhotoViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic) NSUInteger limit;
@property (nonatomic) CGSize imageSize;
@property (nonatomic, retain) UILabel *cancelRequestLibraryLabel;
@property (nonatomic, retain) UIImage *imageCamera;


@end
