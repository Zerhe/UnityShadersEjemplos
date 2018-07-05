Shader "Custom/SnowShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump" {}
		_Snow ("Snow Level", Range(0,1)) = 0
		_SnowColor ("Snow Color", Color) = (1.0,1.0,1.0,1.0)
		_SnowDirection ("Snow Direction", Vector) = (0,1,0)
		_SnowDepth ("Snow Depth", Range(0,0.3)) = 0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		//#pragma surface surf Standard fullforwardshadows
		#pragma surface surf Lambert vertex:vert


		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;
		float _Snow;
		float4 _SnowColor;
		float4 _SnowDirection;
		float _SnowDepth;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal;
			INTERNAL_DATA
		};

		void vert(inout appdata_full v) {
			//&nbsp;Convierte la normal a coordenadas del mundo
			float4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection);
			if (dot(v.normal, sn.xyz) >= lerp(1, -1, (_Snow * 2) / 3))
			{
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
			}
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			float4 c = tex2D (_MainTex, IN.uv_MainTex);				// Albedo comes from a texture tinted by color, color normal del píxel	
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump);		// Obtiene la normal del bump map
			if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= lerp(1, -1, _Snow))			// Obtiene el producto escalar entre el vector normal real y la dirección de la nieve y la compara con el nivel de nieve
				o.Albedo = _SnowColor.rgb;							// Si esto debiera ser nieve, asignar el color de la nieve.
			else
				o.Albedo = c.rgb;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
