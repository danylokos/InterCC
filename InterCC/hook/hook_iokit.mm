//
//  hook_iokit.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "hook_iokit.h"

#include "util.h"
#include <substrate.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/IOCFPlugIn.h>
#include <IOKit/usb/IOUSBLib.h>

static kern_return_t
(*orig_IOObjectRelease)(io_object_t object);

kern_return_t
_IOObjectRelease(io_object_t object) {
    DEBUG_LOG_COLOR(FGGRN)
    return orig_IOObjectRelease(object);
} //DYLD_INTERPOSE(_IOObjectRelease, IOObjectRelease)

static io_service_t
(*orig_IOServiceGetMatchingService)(mach_port_t masterPort,
                                    CFDictionaryRef matching);

io_service_t
_IOServiceGetMatchingService(mach_port_t masterPort,
                             CFDictionaryRef matching) {
    DEBUG_LOG_COLOR(FGGRN)
    qmilog("\t-> matching: %s\n", ((__bridge NSMutableDictionary *)matching).description.UTF8String);
    return orig_IOServiceGetMatchingService(masterPort, matching);
} //DYLD_INTERPOSE(_IOServiceGetMatchingService, IOServiceGetMatchingService)

static kern_return_t
(*orig_IOServiceGetMatchingServices)(mach_port_t masterPort,
                                     CFDictionaryRef matching,
                                     io_iterator_t *existing);

kern_return_t
_IOServiceGetMatchingServices(mach_port_t masterPort,
                              CFDictionaryRef matching,
                              io_iterator_t *existing) {
    DEBUG_LOG_COLOR(FGGRN)
    qmilog("\t-> matching: %s\n", ((__bridge NSMutableDictionary *)matching).description.UTF8String);
    return orig_IOServiceGetMatchingServices(masterPort, matching, existing);
} //DYLD_INTERPOSE(_IOServiceGetMatchingServices, IOServiceGetMatchingServices)

//io_object_t
//_IOIteratorNext(io_iterator_t iterator) {
//    DEBUG_LOG_COLOR(FGGRN)
//    return IOIteratorNext(iterator);
//} DYLD_INTERPOSE(_IOIteratorNext, IOIteratorNext)

static kern_return_t
(*orig_IOServiceOpen)(io_service_t service,
                      task_port_t owningTask,
                      uint32_t type,
                      io_connect_t *connect);

kern_return_t
_IOServiceOpen(io_service_t service,
               task_port_t owningTask,
               uint32_t type,
               io_connect_t *connect) {
    DEBUG_LOG_COLOR(FGGRN)
    char entryName[128];
    IORegistryEntryGetName(service, entryName);
    qmilog("\t-> name: %s, service: %d, owningTask: %d\n", entryName, service, owningTask);
    
    kern_return_t result = orig_IOServiceOpen(service, owningTask, type, connect);
    qmilog("\t-> conn: %d, type: 0x%02x\n", *connect, type);
    
    CFMutableDictionaryRef dictRef;
    IORegistryEntryCreateCFProperties(service, &dictRef, kCFAllocatorDefault, 0);
    qmilog("\t-> properties: %s\n", ((__bridge NSMutableDictionary *)dictRef).description.UTF8String);
    
    return result;
} //DYLD_INTERPOSE(_IOServiceOpen, IOServiceOpen)

static kern_return_t
(*orig_IOServiceClose)(io_connect_t connect);

kern_return_t
_IOServiceClose(io_connect_t connect) {
    DEBUG_LOG_COLOR(FGGRN)
    return orig_IOServiceClose(connect);
} //DYLD_INTERPOSE(_IOServiceClose, IOServiceClose)

#pragma IOKit Call Sync Method

