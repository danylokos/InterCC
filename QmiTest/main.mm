//
//  main.c
//  QmiTest
//
//  Created by Danylo Kostyshyn on 12/12/18.
//  Copyright © 2018 Danylo Kostyshyn. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>

#include <dlfcn.h>
#include <mach/mach.h>

#include "util.h"

#include <string>

#include <dispatch/dispatch.h>
#include <xpc/xpc.h>

#include "hook_libATCommandStudioDynamic.h"

#define ATCommandStudioPath "/usr/lib/libATCommandStudioDynamic.dylib"
#define QMIParserPath "/usr/lib/libQMIParserDynamic.dylib"

template <typename Type_>
static bool dlset(Type_ &function, void* dl, const char* sym) {
    void *value = dlsym(dl, sym);
    if (value == NULL) {
        printf("[-] Unable to find %s\n", sym);
        function = NULL;
        return false;
    } else {
        printf("[+] Found %s at %p\n", sym, value);
        function = reinterpret_cast<Type_>(value);
    }
    return true;
}

void *load_dylib(const char *path) {
    void *handle = dlopen(path, RTLD_NOW);
    if (handle == NULL) {
        printf("[-] Can't load dylib: %s\n", path);
        return NULL;
    }
    printf("[+] Successfully loaded dylib: %s\n", path);
    return handle;
}

#pragma mark -

typedef enum {
} qmi_ServiceType;

typedef struct {
} xpc_dict;

typedef void(^qmiClientStateSendCallback)(void *a1);

#pragma mark -

#define _qmi_Client_Client "_ZN3qmi6ClientC2ERKNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEENS_11ServiceTypeEP16dispatch_queue_sS9_P17_xpc_connection_s"
static MSReturn (*qmi_Client_Client)(void *a1, std::string const &a2, qmi_ServiceType a3, dispatch_queue_t a4, std::string const &a5, void *a6);

#define _qmi_Client_start "_ZNK3qmi6Client5startEv"
static MSReturn (*qmi_Client_start)(void *a1);

//#define _qmi_Client_State_State "_ZN3qmi6Client5StateC2ERKNSt3__112basic_stringIcNS2_11char_traitsIcEENS2_9allocatorIcEEEERKN3xpc10connectionENS_11ServiceTypeERKN8dispatch5queueE"
//static MSReturn (*qmi_Client_State_State)(void *a1, std::string const &a2, xpc_connection_t *a3, qmi_ServiceType a4, dispatch_queue_t *a5);

//#define _qmi_Client_getSvcType "_ZNK3qmi6Client10getSvcTypeEv"
//static unsigned int (*qmi_Client_getSvcType)(void *a1);

#define _qmi_Client_setHandler_pv "_ZNK3qmi6Client10setHandlerENS0_5EventEU13block_pointerFvPvE"
static MSReturn (*qmi_Client_setHandler_pv)(void *a1, qmi_Client_Event a2, QMIClientHandlerObjCallback);

#define _qmi_Client_setHandler_v "_ZNK3qmi6Client10setHandlerENS0_5EventEU13block_pointerFvvE"
static MSReturn (*qmi_Client_setHandler_v)(void *a1, qmi_Client_Event a2, QMIClientHandlerCallback);

#define _qmi_Client_setIndHandler_sm "_ZNK3qmi6Client13setIndHandlerEtU13block_pointerFvRK13QMIServiceMsgE"
static MSReturn (*qmi_Client_setIndHandler_sm)(void *a1, uint16_t a2, QMIServiceMessageCallback a3);

#define _qmi_Client_setIndShouldWake "_ZNK3qmi6Client16setIndShouldWakeEtb"
static MSReturn (*qmi_Client_setIndShouldWake)(void *a1, uint16_t a2, bool a3);

#define _qmi_Client_State_setIndHandler_sm "_ZN3qmi6Client5State13setIndHandlerEtN8dispatch5blockIU13block_pointerFvRK13QMIServiceMsgEEE"
static MSReturn (*qmi_Client_State_setIndHandler_sm)(void *a1, uint16_t a2, QMIClientIndHandlerMsgCallback a3);

#define _qmi_Client_send "_ZNK3qmi6Client4sendERNS0_9SendProxyE"
static MSReturn (*qmi_Client_send)(void *a1, qmi_Client_SendProxy *a2);

#define _qmi_Client_State_send "_ZN3qmi6Client5State4sendERNS0_9SendProxyE"
static MSReturn (*qmi_Client_State_send)(void *a1, qmi_Client_SendProxy *a2);

#define _qmi_Client_State_send_sync "_ZN3qmi6Client5State9send_syncERKN3xpc4dictERK13QMIServiceMsgRKN8dispatch5blockIU13block_pointerFvS8_EEE"
static MSReturn (*qmi_Client_State_send_sync)(void *a1, xpc_object_t *a2, QMIServiceMsg_struct *a3, void *a4);

#define _qmi_Client_State_send_sync_dict "_ZNK3qmi6Client5State9send_syncERKN3xpc4dictE"
static MSReturn (*qmi_Client_State_send_sync_dict)(void *a1, xpc_object_t *a2);

