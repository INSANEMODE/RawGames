// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "thug_bald";
	a[1] = "embassy_worker_02_beard_glasses";
	a[2] = "embassy_worker_02_goatee_glasses";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["embassy_worker_02_facial_Body"] ) )
	{
		startIndex = randomint(3);
		level.nextXModel["embassy_worker_02_facial_Body"] = startIndex;
	}
	index = level.nextXModel["embassy_worker_02_facial_Body"];
	level.nextXModel["embassy_worker_02_facial_Body"] = index+1;

	if( level.nextXModel["embassy_worker_02_facial_Body"] >= 3 )
		level.nextXModel["embassy_worker_02_facial_Body"] = 0;

	if( (index >= 3) || (index < 0))
		index = randomint(3);

	a = main();
	return a[ index ];
}
