sampler tSampler;

struct VertexShaderOutput
{
    float4 Position : POSITION0;
	float2 TexCoord : TEXCOORD0;
};


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
    float4 retVal = tex2D(tSampler, input.TexCoord);
	//retVal.r = 0;
	
	
    return retVal;
}

technique Technique1
{
    pass Pass1
    {
        PixelShader = compile ps_1_1 PixelShaderFunction();
    }
}
