//
//  DKPhotoCell.h
//  photoLibrary
//
//  Created by kuzindmitry on 13.04.17.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DKPhotoCell : UICollectionViewCell
@property (nonatomic, retain) UIImage *photo;
@property (nonatomic,retain) PHAsset *asset;
@property (nonatomic) NSUInteger number;
@property (nonatomic, getter=isPhotoSelected) BOOL photoSelected;
@end
