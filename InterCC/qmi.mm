//
//  qmi.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 12/12/18.
//  Copyright © 2018 Danylo Kostyshyn. All rights reserved.
//

#include "qmi.h"

#include "util.h"

//#define DEBUG_MAC
#ifdef DEBUG_MAC
#define qmilog printf
#define BYTE_COLOR ""
#define BYTE_COLOR_NRM ""
#else
#define BYTE_COLOR FGGRN
#define BYTE_COLOR_NRM FGNRM
#endif

const char *get_qmi_service_name(QmiService service) {
    switch (service) {
        case QMI_SERVICE_CTL: return "CTL";
        case QMI_SERVICE_WDS: return "WDS";
        case QMI_SERVICE_DMS: return "DMS";
        case QMI_SERVICE_NAS: return "NAS";
        case QMI_SERVICE_QOS: return "QOS";
        case QMI_SERVICE_WMS: return "WMS";
        case QMI_SERVICE_PDS: return "PDS";
        case QMI_SERVICE_AUTH: return "AUTH";
        case QMI_SERVICE_AT: return "AT";
        case QMI_SERVICE_VOICE: return "VOICE";
        case QMI_SERVICE_CAT2: return "CAT2";
        case QMI_SERVICE_UIM: return "UIM";
        case QMI_SERVICE_PBM: return "PBM";
        case QMI_SERVICE_QCHAT: return "QCHAT";
        case QMI_SERVICE_RMTFS: return "RMTFS";
        case QMI_SERVICE_TEST: return "TEST";
        case QMI_SERVICE_LOC: return "LOC";
        case QMI_SERVICE_SAR: return "SAR";
        case QMI_SERVICE_IMS: return "IMS";
        case QMI_SERVICE_ADC: return "ADC";
        case QMI_SERVICE_CSD: return "CSD";
        case QMI_SERVICE_MFS: return "MFS";
        case QMI_SERVICE_TIME: return "TIME";
        case QMI_SERVICE_TS: return "TS";
        case QMI_SERVICE_TMD: return "TMD";
        case QMI_SERVICE_SAP: return "SAP";
        case QMI_SERVICE_WDA: return "WDA";
        case QMI_SERVICE_TSYNC: return "TSYNC";
        case QMI_SERVICE_RFSA: return "RFSA";
        case QMI_SERVICE_CSVT: return "CSVT";
        case QMI_SERVICE_QCMAP: return "QCMAP";
        case QMI_SERVICE_IMSP: return "IMSP";
        case QMI_SERVICE_IMSVT: return "IMSVT";
        case QMI_SERVICE_IMSA: return "IMSA";
        case QMI_SERVICE_COEX: return "COEX";
        case QMI_SERVICE_PDC: return "PDC";
        case QMI_SERVICE_STX: return "STX";
        case QMI_SERVICE_BIT: return "BIT";
        case QMI_SERVICE_IMSRTP: return "IMSRTP";
        case QMI_SERVICE_RFRPE: return "RFRPE";
        case QMI_SERVICE_DSD: return "DSD";
        case QMI_SERVICE_SSCTL: return "SSCTL";
        case QMI_SERVICE_CAT: return "CAT";
        case QMI_SERVICE_RMS: return "RMS";
        case QMI_SERVICE_OMA: return "OMA";
        default: return "Unknown";
    }
}

#pragma mark -

typedef enum {
    qmi_ctl_flag_request = 0b00,
    qmi_ctl_flag_response = 0b01,
    qmi_ctl_flag_indication = 0b10,
    qmi_ctl_flag_reserved = 0b11,
} qmi_ctl_flag;

bool is_qmi_ctl_request(uint8_t flags) {
    return ((flags ^ qmi_ctl_flag_request) & 0b11) == 0;
}

bool is_qmi_ctl_response(uint8_t flags) {
    return ((flags ^ qmi_ctl_flag_response) & 0b11) == 0;
}

bool is_qmi_ctl_indication(uint8_t flags) {
    return ((flags ^ qmi_ctl_flag_indication) & 0b11) == 0;
}

bool is_qmi_ctl_reserved(uint8_t flags) {
    return ((flags ^ qmi_ctl_flag_reserved) & 0b11) == 0;
}

