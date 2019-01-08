//
//  hook_libATCommandStudioDynamic.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "hook_libATCommandStudioDynamic.h"

#include "util.h"
#include <substrate.h>

#include "qmi.h"
#include <memory>
#include <string>

#include <dispatch/dispatch.h>
#include <xpc/xpc.h>

/*
typedef struct QMux QMux;
typedef unsigned int QMIClientCallback;

#define QMIClient_requestClient _ZN9QMIClient13requestClientERKNSt3__112basic_stringIcNS0_11char_traitsIcEENS0_9allocatorIcEEEEN3qmi11ServiceTypeERK4QMuxP17QMIClientCallbackbb
extern "C" MSReturn QMIClient_requestClient(void *a1, std::string const &a2, QmiService a3, QMux const &a4, QMIClientCallback *a5, bool a6, bool a7);
static MSReturn (*orig_QMIClient_requestClient)(void *a1, std::string const &a2, QmiService a3, QMux const &a4, QMIClientCallback *a5, bool a6, bool a7);
MSReturn _QMIClient_requestClient(void *a1, std::string const &a2, QmiService a3, QMux const &a4, QMIClientCallback *a5, bool a6, bool a7) {
    DEBUG_LOG_RED
    qmilog("\t-> QMIClient::requestClient %p\n", a1);
    return orig_QMIClient_requestClient(a1, a2, a3, a4, a5, a6, a7);
}

class ATCSIPCDriver { };

class ATCSResetInvoker { };

#define QMux_QMux _ZN4QMuxC1EP13ATCSIPCDriverPvRKNSt3__112basic_stringIcNS3_11char_traitsIcEENS3_9allocatorIcEEEEP16ATCSResetInvokerbb
extern "C" MSReturn QMux_QMux(void *a1, ATCSIPCDriver *a2, void *a3, std::string const &a4, ATCSResetInvoker *a5, bool a6, bool a7);
static MSReturn (*orig_QMux_QMux)(void *a1, ATCSIPCDriver *a2, void *a3, std::string const &a4, ATCSResetInvoker *a5, bool a6, bool a7);
MSReturn _QMux_QMux(void *a1, ATCSIPCDriver *a2, void *a3, std::string const &a4, ATCSResetInvoker *a5, bool a6, bool a7) {
    DEBUG_LOG_RED
    return orig_QMux_QMux(a1, a2, a3, a4, a5, a6, a7);
}
*/
#pragma mark - qmi::Client

typedef enum { } qmi_ServiceType;
/*
#define qmi_Client_Client _ZN3qmi6ClientC2ERKNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEENS_11ServiceTypeEP16dispatch_queue_sS9_P17_xpc_connection_s
extern "C" MSReturn qmi_Client_Client(void *a1, std::string const &a2, qmi_ServiceType a3, dispatch_queue_t a4, std::string const &a5, xpc_connection_t a6);
static MSReturn (*orig_qmi_Client_Client)(void *a1, std::string const &a2, qmi_ServiceType a3, dispatch_queue_t a4, std::string const &a5, xpc_connection_t a6);
MSReturn _qmi_Client_Client(void *a1, std::string const &a2, qmi_ServiceType a3, dispatch_queue_t a4, std::string const &a5, xpc_connection_t a6) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_COLOR(FGGRN)
                   qmilog("\t-> this: %p\n", a1);
                   qmilog("\t-> str1: %s\n", a2.c_str());
                   qmilog("\t-> qmi_srv: %02x, %s\n", a3, get_qmi_service_name((QmiService)a3));
                   qmilog("\t-> gcd_queue: %p, %s\n", a4, dispatch_queue_get_label(a4));
                   qmilog("\t-> str2: %s\n", a5.c_str());
                   qmilog("\t-> xpc_conn: %p\n", a6);
                   )
//    MSReturn result = orig_qmi_Client_Client(a1, a2, a3, a4, a5, a6);
//    qmilog("\t-> this: %p\n", a1);
//    hexdump((uint8_t *)a1, 0x120);
//    return result;
    return orig_qmi_Client_Client(a1, a2, a3, a4, a5, a6);
}
 */

#define qmi_Client_dealloc _ZN3qmi6ClientD1Ev
extern "C" MSReturn qmi_Client_dealloc(void *a1);
static MSReturn (*orig_qmi_Client_dealloc)(void *a1);
MSReturn _qmi_Client_dealloc(void *a1) {
    DEBUG_LOG
    qmilog("\t-> qmi::Client::~Client() %p\n", a1);
    return orig_qmi_Client_dealloc(a1);
}

