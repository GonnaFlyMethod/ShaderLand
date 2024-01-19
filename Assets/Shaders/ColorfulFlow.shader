Shader "Unlit/ColorfulFlow"
{
    Properties
    {
        _ColorIntensity("Color Intensity", Range(0, 1)) = 1
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _ColorAEdge("ColorA Edge", Range(0, 1)) = 0
        _ColorBEdge("ColorB Edge", Range(0, 1)) = 1
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

            float _WavesSpeed;
            float _WavesDensity;
            
            struct MeshaData
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;

            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal: TEXCOORD0;
                float2 uv: TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshaData v)
            {
                Interpolators o;

                o.normal = mul((float3x3)UNITY_MATRIX_M, v.normal);
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv0;
                
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float t = saturate(InverseLerp(_ColorAEdge, _ColorBEdge, i.uv.x));
                return _ColorIntensity * lerp(_ColorA, _ColorB, t) * GetWave(i.uv.x, _WavesSpeed, _WavesDensity);
            }
            
            ENDCG
        }
    }
}
