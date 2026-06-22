#include <string.h>
#include <game.h>
#include <stdio.h>
const char* get_path(const char* filename) {
    static char path[256];
    #ifdef _WIN32
        snprintf(path, sizeof(path), "textures\\%s", filename);
    #else
        snprintf(path, sizeof(path), "textures/%s", filename);
    #endif
    return path;
}