const char *qmi_ctl_flag_name(uint8_t flags) {
    if (is_qmi_ctl_request(flags)) {
        return "↑ REQ";
    } else if (is_qmi_ctl_response(flags)) {
        return "↓ RESP";
    } else if (is_qmi_ctl_indication(flags)) {
        return "→ IND";
    } else if (is_qmi_ctl_reserved(flags)) {
        return "RSRV";
    }
    return NULL;
}

#pragma mark -

void print_tlvs(uint8_t *raw_tlv, uint8_t raw_tlv_length);

char *bits_to_str(uint8_t byte);

#define QMI_MESSAGE_QMUX_MARKER (uint8_t) 0x01

void print_qmi_message(uint8_t const *raw) {
    full_message *message = (full_message *)raw;
    qmilog("marker: %s0x%02x%s\n", BYTE_COLOR, message->marker, BYTE_COLOR_NRM);
    if (message->marker != QMI_MESSAGE_QMUX_MARKER) {
        qmilog("not valid QMUX header\n");
        return;
    }
    qmilog("qmux.length: %s0x%04x%s (%d)\n", BYTE_COLOR, message->qmux.length, BYTE_COLOR_NRM, message->qmux.length);
    char *bits_str = bits_to_str(message->qmux.flags);
    
    qmilog("qmux.flags: %s0x%02x%s (%s)\n", BYTE_COLOR, message->qmux.flags, BYTE_COLOR_NRM, bits_str);
    free(bits_str);
    const char *service_name = get_qmi_service_name((QmiService)message->qmux.service);
    qmilog("qmux.service: %s0x%02x%s (%s)\n", BYTE_COLOR, message->qmux.service, BYTE_COLOR_NRM, service_name);
    qmilog("qmux.client: %s0x%02x%s\n", BYTE_COLOR, message->qmux.client, BYTE_COLOR_NRM);
    if (message->qmux.service == QMI_SERVICE_CTL) {
        char *bits_str = bits_to_str(message->qmi.control.header.flags);
        qmilog("qmi.control.header.flags: %s0x%02x%s (%s) (%s)\n", BYTE_COLOR, message->qmi.control.header.flags, BYTE_COLOR_NRM, bits_str, qmi_ctl_flag_name(message->qmi.control.header.flags));
        free(bits_str);
        qmilog("qmi.control.header.transaction: %s0x%02x%s\n", BYTE_COLOR, message->qmi.control.header.transaction, BYTE_COLOR_NRM);
        qmilog("qmi.control.header.message: %s0x%04x%s\n", BYTE_COLOR, message->qmi.control.header.message, BYTE_COLOR_NRM);
        qmilog("qmi.control.header.tlv_length: %s0x%04x%s (%d)\n", BYTE_COLOR, message->qmi.control.header.tlv_length, BYTE_COLOR_NRM, message->qmi.control.header.tlv_length);
        
        print_tlvs((uint8_t *)message->qmi.control.tlv, message->qmi.control.header.tlv_length);
    } else {
        char *bits_str = bits_to_str(message->qmi.service.header.flags);
        qmilog("qmi.service.header.flags: %s0x%02x%s (%s)\n", BYTE_COLOR, message->qmi.service.header.flags, BYTE_COLOR_NRM, bits_str);
        free(bits_str);
        qmilog("qmi.service.header.transaction: %s0x%04x%s\n", BYTE_COLOR, message->qmi.service.header.transaction, BYTE_COLOR_NRM);
        qmilog("qmi.service.header.message: %s0x%04x%s\n", BYTE_COLOR, message->qmi.service.header.message, BYTE_COLOR_NRM);
        qmilog("qmi.service.header.tlv_length: %s0x%04x%s (%d)\n", BYTE_COLOR, message->qmi.service.header.tlv_length, BYTE_COLOR_NRM, message->qmi.service.header.tlv_length);
        
        print_tlvs((uint8_t *)message->qmi.service.tlv, message->qmi.service.header.tlv_length);
    }
}

