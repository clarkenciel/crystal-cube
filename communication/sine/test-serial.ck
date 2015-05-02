SerialIO.list() @=> string list[];

for (int i; i < list.size(); i++) {
    chout <= i <= ": " <= list[i] <= IO.newline();
}

0 => int device;

SerialIO serial;
serial.open(device, SerialIO.B9600, SerialIO.BINARY);


1::second => now;

[0xff, 0xff] @=> int ping[];

serial.writeBytes(ping);

1::hour => now;