#define _QMIServiceMsg_QMIServiceMsg "_ZN13QMIServiceMsgC2EPKvtb"
static MSReturn (*QMIServiceMsg_QMIServiceMsg)(void *a1, void *a2, int a3, bool a4);

#define _QMIServiceMsg_serialize "_ZNK13QMIServiceMsg9serializeEPvm"
static MSReturn (*QMIServiceMsg_serialize)(QMIServiceMsg_struct *a1, void *a2, int a3);

typedef struct {
    uint16_t message;
    uint8_t pad1[6];
    void *f1;
    void *f2;
} PACKED qmi_MessageBase_struct;

#define _qmi_MessageBase_MessageBase "_ZN3qmi11MessageBaseC2EPKvm"
static MSReturn (*qmi_MessageBase_MessageBase)(void *self, void *data, unsigned int length);

int testATCommandStudio() {
    void *lib_handle = load_dylib(ATCommandStudioPath);
    if (lib_handle) {
        dlset(qmi_Client_Client, lib_handle, _qmi_Client_Client);
        dlset(qmi_Client_start, lib_handle, _qmi_Client_start);
        dlset(qmi_Client_send, lib_handle, _qmi_Client_send);

        dlset(qmi_Client_State_send, lib_handle, _qmi_Client_State_send);
        dlset(qmi_Client_State_send_sync, lib_handle, _qmi_Client_State_send_sync);
        dlset(qmi_Client_State_send_sync_dict, lib_handle, _qmi_Client_State_send_sync_dict);

        dlset(QMIServiceMsg_QMIServiceMsg, lib_handle, _QMIServiceMsg_QMIServiceMsg);
        dlset(QMIServiceMsg_serialize, lib_handle, _QMIServiceMsg_serialize);
        
        dlset(qmi_Client_setHandler_pv, lib_handle, _qmi_Client_setHandler_pv);
        dlset(qmi_Client_setHandler_v, lib_handle, _qmi_Client_setHandler_v);
        dlset(qmi_Client_setIndHandler_sm, lib_handle, _qmi_Client_setIndHandler_sm);
        dlset(qmi_Client_setIndShouldWake, lib_handle, _qmi_Client_setIndShouldWake);

        dlset(qmi_Client_State_setIndHandler_sm, lib_handle, _qmi_Client_State_setIndHandler_sm);
    }
    
    QMIServiceMsg_struct *msg = (QMIServiceMsg_struct *)malloc(sizeof(QMIServiceMsg_struct));
//    QMIServiceMsg_struct *msg = (QMIServiceMsg_struct *)calloc(0x50, sizeof(uint8_t));
    QMIServiceMsg_QMIServiceMsg(msg, (void *)"\x22\x00\x04\x00\x01\x01\x00\x03", 8, false);
    printf("[+] msg: %p\n", msg);
//    fhexdump(stdout, (uint8_t *)msg, sizeof(QMIServiceMsg_struct));;
    
    int qmi_length = msg->tlv_length + 2 + 2;
    uint8_t *buffer = (uint8_t *)malloc(qmi_length * sizeof(uint8_t));
    QMIServiceMsg_serialize(msg, buffer, qmi_length);
    printf("[+] serialized: %p\n", buffer);
    fhexdump(stdout, (uint8_t *)buffer, qmi_length);
    free(buffer);
    
    qmi_Client_struct *client = (qmi_Client_struct *)malloc(sizeof(qmi_Client_struct));
    dispatch_queue_t queue = dispatch_queue_create("qmiclient.gcd.queue.test", 0);
//    dispatch_queue_t queue = dispatch_get_main_queue();
    qmi_Client_Client((void *)client, std::string("TestClient_a2"), (qmi_ServiceType)0x00, queue, std::string("TestClient_a5"), NULL);
    printf("[+] client: %p\n", client);
    printf("[+] state: %p\n", client->state);
    
    qmi_Client_setHandler_pv(client, 0x1, ^(void *) { printf("[+] QMIClientHandlerObjCallback 0x1\n"); });
    qmi_Client_setHandler_pv(client, 0x2, ^(void *) { printf("[+] QMIClientHandlerObjCallback 0x2\n"); });
    qmi_Client_setHandler_pv(client, 0x4, ^(void *) { printf("[+] QMIClientHandlerObjCallback 0x4\n"); });
    qmi_Client_setHandler_pv(client, 0x5, ^(void *obj) {
        printf("[+] QMIClientHandlerObjCallback 0x5\n");
        fhexdump(stdout, (uint8_t *)obj, 16);
    });
    printf("[+] qmi_Client_setHandler_pv\n");

    QMIClientIndHandlerMsgCallback cb = ^(QMIServiceMsg_struct *msg) {
        printf("[+] QMIServiceMessageCallback\n");
    };
    qmi_Client_setIndHandler_sm(client, 0x0022, cb);
    printf("[+] qmi_Client_setIndHandler_sm\n");
    
    qmi_Client_setIndShouldWake(client, 0x0022, 1);
    printf("[+] qmi_Client_setIndShouldWake\n");

    qmi_Client_start((void *)client);
    printf("[+] start\n");

    const char *keys[] = {
//        "msg_id",
        "send_qmi_message",
        "send_timeout_ms"
    };
    
//    xpc_object_t msg_id = xpc_int64_create(10);
    xpc_object_t qmi_message = xpc_data_create("\x22\x00\x04\x00\x01\x01\x00\x03", 8);
    xpc_object_t timeout_ms = xpc_int64_create(25000);
    const xpc_object_t values[] = {
//        msg_id,
        qmi_message,
        timeout_ms
    };
    __block xpc_object_t dict = xpc_dictionary_create(keys, values, 2);

    uint8_t *(^sync_cb)(uint8_t *a1, uint8_t *a2) = ^(uint8_t *a1, uint8_t *a2) {
        printf("[+] QMIServiceMessageCallback\n");
        uint8_t *result = (a1 + 32);
        return (result + 56);
    };
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        qmi_Client_State_send_sync((void *)client->state, &dict, msg, (void *)&sync_cb);
//        printf("[+] qmi_Client_State_send_sync()\n");
//    });
    
//    qmi_Client_State_send_sync_dict((void *)client->state, &dict);
//    printf("[+] qmi_Client_State_send_sync_dict()\n");
    
    qmi_Client_SendProxy *proxy = (qmi_Client_SendProxy *)calloc(0x100, sizeof(uint8_t));
    proxy->client = client;
    proxy->msg = msg;
    proxy->f3 = 0x61a8;
    proxy->f4 = 0x0001;
    proxy->f5 = NULL;
    proxy->f6 = NULL;
//    printf("[+] proxy: %p\n", proxy);
//    fhexdump(stdout, (uint8_t *)proxy, sizeof(qmi_Client_SendProxy));

    qmi_Client_State_send((void *)client->state, proxy);
    printf("[+] qmi_Client_State_send()\n");

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        qmi_Client_send(client, proxy);
//        printf("[+] qmi_Client_send()\n");
//    });

//    printf("[+] proxy: %p\n", proxy);
//    fhexdump(stdout, (uint8_t *)proxy, sizeof(qmi_Client_SendProxy));

    return 0;
}

