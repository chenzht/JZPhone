/* DialerViewController.h
 *
 * Copyright (C) 2009  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>

#import "DialerViewController.h"


@implementation DialerViewController

@synthesize transferMode;

@synthesize addressField;
@synthesize logoutButton;
@synthesize backButton;
@synthesize addCallButton;
@synthesize transferButton;
@synthesize callButton;
@synthesize eraseButton;

@synthesize oneButton;
@synthesize twoButton;
@synthesize threeButton;
@synthesize fourButton;
@synthesize fiveButton;
@synthesize sixButton;
@synthesize sevenButton;
@synthesize eightButton;
@synthesize nineButton;
@synthesize starButton;
@synthesize zeroButton;
@synthesize sharpButton;


#pragma mark - Lifecycle Functions

- (id)init {
    self = [super initWithNibName:@"DialerViewController" bundle:[NSBundle mainBundle]];
    if(self) {
        self->transferMode = FALSE;
    }
    return self;
}

- (void)dealloc {


    // Remove all observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if(compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:@"Dialer"
                                                                content:@"DialerViewController"
                                                               stateBar:@"UIStateBar"
                                                        stateBarEnabled:true
                                                                 tabBar:@"UIMainBar"
                                                          tabBarEnabled:true
                                                             fullscreen:false
                                                          landscapeMode:false
                                                           portraitMode:true];
        compositeDescription.darkBackground = true;
    }
    return compositeDescription;
}


#pragma mark - ViewController Functions

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    [callButton setEnabled:TRUE];

    [addressField setText:@""];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0 // attributed string only available since iOS6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        // fix placeholder bar color in iOS7
        UIColor *color = [UIColor grayColor];
        NSAttributedString* placeHolderString = [[NSAttributedString alloc]
                                                 initWithString:NSLocalizedString(@"请输入号码", @"请输入号码")
                                                 attributes:@{NSForegroundColorAttributeName: color}];
        addressField.attributedPlaceholder = placeHolderString;

    }
#endif
    

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];

	[zeroButton    setDigit:'0'];
	[oneButton     setDigit:'1'];
	[twoButton     setDigit:'2'];
	[threeButton   setDigit:'3'];
	[fourButton    setDigit:'4'];
	[fiveButton    setDigit:'5'];
	[sixButton     setDigit:'6'];
	[sevenButton   setDigit:'7'];
	[eightButton   setDigit:'8'];
	[nineButton    setDigit:'9'];
	[starButton    setDigit:'*'];
	[sharpButton   setDigit:'#'];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    [logoutButton setEnabled:YES];
    [addressField setAdjustsFontSizeToFitWidth:TRUE]; // Not put it in IB: issue with placeholder size
    
    // Set observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdateEvent:)
                                                 name:kUCSCallUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(coreUpdateEvent:)
                                                 name:kUCSCoreUpdate
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdateEvent:) name:kUCSRegistrationUpdate object:nil];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

}


#pragma mark - Event Functions

- (void)callUpdateEvent:(NSNotification*)notif {
//    LinphoneCall *call = [[notif.userInfo objectForKey: @"call"] pointerValue];
//    LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
//    [self callUpdate:call state:state];
}
//
- (void)coreUpdateEvent:(NSNotification*)notif {
//    if([LinphoneManager runningOnIpad]) {
//        LinphoneCore* lc = [LinphoneManager getLc];
//        if(linphone_core_video_enabled(lc) && linphone_core_video_preview_enabled(lc)) {
//            linphone_core_set_native_preview_window_id(lc, (unsigned long)videoPreview);
//            [backgroundView setHidden:FALSE];
//            [videoCameraSwitch setHidden:FALSE];
//        } else {
//            linphone_core_set_native_preview_window_id(lc, (unsigned long)NULL);
//            [backgroundView setHidden:TRUE];
//            [videoCameraSwitch setHidden:TRUE];
//        }
//    }
}




#pragma mark - UITextFieldDelegate Functions

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //[textField performSelector:@selector() withObject:nil afterDelay:0];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == addressField) {
        [addressField resignFirstResponder];
    }
    return YES;
}


#pragma mark - Action Functions
- (IBAction)goConfigClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goConfig" object:nil];
}

- (IBAction)onAddressChange: (id)sender {
    if([[addressField text] length] > 0) {
        [eraseButton setEnabled:TRUE];
        [addCallButton setEnabled:TRUE];
        [transferButton setEnabled:TRUE];
    } else {
        [eraseButton setEnabled:FALSE];
        [addCallButton setEnabled:FALSE];
        [transferButton setEnabled:FALSE];
    }
}


/**
 @author Jozo, 16-06-30 15:06:51
 
 登陆成功回调
 */
- (void)onRegisterStateChange:(UCSRegistrationState) state message:(const char*) message {
    
    switch (state) {
        case UCSRegistrationOk: {
            // 登陆成功
            self.stateLabel.textColor = [UIColor colorWithRed:0.1126 green:0.5388 blue:0.1944 alpha:1.0];
            self.stateLabel.text = @"· 登录成功";
            break;
        }
        case UCSRegistrationNone:
        case UCSRegistrationCleared: {
            self.stateLabel.textColor = [UIColor blackColor];
            self.stateLabel.text = @"· 未登录";
            break;
        }
        case UCSRegistrationFailed: {
            self.stateLabel.textColor = [UIColor colorWithRed:0.9843 green:0.2588 blue:0.2039 alpha:1.0];
            self.stateLabel.text = @"· 登录失败";
            break;
        }
        case UCSRegistrationProgress: {
            self.stateLabel.textColor = [UIColor colorWithRed:0.9765 green:0.4039 blue:0.0 alpha:1.0];
            self.stateLabel.text = @"· 登录中...";
            break;
        }
        default:break;
    }

}
//- (void)registrationUpdateEvent:(NSNotification*)notif {
//    
//    NSLog(@"%@", notif);
//    [self registrationUpdate:[[notif.userInfo objectForKey: @"state"] intValue]];
//}
//
//- (void)registrationUpdate:(UCSRegistrationState)state {
//    switch (state) {
//        case UCSRegistrationOk: {
//            // 登陆成功
//            self.stateLabel.textColor = [UIColor colorWithRed:0.1126 green:0.5388 blue:0.1944 alpha:1.0];
//            self.stateLabel.text = @"· 登录成功";
//            break;
//        }
//        case UCSRegistrationNone:
//        case UCSRegistrationCleared: {
//            self.stateLabel.textColor = [UIColor blackColor];
//            self.stateLabel.text = @"· 未登录";
//            break;
//        }
//        case UCSRegistrationFailed: {
//            self.stateLabel.textColor = [UIColor colorWithRed:0.9843 green:0.2588 blue:0.2039 alpha:1.0];
//            self.stateLabel.text = @"· 登录失败";
//            break;
//        }
//        case UCSRegistrationProgress: {
//            self.stateLabel.textColor = [UIColor colorWithRed:0.9765 green:0.4039 blue:0.0 alpha:1.0];
//            self.stateLabel.text = @"· 登录中...";
//            break;
//        }
//        default:break;
//    }
//}

@end
