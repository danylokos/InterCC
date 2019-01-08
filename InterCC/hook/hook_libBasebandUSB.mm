//
//  hook_libBasebandUSB.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "hook_libBasebandUSB.h"

#include "util.h"
#include <substrate.h>

#include "qmi.h"
#include <memory>
#include <string>

#define PACKED __attribute__((packed))

#define usb_interface_control_init _ZN3usb9interface7control4initEv
extern "C" MSReturn usb_interface_control_init(void *a1);
static MSReturn (*orig_usb_interface_control_init)(void *a1);
MSReturn _usb_interface_control_init(void *a1) {
    DEBUG_LOG_RED
    return orig_usb_interface_control_init(a1);
}

typedef struct {
} usb_interface_control_parameters;

#define usb_interface_control_create _ZN3usb9interface7control6createERKNS1_10parametersE
extern "C" MSReturn usb_interface_control_create(void *a1, usb_interface_control_parameters const &a2);
static MSReturn (*orig_usb_interface_control_create)(void *a1, usb_interface_control_parameters const &a2);
MSReturn _usb_interface_control_create(void *a1, usb_interface_control_parameters const &a2) {
    DEBUG_LOG_SYNC(
                   DEBUG_LOG_COLOR(FGYEL)
                   qmilog("\t-> a2: %p\n", &a2);
                   hexdumpct((uint8_t *)&a2, 0x100);
    )
    return orig_usb_interface_control_create(a1, a2);
}

#define usb_interface_control_control _ZN3usb9interface7controlC2ERKNS1_10parametersE
extern "C" MSReturn usb_interface_control_control(void *a1, usb_interface_control_parameters const &a2);
static MSReturn (*orig_usb_interface_control_control)(void *a1, usb_interface_control_parameters const &a2);
MSReturn _usb_interface_control_control(void *a1, usb_interface_control_parameters const &a2) {
    DEBUG_LOG_SYNC(
    DEBUG_LOG_COLOR(FGYEL)
    qmilog("\t-> a2: %p\n", &a2);
    hexdumpct((uint8_t *)&a2, 0x100);
    )
    return orig_usb_interface_control_control(a1, a2);
}

#define usb_interface_control_engage _ZN3usb9interface7control6engageEv
extern "C" unsigned int usb_interface_control_engage(void *a1);
static unsigned int (*orig_usb_interface_control_engage)(void *a1);
unsigned int _usb_interface_control_engage(void *a1) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_usb_interface_control_engage(a1);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_engageInterface _ZN3usb9interface7control15engageInterfaceEv
extern "C" unsigned int usb_interface_control_engageInterface(void *a1);
static unsigned int (*orig_usb_interface_control_engageInterface)(void *a1);
unsigned int _usb_interface_control_engageInterface(void *a1) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_usb_interface_control_engageInterface(a1);
} //DYLD_INTERPOSE(_func_name, func_name)

typedef struct {
    
} /*PACKED*/ usb_interface_control;

