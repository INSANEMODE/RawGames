// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "cons_worker_1_head";
	a[1] = "cons_worker_2_head";
	a[2] = "cons_worker_3_head";
	a[3] = "cons_worker_4_head";
	a[4] = "cons_worker_5_head";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["cons_site_wrkr_heads_Body"] ) )
	{
		startIndex = randomint(5);
		level.nextXModel["cons_site_wrkr_heads_Body"] = startIndex;
	}
	index = level.nextXModel["cons_site_wrkr_heads_Body"];
	level.nextXModel["cons_site_wrkr_heads_Body"] = index+1;

	if( level.nextXModel["cons_site_wrkr_heads_Body"] >= 5 )
		level.nextXModel["cons_site_wrkr_heads_Body"] = 0;

	if( (index >= 5) || (index < 0))
		index = randomint(5);

	a = main();
	return a[ index ];
}