static kern_return_t
(*orig_IOConnectCallMethod)(mach_port_t connection,
                            uint32_t selector,
                            const uint64_t *input,
                            uint32_t inputCnt,
                            const void *inputStruct,
                            size_t inputStructCnt,
                            uint64_t *output,
                            uint32_t *outputCnt,
                            void *outputStruct,
                            size_t *outputStructCnt);

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
    kern_return_t result = orig_IOConnectCallMethod(connection, selector,
                                                    input, inputCnt,
                                                    inputStruct, inputStructCnt,
                                                    output, outputCnt,
                                                    outputStruct, outputStructCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (input != NULL) {
        qmilog("\t-> input: %d\n", inputCnt);
        hexdumpct((uint8_t *)input, inputCnt);
    }
    if (inputStruct != NULL) {
        qmilog("\t-> inputStruct: %d\n", inputStructCnt);
        hexdumpct((uint8_t *)inputStruct, inputStructCnt);
    }
    if (output != NULL) {
        qmilog("\t-> output: %d\n", *outputCnt);
        hexdumpct((uint8_t *)output, *outputCnt);
    }
    if (outputStruct != NULL) {
        qmilog("\t-> outputStruct: %d\n", *outputStructCnt);
        hexdumpct((uint8_t *)outputStruct, *outputStructCnt);
    }
    return result;
} //DYLD_INTERPOSE(_IOConnectCallMethod, IOConnectCallMethod);

static kern_return_t
(*orig_IOConnectCallScalarMethod)(mach_port_t connection,
                                  uint32_t selector,
                                  const uint64_t *input,
                                  uint32_t inputCnt,
                                  uint64_t *output,
                                  uint32_t *outputCnt);

