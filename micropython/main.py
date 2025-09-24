from machine import Pin, SPI
import time

spi = SPI(0, baudrate=25000_000, polarity=0, phase=0, bits=6, firstbit=SPI.MSB,
          sck=Pin(2), mosi=Pin(3))
cs = Pin(5, Pin.OUT)
cs.value(1)

def create_message(command, data):
    command &= 0x03  # 2 bits
    data &= 0x0F     # 4 bits
    return (command << 4) | data  # 6-bit data in lower bits of byte

def send_spi_6bit(message):
    cs.value(0)
    spi.write(bytearray([message]))
    cs.value(1)
    
##send_spi_6bit(create_message(0b01,0xE))

