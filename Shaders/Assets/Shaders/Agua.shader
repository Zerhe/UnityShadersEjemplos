Shader "Unlit/Agua"
{
	Properties
	{
		_MainTex("Albedo Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_Transparency("Transparency", Range(0.0,0.5)) = 0.25
		_Speed("Speed", float) = 1

	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		LOD 100

		ZWrite off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _Transparency;
			float _Speed;

			v2f vert(appdata v)
			{
				v2f o;
				v.uv.y += _Speed * _Time.x;   // Modifica las uv en y a una velocidad en cierto tiempo
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{

				float4 col = tex2D(_MainTex, i.uv) + _Color;
				col.a = _Transparency;

				return col;
			}
			ENDCG
		}
	}
}