// set int

//#define qmi_Client_set_int _ZN3qmi6Client3setEPKci
//extern "C" unsigned int qmi_Client_set_int(void *a1, char const *a2, int a3);
//unsigned int _qmi_Client_set_int(void *a1, char const *a2, int a3) {
//    DEBUG_LOG
//    qmilog("\t-> qmi::Client::set_int %p\n", a1);
//    return qmi_Client_set_int(a1, a2 ,a3);
//} DYLD_INTERPOSE(_qmi_Client_set_int, qmi_Client_set_int)

// set uint

//#define qmi_Client_set_uint _ZN3qmi6Client3setEPKcj
//extern "C" unsigned int qmi_Client_set_uint(void *a1, char const *a2, unsigned int a3);
//unsigned int _qmi_Client_set_uint(void *a1, char const *a2, unsigned int a3) {
//    DEBUG_LOG
//    qmilog("\t-> qmi::Client::set_uint %p\n", a1);
//    return qmi_Client_set_uint(a1, a2 ,a3);
//} DYLD_INTERPOSE(_qmi_Client_set_uint, qmi_Client_set_uint)

// start

#define qmi_Client_start _ZNK3qmi6Client5startEv
extern "C" MSReturn qmi_Client_start(void *a1);
static MSReturn (*orig_qmi_Client_start)(void *a1);
MSReturn _qmi_Client_start(void *a1) {
    DEBUG_LOG
    qmilog("\t-> qmi::Client::start() %p\n", a1);
    return orig_qmi_Client_start(a1);
} //DYLD_INTERPOSE(_qmi_Client_start, qmi_Client_start)

// stop

 #define qmi_Client_stop _ZNK3qmi6Client4stopEv
extern "C" MSReturn qmi_Client_stop(void *a1);
static MSReturn (*orig_qmi_Client_stop)(void *a1);
MSReturn _qmi_Client_stop(void *a1) {
     DEBUG_LOG
     qmilog("\t-> qmi::Client::stop() %p\n", a1);
     return orig_qmi_Client_stop(a1);
 } //DYLD_INTERPOSE(_qmi_Client_stop, qmi_Client_stop)

#pragma mark - QMIServiceMsg

#define QMIServiceMsg_QMIServiceMsg _ZN13QMIServiceMsgC2EPKvtb
extern "C" MSReturn QMIServiceMsg_QMIServiceMsg(void *a1, void *a2, int a3, bool a4);
static MSReturn (*orig_QMIServiceMsg_QMIServiceMsg)(void *a1, void *a2, int a3, bool a4);
MSReturn _QMIServiceMsg_QMIServiceMsg(void *a1, void *a2, int a3, bool a4) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   
                   qmilog("\t a2: %p, a3: %d, a4: %d\n", a2, a3, a4);
                   hexdump((uint8_t *)a2, a3);
                   )
    return orig_QMIServiceMsg_QMIServiceMsg(a1, a2, a3, a4);
}

#define QMIServiceMsg_QMIServiceMsg2 _ZN13QMIServiceMsgC2ERKNSt3__16vectorIhNS0_9allocatorIhEEEEh
extern "C" MSReturn QMIServiceMsg_QMIServiceMsg2(void *a1, std::vector<unsigned char> *a2, unsigned char a3);
static MSReturn (*orig_QMIServiceMsg_QMIServiceMsg2)(void *a1, std::vector<unsigned char> *a2, unsigned char a3);
MSReturn _QMIServiceMsg_QMIServiceMsg2(void *a1, std::vector<unsigned char> *a2, unsigned char a3) {
    DEBUG_LOG_RED
    return orig_QMIServiceMsg_QMIServiceMsg2(a1, a2, a3);
}

#define QMIServiceMsg_serialize _ZNK13QMIServiceMsg9serializeEPvm
extern "C" MSReturn QMIServiceMsg_serialize(QMIServiceMsg_struct *a1, void *a2, int a3);
static MSReturn (*orig_QMIServiceMsg_serialize)(QMIServiceMsg_struct *a1, void *a2, int a3);
MSReturn _QMIServiceMsg_serialize(QMIServiceMsg_struct *a1, void *a2, int a3) {
    __block MSReturn result;
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   result = orig_QMIServiceMsg_serialize(a1, a2, a3);
                   qmilog("\t a2: %p, a3: %d\n", a2, a3);
                   hexdump((uint8_t *)a2, a3);
                   )
    return result;
}

