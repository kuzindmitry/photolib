//
//  DKPhotos.h
//  photoLibrary
//
//  Created by kuzindmitry on 13.04.17.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKPhotos : UINavigationController
@property (nonatomic) NSUInteger limit;
@property (nonatomic) CGSize imageSize;
@property (nonatomic, retain) UIImage *imageCamera;
@property (nonatomic, retain) NSString *titleBar;
@end
