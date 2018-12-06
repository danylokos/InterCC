//
//  main.m
//  interCC
//
//  Created by Danylo Kostyshyn on 11/30/18.
//  Copyright © 2018 Danylo Kostyshyn. All rights reserved.
//

// libInter

//  launchctl unload /System/Library/LaunchDaemons/com.apple.CommCenter.plist
//  export DYLD_INSERT_LIBRARIES=/var/root/libInterCC.dylib
//  /System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter

//  to interpose methods inside system dylib
//  extract it using jtool from dyld_shared_cache_armXXX
//  and link to the project

#include "dyld-interposing.h"

#include "qmi.h"
#include "util.h"
#include "colors.h"

#include <stdio.h>
#include <string>

#include <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/IOCFPlugIn.h>
#include <IOKit/usb/IOUSBLib.h>

//#include <xpc/xpc.h>

using namespace qmi;

#define CONSOLE_OUTPUT

#ifdef CONSOLE_OUTPUT
#define DEBUG_LOG                   qmilog("INTER: %s\n", __func__);
#define DEBUG_LOG_COLOR(color)      qmilog("%sINTER: %s%s\n", color, __func__, FGNRM);
#define DEBUG_LOG_RED               DEBUG_LOG_COLOR(FGRED)
#define DEBUG_LOG_BLUE              DEBUG_LOG_COLOR(FGBLU)
#define ENABLE_COLOR(color)         qmilog("%s", color);
#define DISABLE_COLOR               qmilog("%s%s", FGNRM, BGNRM);
#else
#define DEBUG_LOG                   qmilog("INTER: %s\n", __func__);
#define DEBUG_LOG_COLOR(color)      DEBUG_LOG
#define DEBUG_LOG_RED               DEBUG_LOG
#define DEBUG_LOG_BLUE              DEBUG_LOG
#define ENABLE_COLOR(color)
#define DISABLE_COLOR
#endif

#pragma mark -

void hexdumpcc(unsigned char *data, unsigned int amount, const char *color) {
    ENABLE_COLOR(color)
    hexdump(data, amount);
    DISABLE_COLOR
}

void hexdumpc(unsigned char *data, unsigned int amount) {
    hexdumpcc(data, amount, FGCYN);
}

void hexdumpct(unsigned char *data, unsigned int amount) {
//#ifdef CONSOLE_OUTPUT
    unsigned int limit = 128;
    if (amount <= limit) {
        hexdumpc(data, amount);
    } else {
        qmilog("\t-> > %d bytes, truncating\n", limit);
        qmilog("\t-> first %d bytes\n", limit);
        hexdumpc(data, MIN(amount, limit));
        qmilog("\t-> last %d bytes\n", limit);
        hexdumpc(data+amount-limit, limit);
    }
//#else
//    hexdumpc(data, amount);
//#endif
}

#pragma mark - Init

__attribute__((constructor)) void lib_main() {
    qmilog("%slibInter injected%s\n", BGRED, BGNRM);
}

#pragma mark - stdlib

FILE *_fopen(const char *filename, const char *mode) {
    ENABLE_COLOR(FGBLU)
    FILE *file = fopen(filename, mode);
    qmilog("%s(%s, %s) -> %p\n", __func__, filename, mode, file);
    DISABLE_COLOR
    return file;
} DYLD_INTERPOSE(_fopen, fopen)

int _fclose(FILE *file) {
    ENABLE_COLOR(FGBLU)
    qmilog("%s(%p)\n", __func__, file);
    DISABLE_COLOR
    return fclose(file);
} DYLD_INTERPOSE(_fclose, fclose)

#pragma mark - IOKit

kern_return_t
_IOObjectRelease(io_object_t object) {
    DEBUG_LOG_COLOR(FGGRN)
    return IOObjectRelease(object);
} DYLD_INTERPOSE(_IOObjectRelease, IOObjectRelease)

io_service_t
_IOServiceGetMatchingService(mach_port_t masterPort,
                             CFDictionaryRef matching) {
    DEBUG_LOG_COLOR(FGGRN)
    qmilog("\t-> matching: %s\n", ((__bridge NSMutableDictionary *)matching).description.UTF8String);
    return IOServiceGetMatchingService(masterPort, matching);
} DYLD_INTERPOSE(_IOServiceGetMatchingService, IOServiceGetMatchingService)

kern_return_t
_IOServiceGetMatchingServices(mach_port_t masterPort,
                              CFDictionaryRef matching,
                              io_iterator_t *existing) {
    DEBUG_LOG_COLOR(FGGRN)
    qmilog("\t-> matching: %s\n", ((__bridge NSMutableDictionary *)matching).description.UTF8String);
    return IOServiceGetMatchingServices(masterPort, matching, existing);
} DYLD_INTERPOSE(_IOServiceGetMatchingServices, IOServiceGetMatchingServices)