#pragma mark - qmi::Client::State

#define qmi_Client_State_State _ZN3qmi6Client5StateC2ERKNSt3__112basic_stringIcNS2_11char_traitsIcEENS2_9allocatorIcEEEERKN3xpc10connectionENS_11ServiceTypeERKN8dispatch5queueE
extern "C" MSReturn qmi_Client_State_State(void *a1, std::string const &a2, xpc_connection_t *a3, qmi_ServiceType a4, dispatch_queue_t *a5);
static MSReturn (*orig_qmi_Client_State_State)(void *a1, std::string const &a2, xpc_connection_t *a3, qmi_ServiceType a4, dispatch_queue_t *a5);
MSReturn _qmi_Client_State_State(void *a1, std::string const &a2, xpc_connection_t *a3, qmi_ServiceType a4, dispatch_queue_t *a5) {
    DEBUG_LOG_SYNC(
    DEBUG_LOG_BLUE
                   qmilog("\t-> this: %p\n", a1);
                   qmilog("\t-> str1: %s\n", a2.c_str());
                   qmilog("\t-> xpc_conn: %p, %s\n", (*a3), xpc_copy_description((*a3)));
                   qmilog("\t-> qmi_srv: %02x, %s\n", a4, get_qmi_service_name((QmiService)a4));
                   qmilog("\t-> qcd_queue: %p, %s\n", (*a5), dispatch_queue_get_label((*a5)));
    )
    return orig_qmi_Client_State_State(a1, a2, a3, a4, a5);
}

#define qmi_Client_State_send_proxy _ZN3qmi6Client5State4sendERNS0_9SendProxyE
extern "C" MSReturn qmi_Client_State_send_proxy(void *a1, qmi_Client_SendProxy *a2);
static MSReturn (*orig_qmi_Client_State_send_proxy)(void *a1, qmi_Client_SendProxy *a2);
MSReturn _qmi_Client_State_send_proxy(void *a1, qmi_Client_SendProxy *a2) {
    DEBUG_LOG_SYNC(
    DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
//                   hexdump((uint8_t *)a1, 0x100);
                   
                   qmilog("\t a2: %p\n", a2);
                   hexdump((uint8_t *)a2, 40);
                   
                   qmilog("\t\t a2.client: %p\n", a2->client);
                   qmilog("\t\t a2.msg: %p\n", a2->msg);
                   qmilog("\t\t\t a2.msg.message: %04x, a2.msg.tlv_length: %04x (%d)\n",
                          a2->msg->message,
                          a2->msg->tlv_length, a2->msg->tlv_length);
                   
                   QMIServiceMsg_struct *msg = a2->msg;
                   int msg_length = msg->tlv_length + 2 + 2;
                   uint8_t *buffer = (uint8_t *)malloc(msg_length * sizeof(uint8_t));
                   QMIServiceMsg_serialize(msg, buffer, msg_length);
                   qmilog("\t\t\t serialized:\n");
                   hexdump(buffer, msg_length);
                   free(buffer);

                   qmilog("\t\t a2.f3: %04x (%d)\n", a2->f3, a2->f3);
                   qmilog("\t\t a2.f4: %04x (%d)\n", a2->f4, a2->f4);

                   qmilog("\t\t a2.f5: %p\n", a2->f5);
                   qmilog("\t\t a2.f6: %p\n", a2->f6);
    )
    return orig_qmi_Client_State_send_proxy(a1, a2);
}

#define qmi_Client_State_send_dict _ZN3qmi6Client5State4sendEN3xpc4dictE
extern "C" MSReturn qmi_Client_State_send_dict(void *a1, xpc_object_t *a2);
static MSReturn (*orig_qmi_Client_State_send_dict)(void *a1, xpc_object_t *a2);
MSReturn _qmi_Client_State_send_dict(void *a1, xpc_object_t *a2) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t a2: %p\n", a2);
                   qmilog("\t a2: %s\n", xpc_copy_description(*a2));
                   )
    return orig_qmi_Client_State_send_dict(a1, a2);
}

