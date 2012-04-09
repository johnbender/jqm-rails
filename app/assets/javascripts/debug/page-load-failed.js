$( document ).bind( "pageloadfailed", function( event, data ){
	$( "html" ).html( data.xhr.responseText.split( /<\/?html[^>]*>/gmi )[1] );
});