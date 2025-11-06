#pragma once

#ifndef ROOF_H_INCLUDED
#define ROOF_H_INCLUDED

int roofVertexCount = 18;

float roofVertices[] = {
    // Side walls
    0.0f, 0.0f, -1.0f, 1.0f,  // A
    0.0f, 1.0f, 0.0f, 1.0f,   // C
    2.0f, 1.0f, 0.0f, 1.0f,   // F

    0.0f, 0.0f, -1.0f, 1.0f,  // A
    2.0f, 1.0f, 0.0f, 1.0f,   // F
    2.0f, 0.0f, -1.0f, 1.0f,  // D

    0.0f, 0.0f, 1.0f, 1.0f,   // B
    0.0f, 1.0f, 0.0f, 1.0f,   // C
    2.0f, 1.0f, 0.0f, 1.0f,   // F

    0.0f, 0.0f, 1.0f, 1.0f,   // B
    2.0f, 1.0f, 0.0f, 1.0f,   // F
    2.0f, 0.0f, 1.0f, 1.0f,   // E

    0.0f, 0.0f, -1.0f, 1.0f,  // A
    0.0f, 0.0f, 1.0f, 1.0f,   // B
    2.0f, 0.0f, 1.0f, 1.0f,   // E

    0.0f, 0.0f, -1.0f, 1.0f,  // A
    2.0f, 0.0f, 1.0f, 1.0f,   // E
    2.0f, 0.0f, -1.0f, 1.0f,  // D
};

// Texture coordinates
float roofTexCoords[] = {
    // Triangle ACF
    0.0f, 0.0f,  // A
    0.0f, 1.0f,  // C
    1.0f, 1.0f,  // F

    // Triangle AFD
    0.0f, 0.0f,  // A
    1.0f, 1.0f,  // F
    1.0f, 0.0f,  // D

    // Triangle BCF
    0.0f, 0.0f,  // B
    0.0f, 1.0f,  // C
    1.0f, 1.0f,  // F

    // Triangle BFE
    0.0f, 0.0f,  // B
    1.0f, 1.0f,  // F
    1.0f, 0.0f,  // E

    // Triangle ABE (dó³ dachu)
    0.0f, 0.0f,  // A
    1.0f, 0.0f,  // B
    1.0f, 1.0f,  // E

    // Triangle AED (dó³ dachu)
    0.0f, 0.0f,  // A
    1.0f, 1.0f,  // E
    0.0f, 1.0f   // D
};

// Normals
float roofNormals[] = {

    0.0f,  0.7071f, -0.7071f, 0.0f,
    0.0f,  0.7071f, -0.7071f, 0.0f,
    0.0f,  0.7071f, -0.7071f, 0.0f,
    0.0f,  0.7071f, -0.7071f, 0.0f,
    0.0f,  0.7071f, -0.7071f, 0.0f,
    0.0f,  0.7071f, -0.7071f, 0.0f,

    // Tylna po³aæ (Z = +)
    0.0f,  0.7071f,  0.7071f, 0.0f,
    0.0f,  0.7071f,  0.7071f, 0.0f,
    0.0f,  0.7071f,  0.7071f, 0.0f,
    0.0f,  0.7071f,  0.7071f, 0.0f,
    0.0f,  0.7071f,  0.7071f, 0.0f,
    0.0f,  0.7071f,  0.7071f, 0.0f,

    // Przednia po³aæ (Z = -)


    // Spód dachu (Y = -)
    0.0f, -1.0f,   0.0f,   0.0f,
    0.0f, -1.0f,   0.0f,   0.0f,
    0.0f, -1.0f,   0.0f,   0.0f,
    0.0f, -1.0f,   0.0f,   0.0f,
    0.0f, -1.0f,   0.0f,   0.0f,
    0.0f, -1.0f,   0.0f,   0.0f
};

#endif // ROOF_H_INCLUDED
