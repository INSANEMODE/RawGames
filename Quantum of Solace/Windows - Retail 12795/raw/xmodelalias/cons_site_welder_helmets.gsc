// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "cons_site_welder_helm";
	a[1] = "cons_site_welder_helm_up";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["cons_site_welder_helmets_Body"] ) )
	{
		startIndex = randomint(2);
		level.nextXModel["cons_site_welder_helmets_Body"] = startIndex;
	}
	index = level.nextXModel["cons_site_welder_helmets_Body"];
	level.nextXModel["cons_site_welder_helmets_Body"] = index+1;

	if( level.nextXModel["cons_site_welder_helmets_Body"] >= 2 )
		level.nextXModel["cons_site_welder_helmets_Body"] = 0;

	if( (index >= 2) || (index < 0))
		index = randomint(2);

	a = main();
	return a[ index ];
}
