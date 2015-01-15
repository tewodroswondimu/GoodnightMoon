//
//  ImageCollectionViewCell.h
//  GoodnightMoon
//
//  Created by Tewodros Wondimu on 1/15/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
//  The purpose of this custom UICollectionViewCells is that
//  this cell has an image view inside of it
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
