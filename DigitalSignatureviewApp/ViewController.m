//
//  ViewController.m
//  DigitalSignatureviewApp
//
//  Created by Shenu Gupta on 14/09/13.
//  Copyright (c) 2013 Shenu Gupta. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Concatenate_String.h"
#import "SocketIO.h"
#import "SocketIOJSONSerialization.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(socketIO)
        {
            socketIO.delegate = nil;
        }
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:4000];
        ;
    });
    mouseMoved = 0;
    NSString *outputstr=[[NSString alloc]init];
   outputstr =[outputstr concatenateString];
    
   
    
    NSLog(@"%@",outputstr);
    
    digitalSigText=[NSMutableString stringWithFormat:@""];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 2) {
        image.image = nil;
        return;
    }
    point = [touch locationInView:self.view];
    point.y -= 20;
    
    [digitalSigText appendFormat:@"%.2f,%.2f",point.x,point.y ];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:[NSString stringWithFormat:@"%f",point.x] forKey:@"x"];
    [temp setObject:[NSString stringWithFormat:@"%f",point.y] forKey:@"y"];
    [self sendUserAnsToserver:temp];
    //NSLog(@"digital text coordinates %@",digitalSigText);
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    currentPoint.y -= 20;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [image.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width,
                                       self.view.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    image.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    point = currentPoint;
    mouseMoved++;
    if (mouseMoved == 10) {
        mouseMoved = 0;
    }
    
    [digitalSigText appendFormat:@"%.2f,%.2f",point.x,point.y ];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:[NSString stringWithFormat:@"%f",point.x] forKey:@"x"];
    [temp setObject:[NSString stringWithFormat:@"%f",point.y] forKey:@"y"];
    [self sendUserAnsToserver:temp];
    //NSLog(@"digital text coordinates %@",digitalSigText);
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 2) {
        image.image = nil;
        return;
    }
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [image.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width,
                                           self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        image.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [digitalSigText appendFormat:@"%.2f,%.2f",point.x,point.y ];
    
    NSLog(@"digital text coordinates %@",digitalSigText);
}
- (void)sendUserAnsToserver: (NSMutableDictionary *)userAnsRequest
{
    NSError *error;
    
    NSString *jsonString = [SocketIOJSONSerialization JSONStringFromObject:userAnsRequest
                                                                     error:&error];
    
    //    [jsonString JSONRepresentation];
    
    NSLog(@"userAnsRequest jsonString %@", jsonString);
    
    [socketIO sendMessage:jsonString
          withAcknowledge:TRUE];
    
    //    [_userAnsArray removeObject:userAnsRequest];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
