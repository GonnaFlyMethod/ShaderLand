#define TAU 6.2831855

float InverseLerp(float a, float b, float v)
{
    return (v-a)/(b-a);
}

float GetWave(float coord, float wavesSpeed, float wavesDensity)
{
    float wave = cos((coord - _Time * wavesSpeed) * wavesDensity * TAU) * 0.5 + 0.5;
    return wave;
}

            