kern_return_t
_IOConnectCallScalarMethod(mach_port_t connection,
                           uint32_t selector,
                           const uint64_t *input,
                           uint32_t inputCnt,
                           uint64_t *output,
                           uint32_t *outputCnt) {
    DEBUG_LOG_COLOR(FGGRN)
    kern_return_t result = orig_IOConnectCallScalarMethod(connection, selector,
                                                          input, inputCnt,
                                                          output, outputCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (input != NULL) {
        qmilog("\t-> input: %d\n", inputCnt);
        hexdumpct((uint8_t *)input, inputCnt);
    }
    if (output != NULL) {
        qmilog("\t-> output: %d\n", *outputCnt);
        hexdumpct((uint8_t *)output, *outputCnt);
    }
    return result;
} //DYLD_INTERPOSE(_IOConnectCallScalarMethod, IOConnectCallScalarMethod)

static kern_return_t
(*orig_IOConnectCallStructMethod)(mach_port_t connection,
                                  uint32_t selector,
                                  const void *inputStruct,
                                  size_t inputStructCnt,
                                  void *outputStruct,
                                  size_t *outputStructCnt);

kern_return_t
_IOConnectCallStructMethod(mach_port_t connection,
                           uint32_t selector,
                           const void *inputStruct,
                           size_t inputStructCnt,
                           void *outputStruct,
                           size_t *outputStructCnt) {
    DEBUG_LOG_COLOR(FGGRN)
    kern_return_t result = orig_IOConnectCallStructMethod(connection, selector,
                                                          inputStruct, inputStructCnt,
                                                          outputStruct, outputStructCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (inputStruct != NULL) {
        qmilog("\t-> inputStruct: %d\n", inputStructCnt);
        hexdumpct((uint8_t *)inputStruct, inputStructCnt);
    }
    if (outputStruct != NULL) {
        qmilog("\t-> outputStruct: %d\n", *outputStructCnt);
        hexdumpct((uint8_t *)outputStruct, *outputStructCnt);
    }    return result;
} //DYLD_INTERPOSE(_IOConnectCallStructMethod, IOConnectCallStructMethod)

#pragma IOKit Call Async Method

static kern_return_t
(*orig_IOConnectCallAsyncMethod)(mach_port_t connection,
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
                                 size_t *outputStructCnt);

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
    kern_return_t result = orig_IOConnectCallAsyncMethod(connection, selector,
                                                         wake_port, reference, referenceCnt,
                                                         input, inputCnt,
                                                         inputStruct, inputStructCnt,
                                                         output, outputCnt,
                                                         outputStruct, outputStructCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (input != NULL) {
        qmilog("\t-> input: %d\n", inputCnt);
        hexdumpct((uint8_t *)input, inputCnt);
    }
    if (inputStruct != NULL) {
        qmilog("\t-> inputStruct: %d\n", inputStructCnt);
        hexdumpct((uint8_t *)inputStruct, inputStructCnt);
    }
    if (output != NULL) {
        qmilog("\t-> output: %d\n", *outputCnt);
        hexdumpct((uint8_t *)output, *outputCnt);
    }
    if (outputStruct != NULL) {
        qmilog("\t-> outputStruct: %d\n", *outputStructCnt);
        hexdumpct((uint8_t *)outputStruct, *outputStructCnt);
    }
    return result;
} //DYLD_INTERPOSE(_IOConnectCallAsyncMethod, IOConnectCallAsyncMethod);

static kern_return_t
(*orig_IOConnectCallAsyncScalarMethod)(mach_port_t connection,
                                       uint32_t selector,
                                       mach_port_t wake_port,
                                       uint64_t *reference,
                                       uint32_t referenceCnt,
                                       const uint64_t *input,
                                       uint32_t inputCnt,
                                       uint64_t *output,
                                       uint32_t *outputCnt);

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
    kern_return_t result = orig_IOConnectCallAsyncScalarMethod(connection, selector,
                                                               wake_port, reference, referenceCnt,
                                                               input, inputCnt,
                                                               output, outputCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (input != NULL) {
        qmilog("\t-> input: %d\n", inputCnt);
        hexdumpct((uint8_t *)input, inputCnt);
    }
    if (output != NULL) {
        qmilog("\t-> output: %d\n", *outputCnt);
        hexdumpct((uint8_t *)output, *outputCnt);
    }
    return result;
} //DYLD_INTERPOSE(_IOConnectCallAsyncScalarMethod, IOConnectCallAsyncScalarMethod)

static kern_return_t
(*orig_IOConnectCallAsyncStructMethod)(mach_port_t connection,
                                       uint32_t selector,
                                       mach_port_t wake_port,
                                       uint64_t *reference,
                                       uint32_t referenceCnt,
                                       const void *inputStruct,
                                       size_t inputStructCnt,
                                       void *outputStruct,
                                       size_t *outputStructCnt);

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
    kern_return_t result = orig_IOConnectCallAsyncStructMethod(connection, selector,
                                                               wake_port, reference, referenceCnt,
                                                               inputStruct, inputStructCnt,
                                                               outputStruct, outputStructCnt);
    qmilog("\t-> sel: 0x%02x, conn: %d\n", selector, connection);
    if (inputStruct != NULL) {
        qmilog("\t-> inputStruct: %d\n", inputStructCnt);
        hexdumpct((uint8_t *)inputStruct, inputStructCnt);
    }
    if (outputStruct != NULL) {
        qmilog("\t-> outputStruct: %d\n", *outputStructCnt);
        hexdumpct((uint8_t *)outputStruct, *outputStructCnt);
    }
    return result;
} //DYLD_INTERPOSE(_IOConnectCallAsyncStructMethod, IOConnectCallAsyncStructMethod)

#pragma mark -

static HRESULT (*orig_IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface)(void *thisPointer, REFIID iid, LPVOID *ppv);
HRESULT _IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface(void *thisPointer, REFIID iid, LPVOID *ppv);

static HRESULT (*orig_IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface)(void *thisPointer, REFIID iid, LPVOID *ppv);
HRESULT _IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface(void *thisPointer, REFIID iid, LPVOID *ppv);

static kern_return_t
(*orig_IOCreatePlugInInterfaceForService)(io_service_t service,
                                          CFUUIDRef pluginType,
                                          CFUUIDRef interfaceType,
                                          IOCFPlugInInterface ***theInterface,
                                          SInt32 *theScore);

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
    kern_return_t result = orig_IOCreatePlugInInterfaceForService(service, pluginType, interfaceType, theInterface, theScore);
    if (CFStringCompare(CFUUIDCreateString(kCFAllocatorDefault, pluginType),
                        CFUUIDCreateString(kCFAllocatorDefault, kIOUSBDeviceUserClientTypeID), 0) == kCFCompareEqualTo) {
        if ((**theInterface)->QueryInterface != _IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface) {
            orig_IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface = (**theInterface)->QueryInterface;
            (**theInterface)->QueryInterface = _IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface;
        }
    } else if (CFStringCompare(CFUUIDCreateString(kCFAllocatorDefault, pluginType),
                               CFUUIDCreateString(kCFAllocatorDefault, kIOUSBInterfaceUserClientTypeID), 0) == kCFCompareEqualTo) {
        if ((**theInterface)->QueryInterface != _IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface) {
            orig_IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface = (**theInterface)->QueryInterface;
            (**theInterface)->QueryInterface = _IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface;
        }
    }
    return result;
} //DYLD_INTERPOSE(_IOCreatePlugInInterfaceForService, IOCreatePlugInInterfaceForService)

