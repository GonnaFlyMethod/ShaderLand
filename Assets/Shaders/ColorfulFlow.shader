Shader "Unlit/ColorfulFlow"
{
    Properties
    {
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _ColorStart("_ColorAStart", Range(0, 1)) = 0
        _ColorEnd("_ColorBEnd", Range(0, 1)) = 1
    }
    SubShader
    {
       
//        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Tags{ "RenderType" = "Opaque"}

        Pass
        {
//            Cull Off
//            Blend One One 
//            ZWrite Off
//            ZTest LEqual
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Common.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _ColorAStart;
            float _ColorBEnd;
            
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
                float topBottomRemover = (abs(i.normal.y) < 0.999);

                //float wave = GetWave(i.uv.y, 5, 2);\
                
                float t = InverseLerp(_ColorAStart, _ColorBEnd, i.uv.x);
                return t;
                
                return lerp(_ColorA, _ColorB, t);

                //
                // float4 gradient = lerp(_ColorA, _ColorB, t);
                // return gradient;
                // return gradient * wave * topBottomRemover;
                // //
                // 
            }
            
            ENDCG
        }
    }
}
