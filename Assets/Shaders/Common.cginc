#define TAU 6.2831855

float InverseLerp(float a, float b, float v)
{
    return (v-a)/(b-a);
}

float GetWave(float2 uv, float wavesSpeed, float wavesNumber)
{
    float wave = cos((uv.x - _Time * wavesSpeed) * wavesNumber * TAU) * 0.5 + 0.5;
    return wave;
}

            