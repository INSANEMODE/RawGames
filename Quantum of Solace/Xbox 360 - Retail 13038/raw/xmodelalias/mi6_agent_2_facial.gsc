// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "mi6_agent_2_facial_beard";
	a[1] = "mi6_agent_2_facial_stache_glasses_ear";
	a[2] = "mi6_agent_2_facial_goatee";
	a[3] = "mi6_agent_2_facial_vandyke_glasses_ear";
	a[4] = "mi6_agent_2_facial_stache_ear";
	a[5] = "mi6_agent_2_facial_beard_glasses_ear";
	a[6] = "mi6_agent_2_facial_glasses_ear";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["mi6_agent_2_facial_Body"] ) )
	{
		startIndex = randomint(7);
		level.nextXModel["mi6_agent_2_facial_Body"] = startIndex;
	}
	index = level.nextXModel["mi6_agent_2_facial_Body"];
	level.nextXModel["mi6_agent_2_facial_Body"] = index+1;

	if( level.nextXModel["mi6_agent_2_facial_Body"] >= 7 )
		level.nextXModel["mi6_agent_2_facial_Body"] = 0;

	if( (index >= 7) || (index < 0))
		index = randomint(7);

	a = main();
	return a[ index ];
}
