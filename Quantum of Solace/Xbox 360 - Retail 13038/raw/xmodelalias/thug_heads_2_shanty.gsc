// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "thug_02_head_olive_shanty";
	a[1] = "thug_02_head_shanty";
	a[2] = "thug_02_head_tan_shanty";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["thug_heads_2_shanty_Body"] ) )
	{
		startIndex = randomint(3);
		level.nextXModel["thug_heads_2_shanty_Body"] = startIndex;
	}
	index = level.nextXModel["thug_heads_2_shanty_Body"];
	level.nextXModel["thug_heads_2_shanty_Body"] = index+1;

	if( level.nextXModel["thug_heads_2_shanty_Body"] >= 3 )
		level.nextXModel["thug_heads_2_shanty_Body"] = 0;

	if( (index >= 3) || (index < 0))
		index = randomint(3);

	a = main();
	return a[ index ];
}
