#!/bin/bash
#FIXME Add usage() function to improve documentation

# Enable exposure of the specified GPIO pin (0-8)
gpio_enable()
{
  if [[("$1" -lt 0) || ("$1" -gt 8)]] ; then
    echo "Valid pins are 0-8"
    return -1;
  fi
  PIN=$((408 + $1));
  sudo sh -c "echo $PIN > /sys/class/gpio/export"
}
# Disables exposure of the specified GPIO pin (0-8)
gpio_disable()
{
  if [[("$1" -lt 0) || ("$1" -gt 8)]] ; then
    echo "Valid pins are 0-8"
    return -1;
  fi
  PIN=$((408 + $1));
  sudo sh -c "echo $PIN > /sys/class/gpio/unexport"
}
# Sets the pin to input or output mode
gpio_mode()
{
  if [[("$1" -lt 0) || ("$1" -gt 8)]] ; then
    echo "Valid pins are 0-8"
    return -1;
  fi
  PIN=$((408 + $1));
  if [[ ! -d /sys/class/gpio/gpio$PIN ]] ; then
    echo "GPIO$1 has not been enabled yet, please call gpio_enable"
    return -1
  fi
  MODE=""
  if [[("$2" == "in") || ("$2" == "IN")]] ; then
    MODE="in"
  elif [[("$2" == "out") || ("$2" == "OUT")]] ; then
    MODE="out"
  fi
  if [[ "$MODE" == "" ]] ; then
    echo 'Valid modes are "in" or "out"'
    return -1;
  fi
  sudo sh -c "echo $MODE > /sys/class/gpio/gpio$PIN/direction"
}
gpio_write()
{
  if [[("$#" -lt 2)]] ; then
    echo "Usage: gpio_write pin value"
    return -1
  fi
  if [[("$1" -lt 0) || ("$1" -gt 8)]] ; then
    echo "Valid pins are 0-8"
    return -1;
  fi
  PIN=$((408 + $1));
  #FIXME - Accept more than one word
  sudo sh -c "echo $2 > /sys/class/gpio/gpio$PIN/value"
}
gpio_read()
{
  if [[("$1" -lt 0) || ("$1" -gt 8)]] ; then
    echo "Valid pins are 0-8"
    return -1;
  fi
  PIN=$((408 + $1));
  cat /sys/class/gpio/gpio$PIN/value
}

# The MIT License (MIT) Copyright (c) 2016 Jeff Larkin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.