#define qmi_Client_State_send_sync _ZN3qmi6Client5State9send_syncERKN3xpc4dictERK13QMIServiceMsgRKN8dispatch5blockIU13block_pointerFvS8_EEE
extern "C" MSReturn qmi_Client_State_send_sync(void *a1, xpc_object_t *a2, QMIServiceMsg_struct *a3, QMIServiceMessageCallback *a4);
static MSReturn (*orig_qmi_Client_State_send_sync)(void *a1, xpc_object_t *a2, QMIServiceMsg_struct *a3, QMIServiceMessageCallback *a4);
MSReturn _qmi_Client_State_send_sync(void *a1, xpc_object_t *a2, QMIServiceMsg_struct *a3, QMIServiceMessageCallback *a4) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_COLOR(FGMAG)
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t a2: %p\n", a2);
                   qmilog("\t a2: %s\n", xpc_copy_description(*a2));

                   qmilog("\t a3: %p\n", a3);
                   qmilog("\t\t a3.message: %04x\n", a3->message);
                   qmilog("\t\t a3.tlv_length: %04x (%d)\n", a3->tlv_length, a3->tlv_length);
                   int msg_length = a3->tlv_length + 2 + 2;
                   uint8_t *buffer = (uint8_t *)malloc(msg_length * sizeof(uint8_t));
                   QMIServiceMsg_serialize(a3, buffer, msg_length);
                   qmilog("\t\t serialized:\n");
                   hexdump(buffer, msg_length);
                   free(buffer);

                   qmilog("\t a4: %p\n", a4);
                   )
    
//    __strong qmiClientStateSendCallback tmp = ^(QMIServiceMsg *msg) {
//        qmilog("\t\t msg: %p\n", msg);
//        (*((qmiClientStateSendCallback *)a4))(msg);
//    };
    return orig_qmi_Client_State_send_sync(a1, a2, a3, a4);
}

#define qmi_Client_State_send_sync_dict _ZNK3qmi6Client5State9send_syncERKN3xpc4dictE
extern "C" MSReturn qmi_Client_State_send_sync_dict(void *a1, xpc_object_t *a2);
static MSReturn (*orig_qmi_Client_State_send_sync_dict)(void *a1, xpc_object_t *a2);
MSReturn _qmi_Client_State_send_sync_dict(void *a1, xpc_object_t *a2) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_COLOR(FGMAG)
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t a2: %p\n", a2);
                   qmilog("\t a2: %s\n", xpc_copy_description(*a2));
                   )
    return orig_qmi_Client_State_send_sync_dict(a1, a2);
}

#pragma mark - Client handler

#define qmi_Client_setHandler_dg _ZNK3qmi6Client10setHandlerENS0_5EventEU13block_pointerFvP16dispatch_group_sE
extern "C" MSReturn qmi_Client_setHandler_dg(void *a1, qmi_Client_Event a2, void *a3);
static MSReturn (*orig_qmi_Client_setHandler_dg)(void *a1, qmi_Client_Event a2, void *a3);
MSReturn _qmi_Client_setHandler_dg(void *a1, qmi_Client_Event a2, void *a3) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t event_type: %04x\n", a2);
                   qmilog("\t a3: %p\n", a3);
                   )
    return orig_qmi_Client_setHandler_dg(a1, a2, a3);
}

#define qmi_Client_setHandler_pv _ZNK3qmi6Client10setHandlerENS0_5EventEU13block_pointerFvPvE
extern "C" MSReturn qmi_Client_setHandler_pv(void *a1, qmi_Client_Event a2, void *a3);
static MSReturn (*orig_qmi_Client_setHandler_pv)(void *a1, qmi_Client_Event a2, void *a3);
MSReturn _qmi_Client_setHandler_pv(void *a1, qmi_Client_Event a2, void *a3) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t event_type: %04x\n", a2);
                   qmilog("\t a3: %p\n", a3);
                   )
    return orig_qmi_Client_setHandler_pv(a1, a2, a3);
}

#define qmi_Client_setHandler_v _ZNK3qmi6Client10setHandlerENS0_5EventEU13block_pointerFvvE
extern "C" MSReturn qmi_Client_setHandler_v(void *a1, qmi_Client_Event a2, void *a3);
static MSReturn (*orig_qmi_Client_setHandler_v)(void *a1, qmi_Client_Event a2, void *a3);
MSReturn _qmi_Client_setHandler_v(void *a1, qmi_Client_Event a2, void *a3) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t event_type: %04x\n", a2);
                   qmilog("\t a3: %p\n", a3);
                   )
    return orig_qmi_Client_setHandler_v(a1, a2, a3);
}