//io_object_t
//_IOIteratorNext(io_iterator_t iterator) {
//    DEBUG_LOG_COLOR(FGGRN)
//    return IOIteratorNext(iterator);
//} DYLD_INTERPOSE(_IOIteratorNext, IOIteratorNext)

kern_return_t
_IOServiceOpen(io_service_t service,
              task_port_t owningTask,
              uint32_t type,
              io_connect_t *connect) {
    DEBUG_LOG_COLOR(FGGRN)
    char entryName[128];
    IORegistryEntryGetName(service, entryName);
    qmilog("\t-> name: %s, service: %d, owningTask: %d\n", entryName, service, owningTask);
    
    kern_return_t result = IOServiceOpen(service, owningTask, type, connect);
    qmilog("\t-> conn: %d, type: 0x%02x\n", *connect, type);
    
    CFMutableDictionaryRef dictRef;
    IORegistryEntryCreateCFProperties(service, &dictRef, kCFAllocatorDefault, 0);
    qmilog("\t-> properties: %s\n", ((__bridge NSMutableDictionary *)dictRef).description.UTF8String);

    return result;
} DYLD_INTERPOSE(_IOServiceOpen, IOServiceOpen)

kern_return_t
_IOServiceClose(io_connect_t connect) {
    DEBUG_LOG_COLOR(FGGRN)
    return IOServiceClose(connect);
} DYLD_INTERPOSE(_IOServiceClose, IOServiceClose)

#pragma IOKit Call Sync Method