#pragma mark -

//typedef struct QMux QMux;
//typedef unsigned int QMIClientCallback;
//
//#define _QMIClient_requestClient "_ZN9QMIClient13requestClientERKNSt3__112basic_stringIcNS0_11char_traitsIcEENS0_9allocatorIcEEEEN3qmi11ServiceTypeERK4QMuxP17QMIClientCallbackbb"
//static MSReturn (*QMIClient_requestClient)(void *a1, std::string const &a2, uint8_t a3, QMux const *a4, QMIClientCallback *a5, bool a6, bool a7);
//
//int testATCommandStudio2() {
//    void *lib_handle = load_dylib(ATCommandStudioPath);
//    if (lib_handle) {
//        dlset(QMIClient_requestClient, lib_handle, _QMIClient_requestClient);
//    }
//
//    void *client = (void *)calloc(100, sizeof(uint8_t));
//    QMIClient_requestClient(client, "TestClient", 0x0c, NULL, 0x0, true, true);
//    printf("[+] QMIClient_requestClient: %p", client);
//    fhexdump(stdout, (uint8_t *)client, 100);
//
//    return 0;
//}

#pragma mark -

int testQMIParser() {
    void *lib_handle = load_dylib(QMIParserPath);
    if (lib_handle) {
        dlset(qmi_MessageBase_MessageBase, lib_handle, _qmi_MessageBase_MessageBase);
    }
    
    if (qmi_MessageBase_MessageBase == NULL) {
        return -1;
    }
    
    size_t size = 0x18;
    qmi_MessageBase_struct *tmp = (qmi_MessageBase_struct *)calloc(size, sizeof(uint8_t));
    printf("[+] memory addr: %p\n", tmp);
    qmi_MessageBase_MessageBase(tmp, (void *)"\x27\x00\x07\x00\x02\x04\x00\x00\x00\x00\x00", 11);
    if (tmp == NULL) {
        printf("[-] Can't create object\n");
        return -1;
    }
    printf("[+] Success\n");
    
//    printf("[*] hexdump: %p\n", tmp);
//    fhexdump(stdout, (uint8_t *)tmp, size);
    
    printf("[*] message: %04x\n", tmp->message);
    printf("[*] f1: %p\n", tmp->f1);
    printf("[*] f2: %p\n", tmp->f2);
    
//    printf("[*] hexdump: %p\n", tmp->f1);
//    fhexdump(stdout, (uint8_t *)tmp->f1, 0x40);
//
//    printf("[*] hexdump: %p\n", tmp->f2);
//    fhexdump(stdout, (uint8_t *)tmp->f2, 0x40);
    
    return 0;
}

int main(int argc, const char *argv[]) {
    NSRunLoop *runLoop;
    @autoreleasepool {
        runLoop = [NSRunLoop currentRunLoop];
        
        testATCommandStudio();
        
        while ([runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    }
    return 0;
}

