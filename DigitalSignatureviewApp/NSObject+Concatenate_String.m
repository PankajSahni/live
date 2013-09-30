//
//  NSObject+Concatenate_String.m
//  DigitalSignatureviewApp
//
//  Created by Shenu Gupta on 15/09/13.
//  Copyright (c) 2013 Shenu Gupta. All rights reserved.
//

#import "NSObject+Concatenate_String.h"

@implementation NSString (Concatenate_String)

-(NSString*)concatenateString{
    
    NSString *concatenateStr=[self stringByAppendingFormat: @"Hello I am perfect"];
    
    return concatenateStr;
}

@end