kern_return_t
_IOConnectCallMethod(mach_port_t connection,
                     uint32_t selector,
                     const uint64_t *input,
                     uint32_t inputCnt,
                     const void *inputStruct,
                     size_t inputStructCnt,
                     uint64_t *output,
                     uint32_t *outputCnt,
                     void *outputStruct,
                     size_t *outputStructCnt) {
    DEBUG_LOG_COLOR(FGMAG)
    kern_return_t result = IOConnectCallMethod(connection, selector,
                                               input, inputCnt,
                                               inputStruct, inputStructCnt,
                                               output, outputCnt,
                                               outputStruct, outputStructCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (input != NULL) {
        qmilog("\t-> input: %d\n", inputCnt);
        hexdumpct((unsigned char *)input, inputCnt);
    }
    if (inputStruct != NULL) {
        qmilog("\t-> inputStruct: %d\n", inputStructCnt);
        hexdumpct((unsigned char *)inputStruct, inputStructCnt);
    }
    if (output != NULL) {
        qmilog("\t-> output: %d\n", *outputCnt);
        hexdumpct((unsigned char *)output, *outputCnt);
    }
    if (outputStruct != NULL) {
        qmilog("\t-> outputStruct: %d\n", *outputStructCnt);
        hexdumpct((unsigned char *)outputStruct, *outputStructCnt);
    }
    return result;
} DYLD_INTERPOSE(_IOConnectCallMethod, IOConnectCallMethod);

kern_return_t
_IOConnectCallScalarMethod(mach_port_t connection,
                           uint32_t selector,
                           const uint64_t *input,
                           uint32_t inputCnt,
                           uint64_t *output,
                           uint32_t *outputCnt) {
    DEBUG_LOG_COLOR(FGGRN)
    kern_return_t result = IOConnectCallScalarMethod(connection, selector,
                                                     input, inputCnt,
                                                     output, outputCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (input != NULL) {
        qmilog("\t-> input: %d\n", inputCnt);
        hexdumpct((unsigned char *)input, inputCnt);
    }
    if (output != NULL) {
        qmilog("\t-> output: %d\n", *outputCnt);
        hexdumpct((unsigned char *)output, *outputCnt);
    }
    return result;
} DYLD_INTERPOSE(_IOConnectCallScalarMethod, IOConnectCallScalarMethod)

kern_return_t
_IOConnectCallStructMethod(mach_port_t connection,
                           uint32_t selector,
                           const void *inputStruct,
                           size_t inputStructCnt,
                           void *outputStruct,
                           size_t *outputStructCnt) {
    DEBUG_LOG_COLOR(FGGRN)
    kern_return_t result = IOConnectCallStructMethod(connection, selector,
                                                     inputStruct, inputStructCnt,
                                                     outputStruct, outputStructCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (inputStruct != NULL) {
        qmilog("\t-> inputStruct: %d\n", inputStructCnt);
        hexdumpct((unsigned char *)inputStruct, inputStructCnt);
    }
    if (outputStruct != NULL) {
        qmilog("\t-> outputStruct: %d\n", *outputStructCnt);
        hexdumpct((unsigned char *)outputStruct, *outputStructCnt);
    }    return result;
} DYLD_INTERPOSE(_IOConnectCallStructMethod, IOConnectCallStructMethod)

#pragma IOKit Call Async Method

kern_return_t
_IOConnectCallAsyncMethod(mach_port_t connection,
                          uint32_t selector,
                          mach_port_t wake_port,
                          uint64_t *reference,
                          uint32_t referenceCnt,
                          const uint64_t *input,
                          uint32_t inputCnt,
                          const void *inputStruct,
                          size_t inputStructCnt,
                          uint64_t *output,
                          uint32_t *outputCnt,
                          void *outputStruct,
                          size_t *outputStructCnt) {
    DEBUG_LOG_COLOR(FGMAG)
    kern_return_t result = IOConnectCallAsyncMethod(connection, selector,
                                                    wake_port, reference, referenceCnt,
                                                    input, inputCnt,
                                                    inputStruct, inputStructCnt,
                                                    output, outputCnt,
                                                    outputStruct, outputStructCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (input != NULL) {
        qmilog("\t-> input: %d\n", inputCnt);
        hexdumpct((unsigned char *)input, inputCnt);
    }
    if (inputStruct != NULL) {
        qmilog("\t-> inputStruct: %d\n", inputStructCnt);
        hexdumpct((unsigned char *)inputStruct, inputStructCnt);
    }
    if (output != NULL) {
        qmilog("\t-> output: %d\n", *outputCnt);
        hexdumpct((unsigned char *)output, *outputCnt);
    }
    if (outputStruct != NULL) {
        qmilog("\t-> outputStruct: %d\n", *outputStructCnt);
        hexdumpct((unsigned char *)outputStruct, *outputStructCnt);
    }
    return result;
} DYLD_INTERPOSE(_IOConnectCallAsyncMethod, IOConnectCallAsyncMethod);

kern_return_t
_IOConnectCallAsyncScalarMethod(mach_port_t connection,
                                uint32_t selector,
                                mach_port_t wake_port,
                                uint64_t *reference,
                                uint32_t referenceCnt,
                                const uint64_t *input,
                                uint32_t inputCnt,
                                uint64_t *output,
                                uint32_t *outputCnt) {
    DEBUG_LOG_COLOR(FGGRN)
    kern_return_t result = IOConnectCallAsyncScalarMethod(connection, selector,
                                                          wake_port, reference, referenceCnt,
                                                          input, inputCnt,
                                                          output, outputCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (input != NULL) {
        qmilog("\t-> input: %d\n", inputCnt);
        hexdumpct((unsigned char *)input, inputCnt);
    }
    if (output != NULL) {
        qmilog("\t-> output: %d\n", *outputCnt);
        hexdumpct((unsigned char *)output, *outputCnt);
    }
    return result;
} DYLD_INTERPOSE(_IOConnectCallAsyncScalarMethod, IOConnectCallAsyncScalarMethod)

kern_return_t
_IOConnectCallAsyncStructMethod(mach_port_t connection,
                                uint32_t selector,
                                mach_port_t wake_port,
                                uint64_t *reference,
                                uint32_t referenceCnt,
                                const void *inputStruct,
                                size_t inputStructCnt,
                                void *outputStruct,
                                size_t *outputStructCnt) {
    DEBUG_LOG_COLOR(FGGRN)
    kern_return_t result = IOConnectCallAsyncStructMethod(connection, selector,
                                                          wake_port, reference, referenceCnt,
                                                          inputStruct, inputStructCnt,
                                                          outputStruct, outputStructCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (inputStruct != NULL) {
        qmilog("\t-> inputStruct: %d\n", inputStructCnt);
        hexdumpct((unsigned char *)inputStruct, inputStructCnt);
    }
    if (outputStruct != NULL) {
        qmilog("\t-> outputStruct: %d\n", *outputStructCnt);
        hexdumpct((unsigned char *)outputStruct, *outputStructCnt);
    }
    return result;
} DYLD_INTERPOSE(_IOConnectCallAsyncStructMethod, IOConnectCallAsyncStructMethod)

static HRESULT (*original_IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface)(void *thisPointer, REFIID iid, LPVOID *ppv);
HRESULT _IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface(void *thisPointer, REFIID iid, LPVOID *ppv);

static HRESULT (*original_IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface)(void *thisPointer, REFIID iid, LPVOID *ppv);
HRESULT _IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface(void *thisPointer, REFIID iid, LPVOID *ppv);

kern_return_t
_IOCreatePlugInInterfaceForService(io_service_t service,
                                   CFUUIDRef pluginType,
                                   CFUUIDRef interfaceType,
                                   IOCFPlugInInterface ***theInterface,
                                   SInt32 *theScore) {
    DEBUG_LOG_COLOR(FGGRN)
    qmilog("\t-> service: %d, pluginType: %s, interfaceType: %s\n", service,
           CFStringGetCStringPtr(CFUUIDCreateString(kCFAllocatorDefault, pluginType), kCFStringEncodingASCII),
           CFStringGetCStringPtr(CFUUIDCreateString(kCFAllocatorDefault, interfaceType), kCFStringEncodingASCII));
    kern_return_t result = IOCreatePlugInInterfaceForService(service, pluginType, interfaceType, theInterface, theScore);
    if (CFStringCompare(CFUUIDCreateString(kCFAllocatorDefault, pluginType),
                        CFUUIDCreateString(kCFAllocatorDefault, kIOUSBDeviceUserClientTypeID), 0) == kCFCompareEqualTo) {
        original_IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface = (**theInterface)->QueryInterface;
        (**theInterface)->QueryInterface = _IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface;
    } else if (CFStringCompare(CFUUIDCreateString(kCFAllocatorDefault, pluginType),
                               CFUUIDCreateString(kCFAllocatorDefault, kIOUSBInterfaceUserClientTypeID), 0) == kCFCompareEqualTo) {
        original_IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface = (**theInterface)->QueryInterface;
        (**theInterface)->QueryInterface = _IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface;
    }
    return result;
} DYLD_INTERPOSE(_IOCreatePlugInInterfaceForService, IOCreatePlugInInterfaceForService)

kern_return_t
_IODestroyPlugInInterface(IOCFPlugInInterface **interface) {
    DEBUG_LOG_COLOR(FGGRN)
    return IODestroyPlugInInterface(interface);
} DYLD_INTERPOSE(_IODestroyPlugInInterface, IODestroyPlugInInterface)

//kern_return_t
//_IOCreateReceivePort(uint32_t msgType, mach_port_t *recvPort) {
//    DEBUG_LOG_RED
//    return IOCreateReceivePort(msgType, recvPort);
//} DYLD_INTERPOSE(_IOCreateReceivePort, IOCreateReceivePort)

#pragma mark - IOCFPlugInInterface

static IOReturn (*original_IOUSBDeviceInterface_USBDeviceOpen)(void *self);
IOReturn _IOUSBDeviceInterface_USBDeviceOpen(void *self);

static IOReturn (*original_IOUSBDeviceInterface_USBDeviceClose)(void *self);
IOReturn _IOUSBDeviceInterface_USBDeviceClose(void *self);

static IOReturn (*original_IOUSBDeviceInterface_GetNumberOfConfigurations)(void *self, UInt8 *numConfig);
IOReturn _IOUSBDeviceInterface_GetNumberOfConfigurations(void *self, UInt8 *numConfig);

static IOReturn (*original_IOUSBDeviceInterface_GetConfiguration)(void *self, UInt8 *configNum);
IOReturn _IOUSBDeviceInterface_GetConfiguration(void *self, UInt8 *configNum);

static IOReturn (*original_IOUSBDeviceInterface_SetConfiguration)(void *self, UInt8 configNum);
IOReturn _IOUSBDeviceInterface_SetConfiguration(void *self, UInt8 configNum);

static IOReturn (*original_IOUSBDeviceInterface_CreateInterfaceIterator)(void *self, IOUSBFindInterfaceRequest *req, io_iterator_t *iter);
IOReturn _IOUSBDeviceInterface_CreateInterfaceIterator(void *self, IOUSBFindInterfaceRequest *req, io_iterator_t *iter);

HRESULT _IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface(void *thisPointer, REFIID iid, LPVOID *ppv) {
    DEBUG_LOG_COLOR(FGYEL)
    HRESULT result = original_IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface(thisPointer, iid, ppv);
    IOUSBDeviceInterface *device = **(IOUSBDeviceInterface ***)ppv;
    
    original_IOUSBDeviceInterface_USBDeviceOpen = device->USBDeviceOpen;
    device->USBDeviceOpen = _IOUSBDeviceInterface_USBDeviceOpen;
    
    original_IOUSBDeviceInterface_USBDeviceClose = device->USBDeviceClose;
    device->USBDeviceClose = _IOUSBDeviceInterface_USBDeviceClose;

    original_IOUSBDeviceInterface_GetNumberOfConfigurations = device->GetNumberOfConfigurations;
    device->GetNumberOfConfigurations = _IOUSBDeviceInterface_GetNumberOfConfigurations;

    original_IOUSBDeviceInterface_GetConfiguration = device->GetConfiguration;
    device->GetConfiguration = _IOUSBDeviceInterface_GetConfiguration;

    original_IOUSBDeviceInterface_SetConfiguration = device->SetConfiguration;
    device->SetConfiguration = _IOUSBDeviceInterface_SetConfiguration;

    original_IOUSBDeviceInterface_CreateInterfaceIterator = device->CreateInterfaceIterator;
    device->CreateInterfaceIterator = _IOUSBDeviceInterface_CreateInterfaceIterator;

    return result;
}

#pragma mark -

static IOReturn (*original_IOUSBInterfaceInterface_USBInterfaceOpen)(void *self);
IOReturn _IOUSBInterfaceInterface_USBInterfaceOpen(void *self);

static IOReturn (*original_IOUSBInterfaceInterface_USBInterfaceClose)(void *self);
IOReturn _IOUSBInterfaceInterface_USBInterfaceClose(void *self);

static IOReturn (*original_IOUSBInterfaceInterface_GetInterfaceNumber)(void *self, UInt8 *intfNumber);
IOReturn _IOUSBInterfaceInterface_GetInterfaceNumber(void *self, UInt8 *intfNumber);

static IOReturn (*original_IOUSBInterfaceInterface_ControlRequest)(void *self, UInt8 pipeRef, IOUSBDevRequest *req);
IOReturn _IOUSBInterfaceInterface_ControlRequest(void *self, UInt8 pipeRef, IOUSBDevRequest *req);

static IOReturn (*original_IOUSBInterfaceInterface_ReadPipe)(void *self, UInt8 pipeRef, void *buf, UInt32 *size);
IOReturn _IOUSBInterfaceInterface_ReadPipe(void *self, UInt8 pipeRef, void *buf, UInt32 *size);

static IOReturn (*original_IOUSBInterfaceInterface_WritePipe)(void *self, UInt8 pipeRef, void *buf, UInt32 size);
IOReturn _IOUSBInterfaceInterface_WritePipe(void *self, UInt8 pipeRef, void *buf, UInt32 size);

HRESULT _IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface(void *thisPointer, REFIID iid, LPVOID *ppv) {
    DEBUG_LOG_COLOR(FGYEL)
    HRESULT result = original_IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface(thisPointer, iid, ppv);
    IOUSBInterfaceStruct *iface = **(IOUSBInterfaceStruct ***)ppv;

    original_IOUSBInterfaceInterface_USBInterfaceOpen = iface->USBInterfaceOpen;
    iface->USBInterfaceOpen = _IOUSBInterfaceInterface_USBInterfaceOpen;
    
    original_IOUSBInterfaceInterface_USBInterfaceClose = iface->USBInterfaceClose;
    iface->USBInterfaceClose = _IOUSBInterfaceInterface_USBInterfaceClose;

    original_IOUSBInterfaceInterface_GetInterfaceNumber = iface->GetInterfaceNumber;
    iface->GetInterfaceNumber = _IOUSBInterfaceInterface_GetInterfaceNumber;

    original_IOUSBInterfaceInterface_ControlRequest = iface->ControlRequest;
    iface->ControlRequest = _IOUSBInterfaceInterface_ControlRequest;

    original_IOUSBInterfaceInterface_ReadPipe = iface->ReadPipe;
    iface->ReadPipe = _IOUSBInterfaceInterface_ReadPipe;

    original_IOUSBInterfaceInterface_WritePipe = iface->WritePipe;
    iface->WritePipe = _IOUSBInterfaceInterface_WritePipe;

    return result;
}

#pragma mark - IOUSBDeviceInterface

IOReturn _IOUSBDeviceInterface_USBDeviceOpen(void *self) {
    DEBUG_LOG_COLOR(FGYEL)
    return original_IOUSBDeviceInterface_USBDeviceOpen(self);
}

IOReturn _IOUSBDeviceInterface_USBDeviceClose(void *self) {
    DEBUG_LOG_COLOR(FGYEL)
    return original_IOUSBDeviceInterface_USBDeviceClose(self);
}

IOReturn _IOUSBDeviceInterface_GetNumberOfConfigurations(void *self, UInt8 *numConfig) {
    DEBUG_LOG_COLOR(FGYEL)
    IOReturn result = original_IOUSBDeviceInterface_GetNumberOfConfigurations(self, numConfig);
    printf("\t-> numConfig: %d\n", *numConfig);
    return result;
}

IOReturn _IOUSBDeviceInterface_GetConfiguration(void *self, UInt8 *configNum) {
    DEBUG_LOG_COLOR(FGYEL)
    IOReturn result = original_IOUSBDeviceInterface_GetConfiguration(self, configNum);
    printf("\t-> configNum: %d\n", *configNum);
    return result;
}

IOReturn _IOUSBDeviceInterface_SetConfiguration(void *self, UInt8 configNum) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> configNum: %d\n", configNum);
    return original_IOUSBDeviceInterface_SetConfiguration(self, configNum);
}

IOReturn _IOUSBDeviceInterface_CreateInterfaceIterator(void *self, IOUSBFindInterfaceRequest *req, io_iterator_t *iter) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> bInterfaceClass: %d, bInterfaceSubClass: %d, bInterfaceProtocol: %d, bAlternateSetting: %d\n",
           req->bInterfaceClass, req->bInterfaceSubClass, req->bInterfaceProtocol, req->bAlternateSetting);
    return original_IOUSBDeviceInterface_CreateInterfaceIterator(self, req, iter);
}

#pragma mark - IOUSBInterfaceInterface

IOReturn _IOUSBInterfaceInterface_USBInterfaceOpen(void *self) {
    DEBUG_LOG_COLOR(FGYEL)
    return original_IOUSBInterfaceInterface_USBInterfaceOpen(self);
}

IOReturn _IOUSBInterfaceInterface_USBInterfaceClose(void *self) {
    DEBUG_LOG_COLOR(FGYEL)
    return original_IOUSBInterfaceInterface_USBInterfaceClose(self);
}

IOReturn _IOUSBInterfaceInterface_GetInterfaceNumber(void *self, UInt8 *intfNumber) {
    DEBUG_LOG_COLOR(FGYEL)
    IOReturn result = original_IOUSBInterfaceInterface_GetInterfaceNumber(self, intfNumber);
    printf("\t-> intfNumber: %d\n", *intfNumber);
    return result;
}

IOReturn _IOUSBInterfaceInterface_ControlRequest(void *self, UInt8 pipeRef, IOUSBDevRequest *req) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> bmRequestType: %d, bRequest: %d, wValue: %d, wLength: %d\n",
           req->bmRequestType, req->bRequest, req->wValue, req->wLength);
    printf("\t-> pData: %d\n", req->wLength);
    hexdumpcc((unsigned char *)req->pData, req->wLength, FGYEL);
    return original_IOUSBInterfaceInterface_ControlRequest(self, pipeRef, req);
}

IOReturn _IOUSBInterfaceInterface_ReadPipe(void *self, UInt8 pipeRef, void *buf, UInt32 *size) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> pipeRef: %d\n", pipeRef);
    IOReturn result = original_IOUSBInterfaceInterface_ReadPipe(self, pipeRef, buf, size);
    hexdumpcc((unsigned char *)buf, *size, FGYEL);
    return result;
}

