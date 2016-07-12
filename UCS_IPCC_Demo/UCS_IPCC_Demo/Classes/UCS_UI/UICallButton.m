/* UICallButton.m
 *
 * Copyright (C) 2011  Belledonne Comunications, Grenoble, France
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

#import "UICallButton.h"
//#import "LinphoneManager.h"

#import <CoreTelephony/CTCallCenter.h>

@implementation UICallButton

@synthesize addressField;


#pragma mark - Lifecycle Functions

- (void)initUICallButton {
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)init {
    self = [super init];
    if (self) {
		[self initUICallButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self initUICallButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
		[self initUICallButton];
	}
    return self;
}	

- (void)dealloc {
//	[addressField release];
//    
//    [super dealloc];
}


#pragma mark -

- (void)touchUp:(id) sender {
    
    if (![[UCSIPCCManager instance] isUCSReady]) {
        return;
    }
    
    NSString *address = [addressField text];
    
    // 获取昵称
    NSString *displayName = nil;

    if( [address length] == 0){
        addressField.text = [UCSUserDefaultManager GetLocalDataString:@"Last_Call_Address"];
        return;
    }

    if( [address length] > 0){
        [UCSUserDefaultManager SetLocalDataString:address key:@"Last_Call_Address"];
        [[UCSIPCCManager instance] call:address displayName:displayName transfer:NO];
    }
}

@end
