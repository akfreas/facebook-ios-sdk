#import <UIKit/UIKit.h>

@interface AFCircleImageView : UIView

@property (nonatomic, retain) UIImage *image;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) UIColor *borderColor;

-(id)initWithImage:(UIImage *)theImage radius:(CGFloat)theRadius;


@end