#define qmi_Client_setIndHandler_sm _ZNK3qmi6Client13setIndHandlerEtU13block_pointerFvRK13QMIServiceMsgE
extern "C" MSReturn qmi_Client_setIndHandler_sm(qmi_Client_struct *a1, qmi_Client_Event a2, QMIServiceMessageCallback a3);
static MSReturn (*orig_qmi_Client_setIndHandler_sm)(qmi_Client_struct *a1, qmi_Client_Event a2, QMIServiceMessageCallback a3);
MSReturn _qmi_Client_setIndHandler_sm(qmi_Client_struct *a1, qmi_Client_Event a2, QMIServiceMessageCallback a3) {
    
    QMIServiceMessageCallback tmp = ^(QMIServiceMsg_struct *msg) {
//        DEBUG_LOG_ASYNC(
                       qmilog("\n====================\n");
                       qmilog("[=] QMIServiceMessageCallback: client %p, event_type: %04x\n", a1, a2);
                       qmilog("[=] message: %04x, tlv_length: %d\n", msg->message, msg->tlv_length);
                       
                       int msg_length = msg->tlv_length + 2 + 2;
                       uint8_t *buffer = (uint8_t *)malloc(msg_length * sizeof(uint8_t));
                       QMIServiceMsg_serialize(msg, buffer, msg_length);
                       qmilog("[=] serialized: %p\n", msg);
                       hexdump(buffer, msg_length);
                       free(buffer);
                       qmilog("====================\n");
                       
                       a3(msg);
//                       )
    };

    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t event_type: %04x\n", a2);
                   qmilog("\t a3: %p\n", a3);
                   qmilog("\t tmp_block: %p\n", tmp);
                   )
    return orig_qmi_Client_setIndHandler_sm(a1, a2, tmp);
}

#pragma mark - State handler

#define qmi_Client_State_setHandler_dg _ZN3qmi6Client5State10setHandlerENS0_5EventEN8dispatch5blockIU13block_pointerFvP16dispatch_group_sEEE
extern "C" MSReturn qmi_Client_State_setHandler_dg(void *a1, qmi_Client_Event a2, void *a3);
static MSReturn (*orig_qmi_Client_State_setHandler_dg)(void *a1, qmi_Client_Event a2, void *a3);
MSReturn _qmi_Client_State_setHandler_dg(void *a1, qmi_Client_Event a2, void *a3) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t event_type: %04x\n", a2);
                   qmilog("\t a3: %p\n", a3);
    )
    return orig_qmi_Client_State_setHandler_dg(a1, a2, a3);
}

#define qmi_Client_State_setHandler_pv _ZN3qmi6Client5State10setHandlerENS0_5EventEN8dispatch5blockIU13block_pointerFvPvEEE
extern "C" MSReturn qmi_Client_State_setHandler_pv(void *a1, qmi_Client_Event a2, void *a3);
static MSReturn (*orig_qmi_Client_State_setHandler_pv)(void *a1, qmi_Client_Event a2, void *a3);
MSReturn _qmi_Client_State_setHandler_pv(void *a1, qmi_Client_Event a2, void *a3) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t event_type: %04x\n", a2);
                   qmilog("\t a3: %p\n", a3);
                   )
    return orig_qmi_Client_State_setHandler_pv(a1, a2, a3);
}
#define qmi_Client_State_setIndHandler_sm _ZN3qmi6Client5State13setIndHandlerEtN8dispatch5blockIU13block_pointerFvRK13QMIServiceMsgEEE
extern "C" MSReturn qmi_Client_State_setIndHandler_sm(void *a1, qmi_Client_Event a2, void *a3);
static MSReturn (*orig_qmi_Client_State_setIndHandler_sm)(void *a1, qmi_Client_Event a2, void *a3);
MSReturn _qmi_Client_State_setIndHandler_sm(void *a1, qmi_Client_Event a2, void *a3) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   qmilog("\t event_type: %04x\n", a2);
                   qmilog("\t a3: %p\n", a3);
                   )
    return orig_qmi_Client_State_setIndHandler_sm(a1, a2, a3);
}

#pragma mark - qmi_CientProxy_State_State

#pragma mark - new