void print_tlvs(uint8_t *raw_tlv, uint8_t raw_tlv_length) {
    uint16_t tlv_idx = 0;
    uint16_t offset = 0;
    while (offset < raw_tlv_length) {
        tlv *tlv_p = (tlv *)&(raw_tlv[offset]);
        
        qmilog("\tqmi.service.tlv[%hu].tlv_type: %s0x%02x%s\n", tlv_idx, BYTE_COLOR, tlv_p->type, BYTE_COLOR_NRM);
        qmilog("\tqmi.service.tlv[%hu].tlv_length: %s0x%04x%s (%d)\n", tlv_idx, BYTE_COLOR, tlv_p->length, BYTE_COLOR_NRM, tlv_p->length);
        if (tlv_p->length > 0) {
            qmilog("\tqmi.service.tlv[%hu].tlv_value:\n", tlv_idx);
#ifdef DEBUG_MAC
            fhexdump(stdout, tlv_p->value, tlv_p->length);
#else
            hexdumpcc(tlv_p->value, tlv_p->length, BYTE_COLOR);
#endif
        }

        uint16_t next_tlv_offset = sizeof(tlv) + tlv_p->length;
        offset += next_tlv_offset;
        
        tlv_idx++;
    }
}

#define BITS_NUM 8

char *bits_to_str(uint8_t byte) {
    char *str = (char *)malloc(sizeof(char) * 10);
    size_t extra_char = 0;
    for (size_t i=0; i<BITS_NUM; i++) {
        if (i == BITS_NUM/2) {
            sprintf(str + i, " %d", (byte >> (BITS_NUM-1-i)) & 0x01);
            extra_char += 1;
        } else {
            sprintf(str + i + extra_char, "%d", (byte >> (BITS_NUM-1-i)) & 0x01);
        }
    }
    return str;
}

#pragma mark -

void get_tlv_value(uint8_t const *raw, uint8_t const type, uint8_t *length, uint8_t **value) {
    full_message *message = (full_message *)raw;
    if (message->marker != QMI_MESSAGE_QMUX_MARKER) {
        qmilog("not valid QMUX header\n");
        return;
    }

    uint8_t *raw_tlv = (uint8_t *)message->qmi.control.tlv;
    uint8_t raw_tlv_length = message->qmi.control.header.tlv_length;
    
    uint16_t tlv_idx = 0;
    uint16_t offset = 0;
    while (offset < raw_tlv_length) {
        tlv *tlv_p = (tlv *)&(raw_tlv[offset]);
        
        if (tlv_p->type == type) {
            *length = tlv_p->length;
            *value = (uint8_t *)malloc(sizeof(uint8_t) * tlv_p->length);
            memcpy(*value, tlv_p->value, tlv_p->length);
            return;
        }

        uint16_t next_tlv_offset = sizeof(tlv) + tlv_p->length;
        offset += next_tlv_offset;

        tlv_idx++;
    }
}

#define QMI_RESULT_SUCCESS 0x0000
#define QMI_RESULT_FAILURE 0x0001

typedef struct ctl_tlv_response_result {
    uint16_t result_code;
    uint16_t error_code;
} PACKED ctl_tlv_response_result;

void get_ctl_resp_result(uint8_t const *raw, bool *is_error, uint16_t *error_code) {
    full_message *message = (full_message *)raw;
    if (message->qmux.service != QMI_SERVICE_CTL) {
        qmilog("not a CTL message\n");
        return;
    }
    if (!is_qmi_ctl_response(message->qmi.control.header.flags)) {
        qmilog("not a CTL response message\n");
        return;
    }

    uint8_t length = 0;
    uint8_t *value = NULL;
    get_tlv_value(raw, 0x02, &length, &value); // 0x02 response result code

    // length 4 bytes, 2 bytes success/error, 2 bytes error code
    if (length != 4) {
        qmilog("not valid CTL response TLV length: %d\n", length);
        free(value);
        return;
    }
    
    ctl_tlv_response_result *resp = (ctl_tlv_response_result *)value;
    switch (resp->result_code) {
        case QMI_RESULT_SUCCESS: {
            *is_error = false;
            *error_code = NULL;
        } break;
        case QMI_RESULT_FAILURE: {
            *is_error = true;
            *error_code = resp->error_code;
        } break;
        default: break;
    }

    free(value);
    return;
}

#pragma mark - TLV