IOReturn _IOUSBInterfaceInterface_WritePipe(void *self, UInt8 pipeRef, void *buf, UInt32 size) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> pipeRef: %d\n", pipeRef);
    hexdumpcc((unsigned char *)buf, size, FGYEL);
    return original_IOUSBInterfaceInterface_WritePipe(self, pipeRef, buf, size);
}

#pragma mark - libATCommandStudioDynamic

//typedef struct xpc_connection_s * xpc_connection_t;
//#define qmi_Client_create _ZN3qmi6Client6createERKNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEENS_11ServiceTypeEP16dispatch_queue_sS9_P17_xpc_connection_s
//extern "C" unsigned int qmi_Client_create(void *a1, std::string const &a2, qmi::ServiceType a3, dispatch_queue_t a4, std::string const &a5, xpc_connection_t a6);
//unsigned int _qmi_Client_create(void *a1, std::string const &a2, qmi::ServiceType a3, dispatch_queue_t a4, std::string const &a5, xpc_connection_t a6) {
//    DEBUG_LOG_COLOR(FGYEL)
//    qmilog("\t-> qmi::Client::create %p\n", a1);
//    qmilog("\t-> a2: %s, a3: 0x%02x (%d), a5: %s\n", a2.c_str(), a3, a3, a5.c_str());
//    return qmi_Client_create(a1, a2, a3, a4, a5, a6);
//} DYLD_INTERPOSE(_qmi_Client_create, qmi_Client_create)

