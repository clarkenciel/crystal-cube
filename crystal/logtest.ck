[0,1] @=> int arr1[];
[2,3] @=> int arr2[];
0 => int dist;
0 => int tempdist;

for ( 0 => int i; i < arr1.cap(); i++ ) {
	Math.abs( arr2[i] - arr1[i] )  +=> tempdist;
	<<< tempdist >>>;
}	 

tempdist => dist;

<<< dist >>>;
