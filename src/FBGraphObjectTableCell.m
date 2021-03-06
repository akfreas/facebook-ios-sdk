/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBGraphObjectTableCell.h"
#import "AFCircleImageView.h"
#import "NoBirthdaySwitchIndicatorPNG.h"
#import "HasBirthdaySwitchIndicatorPNG.h"

static const CGFloat titleFontHeight = 18;
static const CGFloat subtitleFontHeight = 12;
static const CGFloat pictureEdge = 50;
static const CGFloat pictureMargin = 5;
static const CGFloat horizontalMargin = 4;
static const CGFloat titleTopNoSubtitle = 11;
static const CGFloat titleTopWithSubtitle = 3;
static const CGFloat subtitleTop = 23;
static const CGFloat titleHeight = titleFontHeight * 1.25;
static const CGFloat subtitleHeight = subtitleFontHeight * 1.25;

@interface FBGraphObjectTableCell()

@property (nonatomic, retain) AFCircleImageView *pictureView;
@property (nonatomic, retain) UILabel* titleSuffixLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UISwitch *selectedSwitch;

- (void)updateFonts;

@end

@implementation FBGraphObjectTableCell

@synthesize pictureView = _pictureView;
@synthesize titleSuffixLabel = _titleSuffixLabel;
@synthesize activityIndicator = _activityIndicator;
@synthesize boldTitle = _boldTitle;
@synthesize boldTitleSuffix = _boldTitleSuffix;
@synthesize hasBirthday = _hasBirthday;
@synthesize indicateHasBirthday = _indicateHasBirthday;

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Picture
        AFCircleImageView *pictureView = [[AFCircleImageView alloc] initWithImage:nil radius:pictureEdge/2];
        pictureView.clipsToBounds = YES;
        pictureView.contentMode = UIViewContentModeScaleAspectFill;

        self.pictureView = pictureView;
        [self.contentView addSubview:pictureView];
        [pictureView release];

        // Subtitle
        self.detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.detailTextLabel.textColor = [UIColor colorWithRed:0.4 green:0.6 blue:0.8 alpha:1.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:subtitleFontHeight];

        // Title
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textLabel.font = [UIFont systemFontOfSize:titleFontHeight];

        // Content View
        self.contentView.clipsToBounds = YES;
    }

    return self;
}

- (void)dealloc
{
    [_titleSuffixLabel release];
    [_pictureView release];

    [super dealloc];
}

