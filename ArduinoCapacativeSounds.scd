/* CODE BY THOMAS DESAI
-- based somewhat on the following experiment:
https://afternoondust.co.uk/blog/controlling-supercollider-using-an-arduino-sensor
*/


//SERVER

s.boot; // load SC server

// ARDUINO-READ

p = ArduinoSMS("COM5", 115200); // tell SC to read the serial port for the computer, use Arduino to work this out.


// SYNTHDEF STUFF


SynthDef(\death,{
arg freq = 666, gimme = 0, tone = 8, art = 1, amp = 1.5, pan = 0;
var env, out, mod;

	env = Env.perc(0, art + (gimme*0.1));
mod = 5 + (1/IRand(2, 6));

out = PMOsc.ar(freq, mod,
	pmindex: EnvGen.kr(env, timeScale: art, levelScale: 0.3),
	mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));

out = Pan2.ar(out, pan);

out = out * EnvGen.kr(env, timeScale: 1.3*art,
	levelScale: Rand(0.1, 0.5), doneAction:1);
Out.ar(0, out*amp); //Out.ar(bus, out);

}).add; // prepare sound -- here some nice bell chimes


l = Pdef(\life,
	Pbind(
	\instrument, "death",
	\degree, Pwhite (-6, 6),
	\dur, Pseq([1/8], inf),
	\amp, 0.3,
)).play;


z = Pbindef( \fuck,
	\instrument, "death",
	\degree, Pwhite (-6, 6),
	\dur, Prand([1/8, 1/4], inf),
	\amp, 1,
).play; // set a pattern to play with

////CONTROL

   (
        p.action = {
            | ... msg |
		msg.postln;
		z.set(\gimme,msg); // the capacative value is going to control the 'dirtyness' parameter here
        };
    ); // this is the function to make nice dirtyness with your capacative sensors.


p.close; // stop listening to the serial port.