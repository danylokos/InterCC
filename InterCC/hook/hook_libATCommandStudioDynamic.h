//
//  hook_libATCommandStudioDynamic.h
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include <stdlib.h>

#ifndef hook_libATCommandStudioDynamic_h
#define hook_libATCommandStudioDynamic_h

extern "C" void hook_libATCommandStudioDynamic();

#pragma mark - structs

#define PACKED __attribute__((packed))

typedef struct {
} PACKED qmi_Client_State_struct;

typedef struct {
    qmi_Client_State_struct *state;
    void *f2;
} PACKED qmi_Client_struct;

typedef struct {
    void *f1;
    uint8_t pad1[4];
    uint16_t message;
    uint16_t tlv_length;
    void *f2;
    void *f3;
    void *f4;
    uint8_t pad2[4];
    uint32_t checksum;
    uint8_t pad3[32];
} PACKED QMIServiceMsg_struct;

typedef struct {
    qmi_Client_struct *client;
    QMIServiceMsg_struct *msg;
    uint32_t f3;
    uint32_t f4;
    void *f5;
    void *f6;
//    void *f7;
//    uint32_t f8;
//    uint32_t f9;
//    void *f10;
} qmi_Client_SendProxy;

typedef uint16_t qmi_Client_Event;

typedef void(^QMIServiceMessageCallback)(QMIServiceMsg_struct *msg);

typedef void(^QMIClientHandlerCallback)(void);
typedef void(^QMIClientHandlerObjCallback)(void *obj);
typedef void(^QMIClientIndHandlerMsgCallback)(QMIServiceMsg_struct *msg);

#endif /* hook_libATCommandStudioDynamic_h */
