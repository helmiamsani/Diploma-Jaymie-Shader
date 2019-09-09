﻿Shader "Custom/Albedo Greyscale"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _EffectAmoount ("Effect Amount", Range(0,1)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface ImageTransparentGreyScale Lambert alpha

        sampler2D _MainTex;
		uniform float _EffectAmount;
		/*
		A uniform is a global Shader variable declared with the "uniform" storage qualifier.
		These act as parameter
		*/


        struct Input
        {
            float2 uv_MainTex;
        };

		void ImageTransparentGreyScale(Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = lerp(c.rgb, dot(c.rgb,float3(0.3, 0.59, 0.11)), _EffectAmount);
			o.Alpha = c.a;
		}
        ENDCG
    }
    FallBack "Transparent/VertexLit"
}
