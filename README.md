# spi-slave-to-7segLED
A demo written for experimental Tiny Tapeout ECP5 prototyping board.
## Description

The design implements a SPI-slave device for seven-segment display on TT base board. TT FPGA controls seven-segment display via spi-slave and the RP2040 just sends it a 6-bit message to light up the LEDs.

## How to run this design
You'll need a 
(i) TinyTapeout Demo Board, 
(ii) TinyTapeout ECP5 Breakout Board and 
(iii) Raspberry Pi Pico.

![TT Demo board with ECP5 Breakout](_assets/TT_FPGA.jpg)

## Demonstration running on the TT FPGA Breakout Board :

![webp](_assets/spi_7segment_tt.webp)