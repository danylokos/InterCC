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

#include "qmi-enums.h"
#include "qmi-errors.h"

#include <vector>

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

namespace qmi {

    class TLV {
    private:
        tlv *mTLV;
    public:
        TLV(uint8_t *raw);
        TLV(uint8_t type, /*uint16_t length,*/ const char *value);
        ~TLV();
        
        tlv* getRaw();
        
        void print();
    };

    class QmiMessage {
    private:
        full_message *mMessage;
        std::vector<TLV *> *tlvs;
    public:
        QmiMessage(uint8_t *raw);
        QmiMessage(uint8_t service, uint8_t client, uint16_t transaction, uint16_t message);
        ~QmiMessage();
        
        void addTLV(TLV *tlv);
        TLV *getTLV(uint8_t type);
        void clearTLVs();
        
        uint8_t *copyRaw();
        
        void print();
    };
}

void print_qmi_message(uint8_t const *raw);

void get_tlv_value(uint8_t const *raw, uint8_t const type, uint8_t *length, uint8_t **value);

void get_ctl_resp_result(uint8_t const *raw, bool *is_error, uint16_t *error_code);

const char *get_qmi_service_name(QmiService service);

#endif /* qmi_h */
