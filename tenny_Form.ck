fun float[] tCrystal ( float arr[] ) {
	float d1Exp, d2Exp1, d2Exp2;
	float tempMax;

	// find 1d exponent
	for ( 0 => int i; i < arr.cap(); i++ ) {
		arr[i] +=> d1Exp;
	}



	// find second 2d exponent
	for ( 0 => int i; i < arr.cap(); i++ ) {
		if ( arr[i] > tempMax ){
			arr[i] => tempMax;
		}
	}
	tempMax => d2Exp2;
}