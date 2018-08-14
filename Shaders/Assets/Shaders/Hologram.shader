Shader "Unlit/Hologram"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_TextureEffect ("Effect Texture", 2D) = "white" {}
		_NoiseTex ("NoiseTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_Transparency("Transparency", Range(0.0,0.5)) = 0.25
		_CutoutThresh("Distortion", Range(0.0,1.2)) = 0.2						// cantidad minima de un color para que se dibuje
		_GlitchCutoutThresh("Glitch Distortion", Range(0.0,1.2)) = 0.2
		_Distance("Glitch Distance", float) = 1
		[HideInInspector]_Amplitude("Amplitude", float) = 1
		[HideInInspector]_Speed("Speed", float) = 1
		_GlitchSpeed("Glitch Speed", float) = 1
		_GlitchChance("Glitch Chance", Range(0.0,1.0)) = 0.1
		[Toggle] _Overheating("Overheating", Float) = 0
		_SpeedOverheating("SpeedOverheating", float) = 0.5

	}
	SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
		LOD 100

		ZWrite off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			
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
			sampler2D _TextureEffect;
			sampler2D _NoiseTex;
			float4 _Color;
			float _Transparency;
			float _CutoutThresh;
			float _GlitchCutoutThresh;
			float _Distance;
			float _Amplitude;
			float _Speed;
			float _GlitchSpeed;
			float _GlitchChance;
			float _Overheating;
			float _SpeedOverheating;
			
			float Random(int min, int max)    //Pass this function a minimum and maximum value, as well as your texture UV
			{
				if (min > max)
					return 1;        //If the minimum is greater than the maximum, return a default value

				float cap = max - min;    //Subtract the minimum from the maximum
				float rand = tex2Dlod(_NoiseTex, float4 (_Time.x, 0, 0, 0)).r * cap + min;    //Make the texture UV random (add time) and multiply noise texture value by the cap, then add the minimum back on to keep between min and max 
				return rand;    //Return this value
			}
			void Glitch()
			{
				_CutoutThresh = _GlitchCutoutThresh;
				_Amplitude = 150;
				_Speed = _GlitchSpeed;
			}
			v2f vert (appdata v)
			{	
				float glitchTest = Random(0, 1);
				if (glitchTest <= _GlitchChance)
				{
					Glitch();
				}
				v2f o;
				v.vertex.x += cos(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance ;   
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				float glitchTest = Random(0, 1);
				if (glitchTest <= _GlitchChance)
				{
					Glitch();
				}

				if (_Overheating == 1)
				{
					//_Color.r += tan(_Time.y * _SpeedOverheating );			//Explosion owo
					_Color.r += sin(_Time.y * _SpeedOverheating) ;			//Sobrecalentamiento owo
				}

				float4 col = tex2D(_MainTex, i.uv) + _Color;
				col.a = _Transparency;
				clip((tex2D(_TextureEffect, i.uv).r) + _Color.r - _CutoutThresh);   // "Descarta el píxel actual si el valor especificado es menor que cero".

				return col;
			}

			ENDCG
		}
	}
}