qmi::TLV::TLV(uint8_t *raw) {
    size_t tlv_len = sizeof(tlv) + sizeof(uint8_t) * ((tlv *)raw)->length;
    mTLV = (tlv *)malloc(tlv_len);
    memcpy(mTLV, raw, tlv_len);
}

qmi::TLV::TLV(uint8_t type, /*uint16_t length,*/ const char *value) {
    size_t value_len = strlen(value);
    size_t tlv_len = sizeof(tlv) + value_len;
    mTLV = (tlv *)malloc(tlv_len);
    mTLV->type = type;
    mTLV->length = value_len;
    memcpy(mTLV->value, value, value_len);
}

qmi::TLV::~TLV() {
    free(mTLV);
}

tlv* qmi::TLV::getRaw() {
    return mTLV;
}

void qmi::TLV::print() {
    print_tlvs((uint8_t *)mTLV, sizeof(tlv) + mTLV->length);
}

#pragma mark - QmiMessage

qmi::QmiMessage::QmiMessage(uint8_t *raw) {

}

qmi::QmiMessage::QmiMessage(uint8_t service, uint8_t client, uint16_t transaction, uint16_t message) {
    size_t qmi_len = sizeof(full_message);
    if (service == QmiService::QMI_SERVICE_CTL) {
        qmi_len -= 1; // - uint8_t transaction
    }

    mMessage = (full_message *)malloc(sizeof(full_message));
    mMessage->marker = QMI_MESSAGE_QMUX_MARKER;
    mMessage->qmux.length = qmi_len - 1; // - marker
    mMessage->qmux.flags = 0;
    mMessage->qmux.service = service;
    mMessage->qmux.client = client;
    
    switch (service) {
        case QmiService::QMI_SERVICE_CTL: {
            mMessage->qmi.control.header.flags = 0;
            mMessage->qmi.control.header.transaction = (uint8_t)transaction;
            mMessage->qmi.control.header.message = message;
            mMessage->qmi.control.header.tlv_length = 0;
        } break;
        default: {
            mMessage->qmi.service.header.flags = 0;
            mMessage->qmi.service.header.transaction = transaction;
            mMessage->qmi.service.header.message = message;
            mMessage->qmi.service.header.tlv_length = 0;
        } break;
    }
    
    tlvs = new std::vector<TLV *>();
}

qmi::QmiMessage::~QmiMessage() {
    free(mMessage);
    delete tlvs;
}

void qmi::QmiMessage::addTLV(qmi::TLV *tlv) {
    tlvs->push_back(tlv);
}

qmi::TLV *qmi::QmiMessage::getTLV(uint8_t type) {
    for (std::vector<TLV *>::iterator it = tlvs->begin(); it != tlvs->end(); ++it) {
        if (((*it)->getRaw())->type == type) {
            return (*it);
        };
    }
    return nullptr;
}

void qmi::QmiMessage::clearTLVs() {
    tlvs->clear();
}

uint8_t *qmi::QmiMessage::copyRaw() {
    // calc TLVs length
    uint16_t tlvs_len = 0;
    uint8_t *tlvs_raw = nullptr;

    for (std::vector<TLV *>::iterator it = tlvs->begin(); it != tlvs->end(); ++it) {
        uint16_t offset = tlvs_len;

        uint16_t len = sizeof(tlv) + ((*it)->getRaw())->length;
        tlvs_len += len;
        tlvs_raw = (uint8_t *)realloc(tlvs_raw, tlvs_len);
        
        memcpy(tlvs_raw + offset, (*it)->getRaw(), len);
    }

    // create QMI message copy with additional size for TLVs
    size_t qmi_len = mMessage->qmux.length + 1; // + marker
    full_message *message = (full_message *)malloc(qmi_len + tlvs_len);
    memcpy(message, mMessage, qmi_len);
    message->qmux.length += tlvs_len;

    uint8_t *tlv_offset = (message->qmux.service == QMI_SERVICE_CTL) ?
                            (uint8_t *)message->qmi.control.tlv :
                            (uint8_t *)message->qmi.service.tlv;

    memcpy(tlv_offset, tlvs_raw, tlvs_len);
    free(tlvs_raw);

    return (uint8_t *)message;
}

void qmi::QmiMessage::print() {
    uint8_t *raw = (uint8_t *)copyRaw();
    print_qmi_message(raw);
    free(raw);
}

