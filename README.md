# hp-z6-g4-memory-fan-mounts

## Introduction

These are 3D-Printable [OpenSCAD](https://openscad.org/) models to
mount memory fans in an HP Z6 G4 workstation. These are in no way endorsed by HP.
Also, the author is not responsible for any damage resulting from their use.

<p align="center"><img src="../media/media/hp-z6-dual-memory-fan-mount.installed.jpg" alt="HP Z6 G4 with Dual Front Fan Mount"  height="350px" /></p>

## Caveats

This isn't an exact replacement for HP's memory shroud; it does not
guarantee sufficient air flow in all cases. It's also a tight fit, and
if you use your upper 5 1/4" drive area it may be impossible to use.
Also, it doesn't work with a second CPU. Finally, it can make it more
difficult to disassemble and reassemble your machine on a frequent basis. In
all these cases, you may wish to go in a different direction.

With all that said if you wish to add a DIMM or increase your memory
size past 32GB on a single CPU setup, it's probably sufficient.

## Model and Parts

Three models are included:

<div class="model" data-name="HP Z6 G4 Single 80 Memory Fan Mount" data-icon-size="128" data-left-icon="hp-z6-memory-fan-mount-single-80.icon.png" data-left="hp-z6-memory-fan-mount-single-80.stl">

### HP Z6 G4 Single 80 Memory Fan Mount

Replacement fan mount for the HP 80 mm front memory fan. It is installed just
like the OEM mount between the drive cage and the motherboard in the middle part of an
HP Z6 G4 workstation.

</div>

<div class="model" data-name="HP Z6 G4 Dual 80/80 Memory Fan Mount" data-icon-size="128" data-left-icon="hp-z6-memory-fan-mount-dual-80-80.icon.png" data-left="hp-z6-memory-fan-mount-dual-80-80.stl">

### HP Z6 G4 Dual 80/80 Memory Fan Mount

Replaces the single front memory fan with a dual 80 mm fan setup. Installed in the
area between the drive area and motherboard on an HP Z6 G4 workstation. The
secondary fan hangs off the primary memory fan and is aligned
with the upper set of DIMMs. 

</div>

<div class="model" data-name="HP Z6 G4 Dual 80/92 Memory Fan Mount" data-icon-size="128" data-left-icon="hp-z6-memory-fan-mount-dual-80-92.icon.png" data-left="hp-z6-memory-fan-mount-dual-80-92.stl">

### HP Z6 G4 Dual 80/92 Memory Fan Mount

Like the Dual 80/80 mount, except with a 92 mm secondary fan.

</div>

## A Note on HP Workstation 4-Pin Fan Connectors

The "standard" 4-pin HP Workstation fan connector is somewhat proprietary mechanically. Older fans tend
to have four color-coded wires and a reddish-brown connector ([JWT A2548H00-4P](http://www.jwt.com.tw/pro_pdf/A2548.pdf)).
Newer ones seem to have all black wires with a natural (white) connector (e.g. [Molex 22-01-3047](https://www.molex.com/en-us/products/part-detail/22013047)).
These connectors are polarized - both ends of the connector have small ribs. This differs from
4-pin PC-style PWM fans which have a 3+1 key ([Molex 47054-1000](https://www.molex.com/en-us/products/part-detail/470541000)).

Electrically, both PC- and HP-style are compatible and the signals are compatible
and in the same order: Ground, +12VDC, RPM sense, PWM control.

If you want to connect an after-market (i.e. "normal") PC-style PWM fan to an HP-style
motherboard header, you'll have to modify the connector. You can do this either by shaving
the middle key on the PC-style connector or by transplanting the crimped terminals to
an HP-style connector.

## What You'll Need...

### ...for the Single Mount

If you're missing a front memory fan, then you'll need a fan, otherwise, you can
reuse the existing fan and just add the guard and case fan screws.
Note that the dual mount replaces the existing single memory fan mount,
so to some extent the same directions apply.

#### An HP-Compatible 80 mm Fan

<img src="../media/media/fan.jpg" alt="Fan" align="right" width="250px" height="250px" />

Generally, you'll want to buy (or scavenge) an HP-compatible 80 mm x 25 mm PWM
+12VDC fan that has an HP-specific 4-pin connector and a cable length of about 4 inches.

The stock memory fan is a Foxconn PVA080G12Q (0.65A max, 0.35A nominal)
(HP: 907246-001) 12VDC PWM fan. Note that this fan is very common on ebay with
PC-style connector, so make sure you know what you're getting into. I can't find
a lot of 80 mm fans with the HP-style connector, so you might be stuck with ordering
a stock Z6 memory fan. Some other 80 mm fans I saw an HP-style connector:

- AVC DL08025R12U (0.50A) from HP 400 G3 SFF series (both styles)

I reused the stock fan and have not tested any other fans as the primary
memory fan.

#### An 80 mm Fan Guard <a name="guard" />

<img src="../media/media/guard.jpg" alt="Fan Guard" align="right" width="180px" height="180px" />

This is recommended. If you have a choice, go with a flat metal
one. Guards with a bulge fit but add a few mm's to the mount
and, as a result, the mount is much harder to install. Silver wire
matched my CPU fan.

#### Four Case Fan Screws <a name="screws" />

<img src="../media/media/screws.jpg" alt="Case Fan Screws" align="right" width="60px" height="60px" />

These seem more or less standard - silver or black, about 10 mm in length, very
coarse thread. Skip the plastic push-pins/rivets and rubber connectors.

### ...for the Dual Mount

The dual mount adds an additional fan that hangs off the primary
mount. There's cabling, which you have to build, and a second fan
to install in the mount.

#### Cabling

The connector on the motherboard for the second memory fan is intended
to attach to the HP Z6 G4 Memory Shroud (HP: 2HW44AA, 916799-001) and
is nonstandard. The shroud contains a single blower-style fan. The OEM fan is a Foxconn
PVB090G12L-P01-AB +12VDC (0.88A max, 0.70A nominal) 90 mm PWM Fan (HP: 907245-001).

The motherboard's 4-pin (2x2) connector is from the [Molex Micro Fit 3.0](https://www.molex.com/en-us/products/connectors/wire-to-board-connectors/micro-fit-connectors) family
and is actually a Blind-Mate Interface (BMI) part [Molex 44432-0401](https://www.molex.com/en-us/products/part-detail/444320401),
which would make the part on the shroud [Molex 44133-0400](https://www.molex.com/en-us/products/part-detail/441330400).
The location and pin-out are as follows:

**Pin-out** TBD.

<p align="center"><img src="../media/media/pinout.jpg" alt="MEMFAN Pinout" height="350px" /></p>

We can connect a 2x2 [Molex 43025-0400](https://www.molex.com/en-us/products/part-detail/430250400) connector
and bring the signals out to a "standard" fan connector by building a
cable.

There are many ways to construct the cable to connect a fan to that
header. What I did was use a precrimped Molex cable (crimping Molex
Mini-Fit is hard) and crimped on a 4-Pin Fan Header (easier to crimp). I ordered
parts from Aliexpress:

- [2x2P - Molex 3.0MM Micro-Fit Male](https://www.aliexpress.us/item/3256801843724035.html) - pre-crimped Molex wiring
- [Molex 2540 3+1 Pin Black Fan Male](https://www.aliexpress.us/item/2255799913539129.html) - crimpable shrouded fan headers

The shrouded fan header is [LHE C2505-HB04 / 5240B-4A](https://www.lhecn.com/wp-content/uploads/2019/01/C2505C250652405102-1.pdf)
and is sometimes referred to as Molex 2540, but that is not a valid part number.

#### A Second Fan (80 mm or 92 mm), Another Fan Guard, and Four More Case Fan Screws

Assuming you've made the cable yourself, and used the suggested standard PC-style
wiring and connector, then a matching 80 mm Foxconn PVA080G12Q with the PC-style
connector seems like an obvious choice. They are cheap and plentiful on
ebay.

You can also go with a 92 mm fan.

See above for recommendations on the [fan guard](#guard) and [case fan screws](#screws).

## Printing

I use a Creality Ender 3 Pro to build from PLA with a **layer height of 0.2 mm**
and **infill density of 20%** with **support generation**. In Cura, I
set "Support Placement" to "Touching Build Plate" and "Support Overhang Angle" set
to 45 degrees (the default).

After printing, remove the generated supports (at least 4 pieces: two under the
bottom tangs, two under the top tabs) and clean-up the print with utility knife.

## Installation

1.  Set your computer on its side and open up the side.

2.  Remove the existing front memory mount and fan. Refer to the
    [HP Z6 G4 Maintenance and Service Guide](https://support.hp.com/us-en/product/setup-user-guides/hp-z6-g4-workstation/16449901),
    page 27. Note the fan orientation (fan label forward)
    and cable routing. Once out the case, if you want to reuse
    the OEM 80-mm fan, just unclip it from the rear of the OEM mount.
    There is no need to remove the rear fan guard from the OEM fan.

3.  Rearrange any cable flow between the 5 1/4" drive bays and the
    motherboard to open up space. For example, push unused drive
    and CD-ROM power cables into the drive bays.

    If you're building a dual setup, you should probably check your
    electrical cabling prior to assembly. Also, it's not a bad idea
    to trial fit your 3D-printed part at this point, prior to adding
    fans, etc..

    <p align="center"><img src="../media/media/inspection.jpg" alt="Case and Mount Connections" height="350px" /></p>

4.  Assembly the new mount with your 3D-printed part:

    - Insert fans from back (fan labels forward), ensuring that the
      cables are routed nearest to connectors.
    - Screw the fan guards to the front of the mount.

    <p align="center"><img src="../media/media/assembled.jpg" alt="Fan with Mount Assembled"  height="350px" /></p>

5.  Install the mount in the computer. If you removed the OEM fan, then
    the installation is essential the reverse. The easiest sequence seems
    to be tilt the mount slightly forward, insert the bottom tangs in the
    cases slots, push the top tabs down a little and push the top tabs into
    the top slots. Verify a tight and secure fit.

    <p align="center"><img src="../media/media/installed.jpg" alt="Fan with Mount Installed"  height="350px" /></p>

6.  For added security, you can add a twist-tie (or wire) from the
    mount to the case at one of these locations: through the top
    thumbnail holes in the top of the primary fan mount, through the holes
    in top sides of each fan mount, or around the mount's bridge between
    a dual fan setup.

7.  Plug in the fan(s), reattach any hardware, power on and enjoy the cool breeze
    of the memory fans in your HP Z6\! If you want to test higher fan speeds,
    reboot into the BIOS Setup → Advanced → Built-In Device Options → Increase Idle Fan
    Speed(%) → 90 to create a small hurricane.

## Source

The fan mount is built using OpenSCAD. *hp-z6-memory-fan-mount-single-80.scad* is the main
file for the single fan model. *hp-z6-memory-fan-mount-dual-80-80.scad* and
*hp-z6-memory-fan-mount-dual-80-92.scad* builds the dual fan model with
secondary fan sizes of 80 mm or 92 mm respectively. Most of the code
and settings are found in *hp-z6-memory-fan-mounts.scad*.

### Fan Models

Models are used to visualize and verify the relative positions of holes and
mounts during debugging but not necessary for building. This project uses
80- and 92-mm fan models created from [Delta](https://www.delta-fan.com)
fan models. They were converted from STEP to stl format using
[IMAGEtoSTL](https://imagetostl.com/convert/file/stp/to/stl). The full set of
fan models referenced in the source are:

- 92 mm x 25 mm Fan: file _Delta-AFB0912HH.STL_ from [Delta AFB0912HH](https://www.delta-fan.com/AFB0912HH.html)
- 80 mm x 25 mm Fan: file _Delta-AFB0812HH.STL_ from [Delta AFB0812HH](https://www.delta-fan.com/AFB0812HH.html)
- 120 mm x 25 mm Fan: file _Delta-AFB1212HH.STL_ from [Delta AFB1212HH](https://www.delta-fan.com/AFB1212HH.html)

## Also Available on Thingiverse

STLs are available on [Thingiverse](https://www.thingiverse.com/thing:).