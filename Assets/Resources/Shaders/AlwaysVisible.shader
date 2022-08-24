Shader "Feralnex/AlwaysVisible"
{
    Properties
    {
        [PerRendererData] _MainTex("Texture", 2D) = "white" {}
        _Tint("Tint", Color) = (0, 0, 0, 0)
        _VisibleAlpha("Visible alpha", Range(0, 1)) = 1
        _HiddenAlpha("Hidden alpha", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent+1"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }

        Cull Back
        // Controls whether pixels from this object are written to the depth buffer (default is On).
        // If you're drawing solid objects, leave this on. If you're drawing semitransparent effects, switch ZWrite Off.
        ZWrite Off
        ZTest Greater

        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        struct Input {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed4 _Tint;
        float _HiddenAlpha;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float4 c = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = lerp(c.rgb, c.rgb * _Tint.rgb, _Tint.a);
            o.Alpha = c.a * _HiddenAlpha;
        }
        ENDCG
            
        ZWrite On
        ZTest LEqual

        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        struct Input {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed4 _Tint;
        float _VisibleAlpha;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float4 c = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = lerp(c.rgb, c.rgb * _Tint.rgb, _Tint.a);
            o.Alpha = c.a * _VisibleAlpha;
        }
        ENDCG
    }
}
