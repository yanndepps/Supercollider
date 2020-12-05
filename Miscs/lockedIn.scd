(
s.options.memSize_(16384*10);
s.reboot;
s.waitForBoot({

	Ndef(\bits, {
		var t = PulseCount.ar(Impulse.ar(8e3));
		var u = PulseCount.ar(Impulse.ar(7009));
		var sig = HPF.ar(
			(
				((t * 15) & (t >> 5)) |
				((t * 5) & (t >> [3, 4])) |
				((t * 2) & (t >> 9)) |
				((t * 8) & (t >> 11)) |
				(((t*t) & t) | (t >> 3))
				- 3 % 256
			) / 127-1 * 3
			, 20
		) * 0.1;
		var sig2 = LPF.ar(HPF.ar(gcd(t*u, u+t), WhiteNoise.ar()*2000 + 1000), 20);
		sig2 = sig2*sig;
		sig = 0.3*Splay.ar(Limiter.ar(Greyhole.ar(sig + sig2, sig, 0.5, sig), 0.5).flatten);
	}).play;
});
)