Shader "Unlit/Deslizar"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Distance("Distance", float) = 1
		_Amplitude("Amplitude", float) = 1			//Amplitud en 0 para efecto de desaparecer
		_Speed("Speed", float) = 1
		_Amount("Amount", float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

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
			float _Distance;
			float _Amplitude;
			float _Speed;
			float _Amount;
			
			v2f vert (appdata v)
			{
				v2f o;
				v.vertex.x += tan(_Time.y * _Speed) * _Distance * _Amount;  // efecto deslisar horizontalmente 
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