#define qmi_Client_Client _ZN3qmi6ClientC1ERKNSt3__18weak_ptrINS0_5StateEEE
extern "C" MSReturn qmi_Client_Client(void *a1, std::weak_ptr<void *> const &a2);
static MSReturn (*orig_qmi_Client_Client)(void *a1, std::weak_ptr<void *> const &a2);
MSReturn _qmi_Client_Client(void *a1, std::weak_ptr<void *> const &a2) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
                   
                   auto s_a2 = a2.lock();
                   qmilog("\t a2: %p\n", (*s_a2));
                   )
    return orig_qmi_Client_Client(a1, a2);
}

/*
#define qmi_Client_create _ZN3qmi6Client6createERKNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEENS_11ServiceTypeEP16dispatch_queue_sS9_P17_xpc_connection_s
extern "C" MSReturn qmi_Client_create(std::string const &a1, qmi_ServiceType a2, dispatch_queue_t a3, std::string const &a4, xpc_connection_t a5);
static MSReturn (*orig_qmi_Client_create)(std::string const &a1, qmi_ServiceType a2, dispatch_queue_t a3, std::string const &a4, xpc_connection_t a5);
MSReturn _qmi_Client_create(std::string const &a1, qmi_ServiceType a2, dispatch_queue_t a3, std::string const &a4, xpc_connection_t a5) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t-> a1: %s\n", a1.c_str());
                   qmilog("\t-> a2: 0x%02x, %d, %s\n", a2, a2, get_qmi_service_name((QmiService)a2));
                   qmilog("\t-> a3: %p, %s\n", a3, dispatch_queue_get_label(a3));
                   qmilog("\t-> a4: %s\n", a4.c_str());
                   qmilog("\t-> a5: %p\n", a5);
                   )
    return orig_qmi_Client_create(a1, a2, a3, a4, a5);
}
*/

#define qmi_Client_getName _ZNK3qmi6Client7getNameEv
extern "C" MSReturn qmi_Client_getName(void *a1);
static MSReturn (*orig_qmi_Client_getName)(void *a1);
MSReturn _qmi_Client_getName(void *a1) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG
                   qmilog("\t-> a1: %p\n", a1);
                   )
    return orig_qmi_Client_getName(a1);
}

#define qmi_Client_getSvcType _ZNK3qmi6Client10getSvcTypeEv
extern "C" MSReturn qmi_Client_getSvcType(void *a1);
static MSReturn (*orig_qmi_Client_getSvcType)(void *a1);
MSReturn _qmi_Client_getSvcType(void *a1) {
    MSReturn result = orig_qmi_Client_getSvcType(a1);
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t-> a1: %p\n", a1);
                   qmilog("\t-> rt: %d\n", result);
                   )
    return result;
}

#define qmi_Client_send _ZNK3qmi6Client4sendERNS0_9SendProxyE
extern "C" MSReturn qmi_Client_send(void *a1, qmi_Client_SendProxy *a2);
static MSReturn (*orig_qmi_Client_send)(void *a1, qmi_Client_SendProxy *a2);
MSReturn _qmi_Client_send(void *a1, qmi_Client_SendProxy *a2) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_RED
                   qmilog("\t a1: %p\n", a1);
//                   hexdump((uint8_t *)a1, 0x100);
//
                   qmilog("\t a2: %p\n", a2);
                   hexdump((uint8_t *)a2, 0x40);
//
                   qmilog("\t\t a2.client: %p\n", a2->client);
                   qmilog("\t\t a2.msg: %p\n", a2->msg);
                   qmilog("\t\t\t a2.msg.message: %04x, a2.msg.tlv_length: %04x (%d)\n",
                          a2->msg->message,
                          a2->msg->tlv_length, a2->msg->tlv_length);

                   qmilog("\t\t a2.f3: %04x (%d)\n", a2->f3, a2->f3);
                   qmilog("\t\t a2.f4: %04x (%d)\n", a2->f4, a2->f4);

                   qmilog("\t\t a2.f5: %p\n", a2->f5);
                   qmilog("\t\t a2.f6: %p\n", a2->f6);
                   )
    return orig_qmi_Client_send(a1, a2);
};

#pragma mark -

