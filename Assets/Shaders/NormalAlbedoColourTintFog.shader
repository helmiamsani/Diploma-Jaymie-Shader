// This section allows for easy sorting of our shader in the shader menu.
Shader "Lesson/Normal Albedo Colour Tint Fog"
{
	// Are the public properties seen on a material.
	Properties
	{
		_Texture("Texture", 2D) = "black"{}
		// Our Variable name is _Texture.
		// Our Display name is Texture.
		// It is of type 2D and the default untextured colour is  black.
		_NormalMap("Normal", 2D) = "bump"{}
		// Uses rgb colour value to create xyz depth to the material.
		// Bump tells unity this material needs to be marked as a Normal map
		// so that it can be used correctly.
		_Colour("Tint", Color) = (0,0,0,0)
		// RGBA Red Green Blue Alpha
		_FogColour("Fog Colour", Color) = (0,0,0,0)
		// RGBA Red Green Blue Alpha for Fog Colour

	}
	// You can have multiple subshaders.
	// These run at different GPU levels on different platforms.
	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
			// Tags are basically key-value pairs.
			// Inside a SubShader tags are used to determine.
			// Rendering order and other parameters of a subshader.

			// RenderType tag categorizes.
			// Shaders into several predefined groups.
		}
		CGPROGRAM // This is the start of our C for Graphics Language(Short for "Cg").
		#pragma surface mainColour Lambert finalcolor:FogColour vertex:Vert
		// The surfae of our model is affected by the mainColour Functions.
		// The material type is Lambert.
		// Lambert is a flat Material that has no specular (Shiny spots). 
		sampler2D _Texture;
		// This connects out _Texture Variable that is in the Properties section to our 2D _Texture Variable in CG.
		sampler2D _NormalMap; // connects our _NormalMap variable from Properties to the _NormalMap Variable in CG.
		fixed4 _Colour;
		// Reference to the input _Color in the Properties section
		// Fixed4 is 4 small decimals
		// Allows us to store RGBA
		/*
		High precision: float = 32 bits
		Medium precision: half = 16 bits	Range -60000 to +60000
		Low precision: fixed = 11 bits		Range -2.0 to +2.0
		*/		
		fixed4 _FogColour;
		// Refeernce to the input -FogColour in the Properties section

		struct Input 
		{
			float2 uv_Texture;
			// This is in reference to our UV map of our model.
			// UV maps are wrapping of a model. 
			// The letters "U" and "V" denote the axes of the 2D texture because "X", "Y", "Z" are already used to 
			// denote the axes of the 3D object in model space.
			float2 uv_NormalMap;
			// UV map link to the _NormalMap image.
			half fog;
		};

		void Vert(inout appdata_full v, out Input data)
		{
			UNITY_INITIALIZE_OUTPUT(Input, data);
			float4 hpos = UnityObjectToClipPos(v.vertex);
			hpos.xy / hpos.w;
			data.fog = min(1, dot(hpos.xy, hpos.xy) * 0.5);
		}

		void FogColour(Input IN, SurfaceOutput o, inout fixed4 colour)
		{
			fixed3 fogColour = _FogColour.rgb;
			#ifdef UNITY_PASS_FORWARDADD
			fogColour = 0;
			#endif
			colour.rgb = lerp(colour.rgb, fogColour, IN.fog);
		}

		void mainColour(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_Texture, IN.uv_Texture).rgba * _Colour;
			// Albedo is in reference to the surface Image and RGB of our model.
			// RGB (Red Green Blue).
			// We are setting the models surface to the colour of our Texture2D and matching the Texture to our models UV mapping.
			o.Normal = UnpackNormal(tex2D(_Texture, IN.uv_NormalMap));
			// _NormalMap is in reference to the bump map in Properties. 
			// UnpackNormal is required because the file is compressed we need to decompress and get the true value from the image.
			// Bump maps are visible when light reflects off the light is bounced off at angles according to the images RGB or XYZ value this creates the illusion of depth.
		}
		ENDCG // This is the end of our C for Graphics Language (Short for "Cg").
	}
	FallBack "Diffuse" // If all else fails standard shader(Lambert and Texture).
}
