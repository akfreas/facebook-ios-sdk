#import "AFCircleImageView.h"
#import "AFCircleImageLayer.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation AFCircleImageView {
    
    AFCircleImageLayer *circleLayer;
}


+(Class)layerClass {
    return [AFCircleImageLayer class];
}

-(id)initWithImage:(UIImage *)theImage radius:(CGFloat)theRadius {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.radius = theRadius;
        self.backgroundColor = [UIColor clearColor];
        self.contentScaleFactor = [UIScreen mainScreen].scale;
        [(AFCircleImageLayer *)self.layer setRadius:theRadius];
        [(AFCircleImageLayer *)self.layer setImage:theImage];
        [(AFCircleImageLayer *)self.layer setBorderWidth:1.0f];
    }
    return self;
}

-(void)setImage:(UIImage *)image {
    [(AFCircleImageLayer *)self.layer setImage:image];
}

-(UIImage *)image {
    return [(AFCircleImageLayer *)self.layer valueForKey:@"image"];
}

-(void)setRadius:(CGFloat)radius {
    _radius = radius;
    [(AFCircleImageLayer *)self.layer setRadius:radius];
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    [(AFCircleImageLayer *)self.layer setBorderWidth:borderWidth];
}

-(void)setBorderColor:(UIColor *)borderColor {
    [(AFCircleImageLayer *)self.layer setBorderColor:borderColor.CGColor];
}

-(void)layoutSubviews {
    self.layer.frame = self.frame;
    [super layoutSubviews];
}

-(void)setFrame:(CGRect)frame {
    self.layer.frame = frame;
    [super setFrame:frame];
}

-(CGSize)intrinsicContentSize {
    CGSize contentSize = CGSizeMake(_radius * 2, _radius * 2);
    return contentSize;
}

@end