//#define QMIClient_requestClient _ZN9QMIClient13requestClientERKNSt3__112basic_stringIcNS0_11char_traitsIcEENS0_9allocatorIcEEEEN3qmi11ServiceTypeERK4QMuxP17QMIClientCallbackbb
//extern "C" unsigned int QMIClient_requestClient(void *a1, std::string const &a2, qmi::ServiceType a3, QMux const &a4, QMIClientCallback *a5, bool a6, bool a7);
//unsigned int _QMIClient_requestClient(void *a1, std::string const &a2, qmi::ServiceType a3, QMux const &a4, QMIClientCallback *a5, bool a6, bool a7) {
//    DEBUG_LOG_RED
//    qmilog("\t-> QMIClient::requestClient %p\n", a1);
//    return QMIClient_requestClient(a1, a2, a3, a4, a5, a6, a7);
//} DYLD_INTERPOSE(_QMIClient_requestClient, QMIClient_requestClient)

//#define QMux_QMux _ZN4QMuxC1EP13ATCSIPCDriverPvRKNSt3__112basic_stringIcNS3_11char_traitsIcEENS3_9allocatorIcEEEEP16ATCSResetInvokerbb
//extern "C" unsigned int QMux_QMux(void *a1, ATCSIPCDriver *a2, void *a3, std::string const &a4, ATCSResetInvoker *a5, bool a6, bool a7);
//unsigned int _QMux_QMux(void *a1, ATCSIPCDriver *a2, void *a3, std::string const &a4, ATCSResetInvoker *a5, bool a6, bool a7) {
//    DEBUG_LOG
//    return QMux_QMux(a1, a2, a3, a4, a5, a6, a7);
//} DYLD_INTERPOSE(_QMux_QMux, QMux_QMux)

