Shader "Unlit/ColorfulFlow"
{
    Properties
    {
        _ColorIntensity("Color Intensity", Range(0, 1)) = 1
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _ColorAEdge("Color A Edge", Range(0, 1)) = 0
        _ColorBEdge("Color B Edge", Range(0, 1)) = 1
        _Offset("Offset", Range(0, 1)) = 0
        _OffsetMultiplier("Offset Multiplier", Range(0, 1)) = 0.1
        [KeywordEnum(X,Y)] _WavesDirection("Waves Direction", int) = 0
        _WavesSpeed("Waves Speed", Float) = 1
        _WavesDensity("Waves Density", Float) = 5
    }
    SubShader
    {
       
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Common.cginc"

            float _ColorIntensity;
            
            float4 _ColorA;
            float4 _ColorB;

            float _ColorAEdge;
            float _ColorBEdge;

            float _Offset;
            float _OffsetMultiplier;

            int _WavesDirection;
            
            float _WavesSpeed;
            float _WavesDensity;
            
            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;

            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv0;
                
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float t = saturate(InverseLerp(_ColorAEdge, _ColorBEdge, i.uv.x));

                float offset = cos(i.uv.y * TAU * _Offset) * _OffsetMultiplier;

                float wavesDirection = _WavesDirection == 0 ? i.uv.x : i.uv.y;

                return _ColorIntensity * lerp(_ColorA, _ColorB, t) *
                    (GetWave(wavesDirection, _WavesSpeed, _WavesDensity) + offset);
            }
            
            ENDCG
        }
    }
}
