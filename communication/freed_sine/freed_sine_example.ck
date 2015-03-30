SinOsc sin => dac;

SerialIO.list() @=> string list[];

for(int i; i < list.cap(); i++)
{
    chout <= i <= ": " <= list[i] <= IO.newline();
}

SerialIO serial;
serial.open(2, SerialIO.B9600, SerialIO.BINARY);

fun int[] bytePacker(int val, int num_bytes) {
    int bytes[num_bytes];
    
    for (int i; i < num_bytes; i++) {
        val >> (i * 8) & 0xff => bytes[i]; 
    }
    
    return bytes;
}

int vals[3];

while(true)
{
    Math.random2f(6000.0, 12000.0) => float freq;
    
    bytePacker((freq) $ int, 3) @=> vals;
    sin.freq(freq + 40);
    
    serial.writeBytes([vals[0], vals[1], vals[2], 0xff]);
    
    500::ms => now;
}