static kern_return_t
(*orig_IODestroyPlugInInterface)(IOCFPlugInInterface **interface);

kern_return_t
_IODestroyPlugInInterface(IOCFPlugInInterface **interface) {
    DEBUG_LOG_COLOR(FGGRN)
    return orig_IODestroyPlugInInterface(interface);
} //DYLD_INTERPOSE(_IODestroyPlugInInterface, IODestroyPlugInInterface)

//kern_return_t
//_IOCreateReceivePort(uint32_t msgType, mach_port_t *recvPort) {
//    DEBUG_LOG_RED
//    return IOCreateReceivePort(msgType, recvPort);
//} DYLD_INTERPOSE(_IOCreateReceivePort, IOCreateReceivePort)

#pragma mark - IOCFPlugInInterface

static IOReturn (*orig_IOUSBDeviceInterface_USBDeviceOpen)(void *self);
IOReturn _IOUSBDeviceInterface_USBDeviceOpen(void *self);

static IOReturn (*orig_IOUSBDeviceInterface_USBDeviceClose)(void *self);
IOReturn _IOUSBDeviceInterface_USBDeviceClose(void *self);

static IOReturn (*orig_IOUSBDeviceInterface_GetNumberOfConfigurations)(void *self, UInt8 *numConfig);
IOReturn _IOUSBDeviceInterface_GetNumberOfConfigurations(void *self, UInt8 *numConfig);

static IOReturn (*orig_IOUSBDeviceInterface_GetConfiguration)(void *self, UInt8 *configNum);
IOReturn _IOUSBDeviceInterface_GetConfiguration(void *self, UInt8 *configNum);

static IOReturn (*orig_IOUSBDeviceInterface_SetConfiguration)(void *self, UInt8 configNum);
IOReturn _IOUSBDeviceInterface_SetConfiguration(void *self, UInt8 configNum);

static IOReturn (*orig_IOUSBDeviceInterface_CreateInterfaceIterator)(void *self, IOUSBFindInterfaceRequest *req, io_iterator_t *iter);
IOReturn _IOUSBDeviceInterface_CreateInterfaceIterator(void *self, IOUSBFindInterfaceRequest *req, io_iterator_t *iter);