void hook_libATCommandStudioDynamic() {
//    MSHookFunction((void *)&qmi_Client_create, (void *)&_qmi_Client_create, (void **)&orig_qmi_Client_create);
//    MSHookFunction((void *)&QMIClient_requestClient, (void *)&_QMIClient_requestClient, (void **)&orig_QMIClient_requestClient);
//    MSHookFunction((void *)&QMux_QMux, (void *)&_QMux_QMux, (void **)&orig_QMux_QMux);
    MSHookFunction((void *)&qmi_Client_Client, (void *)&_qmi_Client_Client, (void **)&orig_qmi_Client_Client);
//    MSHookFunction((void *)&qmi_Client_dealloc, (void *)&_qmi_Client_dealloc, (void **)&orig_qmi_Client_dealloc);
//    MSHookFunction((void *)&qmi_Client_start, (void *)&_qmi_Client_start, (void **)&orig_qmi_Client_start);
//    MSHookFunction((void *)&qmi_Client_stop, (void *)&_qmi_Client_stop, (void **)&orig_qmi_Client_stop);


//    MSHookFunction((void *)&qmi_Client_State_State, (void *)&_qmi_Client_State_State, (void **)&orig_qmi_Client_State_State);
    MSHookFunction((void *)&qmi_Client_State_send_proxy, (void *)&_qmi_Client_State_send_proxy, (void **)&orig_qmi_Client_State_send_proxy);
//    MSHookFunction((void *)&qmi_Client_State_send_dict, (void *)&_qmi_Client_State_send_dict, (void **)&orig_qmi_Client_State_send_dict);
    MSHookFunction((void *)&qmi_Client_State_send_sync, (void *)&_qmi_Client_State_send_sync, (void **)&orig_qmi_Client_State_send_sync);
//    MSHookFunction((void *)&qmi_Client_State_send_sync_dict, (void *)&_qmi_Client_State_send_sync_dict, (void **)&orig_qmi_Client_State_send_sync_dict);
    
    MSHookFunction((void *)&qmi_Client_setHandler_dg, (void *)&_qmi_Client_setHandler_dg, (void **)&orig_qmi_Client_setHandler_dg);
    MSHookFunction((void *)&qmi_Client_setHandler_pv, (void *)&_qmi_Client_setHandler_pv, (void **)&orig_qmi_Client_setHandler_pv);
    MSHookFunction((void *)&qmi_Client_setHandler_v, (void *)&_qmi_Client_setHandler_v, (void **)&orig_qmi_Client_setHandler_v);
    MSHookFunction((void *)&qmi_Client_setIndHandler_sm, (void *)&_qmi_Client_setIndHandler_sm, (void **)&orig_qmi_Client_setIndHandler_sm);

//    MSHookFunction((void *)&qmi_Client_State_setHandler_dg, (void *)&_qmi_Client_State_setHandler_dg, (void **)&orig_qmi_Client_State_setHandler_dg);
//    MSHookFunction((void *)&qmi_Client_State_setHandler_pv, (void *)&_qmi_Client_State_setHandler_pv, (void **)&orig_qmi_Client_State_setHandler_pv);
//    MSHookFunction((void *)&qmi_Client_State_setIndHandler_sm, (void *)&_qmi_Client_State_setIndHandler_sm, (void **)&orig_qmi_Client_State_setIndHandler_sm);
    
//    MSHookFunction((void *)&QMIServiceMsg_QMIServiceMsg, (void *)&_QMIServiceMsg_QMIServiceMsg, (void **)&orig_QMIServiceMsg_QMIServiceMsg);
//    MSHookFunction((void *)&QMIServiceMsg_QMIServiceMsg2, (void *)&_QMIServiceMsg_QMIServiceMsg2, (void **)&orig_QMIServiceMsg_QMIServiceMsg2);
//    MSHookFunction((void *)&QMIServiceMsg_serialize, (void *)&_QMIServiceMsg_serialize, (void **)&orig_QMIServiceMsg_serialize);
    
    //new
//    MSHookFunction((void *)&qmi_Client_Client, (void *)&_qmi_Client_Client, (void **)&orig_qmi_Client_Client); // OK
//    MSHookFunction((void *)&qmi_Client_create, (void *)&_qmi_Client_create, (void **)&orig_qmi_Client_create); // CRASH
//    MSHookFunction((void *)&qmi_Client_getName, (void *)&_qmi_Client_getName, (void **)&orig_qmi_Client_getName); // CRASH
//    MSHookFunction((void *)&qmi_Client_getSvcType, (void *)&_qmi_Client_getSvcType, (void **)&orig_qmi_Client_getSvcType); // OK
//    MSHookFunction((void *)&qmi_Client_send, (void *)&_qmi_Client_send, (void **)&orig_qmi_Client_send); // CRASH
}
