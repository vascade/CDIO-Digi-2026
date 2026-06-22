#include <SDL3/SDL.h>
#include <stdio.h>
#include <SDL3_image/SDL_image.h>
int run_roulette(int argc, char *argv[])
{
    // To dodge errors in compiling
    (void)argc;
    (void)argv;
    SDL_Init(SDL_INIT_VIDEO);
    Uint64 lastTime = SDL_GetTicks();
    // Traditional window and renderer
    SDL_Window *win = NULL;
    SDL_Renderer *renderer = NULL;
    // Initiation for height and width
    SDL_DisplayID display = SDL_GetPrimaryDisplay();
    const SDL_DisplayMode *mode = SDL_GetDesktopDisplayMode(display);
    int screenWidth = mode->w;
    int screenHeight = mode->h;

    // Window and renderer creation
    win = SDL_CreateWindow("Roulette", screenWidth, screenHeight, SDL_WINDOW_FULLSCREEN);
    renderer = SDL_CreateRenderer(win, NULL);
    SDL_Texture *table;
    SDL_Texture *triangle;

    // table.png values
    int tableWidth = 1000;
    int tableHeight = 1000;
    int tablePosX = (screenWidth / 2) - (tableWidth / 2);
    int tablePosY = (screenHeight / 2) - (tableHeight / 2);

    // triangle.png values
    int triangleWidth = 125;
    int triangleHeight = 75;
    int trianglePosX = (screenWidth / 2) - (tableWidth / 1.70f);
    int trianglePosY = (screenHeight / 2) - (triangleHeight / 2);
    float initialRotation = -95;

    SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);

    // PNG's
    table = IMG_LoadTexture(renderer, "textures/table.png");
    if (!table)
        SDL_Log("FAILED TO LOAD table.png: %s", SDL_GetError());
    triangle = IMG_LoadTexture(renderer, "textures/triangle.png");
    if (!triangle)
        SDL_Log("FAILED TO LOAD triangle.png: %s", SDL_GetError());
    SDL_FRect tablePos = {tablePosX, tablePosY, tableWidth, tableHeight};
    SDL_FRect trianglePos = {trianglePosX, trianglePosY, triangleWidth, triangleHeight};

    // WHEEL ROTATION
    float rotation = 6.0f;
    float spinSpeed = 0.0f;
    float spinFriction = 0.99f;
    // KEYBOARD INPUT
    const bool *keys = SDL_GetKeyboardState(NULL);
    // TEXT
    const char *text = "Marko er en fucking lorteunge";
    int running = 1;
    SDL_Event event;

    while (running)
    {
        //Delta time
        Uint64 now = SDL_GetTicks();
        float deltaTime = (now - lastTime) / 1000.0f;
        lastTime = now;

        while (SDL_PollEvent(&event))
        { // Top right close button
            if (event.type == SDL_EVENT_QUIT)
            {
                running = 0;
            }
            // R for reset
            if (keys[SDL_SCANCODE_R])
            {
                spinSpeed = 0.0f;
                rotation = 6.0f;
            }
        }
            // Press space for close
            if (keys[SDL_SCANCODE_SPACE] || keys[SDL_SCANCODE_ESCAPE])
            {
                running = 0;
            } // Key-down for spin
            if (keys[SDL_SCANCODE_DOWN])
            {
                spinSpeed += 100.0f;
            }
        spinSpeed *= spinFriction;
        rotation += spinSpeed * deltaTime;
        // Rendering Part
        SDL_SetRenderDrawColor(renderer, 53, 101, 77, 255);
        SDL_RenderClear(renderer);
        SDL_RenderTextureRotated(renderer, table, NULL, &tablePos, initialRotation + rotation, NULL, SDL_FLIP_NONE);
        SDL_RenderTexture(renderer, triangle, NULL, &trianglePos);
    
        //Text
        char buf[64];
        SDL_snprintf(buf, sizeof(buf), "Spinspeed: %.2f", spinSpeed);
        SDL_SetRenderScale(renderer, 3,3);
        SDL_SetRenderDrawColor(renderer, 255,255,255,255);// WHITE
        SDL_RenderDebugText(renderer, 10, 10, buf);
        SDL_SetRenderScale(renderer,1,1);
        // DRAW
        SDL_RenderPresent(renderer);
        SDL_Delay(16); // 60 FPS
    }

    // Destroy
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(win);
    SDL_DestroyTexture(table);
    SDL_DestroyTexture(triangle);
    SDL_Quit();
    return 0;
}