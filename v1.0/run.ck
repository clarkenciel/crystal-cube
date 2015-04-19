// run.ck

// communication class
Machine.add(me.dir()  + "/communication/Port.ck");
1::second => now;

// crystal classes
Machine.add(me.dir() + "/crystal/crystal_class.ck");
Machine.add(me.dir()+ "/crystal/map_crystal.ck");
500::ms => now;

// score
Machine.add(me.dir() + "/crystal/score.ck");
