#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#define NR_MEASUREMENTS 10000
static long long cycles[NR_MEASUREMENTS+1];

/*
Intel
MSR 0x619 which contains RAPL energy information for DRAM
MSR 0x641 which contains RAPL energy information for GPU
MSR 0x639 which contains RAPL energy information for cores
MSR 0x611 which contains RAPL energy information for the Package

AMD
Core: 0xC001029A
Package: 0xC001029B
*/
static long long MSR=0xC001029A;


#define sync_rdtsc2(val) \
   do {\
      unsigned int cycles_low, cycles_high;\
      asm volatile("RDTSCP\n\t"\
      "mov %%edx, %0\n\t"\
      "mov %%eax, %1\n\t"\
      "CPUID\n\t": "=r" (cycles_high), "=r" (cycles_low):: "%rax", "%rbx", "%rcx", "%rdx");\
      (val) = ((unsigned long) cycles_low) | (((unsigned long) cycles_high) << 32);\
   } while (0)


void main()
{
	long long status;
        long long cur_status;
	char buffer[256];
	sprintf(buffer,"/dev/cpu/0/msr");
	int fd = open(buffer,O_RDWR);
	pread(fd,&status,8,MSR);
        sync_rdtsc2(cycles[0]);
	for ( int i=1 ; i<NR_MEASUREMENTS ; i++ )
	{
		do
		{
			pread(fd,&cur_status,8,MSR);
		} while(cur_status==status);
		status=cur_status;
		sync_rdtsc2(cycles[i]);
	}

        for ( int i=2 ; i<NR_MEASUREMENTS-1 ; i++ )
		printf("%lli\n",cycles[i]-cycles[i-1]);

}
