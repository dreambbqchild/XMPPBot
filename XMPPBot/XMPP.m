//
//  Bot.m
//  AnagramBot
//
//  Created by Paige Rudnick on 2/8/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import "XMPP.h"
#import "AnagramBot.h"
#include "strophe.h"
#include <pthread.h>
#include <curses.h>

@interface XMPP()
{
    xmpp_ctx_t* _context;
    xmpp_conn_t* _connection;
    BotFactory* _factory;
}
-(xmpp_ctx_t*) context;
-(xmpp_conn_t*) connection;
@end

static void* listenForDisconnect(void* vPtr)
{
    xmpp_conn_t* connection = (xmpp_conn_t*)vPtr;
	NSLog(@"Press any key to exit...");
    getchar();
	NSLog(@"Beginning disconnect sequence...");
	xmpp_disconnect(connection);
    return nil;
}

static int iqHandler(xmpp_conn_t * const conn, xmpp_stanza_t * const stanza, void * const userData) {
    xmpp_ctx_t *ctx = (xmpp_ctx_t*)userData;
    xmpp_stanza_t *reply;
    
    NSLog(@"got IQ %s", xmpp_stanza_get_attribute(stanza, "type"));
    if(xmpp_stanza_get_child_by_name(stanza, "ping"))
    {
        NSLog(@"Ping! Pong!");
        reply = xmpp_stanza_new(ctx);
        xmpp_stanza_set_name(reply, "iq");
        xmpp_stanza_set_type(reply, "result");
        xmpp_stanza_set_attribute(reply, "to", xmpp_stanza_get_attribute(stanza, "from"));
        xmpp_stanza_set_attribute(reply, "id", xmpp_stanza_get_attribute(stanza, "id") ? xmpp_stanza_get_attribute(stanza, "id") : "");
        xmpp_stanza_release(reply);
        
    }
    return 1;
}


static int messageHandler(xmpp_conn_t * const conn, xmpp_stanza_t * const stanza, void * const userData) {
    XMPP* xmpp = (__bridge XMPP*)userData;
	xmpp_stanza_t *reply, *body, *text;
    
	if(!xmpp_stanza_get_child_by_name(stanza, "body")) return 1;
	if(!strcmp(xmpp_stanza_get_attribute(stanza, "type"), "error")) return 1;
	
    NSLog(@"Got Something!");
	NSString* strIn = [[NSString alloc] initWithUTF8String: xmpp_stanza_get_text(xmpp_stanza_get_child_by_name(stanza, "body"))];
    NSArray* result = [[xmpp botFactory] processWithBot:strIn];
    
    if(result)
    {
        BOOL first = TRUE;
        
        for(NSString* line in result)
        {
            NSString* trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([trimmedLine length] == 0)
                continue;
            
            if(!first)
                usleep(750000);

            NSLog(@"%@", trimmedLine);
            
            reply = xmpp_stanza_new([xmpp context]);
            xmpp_stanza_set_name(reply, "message");
            xmpp_stanza_set_type(reply, xmpp_stanza_get_type(stanza) ? xmpp_stanza_get_type(stanza) : "chat");
            xmpp_stanza_set_attribute(reply, "to", xmpp_stanza_get_attribute(stanza, "from"));
            
            body = xmpp_stanza_new([xmpp context]);
            xmpp_stanza_set_name(body, "body");
            
            const char* cStrReply = [trimmedLine cStringUsingEncoding:NSASCIIStringEncoding];
            
            text = xmpp_stanza_new([xmpp context]);
            xmpp_stanza_set_text(text, cStrReply);
            xmpp_stanza_add_child(body, text);
            xmpp_stanza_add_child(reply, body);
            xmpp_send(conn, reply);
            xmpp_stanza_release(reply);
            
            first = FALSE;
        }
    }
	return 1;
}

static void connectionHandler(xmpp_conn_t * const _connection, const xmpp_conn_event_t status, const int error, xmpp_stream_error_t * const stream_error, void * const userData) {
    XMPP* xmpp = (__bridge XMPP*)userData;
    if (status == XMPP_CONN_CONNECT) {
        xmpp_handler_add([xmpp connection], iqHandler, NULL, "iq", NULL, [xmpp context]);
        xmpp_handler_add([xmpp connection], messageHandler, NULL, "message", NULL, userData);
        xmpp_stanza_t* pres = xmpp_stanza_new([xmpp context]);
		xmpp_stanza_set_name(pres, "presence");
		xmpp_send([xmpp connection], pres);
		xmpp_stanza_release(pres);

        pthread_t thr;
        pthread_create(&thr, NULL, &listenForDisconnect, [xmpp connection]);
    }
    else
    {
        fprintf(stderr, "DEBUG: disconnected\n");
		xmpp_stop([xmpp context]);
    }
}

@implementation XMPP
-(id)init {
    self = [super init];
    xmpp_initialize();
    _factory = [[BotFactory alloc] init];
    _context = xmpp_ctx_new(nil, nil);
	_connection = xmpp_conn_new(_context);
    return self;
}

-(xmpp_ctx_t*) context{
    return _context;
}

-(xmpp_conn_t*) connection{
    return _connection;
}

-(BotFactory*)botFactory {
    return _factory;
}

-(BOOL)connectWithJID:(NSString*) jid andPassword:(NSString*)password toURL:(NSString*) url;{
    const char* cStrJid = [jid cStringUsingEncoding:NSASCIIStringEncoding];
    const char* cStrPassword = [password cStringUsingEncoding:NSASCIIStringEncoding];
    const char* cStrUrl = [url cStringUsingEncoding:NSASCIIStringEncoding];
    
    xmpp_conn_set_jid(_connection, cStrJid);
    xmpp_conn_set_pass(_connection, cStrPassword);
    xmpp_connect_client(_connection, cStrUrl, 0, connectionHandler, (__bridge void *)(self));
    xmpp_run(_context);
    return TRUE;
}

-(void)dealloc {
    xmpp_conn_release(_connection);
    xmpp_ctx_free(_context);
    xmpp_shutdown();
}

@end
