#include "game.h"
#include <unistd.h>

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

    // Vars for table
    int frameWidth = table.width;
    int frameHeight = table.height;
    Rectangle sourceRec = { 0, 0, (float)frameWidth, (float)frameHeight };
    Rectangle destRec = { SCREEN_WIDTH/2, SCREEN_HEIGHT/2, frameWidth, frameHeight};
    Vector2 origin = { (float)frameWidth/2, (float)frameHeight/2 };

    float rotation = 6.0;
    float targetRotation = 6.0;

    // Vars for arrow
    Vector2 p1 = {120, SCREEN_HEIGHT/2};
    Vector2 p2 = {50, (SCREEN_HEIGHT/2) - 20};  // was p3
    Vector2 p3 = {50, (SCREEN_HEIGHT/2) + 20};  // was p2

    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        if (IsKeyPressed(KEY_DOWN)) {
            targetRotation += 360.0f / 37;
        }
        rotation += (targetRotation - rotation) * 0.05f;

        // Draw
        BeginDrawing();

            ClearBackground(DARKGREEN);
            DrawTriangle(p1, p2, p3, RED);
            DrawTexturePro(table, sourceRec, destRec, origin, (float)rotation, WHITE);
            DrawFPS(10, 10);

        EndDrawing();
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}