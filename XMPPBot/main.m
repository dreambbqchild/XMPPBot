//
//  main.m
//  AnagramBot
//
//  Created by Paige Rudnick on 2/8/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#include <Security/Security.h>

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "AnagramBot.h"
#import "FortuneBot.h"

#define SERVICE_NAME "XMPPBot"

BOOL StorePassword(NSString* userName, NSString* password)
{
    const char* cStrUserName = [userName cStringUsingEncoding:NSUTF8StringEncoding];
    const char* cStrPassword = [password cStringUsingEncoding:NSUTF8StringEncoding];
    return SecKeychainAddGenericPassword(NULL, strlen(SERVICE_NAME), SERVICE_NAME, (UInt32)[userName length] + 1, cStrUserName, (UInt32)[password length] + 1, cStrPassword, NULL) == noErr;
}

NSString* GetPassword(NSString* userName)
{
    NSString* password = nil;
    const char* cStrUserName = [userName cStringUsingEncoding:NSUTF8StringEncoding];
    UInt32 bufferSize = 0;
    char* buffer = NULL;
    SecKeychainItemRef itemRef = {0};
    OSStatus result = SecKeychainFindGenericPassword(NULL, strlen(SERVICE_NAME), SERVICE_NAME, (UInt32)[userName length] + 1, cStrUserName, &bufferSize, (void**)&buffer, &itemRef);
    
    if (result == noErr)
    {
        password = [[NSString alloc] initWithCString:buffer encoding:NSUTF8StringEncoding];
        SecKeychainItemFreeContent(NULL, buffer);
    }
    
    if(itemRef)
        CFRelease(itemRef);
        
    return password;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSData *data = [NSData dataWithContentsOfFile:@"config.json"];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if(!json)
            return 0;
        
        NSDictionary* login = [json objectForKey:@"login"];
        if(!login)
            return 0;
        
        NSString* password = GetPassword([login objectForKey:@"username"]);
        if(!password)
        {
            char buffer[64] = {0};
            NSLog(@"Password not found. Please supply for %@:", [login objectForKey:@"username"]);
            //ToDo: Echo ***'s
            fgets(buffer, sizeof(buffer), stdin);
            password = [[NSString alloc] initWithCString:buffer encoding:NSUTF8StringEncoding];
            password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(!StorePassword([login objectForKey:@"username"], password))
            {
                NSLog(@"Could not store password. Aborting...");
                return 1;
            }
        }
        
        XMPP* xmpp = [[XMPP alloc] init];
        AnagramBot* anagram = [[AnagramBot alloc] initWithFile:[json objectForKey:@"anagram"]];
        [[xmpp botFactory] registerBot:anagram];
        
        FortuneBot* fortune = [[FortuneBot alloc] initWithFortuneFiles:[json objectForKey:@"fortune"]];
        [[xmpp botFactory] registerBot:fortune];
        
        [xmpp connectWithJID:[login objectForKey:@"username"] andPassword:password toURL:[login objectForKey:@"url"]];
    }
    return 0;
}

