
opendir( DIR, '.' );
@files = grep( /\.m$/, readdir(DIR) );
closedir DIR;
@files = grep( !/^contents.m$/, @files );
@files = sort( @files );
unshift( @files, "contents.m" );

open( CONCATFILE, ">commands.txt" ) || die "command.txt : $!";

foreach $file (@files)
{
	if ( extract($file)  )
	{
		print CONCATFILE "_" x 95 . "\n\n\n";
	}
}

close( CONCATEFILE );



sub extract
{
	my( $filename ) = $_[0];
	my ( $flag ) = 0;

	open( MFILE, $filename ) || die  "$filename : $!";

	while( defined($line=<MFILE>) && $line !~ /^%/ ) 
	{
	}

    @words = split( /\s/, $line );
	if ( $#words > 2 )
	{
	    $line = "% " . $words[1];
	}
	 
	while( defined($line) && $line =~ /^%/ && $line !~ /Cogent 2000 function/)
	{
	    $flag = 1;
	    chomp( $line );
		if ( length($line) > 2 )
		{
		    $line = substr( $line, 2, length($line)-2 );
		}
		else
		{
		    $line = "";
		}
	    
	    print CONCATFILE $line . "\n";
		$line = $line=<MFILE>;
	}

	close( MFILE );

	return $flag;
}


