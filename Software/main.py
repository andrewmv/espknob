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
import network
import time
import micropython
import machine
import uasyncio
from eiscp import discover
from eiscp import eiscp

# Globals 

rot_position = 0
serviced_irq_count = 0
total_irq_count = 0
debounce_us = 2500
last_isr_tick = 0
wlan = None
rec_ip = None

# Functions

# Setup wifi
def do_connect():
	global wlan
	wlan = network.WLAN(network.STA_IF)
	wlan.active(True)
	if not wlan.isconnected():
		print('Connecting to network...')
		wlan.connect('BleatBand', 'headbutt')
		while not wlan.isconnected():
			pass
	print('network config:', wlan.ifconfig())

# Process a knob rotation event as an ISR
def rot_irq(pin=None):
	global rot_b, rot_position, debounce_us, last_isr_tick

	direction = rot_b.value()

	# DEBUG
	# total_irq_count += 1
	 
	# No-op if this IRQ was already serviced less than debouce_ms ago
	ticks = time.ticks_us()
	if (time.ticks_diff(ticks, last_isr_tick)) < debounce_us:
		return
	last_isr_tick = ticks

	# DEBUG Keep track of or IRQ count
	# serviced_irq_count += 1

	# Determine direction of rotation, and update our state
	if direction == 1:
		rot_position -= 1
	else:
		rot_position += 1

# Process a knob press event
def sw_irq(pin=None):
	global last_isr_tick, rot_position, debounce_us

	# No-op if this IRQ was already serviced less than debouce_ms ago
	ticks = time.ticks_us()
	if (time.ticks_diff(ticks, last_isr_tick)) < debounce_us:
		return
	last_isr_tick = ticks

	rot_position = 0

def onkyo_discover():
	while True:
		print('Discovering receivers on network...')
		recs = loop.run_until_complete(discover())
		if len(recs) > 0:
			if len(recs) > 1:
				print('Warning - found more than one eISCP receiver on network - choosing the first')
			print('Found receiver: ' + str(recs[0]))
			ip_start = recs[0].find(' ') + 1
			ip_end = recs[0].find(':')
			return recs[0][ip_start:ip_end]
		else:
			print('No receivers found - scanning again in 5 seconds')
			time.sleep(5)

def onkyo_init():
	# Make sure we're on wifi
	do_connect()
	# Discover receiver IP if we don't have it already
	if rec_ip = None:
		rec_ip = onkyo_discover()
	# Now that we have the IP, create and return a client
	return eiscp.eISCP(rec_ip)

def vol_up(rec, loop):
	print('Sending Volume Up Command')
	try:
		loop.run_until_complete(rec.command("MVL", "UP"))
	except ValueError

def vol_down(rec, loop):
	print('Sending Volume Down Command')
	loop.run_until_complete(rec.command("MVL", "DOWN"))

def main_loop():
	while True:
		old_pos = rot_position
		time.sleep_ms(250)
		if rot_position > old_pos:
			vol_up(rec, loop)
		elif rot_position < old_pos:
			vol_down(rec, loop)
			
### Init ###

print('Starting main.py v0.5')

# Pin mode configuration
led = machine.Pin(13, machine.Pin.OUT)
led.off()
rot_a = machine.Pin(14, machine.Pin.IN)
rot_b = machine.Pin(18, machine.Pin.IN)
rot_sw = machine.Pin(17, machine.Pin.IN)

# Pin interrupt handler configuration
trig_cond = machine.Pin.IRQ_RISING
wake_cond = (1 | machine.SLEEP | machine.DEEPSLEEP)
rot_a.irq(handler=rot_irq, trigger=trig_cond, wake=wake_cond)
rot_sw.irq(handler=sw_irq, trigger=trig_cond, wake=wake_cond)

# Setup emergency exception buffer to enable ISR stack traces
micropython.alloc_emergency_exception_buf(100)

# Find and connect to Onkyo device
rec = onkyo_init()

# Light LED to indicate we're connected and ready
led.on()

# Main loop
main_loop()

