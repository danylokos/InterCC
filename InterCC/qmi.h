//
//  qmi.h
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/4/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#ifndef qmi_h
#define qmi_h

#include <stdlib.h>

/*
 https://github.com/freedesktop/libqmi/blob/master/src/libqmi-glib/qmi-message.c
 */

#define PACKED __attribute__((packed))

typedef struct qmux {
    uint16_t length;
    uint8_t flags;
    uint8_t service;
    uint8_t client;
} PACKED qmux;

typedef struct control_header {
    uint8_t flags;
    uint8_t transaction;
    uint16_t message;
    uint16_t tlv_length;
} PACKED control_header;

typedef struct service_header {
    uint8_t flags;
    uint16_t transaction;
    uint16_t message;
    uint16_t tlv_length;
} PACKED service_header;

typedef struct tlv {
    uint8_t type;
    uint16_t length;
    uint8_t value[];
} PACKED tlv;

typedef struct control_message {
    control_header header;
    tlv tlv[];
} PACKED control_message;

typedef struct service_message {
    service_header header;
    tlv tlv[];
} PACKED service_message;

typedef struct full_message {
    uint8_t marker;
    qmux qmux;
    union {
        control_message control;
        service_message service;
    } qmi;
} PACKED full_message;

/*
 https://github.com/freedesktop/libqmi/blob/master/src/libqmi-glib/qmi-enums.h
 */

typedef enum {
    QMI_SERVICE_UNKNOWN = -1,
    QMI_SERVICE_CTL = 0,
    QMI_SERVICE_WDS = 1,
    QMI_SERVICE_DMS = 2,
    QMI_SERVICE_NAS = 3,
    QMI_SERVICE_QOS = 4,
    QMI_SERVICE_WMS = 5,
    QMI_SERVICE_PDS = 6,
    QMI_SERVICE_AUTH = 7,
    QMI_SERVICE_AT = 8,
    QMI_SERVICE_VOICE = 9,
    QMI_SERVICE_CAT2 = 10,
    QMI_SERVICE_UIM = 11,
    QMI_SERVICE_PBM = 12,
    QMI_SERVICE_QCHAT = 13,
    QMI_SERVICE_RMTFS = 14,
    QMI_SERVICE_TEST = 15,
    QMI_SERVICE_LOC = 16,
    QMI_SERVICE_SAR = 17,
    QMI_SERVICE_IMS = 18,
    QMI_SERVICE_ADC = 19,
    QMI_SERVICE_CSD = 20,
    QMI_SERVICE_MFS = 21,
    QMI_SERVICE_TIME = 22,
    QMI_SERVICE_TS = 23,
    QMI_SERVICE_TMD = 24,
    QMI_SERVICE_SAP = 25,
    QMI_SERVICE_WDA = 26,
    QMI_SERVICE_TSYNC = 27,
    QMI_SERVICE_RFSA = 28,
    QMI_SERVICE_CSVT = 29,
    QMI_SERVICE_QCMAP = 30,
    QMI_SERVICE_IMSP = 31,
    QMI_SERVICE_IMSVT = 32,
    QMI_SERVICE_IMSA = 33,
    QMI_SERVICE_COEX = 34,
    /* 35, reserved */
    QMI_SERVICE_PDC = 36,
    /* 37, reserved */
    QMI_SERVICE_STX = 38,
    QMI_SERVICE_BIT = 39,
    QMI_SERVICE_IMSRTP = 40,
    QMI_SERVICE_RFRPE = 41,
    QMI_SERVICE_DSD = 42,
    QMI_SERVICE_SSCTL = 43,
    QMI_SERVICE_CAT = 224,
    QMI_SERVICE_RMS = 225,
    QMI_SERVICE_OMA = 226
} QmiService;

void print_qmi_message(uint8_t *raw);

#endif /* qmi_h */
