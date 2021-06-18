CC=gcc
CFLAGS=-fopenmp -O0

all: low_power_repnop low_power_pause low_power_sqrtsd low_power_fsqrt
.PHONY: all

low_power_repnop:
	$(CC) -o low_power_repnop low_power.c -DUSE_REPNOP $(CFLAGS)

low_power_pause:
	$(CC) -o low_power_pause low_power.c -DUSE_PAUSE $(CFLAGS)

low_power_sqrtsd:
	$(CC) -o low_power_sqrtsd low_power.c -DUSE_SQRTSD $(CFLAGS)

low_power_fsqrt:
	$(CC) -o low_power_fsqrt low_power.c -DUSE_FSQRT $(CFLAGS)

clean:
	rm low_power_repnop low_power_pause low_power_sqrtsd low_power_fsqrt