HRESULT _IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface(void *thisPointer, REFIID iid, LPVOID *ppv) {
    DEBUG_LOG_COLOR(FGYEL)
    qmilog("\t-> self: %p, ppv: %p\n", thisPointer, ppv);
    HRESULT result = orig_IOCFPlugInInterface_IOUSBDeviceUserClient_QueryInterface(thisPointer, iid, ppv);
    qmilog("\t-> result: %d\n", result);
    IOUSBDeviceInterface *device = **(IOUSBDeviceInterface ***)ppv;
    
    if (device->USBDeviceOpen != _IOUSBDeviceInterface_USBDeviceOpen) {
        orig_IOUSBDeviceInterface_USBDeviceOpen = device->USBDeviceOpen;
        device->USBDeviceOpen = _IOUSBDeviceInterface_USBDeviceOpen;
    }
    
    if (device->USBDeviceClose != _IOUSBDeviceInterface_USBDeviceClose) {
        orig_IOUSBDeviceInterface_USBDeviceClose = device->USBDeviceClose;
        device->USBDeviceClose = _IOUSBDeviceInterface_USBDeviceClose;
    }
    
    if (device->GetNumberOfConfigurations != _IOUSBDeviceInterface_GetNumberOfConfigurations) {
        orig_IOUSBDeviceInterface_GetNumberOfConfigurations = device->GetNumberOfConfigurations;
        device->GetNumberOfConfigurations = _IOUSBDeviceInterface_GetNumberOfConfigurations;
    }
    
    if (device->GetConfiguration != _IOUSBDeviceInterface_GetConfiguration) {
        orig_IOUSBDeviceInterface_GetConfiguration = device->GetConfiguration;
        device->GetConfiguration = _IOUSBDeviceInterface_GetConfiguration;
    }
    
    if (device->SetConfiguration != _IOUSBDeviceInterface_SetConfiguration) {
        orig_IOUSBDeviceInterface_SetConfiguration = device->SetConfiguration;
        device->SetConfiguration = _IOUSBDeviceInterface_SetConfiguration;
    }
    
    if (device->CreateInterfaceIterator != _IOUSBDeviceInterface_CreateInterfaceIterator) {
        orig_IOUSBDeviceInterface_CreateInterfaceIterator = device->CreateInterfaceIterator;
        device->CreateInterfaceIterator = _IOUSBDeviceInterface_CreateInterfaceIterator;
    }
    
    return result;
}

#pragma mark -

static IOReturn (*orig_IOUSBInterfaceInterface_USBInterfaceOpen)(void *self);
IOReturn _IOUSBInterfaceInterface_USBInterfaceOpen(void *self);

static IOReturn (*orig_IOUSBInterfaceInterface_USBInterfaceClose)(void *self);
IOReturn _IOUSBInterfaceInterface_USBInterfaceClose(void *self);

static IOReturn (*orig_IOUSBInterfaceInterface_GetInterfaceNumber)(void *self, UInt8 *intfNumber);
IOReturn _IOUSBInterfaceInterface_GetInterfaceNumber(void *self, UInt8 *intfNumber);

static IOReturn (*orig_IOUSBInterfaceInterface_ControlRequest)(void *self, UInt8 pipeRef, IOUSBDevRequest *req);
IOReturn _IOUSBInterfaceInterface_ControlRequest(void *self, UInt8 pipeRef, IOUSBDevRequest *req);

static IOReturn (*orig_IOUSBInterfaceInterface_ReadPipe)(void *self, UInt8 pipeRef, void *buf, UInt32 *size);
IOReturn _IOUSBInterfaceInterface_ReadPipe(void *self, UInt8 pipeRef, void *buf, UInt32 *size);

static IOReturn (*orig_IOUSBInterfaceInterface_WritePipe)(void *self, UInt8 pipeRef, void *buf, UInt32 size);
IOReturn _IOUSBInterfaceInterface_WritePipe(void *self, UInt8 pipeRef, void *buf, UInt32 size);

