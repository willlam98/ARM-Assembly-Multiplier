# ARM-Assembly-Multiplier


Introduction to Computer Architecture (c) 2015, 2016 Imperial College London. Author: Thomas J. W. Clarke (see EEE web pages to contact).

EIE1/EE2 Introduction to Computer Architecture Programming Project Autumn 2018

The project has two parts, A and B. All students are expected to submit answers to Part A. It is expected that less than half of the class will submit answers to Part B, which has a much higher standard requird before any marks are awarded, and is also longer. Please do not spend a lot of time on an answer for B in the hope of getting marks. It is unlikely to benefit you.

All subroutines specified below must be APCS (Arm Procedure Call Standard) compliant as defined in CT6, section 6.6.

Parts A and B are submitted separately. In order to ensure you gain marks, following the exact instructions for how to submit your code, as given below, is important. Note that non-working answers to Part B, even if involving a lot of effort, will not be given marks.
Overall Assessment

Part
	

Subroutine
	

Weight

A
	

MUL16X16
	

30%

A
	

MUL32X32
	

30%

B
	

MUL128X128
	

40%
Part A
MUL16X16

This subroutine must obey APCS. In addition:

    Inputs
        R1(15:0) = a. R1(31:16) not used.
        R2(15:0) = b. R2(31:16) not used
    Outputs
        R0(31:0) = unsigned a*b
        R1 on output the same as R1 input value (all bits)
        R2 undefined
        R3 undefined
        R12 undefined

Assessment

Functionality (60%). The subroutine must deliver correct answers, and obey the APCS and the output specification above, for any values in input registers (R13 will contain a valid stack pointer to an APCS FD style stack).

Speed (40%). No marks will be awarded unless code is fully functional. For random data (which is typically 16 bits long) speed as measured by number of instructions executed will be assessed. Where solutions have data-dependent speed the average speed will be taken, where all bit patterns input have equal probability. Solutions as fast as the model solution will be awarded full marks for speed. The class median speed or below will be awarded zero marks. In between these two points marks will be scaled linearly with 1/N where N is is the (dynamic) number of cycles executed as given by Visual2 1.06.5+..
MUL32X32

This subroutine must obey APCS, and may call MUL16X16.

Note that the inputs here are all arbitrary pointers whose values are given to you by my testbench. You cannot assume anything about these values, or that they saty the same between one subroutine call and the next. My testbench will set up (input) and read (output) memory locations correctly to test the functionality, using random data.

    Inputs
        R1: pointer to memory word mem32[R1].
        R2: pointer to memory word mem32[R2].
        R3: pointer to sequence of memory words making a little-endian multiple-word unsigned number: mem32[R3], mem32[R3+4], mem32[R3+8], ...
        R1, R2, R3 are divisible by 4.
        You may assume the memory words specified by R3 are distinct from words mem32[R1] and mem32[R2], however R1 and R2 (and hence the input memory locations) may be the same.
    Outputs
        R3 must be the same as its value on input
        R0, R1, R2, R12 undefined
        Locations mem32[R3], mem32[R3+4], (using the R3 input value) are interpreted as a 64 bit unsigned integer Q stored in memory:
            Q(63:32) = mem32[R3+4]
            Q(31:0) = mem32[R3]
        Q must have the 64 bit unsigned product: P = mem32[R1] * mem32[R2] added to it in memory. Q := Q + P.
        The carry from the Q + P addition must be added to mem32[R3+8]. Similarly the carry from the addition to mem32[R3+n*4] must be added in memory to mem32[R3+(n+1)*4] for n = 2, 3, ...
            This process propagates carries through as many words as required with the effect of adding P to the (unspecified length) unsigned integer R stored with R(63:0) = Q and R(32n+31:32n) = mem32[R3+n]. It may be assumed that at some point, dependent on the supplied memory data, the carry addition will terminate with a zero carry.
        No other memory location must be changed (except for unused stack from nested subroutine calls).

