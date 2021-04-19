Pipelined Datapath Version 2.0  11/07/2019 

TEAM MEMBERS 
-------------

- Lobna ElHawary   / 900160270
- Marian Ramsis    / 900163444
- Shahd El Ashmawy / 900161393


Attached is the implementation of the pipelined datapath for the RISC-V processor. It supports the RV32I base integer instruction set, including an implementation of the EBREAK instruction which halts the program counter from updating, and prevents further instructions from being fetched. 

The code and results for the test cases used to test the functionality of the implementation are also attached in the zip file. 


ASSUMPTIONS 
------------
We assumed that the EBREAK instruction will turn the load of the PC = 0, when decoding (in the ID stage)
 
We assumed that values of ALU selection (produced by concatenating the ALUop with the func3 and func7 of the instruction) that control the ALU are not given and we assigned values of our own. 
The values given can be found below and in the excel sheet. 


AND : 0000       
OR  : 0001 
ADD : 0010
XOR : 0011
SRL : 0100
SRA : 0101
SUB : 0110
SLL : 0111
SLT : 1000
SLTU: 1001
Nothing : 1010 

We also assumed the design to not be directly influenced by that of RISC-V but maintain the same functionality. 

NAMING CONVENTIONS
------------------
We named the wire vars based on which register (the IF_ID, ID_EX, EX_MEM, MEM_WB) it comes from or goes into, followed by an underscore then a name to indicate what the data represents, followed by whether the wire is an input/output of the aforementioned registers.

For example:
ID_EX_cntrl_output represents the control signals coming out of the ID_EX register. 

ERRORS
-------
All the instructions we tested are working as expected.   

USER GUIDE
----------

The first instruction needs to be a nop:

      mem[0]=  8'b0_0110011;  //add x0,x0,x0
      mem[1] = 8'b0_000_0000;
      mem[2] = 8'b0000_0000;
      mem[3] = 8'b00000000;

 