HRESULT _IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface(void *thisPointer, REFIID iid, LPVOID *ppv) {
    DEBUG_LOG_COLOR(FGYEL)
    HRESULT result = orig_IOCFPlugInInterface_IOUSBInterfaceUserClient_QueryInterface(thisPointer, iid, ppv);
    IOUSBInterfaceStruct *iface = **(IOUSBInterfaceStruct ***)ppv;
    
//    if (iface->USBInterfaceOpen != _IOUSBInterfaceInterface_USBInterfaceOpen) {
//        orig_IOUSBInterfaceInterface_USBInterfaceOpen = iface->USBInterfaceOpen;
//        iface->USBInterfaceOpen = _IOUSBInterfaceInterface_USBInterfaceOpen;
//    }
//
//    if (iface->USBInterfaceClose != _IOUSBInterfaceInterface_USBInterfaceClose) {
//        orig_IOUSBInterfaceInterface_USBInterfaceClose = iface->USBInterfaceClose;
//        iface->USBInterfaceClose = _IOUSBInterfaceInterface_USBInterfaceClose;
//    }

//    if (iface->GetInterfaceNumber != _IOUSBInterfaceInterface_GetInterfaceNumber) {
//        orig_IOUSBInterfaceInterface_GetInterfaceNumber = iface->GetInterfaceNumber;
//        iface->GetInterfaceNumber = _IOUSBInterfaceInterface_GetInterfaceNumber;
//    }
    
    if (iface->ControlRequest != _IOUSBInterfaceInterface_ControlRequest) {
        orig_IOUSBInterfaceInterface_ControlRequest = iface->ControlRequest;
        iface->ControlRequest = _IOUSBInterfaceInterface_ControlRequest;
    }
    
    if (iface->ReadPipe != _IOUSBInterfaceInterface_ReadPipe) {
        orig_IOUSBInterfaceInterface_ReadPipe = iface->ReadPipe;
        iface->ReadPipe = _IOUSBInterfaceInterface_ReadPipe;
    }
    
    if (iface->WritePipe != _IOUSBInterfaceInterface_WritePipe) {
        orig_IOUSBInterfaceInterface_WritePipe = iface->WritePipe;
        iface->WritePipe = _IOUSBInterfaceInterface_WritePipe;
    }
    
    return result;
}

#pragma mark - IOUSBDeviceInterface

IOReturn _IOUSBDeviceInterface_USBDeviceOpen(void *self) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_IOUSBDeviceInterface_USBDeviceOpen(self);
}

IOReturn _IOUSBDeviceInterface_USBDeviceClose(void *self) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_IOUSBDeviceInterface_USBDeviceClose(self);
}

IOReturn _IOUSBDeviceInterface_GetNumberOfConfigurations(void *self, UInt8 *numConfig) {
    DEBUG_LOG_COLOR(FGYEL)
    IOReturn result = orig_IOUSBDeviceInterface_GetNumberOfConfigurations(self, numConfig);
    printf("\t-> numConfig: %d\n", *numConfig);
    return result;
}

IOReturn _IOUSBDeviceInterface_GetConfiguration(void *self, UInt8 *configNum) {
    DEBUG_LOG_COLOR(FGYEL)
    IOReturn result = orig_IOUSBDeviceInterface_GetConfiguration(self, configNum);
    printf("\t-> configNum: %d\n", *configNum);
    return result;
}

IOReturn _IOUSBDeviceInterface_SetConfiguration(void *self, UInt8 configNum) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> configNum: %d\n", configNum);
    return orig_IOUSBDeviceInterface_SetConfiguration(self, configNum);
}

IOReturn _IOUSBDeviceInterface_CreateInterfaceIterator(void *self, IOUSBFindInterfaceRequest *req, io_iterator_t *iter) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> bInterfaceClass: %d, bInterfaceSubClass: %d, bInterfaceProtocol: %d, bAlternateSetting: %d\n",
           req->bInterfaceClass, req->bInterfaceSubClass, req->bInterfaceProtocol, req->bAlternateSetting);
    return orig_IOUSBDeviceInterface_CreateInterfaceIterator(self, req, iter);
}

#pragma mark - IOUSBInterfaceInterface

IOReturn _IOUSBInterfaceInterface_USBInterfaceOpen(void *self) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_IOUSBInterfaceInterface_USBInterfaceOpen(self);
}

IOReturn _IOUSBInterfaceInterface_USBInterfaceClose(void *self) {
    DEBUG_LOG_COLOR(FGYEL)
    return orig_IOUSBInterfaceInterface_USBInterfaceClose(self);
}