The MUL32X32 code can call MUL16X16 any number of times but must not otherwise use the MUL16X16 code. It will be tested using a version of MUL16X16 written by the marker to the specification given above, which will not be identical to the student version. For example, your code for MUL16X16 may leave unchanged R3 and R12. That is fine, but when you call MUL16X16 from your MUL32X32 I will test this with my MUL16X16 which will change those registers.
MUL32X32 Assessment
Multiply Functionality (50%).

The subroutine must deliver correct answers, and obey the APCS and the output specification above, for inputs:

    R1, R2, R3 have arbitrary values divisible by 4 assigned by the testbench
    mem32[R1] and mem32[R2] have arbitrary values assigned by the testbench
    R13 contains a valid stack pointer to an APCS FD style stack
    mem32[R3] and mem32[R3+4] are set to 0 by the testbench
    Note that these marks can be gained for correct 64 bit output and no addition. Furthermore the carry propagation is not required for these marks.

Add functionality (20%)

    No marks will be awarded for add functionality unles multiply is fully working.
    In addition to the above, the memory output must be correct for any values set by the testbench for mem32[R3], mem[32+4], mem32[R3+8], ...

Code compactness (30%).

    No marks will be awarded for compactness unless code is fully working for multiply and Add.
    Compactness will be measured based on (static) number of instructions written in the MUL32X32 subroutine (not counting the MUL16X16 definition or any DCD, DCB definitions).
    Solutions as compact as the model solution will be awarded full marks for compactness.
    The class median compactness or below will be awarded zero marks.
    In between these two points marks will be scaled linearly with 1/N where N is is the static number of instructions in the submitted code.

Discussion of Part A

This work shows that you have the ability to write significant amounts of useful code, understanding the use of subroutines and memory. The assessment for code speed and compactness rewards those who can write more efficient (in different ways) code. MUL16X16 is easy and everyone whould be able to write it. MUL32X32 is harder because it requires accurate understanding of how memory access works, but not particularly complex. You can achieve partial marks for MUL32X32 by correctly implementing the multiplication but not the addition.

You may wish to note that long multiplication can be used, as learnt in school, using 2^16 as a radix.

Thus 32X32 bit multiplication can be implemented using 4 calls to the 16X16 multiply subroutine.
Submission of Part A

Submit your MUL16X16 and MUL32X32 subroutines in the same file each without test data or memory definitions. The test code I use will provide inputs and memory data suitable for testing. It will then test your MUL16X16 and your MUL32X32 independently. Your MUL32X32 will be tested for full credit with a working, correct MUL16X16 that I add. If this does not work the fallback will be to test it with your MUL16X16 for some credit.

That means that you can in theory get 100% for MUL32x32 without ever writing MUL16X16, however also you may lose marks if your MUL32X32 works only with your MUL16X16 but not with the test MUL16X16.

    Deadline: Wednesday 9th January 2019 22:00
    Submit links

Part B - MUL128X128

Using multiple calls to MUL32XMUL32 write a subroutine MUL128XMUL128 which performs 128X128 bit twos complement signed* multiplication, with inputs and outputs in memory, as follows.

    Inputs

        R1: pointer to 4 contiguous memory words: mem32[R1] ... mem32[R1+12] containing 128 bit little-endian non-negative signed number.

        R2: pointer to 4 contiguous memory words: mem32[R2] ... mem32[R2+12] containing 128 bit little-endian signed number.

        R3: pointer to 8 contiguous memory words: mem32[R3] ... mem32[R3+28] containing 256 bit little-endian signed number.
        You may assume that the output memory area specified by R3 does not overlap the areas specified by R1, R2. However R1 and R2 areas may overlap or be identical.

    Outputs
        R0, R1, R2, R3 undefined

        Locations mem32[R3] ... mem32[R3+28] must be written with the 256 bit signed product of the 128 bit numbers in memory specified by R1 and R2. The product is written as a little-endian signed number.

        Other memory locations must not be changed (except for unused stack). One consequence of this is that you cannot define memory locations with DCD. If you need to use memory for temporary results you must use stack memory which is released when your subroutine terminates.

        You may write subroutines to perform addition, subtraction, etc but may not write a multiply subroutine: all multiplication must be based on calls to MUL32X32 which will be given to you by my testbench and have the specification given above, but not necessarily be identical to your MUL32X32.

    Note

        All multiple word numbers stored in contiguous memory are stored unsigned little-endian such that for a number S with lowest memory location address A:

            mem32[A+4n] = S(32n+31:32n)

