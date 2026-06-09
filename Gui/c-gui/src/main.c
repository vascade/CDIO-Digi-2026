#include "game.h"

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
int main(void)
{
    // Initialization
    //--------------------------------------------------------------------------------------
    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Roulette");
    SetTargetFPS(60);
    
    Texture2D table = LoadTexture("textures/table.png");

    int frameWidth = table.width;
    int frameHeight = table.height;

    Rectangle sourceRec = { 0, 0, (float)frameWidth, (float)frameHeight };
    Rectangle destRec = { SCREEN_WIDTH/2, SCREEN_HEIGHT/2, frameWidth, frameHeight};

    Vector2 origin = { (float)frameWidth/2, (float)frameHeight/2 };
    int rotation = 0;

    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        rotation++;

        // Draw
        BeginDrawing();

            
            ClearBackground(RAYWHITE);
            DrawTexturePro(table, sourceRec, destRec, origin, (float)rotation, WHITE);
            
        EndDrawing();
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}