IOReturn _IOUSBInterfaceInterface_GetInterfaceNumber(void *self, UInt8 *intfNumber) {
    DEBUG_LOG_COLOR(FGYEL)
    IOReturn result = orig_IOUSBInterfaceInterface_GetInterfaceNumber(self, intfNumber);
    printf("\t-> intfNumber: %d\n", *intfNumber);
    return result;
}

IOReturn _IOUSBInterfaceInterface_ControlRequest(void *self, UInt8 pipeRef, IOUSBDevRequest *req) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> bmRequestType: %d, bRequest: %d, wValue: %d, wLength: %d\n",
           req->bmRequestType, req->bRequest, req->wValue, req->wLength);
    printf("\t-> pData: %d\n", req->wLength);
    hexdumpcc((uint8_t *)req->pData, req->wLength, FGYEL);
    return orig_IOUSBInterfaceInterface_ControlRequest(self, pipeRef, req);
}

IOReturn _IOUSBInterfaceInterface_ReadPipe(void *self, UInt8 pipeRef, void *buf, UInt32 *size) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> pipeRef: %d\n", pipeRef);
    IOReturn result = orig_IOUSBInterfaceInterface_ReadPipe(self, pipeRef, buf, size);
    hexdumpcc((uint8_t *)buf, *size, FGYEL);
    return result;
}

IOReturn _IOUSBInterfaceInterface_WritePipe(void *self, UInt8 pipeRef, void *buf, UInt32 size) {
    DEBUG_LOG_COLOR(FGYEL)
    printf("\t-> pipeRef: %d\n", pipeRef);
    hexdumpcc((uint8_t *)buf, size, FGYEL);
    return orig_IOUSBInterfaceInterface_WritePipe(self, pipeRef, buf, size);
}

#pragma mark -

void hook_iokit() {
//    MSHookFunction((void *)&IOObjectRelease, (void *)&_IOObjectRelease, (void **)&orig_IOObjectRelease);
    MSHookFunction((void *)&IOServiceGetMatchingService, (void *)&_IOServiceGetMatchingService, (void **)&orig_IOServiceGetMatchingService);
    MSHookFunction((void *)&IOServiceGetMatchingServices, (void *)&_IOServiceGetMatchingServices, (void **)&orig_IOServiceGetMatchingServices);
    MSHookFunction((void *)&IOServiceOpen, (void *)&_IOServiceOpen, (void **)&orig_IOServiceOpen);
    MSHookFunction((void *)&IOServiceClose, (void *)&_IOServiceClose, (void **)&orig_IOServiceClose);
    MSHookFunction((void *)&IOCreatePlugInInterfaceForService, (void *)&_IOCreatePlugInInterfaceForService, (void **)&orig_IOCreatePlugInInterfaceForService);
    MSHookFunction((void *)&IODestroyPlugInInterface, (void *)&_IODestroyPlugInInterface, (void **)&orig_IODestroyPlugInInterface);

//    MSHookFunction((void *)&IOConnectCallMethod, (void *)&_IOConnectCallMethod, (void **)&orig_IOConnectCallMethod);
//    MSHookFunction((void *)&IOConnectCallScalarMethod, (void *)&_IOConnectCallScalarMethod, (void **)&orig_IOConnectCallScalarMethod);
//    MSHookFunction((void *)&IOConnectCallStructMethod, (void *)&_IOConnectCallStructMethod, (void **)&orig_IOConnectCallStructMethod);

//    MSHookFunction((void *)&IOConnectCallAsyncMethod, (void *)&_IOConnectCallAsyncMethod, (void **)&orig_IOConnectCallAsyncMethod);
//    MSHookFunction((void *)&IOConnectCallAsyncScalarMethod, (void *)&_IOConnectCallAsyncScalarMethod, (void **)&orig_IOConnectCallAsyncScalarMethod);
//    MSHookFunction((void *)&IOConnectCallAsyncStructMethod, (void *)&_IOConnectCallAsyncStructMethod, (void **)&orig_IOConnectCallAsyncStructMethod);
}
