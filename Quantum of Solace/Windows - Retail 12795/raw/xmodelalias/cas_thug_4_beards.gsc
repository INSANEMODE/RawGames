// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "thug_bald";
	a[1] = "cas_thug_4_chin";
	a[2] = "thug_bald";
	a[3] = "cas_thug_4_beard";
	a[4] = "thug_bald";
	a[5] = "cas_thug_4_goatee";
	a[6] = "cas_thug_4_stache";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["cas_thug_4_beards_Body"] ) )
	{
		startIndex = randomint(7);
		level.nextXModel["cas_thug_4_beards_Body"] = startIndex;
	}
	index = level.nextXModel["cas_thug_4_beards_Body"];
	level.nextXModel["cas_thug_4_beards_Body"] = index+1;

	if( level.nextXModel["cas_thug_4_beards_Body"] >= 7 )
		level.nextXModel["cas_thug_4_beards_Body"] = 0;

	if( (index >= 7) || (index < 0))
		index = randomint(7);

	a = main();
	return a[ index ];
}
