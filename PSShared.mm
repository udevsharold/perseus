//    Copyright (c) 2021 udevs
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, version 3.
//
//    This program is distributed in the hope that it will be useful, but
//    WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//    General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program. If not, see <http://www.gnu.org/licenses/>.

#import "PSShared.h"
#import "PrivateHeaders.h"
#import "PSAndromeda.h"
#import <objc/runtime.h>

static NSXPCConnection* nacXPCConnection(){
	
	NSXPCConnection *nacConnection = [[NSXPCConnection alloc] initWithMachServiceName:@"com.apple.NanoAudioControl" options:NSXPCConnectionPrivileged];
	NSXPCInterface *interface = [NSXPCInterface interfaceWithProtocol:@protocol(NACXPCInterface)];
	//[interface setClasses:[NSSet setWithObjects:[NSArray class], [objc_getClass("NACAudioRouteBuffer") class], nil] forSelector:@selector(audioRoutesForCategory:result:) argumentIndex:0 ofReply:YES];
	nacConnection.remoteObjectInterface = interface;
	
	nacConnection.interruptionHandler = ^{
		HBLogDebug(@"NAC cnx terminated");
	};
	
	nacConnection.invalidationHandler = ^{
		HBLogDebug(@"NAC cnx invalidated");
	};
	
	
	[nacConnection resume];
	
	return nacConnection;
}

void pokeGizmo(PSPokeGizmoType type){
	
	//wake watch
	sendGeneralPerseusQueryWithReply(YES, ^(xpc_object_t reply){
	});
	
	NSXPCConnection *nacConnection = nacXPCConnection();
	[[nacConnection remoteObjectProxy] setHapticIntensity:1.0];
	
	switch (type) {
		case PSPokeGizmoTypeOnce:{
			//Dirty, but works
			[[nacConnection remoteObjectProxy] setHapticIntensity:1.0];
			[nacConnection invalidate];
			break;
		}
		case PSPokeGizmoTypeDouble:{
			//This one is buggy, sometimes it only send one haptic
			[[nacConnection remoteObjectProxy] setHapticIntensity:1.0];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[[nacConnection remoteObjectProxy] setHapticIntensity:1.0];
				[nacConnection invalidate];
			});
			break;
		}
			/*
			 case PSPokeGizmoTypeDefault:{
			 [[nacConnection remoteObjectProxy] setHapticState:1];
			 break;
			 }
			 case PSPokeGizmoTypeProminent:{
			 [[nacConnection remoteObjectProxy] setHapticState:2];
			 break;
			 }
			 */
		default:
			[nacConnection invalidate];
			break;
	}
	
}

NSString *username(uid_t uid){
	struct passwd *pw;
	pw = getpwuid(uid);
	return @(pw->pw_name);
}
