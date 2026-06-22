#include <stdio.h>
#include <libserialport.h>
#include "globals.h"

void serial(void)
{
    if (sp_list_ports(&ports) != SP_OK) {
        printf("Failed listing ports.\n");
        return;
    }

    printf("Pick the correct port:\n");

    for (int i = 0; ports[i] != NULL; i++) {
        printf("%d: %s\n", i, sp_get_port_name(ports[i]));
    }

    scanf("%d", &port_num);

    sp_set_baudrate(ports[port_num], 115200);
    sp_set_bits(ports[port_num], 8);
    sp_set_parity(ports[port_num], SP_PARITY_NONE);
    sp_set_stopbits(ports[port_num], 1);
    sp_set_flowcontrol(ports[port_num], SP_FLOWCONTROL_NONE);

    if (sp_open(ports[port_num], SP_MODE_READ) != SP_OK) {
        printf("Failed to open port.\n");
        return;
    }
}