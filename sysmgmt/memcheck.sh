#!/bin/bash
# Check memory in a fancy way...
# scoday@gmx.com

formatmem() {
  echo ::memstat | mdb -k
}

formatmem