#define usb_interface_control_engageInterface_sync _ZN3usb9interface7control20engageInterface_syncENSt3__18weak_ptrIS1_EE
extern "C" unsigned int usb_interface_control_engageInterface_sync(void *a1, std::weak_ptr<usb_interface_control> a2);
static unsigned int (*orig_usb_interface_control_engageInterface_sync)(void *a1, std::weak_ptr<usb_interface_control> a2);
unsigned int _usb_interface_control_engageInterface_sync(void *a1, std::weak_ptr<usb_interface_control> a2) {
    DEBUG_LOG_SYNC(
    DEBUG_LOG_COLOR(FGYEL)
    std::shared_ptr<usb_interface_control> sp;
    sp = a2.lock();
    qmilog("\t-> sp1: %p\n", sp.get());
    hexdumpct((uint8_t *)sp.get(), 0x100);
    )
    return orig_usb_interface_control_engageInterface_sync(a1, a2);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_write _ZN3usb9interface7control5writeERKP15dispatch_data_sRKN8dispatch5blockIU13block_pointerFvbEEE
extern "C" unsigned int usb_interface_control_write(void *a1, dispatch_data_t *a2, void *a3);
static unsigned int (*orig_usb_interface_control_write)(void *a1, dispatch_data_t *a2, void *a3);
unsigned int _usb_interface_control_write(void *a1, dispatch_data_t *a2, void *a3) {
    DEBUG_LOG_SYNC(
       DEBUG_LOG_COLOR(FGYEL)
       if (a2 != NULL) {
           NSData *data = (NSData *)*a2;
           qmilog("\t-> a2: %d\n", data.length);
           hexdumpct((uint8_t *)(data.bytes), data.length);
       }
    )
    return orig_usb_interface_control_write(a1, a2, a3);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_writeInterface _ZN3usb9interface7control14writeInterfaceERKP15dispatch_data_sRKN8dispatch5blockIU13block_pointerFvbEEE
extern "C" unsigned int usb_interface_control_writeInterface(void *a1, dispatch_data_t *a2, void *a3);
static unsigned int (*orig_usb_interface_control_writeInterface)(void *a1, dispatch_data_t *a2, void *a3);
unsigned int _usb_interface_control_writeInterface(void *a1, dispatch_data_t *a2, void *a3) {
    DEBUG_LOG_SYNC(
        DEBUG_LOG_COLOR(FGYEL)
        if (a2 != NULL) {
            NSData *data = (NSData *)*a2;
            qmilog("\t-> a2: %p %d\n", a2, data.length);
            hexdumpct((uint8_t *)(data.bytes), data.length);
            print_qmi_message((uint8_t *)data.bytes);
        }
    )
    return orig_usb_interface_control_writeInterface(a1, a2, a3);
} //DYLD_INTERPOSE(_func_name, func_name)

typedef struct {
    void *ptr1;
    void *ptr2;
    size_t f1[3];
    void *ptr3;
    dispatch_data_t data;
} PACKED usb_buffer;

//#define usb_interface_control_queueBulkReadCompletion_sync _ZN3usb9interface7control28queueBulkReadCompletion_syncERKNSt3__110shared_ptrINS_6bufferEEERKiRKm
//extern "C" unsigned int usb_interface_control_queueBulkReadCompletion_sync(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4);
//static unsigned int (*orig_usb_interface_control_queueBulkReadCompletion_sync)(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4);
//unsigned int _usb_interface_control_queueBulkReadCompletion_sync(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4) {
//    DEBUG_LOG_RED
//    unsigned int result = orig_usb_interface_control_queueBulkReadCompletion_sync(a1, a2, a3, a4);
//    qmilog("\t-> a3: %d, a4: %d\n", a3, a4);
//    if (a4 > 0) {
//        hexdumpct((uint8_t *)a2.get(), a4);
//    }
//    return result;
//} //DYLD_INTERPOSE(_usb_interface_control_init, usb_interface_control_init)
//
//#define usb_interface_control_queueBulkWriteCompletion_sync _ZN3usb9interface7control29queueBulkWriteCompletion_syncERKNSt3__110shared_ptrINS_6bufferEEERKiRKm
//extern "C" unsigned int usb_interface_control_queueBulkWriteCompletion_sync(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4);
//static unsigned int (*orig_usb_interface_control_queueBulkWriteCompletion_sync)(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4);
//unsigned int _usb_interface_control_queueBulkWriteCompletion_sync(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4) {
//    DEBUG_LOG_RED
//    qmilog("\t-> a3: %d, a4: %d\n", a3, a4);
//    if (a4 > 0) {
//        hexdumpct((uint8_t *)a2.get(), a4);
//    }
//    return orig_usb_interface_control_queueBulkWriteCompletion_sync(a1, a2, a3, a4);
//} //DYLD_INTERPOSE(_usb_interface_control_init, usb_interface_control_init)
//
//#define usb_interface_control_dispatchRead_sync _ZN3usb9interface7control17dispatchRead_syncERKNSt3__110shared_ptrINS_6bufferEEE
//extern "C" unsigned int usb_interface_control_dispatchRead_sync(void *a1, std::shared_ptr<usb_buffer> const &a2);
//static unsigned int (*orig_usb_interface_control_dispatchRead_sync)(void *a1, std::shared_ptr<usb_buffer> const &a2);
//unsigned int _usb_interface_control_dispatchRead_sync(void *a1, std::shared_ptr<usb_buffer> const &a2) {
//    DEBUG_LOG_RED
//    return orig_usb_interface_control_dispatchRead_sync(a1, a2);
//} //DYLD_INTERPOSE(_func_name, func_name)
//
#define usb_interface_control_queueControlReadCompletion_sync _ZN3usb9interface7control31queueControlReadCompletion_syncERKNSt3__110shared_ptrINS_6bufferEEERKiRKm
extern "C" unsigned int usb_interface_control_queueControlReadCompletion_sync(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4);
static unsigned int (*orig_usb_interface_control_queueControlReadCompletion_sync)(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4);
unsigned int _usb_interface_control_queueControlReadCompletion_sync(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4) {
    DEBUG_LOG_SYNC(
        DEBUG_LOG_RED
        qmilog("\t-> a2: %p, a3: %d, a4: %d\n", a2.get(), a3, a4);
//    qmilog("\t\t-> a2.ptr1: %p, a2.ptr2: %p, a2.ptr3: %p, a2.data: %p\n",
//          a2.get()->ptr1, a2.get()->ptr2, a2.get()->ptr3, a2.get()->data);
//    size_t f1[] = { a2.get()->f1[0], a2.get()->f1[1], a2.get()->f1[2] };
//    qmilog("\t\t-> a2.f1: 0x%04x (%d), 0x%04x (%d), 0x%04x (%d)\n", f1[0], f1[0], f1[1], f1[1], f1[2], f1[2]);
        if (a2.get()->data != NULL && a4 > 0) {
            NSData *data = (NSData *)a2.get()->data;
            qmilog("\t-> data: %p %d\n", a2.get()->data, a4);
            hexdumpct((uint8_t *)(data.bytes), a4);
            print_qmi_message((uint8_t *)data.bytes);
        }
    )
    return orig_usb_interface_control_queueControlReadCompletion_sync(a1, a2, a3, a4);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_queueControlWriteCompletion_sync _ZN3usb9interface7control32queueControlWriteCompletion_syncERKNSt3__110shared_ptrINS_6bufferEEERKiRKm
extern "C" unsigned int usb_interface_control_queueControlWriteCompletion_sync(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4);
static unsigned int (*orig_usb_interface_control_queueControlWriteCompletion_sync)(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4);
unsigned int _usb_interface_control_queueControlWriteCompletion_sync(void *a1, std::shared_ptr<usb_buffer> const &a2, int const &a3, unsigned long const &a4) {
    DEBUG_LOG_SYNC(
    DEBUG_LOG_RED
        qmilog("\t-> a2: %p, a3: %d, a4: %d\n", a2.get(), a3, a4);
        //    qmilog("\t\t-> a2.ptr1: %p, a2.ptr2: %p, a2.ptr3: %p, a2.data: %p\n",
        //          a2.get()->ptr1, a2.get()->ptr2, a2.get()->ptr3, a2.get()->data);
        //    size_t f1[] = { a2.get()->f1[0], a2.get()->f1[1], a2.get()->f1[2] };
        //    qmilog("\t\t-> a2.f1: 0x%04x (%d), 0x%04x (%d), 0x%04x (%d)\n", f1[0], f1[0], f1[1], f1[1], f1[2], f1[2]);
        if (a2.get()->data != NULL && a4 > 0) {
            NSData *data = (NSData *)a2.get()->data;
            qmilog("\t-> data: %p %d\n", a2.get()->data, a4);
            hexdumpct((uint8_t *)(data.bytes), a4);
            print_qmi_message((uint8_t *)data.bytes);
        }
    )
    return orig_usb_interface_control_queueControlWriteCompletion_sync(a1, a2, a3, a4);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_ioCompletionInternal_sync _ZN3usb9interface7control25ioCompletionInternal_syncERKNSt3__110shared_ptrINS_6bufferEEERKiRKm
extern "C" unsigned int usb_interface_control_ioCompletionInternal_sync(void *a1, std::shared_ptr<usb_buffer> const& a2, int const& a3, unsigned long const& a4);
static unsigned int (*orig_usb_interface_control_ioCompletionInternal_sync)(void *a1, std::shared_ptr<usb_buffer> const& a2, int const& a3, unsigned long const& a4);
unsigned int _usb_interface_control_ioCompletionInternal_sync(void *a1, std::shared_ptr<usb_buffer> const& a2, int const& a3, unsigned long const& a4) {
    DEBUG_LOG_SYNC(
        DEBUG_LOG_RED
        qmilog("\t-> a3: %d, a4: %d\n", a3, a4);
        if (a2.get()->data != NULL && a4 > 0) {
            NSData *data = (NSData *)a2.get()->data;
            qmilog("\t-> data: %p %d\n", a2.get(), a4);
            //        hexdumpct((uint8_t *)(data.bytes), a4);
            print_qmi_message((uint8_t *)data.bytes);
        }
    )
    return orig_usb_interface_control_ioCompletionInternal_sync(a1, a2, a3, a4);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_recover _ZN3usb9interface7control7recoverEv
extern "C" unsigned int usb_interface_control_recover(void *a1);
static unsigned int (*orig_usb_interface_control_recover)(void *a1);
unsigned int _usb_interface_control_recover(void *a1) {
    DEBUG_LOG_RED
    return orig_usb_interface_control_recover(a1);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_recoverInterface _ZN3usb9interface7control16recoverInterfaceEv
extern "C" unsigned int usb_interface_control_recoverInterface(void *a1);
static unsigned int (*orig_usb_interface_control_recoverInterface)(void *a1);
unsigned int _usb_interface_control_recoverInterface(void *a1) {
    DEBUG_LOG_RED
    return orig_usb_interface_control_recoverInterface(a1);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_teardown _ZN3usb9interface7control8teardownEv
extern "C" unsigned int usb_interface_control_teardown(void *a1);
static unsigned int (*orig_usb_interface_control_teardown)(void *a1);
unsigned int _usb_interface_control_teardown(void *a1) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_usb_interface_control_teardown(a1);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_teardownInterface _ZN3usb9interface7control17teardownInterfaceEv
extern "C" unsigned int usb_interface_control_teardownInterface(void *a1);
static unsigned int (*orig_usb_interface_control_teardownInterface)(void *a1);
unsigned int _usb_interface_control_teardownInterface(void *a1) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_usb_interface_control_teardownInterface(a1);
} //DYLD_INTERPOSE(_func_name, func_name)

#define usb_interface_control_teardownInterface_sync _ZN3usb9interface7control22teardownInterface_syncEN8dispatch5groupE
extern "C" unsigned int usb_interface_control_teardownInterface_sync(void *a1, void *a2);
static unsigned int (*orig_usb_interface_control_teardownInterface_sync)(void *a1, void *a2);
unsigned int _usb_interface_control_teardownInterface_sync(void *a1, void *a2) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_usb_interface_control_teardownInterface_sync(a1, a2);
} //DYLD_INTERPOSE(_func_name, func_name)

#pragma mark -

void hook_libBasebandUSB() {
//    MSHookFunction((void *)&usb_interface_control_init,
//                   (void *)&_usb_interface_control_init,
//                   (void **)&orig_usb_interface_control_init);

//    MSHookFunction((void *)&usb_interface_control_create,
//                   (void *)&_usb_interface_control_create,
//                   (void **)&orig_usb_interface_control_create);
//    MSHookFunction((void *)&usb_interface_control_control,
//                   (void *)&_usb_interface_control_control,
//                   (void **)&orig_usb_interface_control_control);
    /*
    MSHookFunction((void *)&usb_interface_control_engage,
                   (void *)&_usb_interface_control_engage,
                   (void **)&orig_usb_interface_control_engage);
    MSHookFunction((void *)&usb_interface_control_engageInterface,
                   (void *)&_usb_interface_control_engageInterface,
                   (void **)&orig_usb_interface_control_engageInterface);
    MSHookFunction((void *)&usb_interface_control_engageInterface_sync,
                   (void *)&_usb_interface_control_engageInterface_sync,
                   (void **)&orig_usb_interface_control_engageInterface_sync);
     */
    
    /*
    MSHookFunction((void *)&usb_interface_control_write,
                   (void *)&_usb_interface_control_write,
                   (void **)&orig_usb_interface_control_write);
    MSHookFunction((void *)&usb_interface_control_writeInterface,
                   (void *)&_usb_interface_control_writeInterface,
                   (void **)&orig_usb_interface_control_writeInterface);
     */
    
    /*
    MSHookFunction((void *)&usb_interface_control_queueBulkReadCompletion_sync,
                   (void *)&_usb_interface_control_queueBulkReadCompletion_sync,
                   (void **)&orig_usb_interface_control_queueBulkReadCompletion_sync);
    MSHookFunction((void *)&usb_interface_control_queueBulkWriteCompletion_sync,
                   (void *)&_usb_interface_control_queueBulkWriteCompletion_sync,
                   (void **)&orig_usb_interface_control_queueBulkWriteCompletion_sync);
     */

    /*
    MSHookFunction((void *)&usb_interface_control_dispatchRead_sync,
                   (void *)&_usb_interface_control_dispatchRead_sync,
                   (void **)&orig_usb_interface_control_dispatchRead_sync);
     */
    
    MSHookFunction((void *)&usb_interface_control_queueControlReadCompletion_sync,
                   (void *)&_usb_interface_control_queueControlReadCompletion_sync,
                   (void **)&orig_usb_interface_control_queueControlReadCompletion_sync);

    MSHookFunction((void *)&usb_interface_control_queueControlWriteCompletion_sync,
                   (void *)&_usb_interface_control_queueControlWriteCompletion_sync,
                   (void **)&orig_usb_interface_control_queueControlWriteCompletion_sync);
    
    /*
    MSHookFunction((void *)&usb_interface_control_ioCompletionInternal_sync,
                   (void *)&_usb_interface_control_ioCompletionInternal_sync,
                   (void **)&orig_usb_interface_control_ioCompletionInternal_sync);
     */

    /*
    MSHookFunction((void *)&usb_interface_control_recover,
                   (void *)&_usb_interface_control_recover,
                   (void **)&orig_usb_interface_control_recover);
    MSHookFunction((void *)&usb_interface_control_recoverInterface,
                   (void *)&_usb_interface_control_recoverInterface,
                   (void **)&orig_usb_interface_control_recoverInterface);
    MSHookFunction((void *)&usb_interface_control_teardown,
                   (void *)&_usb_interface_control_teardown,
                   (void **)&orig_usb_interface_control_teardown);
    MSHookFunction((void *)&usb_interface_control_teardownInterface,
                   (void *)&_usb_interface_control_teardownInterface,
                   (void **)&orig_usb_interface_control_teardownInterface);
    MSHookFunction((void *)&usb_interface_control_teardownInterface_sync,
                   (void *)&_usb_interface_control_teardownInterface_sync,
                   (void **)&orig_usb_interface_control_teardownInterface_sync);
     */
}
