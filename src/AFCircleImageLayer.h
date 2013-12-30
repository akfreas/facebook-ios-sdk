#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
@interface AFCircleImageLayer : CALayer


@property (nonatomic, retain) UIImage *image;
@property (assign) CGFloat radius;
@property (assign) CGRect frame;
@property (assign) CGFloat borderWidth;
@property (assign) CGColorRef borderColor;


-(id)initWithRadius:(CGFloat)theRadius;
-(id)initWithImage:(UIImage *)theImage radius:(CGFloat)theRadius;

@end
