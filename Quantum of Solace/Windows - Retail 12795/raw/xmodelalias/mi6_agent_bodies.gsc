// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "mi6_agent_1_body_bluetie";
	a[1] = "mi6_agent_1_body_redtie";
	a[2] = "mi6_agent_1_body";
	a[3] = "mi6_agent_1_body_tantie";
	a[4] = "mi6_agent_1_body_greentie";
	a[5] = "mi6_agent_1_body_silvertie";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["mi6_agent_bodies_Body"] ) )
	{
		startIndex = randomint(6);
		level.nextXModel["mi6_agent_bodies_Body"] = startIndex;
	}
	index = level.nextXModel["mi6_agent_bodies_Body"];
	level.nextXModel["mi6_agent_bodies_Body"] = index+1;

	if( level.nextXModel["mi6_agent_bodies_Body"] >= 6 )
		level.nextXModel["mi6_agent_bodies_Body"] = 0;

	if( (index >= 6) || (index < 0))
		index = randomint(6);

	a = main();
	return a[ index ];
}
