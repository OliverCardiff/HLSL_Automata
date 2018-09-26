#define M_PI 3.14159265358979323846

sampler tSampler = sampler_state{ AddressU = WRAP; AddressV = WRAP; };

float2 xScreenSize;
Texture xTexture;
float xTime;

bool xBlueSpawn;
bool xGreenSpawn;

bool xRandomise;

sampler TextureSampler = sampler_state { texture = <xTexture> ; magfilter = LINEAR;
    minfilter = LINEAR; mipfilter=LINEAR; AddressU = WRAP; AddressV = WRAP;};

float2 mccool_rand(float2 ij)
{
  const float4 a=float4(M_PI * M_PI * M_PI * M_PI, exp(4.0), pow(13.0, M_PI / 2.0), sqrt(1997.0));
  float4 result =float4(ij,ij);

  for(int i = 0; i < 3; i++) 
  {
      result.x = frac(dot(result, a));
      result.y = frac(dot(result, a));
      result.z = frac(dot(result, a));
      result.w = frac(dot(result, a));
  }

  return (result.xy);
}


float4 select_pixel(float2 TexCoord, float2 pixelDist)
{
	float2 newCoords;
	float4 box[8];
	float4 direction[8] = 
	{
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
	};
	float2 dirCoords = float2(0,0);
	
	newCoords = TexCoord - pixelDist;
	box[0] = tex2D(tSampler, newCoords);
	
	if(box[0].r != 0)
	{
		dirCoords.x = xTime * box[0].r + box[0].b + box[0].g;
		dirCoords.y = xTime * box[0].r + box[0].b + box[0].g;
		direction[0] = tex2D(TextureSampler, dirCoords);
	}
	
	newCoords.y = TexCoord.y - pixelDist.y;
	newCoords.x = TexCoord.x;
	box[1] = tex2D(tSampler, newCoords);
	
	if(box[1].r != 0)
	{
		dirCoords.x = xTime * box[1].r + box[1].b + box[1].g;
		dirCoords.y = xTime * box[1].r + box[1].b + box[1].g;
		direction[1] = tex2D(TextureSampler, dirCoords);
	}
	newCoords.x = TexCoord.x + pixelDist.x;
	newCoords.y = TexCoord.y - pixelDist.y;
	box[2] = tex2D(tSampler, newCoords);
	
	if(box[2].r != 0)
	{
		dirCoords.x = xTime * box[2].r + box[2].b + box[2].g;
		dirCoords.y = xTime * box[2].r + box[2].b + box[2].g;
		direction[2] = tex2D(TextureSampler, dirCoords);
	}
	newCoords.x = TexCoord.x - pixelDist.x;
	newCoords.y = TexCoord.y;
	box[3] = tex2D(tSampler, newCoords);
	
	if(box[3].r != 0)
	{
		dirCoords.x = xTime * box[3].r + box[3].b + box[3].g;
		dirCoords.y = xTime * box[3].r + box[3].b + box[3].g;
		direction[3] = tex2D(TextureSampler, dirCoords);
	}
	newCoords.x = TexCoord.x + pixelDist.x;
	newCoords.y = TexCoord.y;
	box[4] = tex2D(tSampler, newCoords);
	
	if(box[4].r != 0)
	{
		dirCoords.x = xTime * box[4].r + box[4].b + box[4].g;
		dirCoords.y = xTime * box[4].r + box[4].b + box[4].g;
		direction[4] = tex2D(TextureSampler, dirCoords);
	}
	newCoords.x = TexCoord.x - pixelDist.x;
	newCoords.y = TexCoord.y + pixelDist.y;
	box[5] = tex2D(tSampler, newCoords);
	
	if(box[5].r != 0)
	{
		dirCoords.x = xTime * box[5].r + box[5].b + box[5].g;
		dirCoords.y = xTime * box[5].r + box[5].b + box[5].g;
		direction[5] = tex2D(TextureSampler, dirCoords);
	}
	newCoords.x = TexCoord.x;
	newCoords.y = TexCoord.y + pixelDist.y;
	box[6] = tex2D(tSampler, newCoords);
	
	if(box[6].r != 0)
	{
		dirCoords.x = xTime * box[6].r + box[6].b + box[6].g;
		dirCoords.y = xTime * box[6].r + box[6].b + box[6].g;
		direction[6] = tex2D(TextureSampler, dirCoords);
	}
	newCoords = TexCoord + pixelDist;
	box[7] = tex2D(tSampler, newCoords);
	
	if(box[7].r != 0)
	{
		dirCoords.x = xTime * box[7].r + box[7].b + box[7].g;
		dirCoords.y = xTime * box[7].r + box[7].b + box[7].g;
		direction[7] = tex2D(TextureSampler, dirCoords);
	}
	
	float4 retVal = float4(0,0,0,0);
	
	if(direction[4].r > 0 && direction[4].r < 0.125)
	{
		retVal = box[4];
	}
	if(direction[5].r >= 0.125 && direction[5].r < 0.25)
	{
		retVal = box[5];
	}
	if(direction[6].r >= 0.25 && direction[6].r < 0.375)
	{
		retVal = box[6];
	}
	if(direction[7].r >= 0.375 && direction[7].r < 0.50)
	{
		retVal = box[7];
	}
	if(direction[0].r >= 0.50 && direction[0].r < 0.625)
	{
		retVal = box[0];
	}
	if(direction[1].r >= 0.625 && direction[1].r < 0.75)
	{
		retVal = box[1];
	}
	if(direction[2].r >= 0.75 && direction[2].r < 0.875)
	{
		retVal = box[2];
	}
	if(direction[3].r >= 0.875 && direction[3].r < 1)
	{
		retVal = box[3];
	}
	float4 sum = float4(0,0,0,0);

	return retVal;
}

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;

};


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
    float2 pixelDist = 1/xScreenSize;
		
	float4 retVal = select_pixel(input.TexCoord, pixelDist);
	
	if(retVal.b != 0 || retVal.g != 0)
	{

		/*if(retVal.r > 0.0005)
		{
			retVal.a = 1;
			float2 coords;
			bool doSample;
		
			if(retVal.g > retVal.b)
			{
				if(xTime % (retVal.g  + retVal.r/2) < 0.016)
				{
					coords.xy = retVal.g;
					doSample = true;
				}
				else doSample = false;
			}
			else
			{
				if(xTime % (retVal.b  + retVal.r/2) < 0.016)
				{
					coords.xy = retVal.b;
					doSample = true;
				}
				else doSample = false;
			}
			if(doSample)
			{
				coords.y += xTime % 1;
				coords.x = retVal.r;
				float4 newDir = tex2D(TextureSampler, coords);
				retVal.r = newDir.r;
			}
		}
		else
		{
			retVal.r += 0.01;
		}*/
	}
	else
	{
		retVal.rgba = 0;
	}

    return retVal;
}

