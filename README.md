# Starbound-bardez-liquid-pump

This repo is a mod for [Starbound](https://playstarbound.com/), based on top of the
[Frackin' Universe](https://steamcommunity.com/sharedfiles/filedetails/?id=729480149) mod. This mod does the following:

Adds in 4 new items for liquid processing:

- Liquid Pressure Gauge (`bardez_liquid_compression_sensor`), an analog needle-display gauge that graphically ticks a needle to indicate pressure of foreground
liquid in front of the sensor. It wires output similar to power networks, and its metadata contains the amount of liquid detected, 
which can be connected to and emitted to the display.
- Liquid Pressure Display (`bardez_liquid_compression_display`), a digital display supporting up to 999 of the amount of liquid detected in the 1x1 block
in front of a connected Liquid Compression Sensor. This tells you how compressed a liquid in an area is!
- Liquid Capturing Drain (`bardez_liquid_drain`), which is both a drain and a container. It is a wirable object compatible with item transfer networks, too!
It will drain liquid in front of it when `on` and move that liquid into its container inventory.
- Quantum Liquid Compressor (`bardez_liquid_compressor`): this item is wirable, and when `on`, it will take a liquid in front of it an emit it
compressed back out on the side, with a slight multiplier. This makes it a cheat item. It is a neat alternative to the liquid drip mechanics of
infinite X liquids in the base game.
