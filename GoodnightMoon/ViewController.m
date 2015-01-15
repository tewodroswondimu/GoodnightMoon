//
//  ViewController.m
//  GoodnightMoon
//
//  Created by Tewodros Wondimu on 1/15/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSMutableArray *arrayOfMoonImages;
@property (weak, nonatomic) IBOutlet UIView *shadeView;

// Setup behaviors
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create an array of images
    UIImage *image1 = [UIImage imageNamed:@"moon_1"];
    UIImage *image2 = [UIImage imageNamed:@"moon_2"];
    UIImage *image3 = [UIImage imageNamed:@"moon_3"];
    UIImage *image4 = [UIImage imageNamed:@"moon_4"];
    UIImage *image5 = [UIImage imageNamed:@"moon_5"];
    UIImage *image6 = [UIImage imageNamed:@"moon_6"];
    self.arrayOfMoonImages = [NSMutableArray alloc];
    self.arrayOfMoonImages = [self.arrayOfMoonImages initWithObjects: image1, image2, image3, image4, image5, image6, nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Create a physical environment
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    // Create different behaviors and associate them to the view
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView] mode:UIPushBehaviorModeContinuous];

    // Collision behaviors is something that boundry that it can collide against
    [self.collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                            fromPoint:CGPointMake(0, self.view.frame.size.height)
                                              toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];


    [self.gravityBehavior setGravityDirection:CGVectorMake(0, 0)];  // no gravity when the view loads

    [self.dynamicItemBehavior setElasticity:0.25];   // for bouncing off the boundaries

    // Add all those behaviors to the dynamic animator
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.pushBehavior];
    [self.dynamicAnimator addBehavior:self.dynamicItemBehavior];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Created a custom cell which includes an image view
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moonCellID" forIndexPath:indexPath];

    // Change the image to the image in the array of images
    cell.imageView.image = [self.arrayOfMoonImages objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)gesture
{
    // The translations is the distance from the first point where the user drags
    CGPoint translation = [gesture translationInView:gesture.view];

    // Change the green view's location in y to it's current position plus the translation's y
    int changeToY = gesture.view.center.y + translation.y;
    gesture.view.center = CGPointMake(gesture.view.center.x, changeToY);

    // Reset the translation everytime you drag
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];

    CGFloat yVelocity = [gesture velocityInView:gesture.view].y;  // get the y velocity

    // Check to see how fast we're going and alter the reactions
    // Velocity is measured in pixel per seconds
    if (gesture.state == UIGestureRecognizerStateEnded) {

        [self.dynamicAnimator updateItemUsingCurrentState:self.shadeView];

        if (yVelocity < -500.0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            [self.dynamicItemBehavior setElasticity:0.5];
            [self.pushBehavior setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
        }
        else if (yVelocity >= -500.0 && yVelocity < 0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            [self.dynamicItemBehavior setElasticity:0.25];
            [self.pushBehavior setPushDirection:CGVectorMake(0, -500.0)];
        }
        else if (yVelocity >= 0 && yVelocity < 500.0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            [self.dynamicItemBehavior setElasticity:0.25];
            [self.pushBehavior setPushDirection:CGVectorMake(0, 500.0)];
        } else {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            [self.dynamicItemBehavior setElasticity:0.5];
            [self.pushBehavior setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
        }
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // returns the number of items inside the collection view
    return 6;
}

@end
