#include <stdio.h>
#include "game.h"
/*#include "libserialport.h"

void serial() {
    // Setup vars
    struct sp_port **ports;
    int port_num = 0;

    // Pick a port
    if (sp_list_ports(&ports) != SP_OK) {
        printf("Failed listing to ports.\n");
        return;
    }

    printf("Pick the correct port\n");

    for (int i = 0; ports[i] != NULL; i++) {
        printf("%i: %s\n", i, sp_get_port_name(ports[i]));
    }
    scanf("> %i\n", &port_num);

    // Setup and listen on the port
    sp_set_baudrate(ports[port_num], 115200);
    sp_set_bits(ports[port_num], 8);
    sp_set_parity(ports[port_num], SP_PARITY_NONE);
    sp_set_stopbits(ports[port_num], 1);
    sp_set_flowcontrol(ports[port_num], SP_FLOWCONTROL_NONE);

    if (sp_open(ports[port_num], SP_MODE_READ) != SP_OK) {
        printf("Failed to open port.\n");
        return;
    }


    sp_free_port_list(ports);
} */