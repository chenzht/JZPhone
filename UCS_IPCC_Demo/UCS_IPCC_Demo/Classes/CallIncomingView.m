/* IncomingCallViewController.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
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

#import "CallIncomingView.h"

static NSTimer *timer;

@implementation CallIncomingView

#pragma mark - ViewController Functions

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        timer = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callReleasedEvent) name:@"UCS_Call_Released" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStateUpdateEvent:) name:kUCSCallUpdate object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [self cancelTimer];
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
}

- (void)viewDidLoad {
    self.speakButton.hidden = YES;
    
    NSString *remoteAddress = [[UCSIPCCManager instance] getRemoteAddress];
    NSString *remoteDisplayName = [[UCSIPCCManager instance] getRemoteDisplayName];
    self.addressLabel.text = remoteDisplayName.length == 0 ? remoteAddress : remoteDisplayName;
    
        
}

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
	if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:@"CallIncoming"
                                                                content:@"CallIncomingView"
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

- (UICompositeViewDescription *)compositeViewDescription {
	return self.class.compositeViewDescription;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

}

#pragma mark - Event Functions

- (void)callStateUpdateEvent:(NSNotification *)notif {
    UCSCall *acall = [[notif.userInfo objectForKey:@"call"] pointerValue];
	UCSCallState astate = [[notif.userInfo objectForKey:@"state"] intValue];
	[self callUpdate:acall state:astate];
}

- (void)callUpdate:(UCSCall *)acall state:(UCSCallState)astate {
	if (_call == acall && (astate == UCSCallEnd || astate == UCSCallError)) {
		[_delegate incomingCallAborted:_call];
        [self onDeclineClick:nil];
	} else if (_call == acall && astate == UCSCallConnected){
        // 点击了接听且连接, 改变UI
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
//                                         target:self
//                                       selector:@selector(callDurationUpdate)
//                                       userInfo:nil
//                                        repeats:YES];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(callDurationUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
        
        self.speakButton.hidden = NO;
        self.acceptButton.hidden = YES;
	}
}

#pragma mark -

- (void)update {
//	const LinphoneAddress *addr = linphone_call_get_remote_address(_call);
//	[ContactDisplay setDisplayNameLabel:_nameLabel forAddress:addr];
//	char *uri = linphone_address_as_string_uri_only(addr);
//	_addressLabel.text = [NSString stringWithUTF8String:uri];
//	ms_free(uri);
//	[_avatarImage setImage:[FastAddressBook imageForAddress:addr thumbnail:NO] bordered:YES withRoundedRadius:YES];
//
//	_tabBar.hidden = linphone_call_params_video_enabled(linphone_call_get_remote_params(_call));
//	_tabVideoBar.hidden = !_tabBar.hidden;
}

#pragma mark - Property Functions

//- (void)setCall:(id)call {
//	_call = call;
//	[self update];
//}

#pragma mark - Action Functions

- (IBAction)onAcceptClick:(id)event {
	[[UCSIPCCManager instance] acceptCall:_call];
}

- (IBAction)onDeclineClick:(id)event {
    [self callReleasedEvent];
	[[UCSIPCCManager instance] hangUpCall];
    
}

- (IBAction)onSpeakClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[UCSIPCCManager instance] setSpeakerEnabled:sender.selected];
}

- (void)callReleasedEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)callDurationUpdate {
    
    int duration = [[UCSIPCCManager instance] getCallDuration];
    if (duration != 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@", [UCSIPCCManager durationToString:duration]];
    }
}

- (void)cancelTimer {
    
    [timer invalidate];
    timer = nil;
    
}
@end