//#define qmi_Client_Client _ZN3qmi6ClientC1ERKNSt3__18weak_ptrINS0_5StateEEE
//typedef unsigned int qmi_Client_State;
//extern "C" unsigned int qmi_Client_Client(void *a1, qmi_Client_State a2);
//unsigned int _qmi_Client_Client(void *a1, qmi_Client_State a2) {
//    DEBUG_LOG
//    qmilog("\t-> qmi::Client::Client() %p\n", a1);
//    return qmi_Client_Client(a1, a2);
//} DYLD_INTERPOSE(_qmi_Client_Client, qmi_Client_Client)
//
//#define qmi_Client_dealloc _ZN3qmi6ClientD1Ev
//extern "C" unsigned int qmi_Client_dealloc(void *a1);
//unsigned int _qmi_Client_dealloc(void *a1) {
//    DEBUG_LOG
//    qmilog("\t-> qmi::Client::~Client() %p\n", a1);
//    return qmi_Client_dealloc(a1);
//} DYLD_INTERPOSE(_qmi_Client_dealloc, qmi_Client_dealloc)

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

//#define qmi_Client_start _ZNK3qmi6Client5startEv
//extern "C" unsigned int qmi_Client_start(void *a1);
//unsigned int _qmi_Client_start(void *a1) {
//    DEBUG_LOG
//    qmilog("\t-> qmi::Client::start %p\n", a1);
//    return qmi_Client_start(a1);
//} DYLD_INTERPOSE(_qmi_Client_start, qmi_Client_start)

