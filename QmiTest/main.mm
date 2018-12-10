//
//  main.c
//  QmiTest
//
//  Created by Danylo Kostyshyn on 12/12/18.
//  Copyright © 2018 Danylo Kostyshyn. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include "qmi.h"

int main(int argc, const char * argv[]) {
    uint8_t ctl_test[] =
        "\x01" // marker
        "\x0b\x00" // qmux.length
        "\x00" // qmux.flags
        "\x00" // qmux.service
        "\x00" // qmux.client
        "\x00" // qmi.control.header.flags
        "\x0f" // qmi.control.header.transaction
        "\x27\x00" // qmi.control.header.messaage
        "\x00\x00" // qmi.control.header.tlv_length
        ""; // qmi.service.tlv[]

    uint8_t ctl_test2[] =
        "\x01" // marker
        "\x10\x00" // qmux.length
        "\x00" // qmux.flags
        "\x00" // qmux.service
        "\x00" // qmux.client
        "\x00" // qmi.control.header.flags
        "\x0f" // qmi.control.header.transaction
        "\x27\x00" // qmi.control.header.messaage
        "\x05\x00" // qmi.control.header.tlv_length
    
        // qmi.service.tlv[]
            "\x01" // qmi.service.tlv.type
            "\x02\x00" // qmi.service.tlv.length
            "\x03\x04"; // qmi.service.tlv.value[]
   
    uint8_t ctl_test3[] =
        "\x01" // marker
        "\x0b\x00" // qmux.length
        "\x00" // qmux.flags
        "\x00" // qmux.service
        "\x00" // qmux.client
        "\x01" // qmi.control.header.flags
        "\x0f" // qmi.control.header.transaction
        "\x27\x00" // qmi.control.header.messaage
        "\x00\x00" // qmi.control.header.tlv_length
        ""; // qmi.service.tlv[]
    
    uint8_t ctl_test4[] =
        "\x01" // marker
        "\x0b\x00" // qmux.length
        "\x00" // qmux.flags
        "\x00" // qmux.service
        "\x00" // qmux.client
        "\x02" // qmi.control.header.flags
        "\x0f" // qmi.control.header.transaction
        "\x27\x00" // qmi.control.header.messaage
        "\x00\x00" // qmi.control.header.tlv_length
        ""; // qmi.service.tlv[]

    uint8_t ctl_test5[] =
        "\x01" // marker
        "\x0b\x00" // qmux.length
        "\x00" // qmux.flags
        "\x00" // qmux.service
        "\x00" // qmux.client
        "\x03" // qmi.control.header.flags
        "\x0f" // qmi.control.header.transaction
        "\x27\x00" // qmi.control.header.messaage
        "\x00\x00" // qmi.control.header.tlv_length
        ""; // qmi.service.tlv[]

    uint8_t ctl_test6[] =
        "\x01" // marker
        "\x0b\x00" // qmux.length
        "\x00" // qmux.flags
        "\x00" // qmux.service
        "\x00" // qmux.client
        "\x04" // qmi.control.header.flags
        "\x0f" // qmi.control.header.transaction
        "\x27\x00" // qmi.control.header.messaage
        "\x00\x00" // qmi.control.header.tlv_length
        ""; // qmi.service.tlv[]

    uint8_t nas_test[] =
        "\x01" // marker
        "\x30\x00" // qmux.length
        "\x00" // qmux.flags
        "\x03" // qmux.service
        "\x01" // qmux.client
        "\x04" // qmi.service.header.flags
        "\x14\x00" // qmi.service.header.transaction
        "\x02\x00" // qmi.service.header.messaage
        "\x24\x00" // qmi.service.header.tlv_length
    
        // qmi.service.tlv[]
            "\x13" // qmi.service.tlv.type
            "\x02\x00" // qmi.service.tlv.length
            "\x00\x00" // qmi.service.tlv.value[]
    
            "\x14"
            "\x02\x00"
            "\x00\x00"
    
            "\x15"
            "\x02\x00"
            "\x04\x05"
    
            "\x16"
            "\x02\x00"
            "\x00\x00"
    
            "\x18"
            "\x02\x00"
            "\x00\x00"
    
            "\x1b"
            "\x03\x00"
            "\x01\x02\x03"
    
            "\x1c"
            "\x02\x00"
            "\x00\x00";

    uint8_t oma_test[] =
        "\x01"
        "\xa0\x01"
        "\x00"
        "\xe2"
        "\x05"
    
        "\x00"
        "\x05\x00"
        "\x02\xb0"
        "\x94\x01"
    "\x01\x91\x01\x30\x82\x01\x8d\x02\x01\x01\x30\x0b\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x01\x05\x31\x58\x9f\x3f\x04\x27\xf0\xff\xc4\x9f\x40\x04\xe1\x00\x5a\x00\x9f\x4b\x14\x79\xe4\xda\xa4\x9c\x60\x53\x71\xf8\xda\x35\x9b\xe3\x02\xe1\x14\xc1\xb3\xe4\x8f\x9f\x87\x6d\x07\x01\x31\x83\x00\x36\x33\x63\x9f\x97\x3d\x0c\x00\x00\x00\x00\xee\xee\xee\xee\xee\xee\xee\xef\x9f\x97\x3e\x04\x00\x00\x00\x00\x9f\x97\x3f\x04\x01\x00\x00\x00\x9f\x97\x40\x04\x00\x00\x00\x00\x04\x81\x80\xc6\x89\xc8\x0a\x1e\xca\x48\x5e\x30\x55\xff\x7a\xe2\x09\x53\x9f\xa8\x73\x7c\x7e\xc2\x4f\x55\xc7\xfb\x71\xf8\xcc\xd1\xce\x19\xac\xbc\x5a\x69\x46\xfa\x51\x7e\x9c\x6d\x40\x64\xd9\x28\x50\x29\x2d\x6b\xd8\x8d\x45\x1f\x3e\xc8\x59\xda\x9d\xb5\x3f\xd9\x3d\x21\x3c\xb3\x57\xab\x6e\xd0\x5d\xaf\xb5\xa1\xd0\xfc\x7e\x1f\x10\xf2\xc6\x45\xdd\xb6\xc4\x66\xed\xe5\xb0\x95\xac\xde\xac\x32\xe7\x21\xbe\xd0\x9a\x48\x9c\x9d\x98\x4b\xa5\x72\xa1\x54\xf5\xa6\xba\xdf\xd2\xf8\xf2\xb8\xde\x7c\xef\x95\xc0\x11\x91\x7a\x9a\xd0\x36\x91\xbf\xa3\x81\x9d\x30\x0b\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x01\x01\x03\x81\x8d\x00\x30\x81\x89\x02\x81\x81\x00\xed\x3a\x3f\x64\xd1\xe8\x20\x9c\xc1\x52\x06\x34\xef\x7e\x2f\xb2\x09\x7e\x00\x2c\x43\x43\xe7\xf8\xaa\xeb\xe6\x4a\xb3\xc0\xb6\x00\xc4\x35\x26\x70\x69\x5a\xc7\x5e\x91\x7e\x71\x12\x81\x00\x1a\xa4\x0d\xad\x34\x61\xc1\x0d\xc7\x67\x6d\x4b\x5b\x6e\x1c\xb2\x83\x36\x7d\x73\x31\x92\xda\x65\x1a\x62\x2b\xd5\x1e\x88\xc3\xcd\x64\xbe\xa6\x96\x0d\x76\x05\x62\xf0\x56\x39\x45\x38\x61\x03\xf1\x4e\xa9\x7d\x7c\x0e\xc3\xa0\xff\x14\x20\xd1\x82\xfc\x86\x06\x7e\xf0\xb3\x0f\x2c\x11\xae\xc0\x76\x56\x26\x30\x71\xa6\x92\xfc\x20\x38\xfd\x02\x03\x01\x00\x01";

    print_qmi_message(ctl_test); printf("\n\n");
    print_qmi_message(ctl_test2); printf("\n\n");
    print_qmi_message(ctl_test3); printf("\n\n");
    print_qmi_message(ctl_test4); printf("\n\n");
    print_qmi_message(ctl_test5); printf("\n\n");
    print_qmi_message(ctl_test6); printf("\n\n");
    print_qmi_message(nas_test); printf("\n\n");
    print_qmi_message(oma_test);
    
    return 0;
}
