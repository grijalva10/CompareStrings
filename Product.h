//
//  Product.h
//  CompareStrings
//
//  Created by Jeff on 2/27/13.
//  Copyright (c) 2013 codeSlider. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *vendorCode;
@property (nonatomic, readwrite) NSInteger *price;

@end