// stop

// #define qmi_Client_stop _ZNK3qmi6Client4stopEv
// extern "C" unsigned int qmi_Client_stop(void *a1);
// unsigned int _qmi_Client_stop(void *a1) {
//     DEBUG_LOG
//     qmilog("\t-> qmi::Client::stop %p\n", a1);
//     return qmi_Client_stop(a1);
// } DYLD_INTERPOSE(_qmi_Client_stop, qmi_Client_stop)

// getName

// #define qmi_Client_getName _ZNK3qmi6Client7getNameEv
// extern "C" void * qmi_Client_getName(void *a1);
// void * _qmi_Client_getName(void *a1) {
//     DEBUG_LOG
//     qmilog("\t-> qmi::Client::getName %p\n", a1);
//     return qmi_Client_getName(a1);
// } DYLD_INTERPOSE(_qmi_Client_getName, qmi_Client_getName)

// getSvcType

//#define qmi_Client_getSvcType _ZNK3qmi6Client10getSvcTypeEv
//extern "C" unsigned int qmi_Client_getSvcType(void *a1);
//unsigned int _qmi_Client_getSvcType(void *a1) {
//    DEBUG_LOG
//    unsigned int result = qmi_Client_getSvcType(a1);
//    qmilog("\t-> qmi::Client::getSvcType %p 0x%02x (%d)\n", a1, result, result);
//    return result;
//} DYLD_INTERPOSE(_qmi_Client_getSvcType, qmi_Client_getSvcType)

//#define qmi_Client_send _ZNK3qmi6Client4sendERNS0_9SendProxyE
//extern "C" unsigned int qmi_Client_send(void *a1, void *a2);
//unsigned int _qmi_Client_send(void *a1, void *a2) {
//    DEBUG_LOG
//    return qmi_Client_send(a1, a2);
//} DYLD_INTERPOSE(_qmi_Client_send, qmi_Client_send)

#pragma mark - libQMIParserDynamic

//#define qmi_MessageBase_MessageBase _ZN3qmi11MessageBaseC2EPKvm
//extern "C" unsigned int qmi_MessageBase_MessageBase(void const *a1, unsigned long a2);
//unsigned int _qmi_MessageBase_MessageBase(void const *a1, unsigned long a2) {
//    DEBUG_LOG_RED
//    return qmi_MessageBase_MessageBase(a1, a2);
//} DYLD_INTERPOSE(_qmi_MessageBase_MessageBase, qmi_MessageBase_MessageBase)

