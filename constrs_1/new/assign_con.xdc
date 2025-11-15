# Basys3 (Artix-7 XC7A35T) constraints for the updated top_parking ports

# Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.000 [get_ports clk]

# Buttons
set_property PACKAGE_PIN U18 [get_ports btn_entry]
set_property IOSTANDARD LVCMOS33 [get_ports btn_entry]

set_property PACKAGE_PIN T18 [get_ports btn_exit]
set_property IOSTANDARD LVCMOS33 [get_ports btn_exit]

set_property PACKAGE_PIN U17 [get_ports btn_reset]
set_property IOSTANDARD LVCMOS33 [get_ports btn_reset]

# 7-seg segments (seg[0]..seg[6]) -> a,b,c,d,e,f,g
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

# decimal point
set_property PACKAGE_PIN V7 [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]

# 7-seg anodes (an[0]..an[3]) - digit enables (an[0] = rightmost digit)
set_property PACKAGE_PIN U2 [get_ports {an[0]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]   ; set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


# User LEDs (leds[0]..leds[15]) - unique pins; map exactly 16 pins:
set_property PACKAGE_PIN W18 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]

set_property PACKAGE_PIN U16 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]

set_property PACKAGE_PIN E19 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]

set_property PACKAGE_PIN U19 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]

set_property PACKAGE_PIN V19 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]

set_property PACKAGE_PIN U15 [get_ports {leds[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]

set_property PACKAGE_PIN U14 [get_ports {leds[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[6]}]

set_property PACKAGE_PIN V14 [get_ports {leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[7]}]

set_property PACKAGE_PIN V13 [get_ports {leds[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[8]}]

set_property PACKAGE_PIN V3  [get_ports {leds[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[9]}]

set_property PACKAGE_PIN W3  [get_ports {leds[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[10]}]

set_property PACKAGE_PIN U3  [get_ports {leds[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[11]}]

set_property PACKAGE_PIN P3  [get_ports {leds[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[12]}]

set_property PACKAGE_PIN N3  [get_ports {leds[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[13]}]

# map leds[14] -> P1, leds[15] -> L1 and set IOSTANDARD
set_property PACKAGE_PIN P1 [get_ports {leds[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[14]}]

set_property PACKAGE_PIN L1 [get_ports {leds[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[15]}]


# If you prefer separate status LEDs, you can map led_available / led_full instead.
# In this XDC we mapped the bus to all 16 user LEDs and used leds[14]/leds[15] for status visually.

