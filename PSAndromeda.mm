//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "PSAndromeda.h"
#import "Vexillarius.h"
#import "PrivateHeaders.h"
#include <stdio.h>

static xpc_object_t generalQueriesMessage(BOOL fastUnlock){
    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    
    xpc_dictionary_set_bool(message, kPerseusEvent, YES);
    
    xpc_object_t queries = xpc_array_create(NULL, 0);
    xpc_array_set_int64(queries, ((size_t)(-1)), PSQueryTypeWristState);
    xpc_array_set_int64(queries, ((size_t)(-1)), PSQueryTypeLockState);
    xpc_array_set_int64(queries, ((size_t)(-1)), PSQueryTypeNearby);
    xpc_array_set_int64(queries, ((size_t)(-1)), PSQueryTypeActive);
    xpc_array_set_int64(queries, ((size_t)(-1)), PSQueryTypeConnected);
    xpc_array_set_int64(queries, ((size_t)(-1)), (fastUnlock?PSQueryTypeRSSICache:PSQueryTypeRSSI));
    xpc_array_set_int64(queries, ((size_t)(-1)), PSQueryTypeGizmoName);

    xpc_dictionary_set_value(message, kPerseusQuery, queries);
    
    return message;
}

static const char* fullImagePathNamed(const char* name, const char* fileExt, int mode){
    static char str[128];
    snprintf(str, sizeof(str), "/Library/Application Support/Perseus.bundle/%s-%s.%s", name, (mode==0?"Light":"Dark"), fileExt);
    return str;
}

xpc_object_t vexillariusMessage(const char *title, const char *subTitle, const char *imageName, double timeout){
    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_double(message, VXKey.timeout, timeout?:2.0);
    xpc_dictionary_set_string(message, VXKey.title, title);
    xpc_dictionary_set_string(message, VXKey.subtitle, subTitle);

    if (@available(iOS 13.0, *)){
        if ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleLight){
            const char *imgPath = fullImagePathNamed(imageName, "png", 1);
            xpc_dictionary_set_string(message, VXKey.leadingImagePath, imgPath);
        }else{
            const char *imgPath = fullImagePathNamed(imageName, "png", 0);
            xpc_dictionary_set_string(message, VXKey.leadingImagePath, imgPath);
        }
    }
    return message;
}

static xpc_object_t invalidateRSSIMessage(){
    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    
    xpc_dictionary_set_bool(message, kPerseusEvent, YES);
    
    xpc_object_t queries = xpc_array_create(NULL, 0);
    xpc_array_set_bool(queries, ((size_t)(-1)), PSQueryTypeInvalidateRSSI);
    
    xpc_dictionary_set_value(message, kPerseusQuery, queries);
    
    return message;
}

static xpc_connection_t sdXPCConnection(){
    xpc_connection_t connection =
    xpc_connection_create_mach_service("com.apple.sharingd.nsxpc", NULL, 0);
    xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
    });
    xpc_connection_resume(connection);
    return connection;
}

void sendPerseusQueryWithReply(xpc_object_t message, xpc_handler_t handler){
    xpc_connection_t sdConnection = sdXPCConnection();
    if (sdConnection){
        
        xpc_connection_send_message_with_reply(sdConnection, message, dispatch_get_main_queue(), ^(xpc_object_t reply){
            if (handler){
                if (xpc_get_type(reply) == XPC_TYPE_DICTIONARY){
                    xpc_object_t result = xpc_dictionary_get_value(reply, "result");
                    handler(result);
                }else{
                    handler(xpc_dictionary_create(NULL, NULL, 0));
                }
            }
        });
    }
}

void sendGeneralPerseusQueryWithReply(BOOL fastUnlock, xpc_handler_t handler){
    sendPerseusQueryWithReply(generalQueriesMessage(fastUnlock), handler);
}

void sendInvalidateRSSIPerseusQueryWithReply(xpc_handler_t handler){
    sendPerseusQueryWithReply(invalidateRSSIMessage(), handler);
}

static xpc_connection_t vxXPCConnection(){
    xpc_connection_t connection =
    xpc_connection_create_mach_service("com.udevs.vexillarius", NULL, 0);
    xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
    });
    xpc_connection_resume(connection);
    return connection;
}

void sendVexillariusMesage(xpc_object_t message){
    xpc_connection_t vxConnection = vxXPCConnection();
    if (vxConnection){
        xpc_connection_send_message(vxConnection, message);
    }
}