MUL128X128 Assessment
Functionality. (50%).

Is the specification met for all input values (both of R1,R2,R3 and memory locations)?
Speed. (50%).

    No marks will be awarded unless code is fully functional.
    Each call to MUL32X32 will be counted as approximately 150 cycles.
    The total time N of your code will be calculated as number of cycles executed as given by Visual2 v 1.06.5+, and speed calculated as 1/N. A speed mark will be awarded to solutions above median speed (of fully functional solutions) scaled linearly so that the model solution or faster is awarded 100% and the median speed solution 0. All other solutions will have zero speed mark.

Discussion of Part B

Warning. The reward for part B in terms of marks awarded for time taken is much lower than for Part A, and the risk is higher: it is easy to write an answer you think is correct which in fact does not work. In addition, the work is significantly more difficult than Part A, even in its most simple form. For this reason it is expected that less than 50% of the class will attempt this work. However, Part B this year is significantly easier than it has been in some previous years.

Fast solutions might (with much greater complexity) make use of Karatsuba multiplication or some variant to reduce execution time. Note however that these more complex algorithms will be more of a challenge to get working. If you want to try this, get a simpler (long multiplication) algorithm working and then test the complex algorithms against this with different random data to ensure correctness.

Visual2 v1.6.x has good testbench functionality (I'll provide email support through the vacation in case of bugs or issues). I supply you with minimal testbenches for Part A. Thus if your code passes the testbench I supply it is doing roughly the right thing, but not necessarily working properly. You are very strongly advised to add to the given testbench with your own data to check that your code works. Random numeric data is always a good way to test arithmetic.
Submission of Part B

Submit your MUL128X128 subroutine without test data, memory definitions, or MUL32X32. My testbench will append a MUL32X32 definition to your submitted code, and also provide inputs and memory data suitable for testing.

    Deadline: Wednesday 9th January 2019 22:00
    Submit link

Notes

    project finalised 5/12/2018

    Watch this space for typos, clarifications.
        9/12/2018 Part B inputs and outputs changed from unsigned to signed.
        11/12/2018 Part A definition of Q corrected to be little-endian consistent with R.
        11/12/2018. Textual clarifications. Speed assessment for MUL16X16 made more precise.
        11/12/2018. Publish Visual 1.06.5 with timing model. Use timing for speed assessment.

        13/12/2018. Altered submission of Part A so you can submit both subroutines in one file and get some credit for MUL32X32 working with your MUL16X16 as you will have tested it, even if it does not work with the official MUL16X16.
        13/12/2018 v2 of MUL32X32 testbench published.
        14/12/2018 improved documentation on testbenches

        22/12/2018 added assessment notes.

        2/1/2019 changed released MUL128X128 testbench to make R0 unsigned as per specification.

FAQ

    Q. In MUL16X16, does "bits 31:16 are not used" mean we can assume they will be 0 on inputs?
        A: No.
    Q. For Part A if my code passes the testbench you have provided can I assume that it will get all the "functionality" marks?
        A. No, because the testbench is not complete. However you can be sure you will get at least 50% of the functionality marks if it passes my testbench. You should read the spec and add tests yourself to obtain better testing.
    Q. Where are the supplied testbenches?
        A. See below.
    Q. Can I submit my MUL32X32 with my own MUL16X16 in one file?
        A. Yes. Your own MUL16X16 will be renamed and a correct (obeying the specification) MUL16X16 inserted so your MUl32X32 can be fairly tested. This means you must be careful not to have code in MUL32X32 that depends on your function not changing registers stated to be undefined on output in the specification. Some marks will be awarded if your MUL32X32 is functional with your MUL16X16 but not with mine.
    Q. Can I use tables to speed up MUL16X16?
        Yes you can, subject to a maximum total data size of 20kB (5K words). However note that due to the clock cycle time metric used for marking this will not necessarily be faster.
    Q. How can I get marks? See Notes

Testbenches

For usage please follow the tutorial under help->testbenches.

testbenches