//#define qmi_ResponseBase_ResponseBase _ZN3qmi12ResponseBaseC1EPKvm
//extern "C" unsigned int qmi_ResponseBase_ResponseBase(void const *a1, unsigned long a2);
//unsigned int _qmi_ResponseBase_ResponseBase(void const *a1, unsigned long a2) {
//    DEBUG_LOG_RED
//    return qmi_ResponseBase_ResponseBase(a1, a2);
//} DYLD_INTERPOSE(_qmi_ResponseBase_ResponseBase, qmi_ResponseBase_ResponseBase)

//#define qmi_ResponseBase_ResponseBase2 _ZN3qmi12ResponseBaseC2EPKvm
//extern "C" unsigned int qmi_ResponseBase_ResponseBase2(void const *a1, unsigned long a2);
//unsigned int _qmi_ResponseBase_ResponseBase2(void const *a1, unsigned long a2) {
//    DEBUG_LOG_RED
//    return qmi_ResponseBase_ResponseBase2(a1, a2);
//} DYLD_INTERPOSE(_qmi_ResponseBase_ResponseBase2, qmi_ResponseBase_ResponseBase2)

#pragma mark - libBasebandUSB

//typedef struct usb_shim_paramteres usb_shim_paramteres;
//#define usb_shim_create _ZN3usb4shim6createERKNS0_10paramteresE
//extern "C" unsigned int usb_shim_create(void *a1, usb_shim_paramteres const &a2);
//unsigned int _usb_shim_create(void *a1, usb_shim_paramteres const &a2) {
//    DEBUG_LOG_RED
//    return usb_shim_create(a1, a2);
//} DYLD_INTERPOSE(_usb_shim_create, usb_shim_create)
//
//#define usb_interface_control_init _ZN3usb9interface7control4initEv
//extern "C" unsigned int usb_interface_control_init(void *a1);
//unsigned int _usb_interface_control_init(void *a1) {
//    DEBUG_LOG_RED
//    return usb_interface_control_init(a1);
//} DYLD_INTERPOSE(_usb_interface_control_init, usb_interface_control_init)
//
//typedef struct usb_interface_control_parameters usb_interface_control_parameters;
//#define usb_interface_control_create _ZN3usb9interface7control6createERKNS1_10parametersE
//extern "C" unsigned int usb_interface_control_create(void *a1, usb_interface_control_parameters const &a2);
//unsigned int _usb_interface_control_create(void *a1, usb_interface_control_parameters const &a2) {
//    DEBUG_LOG_RED
//    return usb_interface_control_create(a1, a2);
//} DYLD_INTERPOSE(_usb_interface_control_create, usb_interface_control_create)

//#define usb_interface_control_writeInterface _ZN3usb9interface7control14writeInterfaceERKP15dispatch_data_sRKN8dispatch5blockIU13block_pointerFvbEEE
//extern "C" unsigned int usb_interface_control_writeInterface(void *a1, void *a2, void *a3);
//unsigned int _usb_interface_control_writeInterface(void *a1, void *a2, void *a3) {
//    DEBUG_LOG_RED
//    return usb_interface_control_writeInterface(a1, a2, a3);
//} DYLD_INTERPOSE(_usb_interface_control_writeInterface, usb_interface_control_writeInterface)
//
//#define usb_interface_control_write _ZN3usb9interface7control5writeERKP15dispatch_data_sRKN8dispatch5blockIU13block_pointerFvbEEE
//extern "C" unsigned int usb_interface_control_write(void *a1, void *a2, void *a3);
//unsigned int _usb_interface_control_write(void *a1, void *a2, void *a3) {
//    DEBUG_LOG_RED
//    return usb_interface_control_write(a1, a2, a3);
//} DYLD_INTERPOSE(_usb_interface_control_write, usb_interface_control_write)

#pragma mark - libBasebandManager

//extern "C" unsigned int ETLDLOADCommandSend(void *a1);
//unsigned int _ETLDLOADCommandSend(void *a1) {
//    DEBUG_LOG_RED
//    return ETLDLOADCommandSend(a1);
//} DYLD_INTERPOSE(_ETLDLOADCommandSend, ETLDLOADCommandSend)

#pragma mark - XPC

//extern "C" xpc_connection_t _xpc_connection_create(const char *name, dispatch_queue_t targetq) {
//    DEBUG_LOG
//    qmilog("\t-> xpc_connection_create name: %s\n", name);
//    return xpc_connection_create(name, targetq);
//} DYLD_INTERPOSE(_xpc_connection_create, xpc_connection_create)

// crashing
//extern "C" xpc_endpoint_t _xpc_endpoint_create(xpc_connection_t connection) {
//    DEBUG_LOG_RED
//    return xpc_endpoint_create(connection);
//} DYLD_INTERPOSE(_xpc_endpoint_create, xpc_endpoint_create)