static void replyWithObject(xpc_object_t replyObject, xpc_object_t event){
    xpc_connection_t remote = xpc_dictionary_get_remote_connection(event);
    xpc_object_t reply = xpc_dictionary_create_reply(event);
    xpc_dictionary_set_value(reply, "result", replyObject);
    xpc_connection_send_message(remote, reply);
}

void handlePerseusEvent(xpc_object_t event){
    
    
    xpc_object_t queries = xpc_dictionary_get_value(event, kPerseusQuery);
    xpc_object_t xpcReplyObject = xpc_dictionary_create(NULL, NULL, 0);
    
    if (xpc_get_type(queries) == XPC_TYPE_ARRAY){
        
        //Ensure latest connection state
        SDPairedDeviceAgent *pairedDeviceAgent = [objc_getClass("SDPairedDeviceAgent") sharedAgent];
        dispatch_sync(pairedDeviceAgent.dispatchQueue, ^{
            NSMutableDictionary *msg = [@{
                @"met":@1,
                @"rin":@1
            } mutableCopy];
            if (@available(iOS 14.0, *)){
                [pairedDeviceAgent _idsSendStateUpdate:msg asWaking:YES];
            }else{
                [pairedDeviceAgent _idsSendStateUpdate:msg];
            }
        });
        
        SDStatusMonitor *statusMonitor = [objc_getClass("SDStatusMonitor") sharedMonitor];
        IDSService *service = [pairedDeviceAgent valueForKey:@"_idsService"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isDefaultPairedDevice == 1"];
        IDSDevice *defaultPairedDevice = [[service.devices filteredArrayUsingPredicate:predicate] firstObject];
        
        xpc_array_apply(queries, ^_Bool(size_t index, xpc_object_t value){
            xpc_type_t valueType = xpc_get_type(value);
            
            if (valueType == XPC_TYPE_INT64){
                
                switch (xpc_int64_get_value(value)){
                    case PSQueryTypeWristState:{
                        xpc_dictionary_set_int64(xpcReplyObject, "pairedWatchWristState", (int64_t)statusMonitor.pairedWatchWristState);
                        break;
                    }
                    case PSQueryTypeLockState:{
                        xpc_dictionary_set_int64(xpcReplyObject, "pairedWatchLockState", (int64_t)statusMonitor.pairedWatchLockState);
                        break;
                    }
                    case PSQueryTypeNearby:{
                        if (defaultPairedDevice){
                            xpc_dictionary_set_bool(xpcReplyObject, "nearby", defaultPairedDevice.nearby);
                        }
                        break;
                    }
                    case PSQueryTypeActive:{
                        if (defaultPairedDevice){
                            xpc_dictionary_set_bool(xpcReplyObject, "active", defaultPairedDevice.isActive);
                        }
                        break;
                    }
                    case PSQueryTypeConnected:{
                        if (defaultPairedDevice){
                            xpc_dictionary_set_bool(xpcReplyObject, "connected", defaultPairedDevice.connected);
                        }
                        break;
                    }
                    case PSQueryTypeInvalidateRSSI:{
                        currentRssi = 1;
                        break;
                    }
                    case PSQueryTypeRSSI:{
                        xpc_dictionary_set_int64(xpcReplyObject, "rssi", currentRssi);
                        break;
                    }
                    case PSQueryTypeGizmoName:{
                        if (defaultPairedDevice){
                            xpc_dictionary_set_string(xpcReplyObject, "name", [defaultPairedDevice.name UTF8String]);
                        }
                        break;
                    }
                    case PSQueryTypeRSSICache:{
                        if (cachedRssi < 0 && currentRssi > 0){
                            xpc_dictionary_set_int64(xpcReplyObject, "rssi", cachedRssi);
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if (currentRssi > 0){
                                    CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)FORCE_LOCK_NN,  NULL, NULL, kCFNotificationDeliverImmediately);
                                }
                            });
                        }else{
                            xpc_dictionary_set_int64(xpcReplyObject, "rssi", currentRssi);
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
            return YES;
        });
    }
    
    replyWithObject(xpcReplyObject, event);
}

id valueForKey(NSString *key){
    CFStringRef appID = (__bridge CFStringRef)PERSEUS_IDENTIFIER;
    CFPreferencesAppSynchronize(appID);
    
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (keyList != NULL){
        BOOL containsKey = CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), (__bridge CFStringRef)key);
        CFRelease(keyList);
        if (!containsKey) return nil;
        
        return CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key, appID));
    }
    return nil;
}
