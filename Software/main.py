# 2021/10 Andrew Villeneuve
# uPython program to read rotary encoder, and send volume level commands
# to Onkyo receiver via eISCP
#
# Target platform: ESP32 (Sparkfun Thing Plus ESP32-S2 WROOM)
#
# Pins:
# 	A2/GPIO14: Rotary Encoder A
#	A1/GPIO18: Rotary Encoder B
#	A0/GPIO17: Rotary Encoder Switch
#

# Modules
#import eiscp
import network
import time
import micropython
import machine

# Functions

def do_connect():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    if not wlan.isconnected():
        print('Connecting to network...')
        wlan.connect('BleatBand', 'headbutt')
        while not wlan.isconnected():
            pass
    print('network config:', wlan.ifconfig())

def rot_irq(pin=None):
	global led
	if led.value() == 1:
		led.off()
	else:
		led.on()

# def onkyo_init():
# 	while True:
# 		print('Discovering receivers on network...')
# 		recs = eiscp.eISCP.discover(timeout=5)
# 		if len(recs) > 0:
# 			if len(recs) > 1:
# 				print('Warning - found more than one eISCP receiver on network - choosing the first')
# 			print('Found receiver: ' + str(recs[0]))
# 			return recs[0]
# 		else:
# 			print('No receivers found - scanning again in 5 seconds')
# 			time.sleep(5)

### Init ###

print('Starting main.py v0.2')

# Pin mode configuration
led = machine.Pin(13, machine.Pin.OUT)
led.off()
rot_a = machine.Pin(14, machine.Pin.IN, machine.Pin.PULL_UP)
rot_b = machine.Pin(18, machine.Pin.IN, machine.Pin.PULL_UP)
rot_sw = machine.Pin(17, machine.Pin.IN, machine.Pin.PULL_UP)

# Pin interrupt handler configuration
trig_cond = machine.Pin.IRQ_FALLING
wake_cond = (1 | machine.SLEEP | machine.DEEPSLEEP)
rot_a.irq(handler=rot_irq, trigger=trig_cond, wake=wake_cond)
# rot_sw.irq(handler=sw_irq, trigger=trig_cond, wake=wake_cond)

# Setup emergency exception buffer to enable ISR stack traces
micropython.alloc_emergency_exception_buf(100)

# Connect to wifi network
do_connect()

# Find and connect to Onkyo device
# rec = onkyo_init()
