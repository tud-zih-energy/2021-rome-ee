#pragma once

#define PREFIX "v"
#define POSTFIX "dqu"
#define REGISTER "y"

/*
%r[8-15] = *addr
%cl = 0
repeat instructions / 32 dynamic:
    repeat 4 static:
        shr %cl,%r[8-15]
*/
void shr_kernel(uint64_t *addr, uint64_t instructions) {
    // clang-format off
    __asm__ __volatile__(
    "nop;"
    "nop;"
        "xor %%cl,%%cl;"
    "nop;"
    "nop;"
        "mov 0(%%rbx),%%r8;"
        "mov 0(%%rbx),%%r9;"
        "mov 0(%%rbx),%%r10;"
        "mov 0(%%rbx),%%r11;"
        "mov 0(%%rbx),%%r12;"
        "mov 0(%%rbx),%%r13;"
        "mov 0(%%rbx),%%r14;"
        "mov 0(%%rbx),%%r15;"
        "jmp _work_loop_shr_8x4;"
        ".align 64,0x0;"
        "_work_loop_shr_8x4:"
        "shr %%cl,%%r8;"
        "shr %%cl,%%r9;"
        "shr %%cl,%%r10;"
        "shr %%cl,%%r11;"
        "shr %%cl,%%r12;"
        "shr %%cl,%%r13;"
        "shr %%cl,%%r14;"
        "shr %%cl,%%r15;"
        "shr %%cl,%%r8;"
        "shr %%cl,%%r9;"
        "shr %%cl,%%r10;"
        "shr %%cl,%%r11;"
        "shr %%cl,%%r12;"
        "shr %%cl,%%r13;"
        "shr %%cl,%%r14;"
        "shr %%cl,%%r15;"
        "shr %%cl,%%r8;"
        "shr %%cl,%%r9;"
        "shr %%cl,%%r10;"
        "shr %%cl,%%r11;"
        "shr %%cl,%%r12;"
        "shr %%cl,%%r13;"
        "shr %%cl,%%r14;"
        "shr %%cl,%%r15;"
        "shr %%cl,%%r8;"
        "shr %%cl,%%r9;"
        "shr %%cl,%%r10;"
        "shr %%cl,%%r11;"
        "shr %%cl,%%r12;"
        "shr %%cl,%%r13;"
        "shr %%cl,%%r14;"
        "shr %%cl,%%r15;"
        "sub $32,%%rax;"
        "jnz _work_loop_shr_8x4;"
        :
        : "a"(instructions), "b" (addr)
        : "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15", "memory"
    );
    // clang-format off
}

void xor_kernel(uint64_t* addr, uint64_t instructions)
{
    // clang-format off
    __asm__ __volatile__(
        "mov %%rax,%%r9;"   // addr
        "mov %%rbx,%%r10;"  // passes
        PREFIX "mov" POSTFIX " 0(%%r9), %%" REGISTER "mm0;"
        PREFIX "mov" POSTFIX " 0(%%r9), %%" REGISTER "mm1;"
        PREFIX "mov" POSTFIX " 0(%%r9), %%" REGISTER "mm2;"
        PREFIX "mov" POSTFIX " 0(%%r9), %%" REGISTER "mm3;"
        PREFIX "mov" POSTFIX " 0(%%r9), %%" REGISTER "mm4;"
        PREFIX "mov" POSTFIX " 0(%%r9), %%" REGISTER "mm5;"
        PREFIX "mov" POSTFIX " 0(%%r9), %%" REGISTER "mm6;"
        PREFIX "mov" POSTFIX " 0(%%r9), %%" REGISTER "mm7;"
        PREFIX "mov" POSTFIX " 64(%%r9), %%" REGISTER "mm8;"
        PREFIX "mov" POSTFIX " 64(%%r9), %%" REGISTER "mm9;"
        PREFIX "mov" POSTFIX " 64(%%r9), %%" REGISTER "mm10;"
        PREFIX "mov" POSTFIX " 64(%%r9), %%" REGISTER "mm11;"
        PREFIX "mov" POSTFIX " 64(%%r9), %%" REGISTER "mm12;"
        PREFIX "mov" POSTFIX " 64(%%r9), %%" REGISTER "mm13;"
        PREFIX "mov" POSTFIX " 64(%%r9), %%" REGISTER "mm14;"
        PREFIX "mov" POSTFIX " 64(%%r9), %%" REGISTER "mm15;"
        "jmp _work_loop_avx_store_pi_8;"
        ".align 64,0x0;"
        "_work_loop_avx_store_pi_8:"
        "vxorps %%ymm0, %%ymm8, %%ymm8;"
        "vxorps %%ymm1, %%ymm9, %%ymm9;"
        "vxorps %%ymm2, %%ymm10, %%ymm10;"
        "vxorps %%ymm3, %%ymm11, %%ymm11;"
        "vxorps %%ymm4, %%ymm12, %%ymm12;"
        "vxorps %%ymm5, %%ymm13, %%ymm13;"
        "vxorps %%ymm6, %%ymm14, %%ymm14;"
        "vxorps %%ymm7, %%ymm15, %%ymm15;"
        "vxorps %%ymm0, %%ymm8, %%ymm8;"
        "vxorps %%ymm1, %%ymm9, %%ymm9;"
        "vxorps %%ymm2, %%ymm10, %%ymm10;"
        "vxorps %%ymm3, %%ymm11, %%ymm11;"
        "vxorps %%ymm4, %%ymm12, %%ymm12;"
        "vxorps %%ymm5, %%ymm13, %%ymm13;"
        "vxorps %%ymm6, %%ymm14, %%ymm14;"
        "vxorps %%ymm7, %%ymm15, %%ymm15;"
        "vxorps %%ymm0, %%ymm8, %%ymm8;"
        "vxorps %%ymm1, %%ymm9, %%ymm9;"
        "vxorps %%ymm2, %%ymm10, %%ymm10;"
        "vxorps %%ymm3, %%ymm11, %%ymm11;"
        "vxorps %%ymm4, %%ymm12, %%ymm12;"
        "vxorps %%ymm5, %%ymm13, %%ymm13;"
        "vxorps %%ymm6, %%ymm14, %%ymm14;"
        "vxorps %%ymm7, %%ymm15, %%ymm15;"
        "vxorps %%ymm0, %%ymm8, %%ymm8;"
        "vxorps %%ymm1, %%ymm9, %%ymm9;"
        "vxorps %%ymm2, %%ymm10, %%ymm10;"
        "vxorps %%ymm3, %%ymm11, %%ymm11;"
        "vxorps %%ymm4, %%ymm12, %%ymm12;"
        "vxorps %%ymm5, %%ymm13, %%ymm13;"
        "vxorps %%ymm6, %%ymm14, %%ymm14;"
        "vxorps %%ymm7, %%ymm15, %%ymm15;"
        "sub $32,%%r10;"
        "jnz _work_loop_avx_store_pi_8;"
        :
        : "a"(addr), "b" (instructions)
        : "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15", "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5", "xmm6", "xmm7", "xmm8", "xmm9", "xmm10", "xmm11", "xmm12", "xmm13", "xmm14", "xmm15", "memory"
    );
    // clang-format on
}
