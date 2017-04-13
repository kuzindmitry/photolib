//
//  DKPhotoCell.m
//  photoLibrary
//
//  Created by kuzindmitry on 13.04.17.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import "DKPhotoCell.h"

@interface DKPhotoCell ()
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *selectionLabel;
@end

@implementation DKPhotoCell

-(void)setPhoto:(UIImage *)photo {
    _photo = photo;
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    self.imageView.image = photo;
}

-(void)setNumber:(NSUInteger)number {
    _number = number;
    if (!self.selectionLabel) {
        self.selectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 30, self.bounds.size.height - 30, 20, 20)];
        self.selectionLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:230.0/255.0 alpha:1.0];
        self.selectionLabel.layer.cornerRadius = 10;
        self.selectionLabel.clipsToBounds = YES;
        self.selectionLabel.textAlignment = NSTextAlignmentCenter;
        self.selectionLabel.textColor = [UIColor whiteColor];
        self.selectionLabel.font = [UIFont systemFontOfSize:14];
        self.selectionLabel.hidden = YES;
        [self.contentView addSubview:self.selectionLabel];
    }
    if (number == 0) {
        self.selectionLabel.hidden = YES;
        self.selectionLabel.text = @"";
        self.photoSelected = NO;
    } else {
        self.selectionLabel.hidden = NO;
        self.selectionLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
        self.photoSelected = YES;
    }
}

@end
