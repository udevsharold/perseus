//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "PSShared.h"
#import "PrivateHeaders.h"

static NSXPCConnection* nacXPCConnection(){
    
    NSXPCConnection *nacConnection = [[NSXPCConnection alloc] initWithMachServiceName:@"com.apple.NanoAudioControl" options:NSXPCConnectionPrivileged];
    NSXPCInterface *interface = [NSXPCInterface interfaceWithProtocol:@protocol(NACXPCInterface)];
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
    NSXPCConnection *nacConnection = nacXPCConnection();
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
