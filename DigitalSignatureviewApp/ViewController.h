//
//  ViewController.h
//  DigitalSignatureviewApp
//
//  Created by Shenu Gupta on 14/09/13.
//  Copyright (c) 2013 Shenu Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
@interface ViewController : UIViewController<SocketIODelegate>{
    SocketIO *socketIO;
    id delegate;
    CGPoint point;
    UIImageView *image;
    BOOL mouseSwiped;
    int mouseMoved;
    
    NSMutableString *digitalSigText;
}

@property (strong, nonatomic)IBOutlet UIImageView *image;

@end