float4 PixelShaderFunction2(VertexShaderOutput input) : COLOR0
{
		
	float2 pixelDist = 1/xScreenSize;
	float4 origin = tex2D(tSampler, input.TexCoord);
	float4 retVal = origin;
	
	if(origin.a != 0 || xBlueSpawn || xGreenSpawn)
	{
		float2 newCoords;
		float4 box[8];
		float4 sum = float4(0,0,0,0);
		
		newCoords = input.TexCoord - pixelDist;
		box[0] = tex2D(tSampler, newCoords);
		
		newCoords.y = input.TexCoord.y - pixelDist.y;
		newCoords.x = input.TexCoord.x;
		box[1] = tex2D(tSampler, newCoords);
		
		newCoords.x = input.TexCoord.x + pixelDist.x;
		newCoords.y = input.TexCoord.y - pixelDist.y;
		box[2] = tex2D(tSampler, newCoords);
		
		newCoords.x = input.TexCoord.x - pixelDist.x;
		newCoords.y = input.TexCoord.y;
		box[3] = tex2D(tSampler, newCoords);
		
		newCoords.x = input.TexCoord.x + pixelDist.x;
		newCoords.y = input.TexCoord.y;
		box[4] = tex2D(tSampler, newCoords);
		
		newCoords.x = input.TexCoord.x - pixelDist.x;
		newCoords.y = input.TexCoord.y + pixelDist.y;
		box[5] = tex2D(tSampler, newCoords);
		
		newCoords.x = input.TexCoord.x;
		newCoords.y = input.TexCoord.y + pixelDist.y;
		box[6] = tex2D(tSampler, newCoords);
		
		newCoords = input.TexCoord + pixelDist;
		box[7] = tex2D(tSampler, newCoords);
		
		for(int i = 0;i < 8; i++)
		{
			sum += box[i];
		}
		
		if(xBlueSpawn && box[0].b > 0)
		{
			if(sum.b == box[0].b)
			{
				float2 cool = mccool_rand(input.TexCoord);
				retVal = float4(cool.y, 0, cool.x/2, 1);
			}
		}
		if (xGreenSpawn && box[0].g > 0)
		{
			if(sum.g == box[0].g)
			{
				float2 cool = mccool_rand(input.TexCoord);
				retVal = float4(cool.y, cool.x/2, 0, 1);
			}
		}
		else if(origin.a != 0)
		{
			if(origin.b > origin.g)
			{
				float max = box[0].b;
				float red;
				float red2;
				float green = box[0].g;
				int captureI = 0;
				
				for(int i = 1;i < 8; i++)
				{
					if(box[i].g > green)
					{
						green = box[i].g;
						red2 = box[i].r;
					}
					if(box[i].b > max)
					{
						max = box[i].b;
						red = box[i].r;
						captureI = i;
					}
				}
				if(sum.g > sum.b)
				{
					retVal.b = 0;
					retVal.g = green;
					retVal.r = red2;
				}
				else if(max != 0 && max > origin.b)
				{
					retVal.b = max;
					retVal.r = red;
				}
				else if(max == origin.b && captureI > 3)
				{
					retVal.r = red;
				}
			}
			else
			{
				float max = box[0].g;
				float red;
				float red2;
				float blue = box[0].b;
				int captureI = 0;
				
				for(int i = 1;i < 8; i++)
				{
					if(box[i].b > blue)
					{
						blue = box[i].b;
						red2 = box[i].r;
					}
					if(box[i].g > max)
					{
						max = box[i].g;
						red = box[i].r;
						captureI = i;
					}
				}
				if(sum.b > sum.g)
				{
					retVal.g = 0;
					retVal.b = blue;
					retVal.r = red2;
				}
				else if(max != 0 && max > origin.g)
				{
					retVal.g = max;
					retVal.r = red;
				}
				else if(max == origin.g && captureI > 3)
				{
					retVal.r = red;
				}
			}
		}
      if(xRandomise)
      {
		  retVal.r = mccool_rand(input.TexCoord).x;
      }

	}

	return retVal;
}

technique Technique1
{
    pass Pass0
    {
        PixelShader = compile ps_3_0 PixelShaderFunction();
    }
    pass Pass1
    {
        PixelShader = compile ps_3_0 PixelShaderFunction2();
    }
}