#pragma mark -

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)layoutSubviews
{
    [super layoutSubviews];

    [self updateFonts];

    BOOL hasPicture = (self.picture != nil);
    BOOL hasSubtitle = (self.subtitle != nil);
    BOOL hasTitleSuffix = (self.titleSuffix != nil);

    CGFloat pictureWidth = hasPicture ? pictureEdge : 0;
    CGSize cellSize = self.contentView.bounds.size;
    CGFloat textLeft = (hasPicture ? ((2 * pictureMargin) + pictureWidth) : 0) + horizontalMargin;
    CGFloat textWidth = cellSize.width - (textLeft + horizontalMargin);
    CGFloat titleTop = hasSubtitle ? titleTopWithSubtitle : self.contentView.frame.size.height / 2 - titleHeight / 2;
    
    CGFloat switchWidth = self.selectedSwitch.bounds.size.width;
    CGFloat switchHeight = self.selectedSwitch.bounds.size.height;
    CGFloat switchRightMargin = 5.0f;
    
    self.pictureView.frame = CGRectMake(pictureMargin, pictureMargin, pictureWidth, pictureEdge);
    self.detailTextLabel.frame = CGRectMake(textLeft, subtitleTop, textWidth, subtitleHeight);
    self.selectedSwitch.frame = CGRectMake(self.contentView.bounds.size.width - switchWidth - switchRightMargin, self.contentView.bounds.size.height/2 - switchHeight/2, switchWidth, switchHeight);
    self.selectedSwitch.on = self.selected;
    if (self.indicateHasBirthday) {
        if (self.hasBirthday) {
            self.selectedSwitch.thumbTintColor = [UIColor colorWithPatternImage:[HasBirthdaySwitchIndicatorPNG image]];
        } else {
            self.selectedSwitch.thumbTintColor =  [UIColor colorWithPatternImage:[NoBirthdaySwitchIndicatorPNG image]];
        }
    }
    if (!hasTitleSuffix) {
        self.textLabel.frame = CGRectMake(textLeft, titleTop, textWidth, titleHeight);
    } else {
        CGSize titleSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
        CGSize spaceSize = [@" " sizeWithFont:self.textLabel.font];
        CGFloat titleWidth = titleSize.width + spaceSize.width;
        self.textLabel.frame = CGRectMake(textLeft, titleTop, titleWidth, titleHeight);

        CGFloat titleSuffixLeft = textLeft + titleWidth;
        CGFloat titleSuffixWidth = textWidth - titleWidth;
        self.titleSuffixLabel.frame = CGRectMake(titleSuffixLeft, titleTop, titleSuffixWidth, titleHeight);
    }

    [self.pictureView setHidden:!(hasPicture)];
    [self.detailTextLabel setHidden:!(hasSubtitle)];
    [self.titleSuffixLabel setHidden:!(hasTitleSuffix)];
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

+ (CGFloat)rowHeight
{
    return pictureEdge + (2 * pictureMargin) + 1;
}

- (void)startAnimatingActivityIndicator {
    CGRect cellBounds = self.bounds;
    if (!self.activityIndicator) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.autoresizingMask =
        (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);

        self.activityIndicator = activityIndicator;
        [self addSubview:activityIndicator];
        [activityIndicator release];
    }

    self.activityIndicator.center = CGPointMake(CGRectGetMidX(cellBounds), CGRectGetMidY(cellBounds));

    [self.activityIndicator startAnimating];
}

- (void)stopAnimatingActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator stopAnimating];
    }
}

- (void)updateFonts {
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:titleFontHeight];
    self.titleSuffixLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:titleFontHeight];
    self.titleSuffixLabel.textColor = self.textLabel.textColor = [UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    [self.titleSuffixLabel sizeToFit];
    [self.textLabel sizeToFit];
}
- (void)createTitleSuffixLabel {
    if (!self.titleSuffixLabel) {
        UILabel *titleSuffixLabel = [[UILabel alloc] init];
        titleSuffixLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:titleSuffixLabel];

        self.titleSuffixLabel = titleSuffixLabel;
        [titleSuffixLabel release];
    }
}

-(void)addSelectedSwitch {
    UISwitch *selectedSwitch = [[UISwitch alloc] init];
    self.selectedSwitch = selectedSwitch;
    self.selectedSwitch.userInteractionEnabled = NO;
    [selectedSwitch release];
    [self.contentView addSubview:self.selectedSwitch];
}

#pragma mark - Properties

-(void)setSelected:(BOOL)selected {
    if (self.selectedSwitch == nil) {
        [self addSelectedSwitch];
    }
    if (self.selectedSwitch.isOn != selected) {
        self.selectedSwitch.on = selected;
    }
    [super setSelected:selected];
}

- (UIImage *)picture
{
    return self.pictureView.image;
}

- (void)setPicture:(UIImage *)picture
{
    self.pictureView.image = picture;
    [self setNeedsLayout];
}

- (NSString*)subtitle
{
    return self.detailTextLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.detailTextLabel.text = subtitle;
    [self setNeedsLayout];
}

- (NSString*)title
{
    return self.textLabel.text;
}

- (void)setTitle:(NSString *)title
{
    self.textLabel.text = title;
    [self setNeedsLayout];
}

- (NSString*)titleSuffix
{
    return self.titleSuffixLabel.text;
}

- (void)setTitleSuffix:(NSString *)titleSuffix
{
    if (titleSuffix) {
        [self createTitleSuffixLabel];
    }
    if (self.titleSuffixLabel) {
        self.titleSuffixLabel.text = titleSuffix;
    }
    [self setNeedsLayout];
}

@end
