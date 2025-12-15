# GP6 - Compiler Back End
## ReadMe Question
### Readme Question: How do you track when virtual registers are in use? How do you assign physical registers to them?
- Our compiler creates a list of NYAC structs, each representing an instruction and the virtual registers it defines and uses.
- Each NYAC is assigned a unique virtual register, which is incremented for every new temporary or variable reference.
- We perform liveness analysis by scanning the NYAC list backward to determine where each virtual register is live in or live out.
- Using that information, we build an interference graph, where nodes are virtual registers and edges connect registers that are live at the same time.
- Physical registers are then assigned through graph coloring with each color repersenting a real physical register.
- If the number of live registers exceeds the number of available physical registers, we spill excess ones to the stack and reload them when needed.
- This ensures that no two live virtual registers share the same physical register at the same time
- Thank you Dr.Harris for teaching us about this method
### What needs to happen in each of the 4 phases of a function call? (10 points).
- Pre-Call:
  - The compiler evaluates arguments and places them into registers. If the arguments exceed the available registers, it spills the remaining ones to the stack.
  - The compiler then creates a call frame by saving any caller-saved registers that hold live values across the call and adjusting the stack pointer for alignment.
- Prologue:
  - The callee saves any callee-saved registers that it will use.
  - It allocates space on the stack for local temporaries, saved state, and variables.
- Epilogue:
  - The callee places the return value in register a0 then restores all callee-saved registers, and deallocates its stack frame. 
  - It then returns to the caller
- Post-Call:
  - After returning, the caller restores any previously saved caller-saved registers and continues execution normally.
### CS660 Readme Question: What is instruction scheduling? Why do we not need to worry about it? (20 points).
- Instruction scheduling is basically the process of reordering instructions to keep the CPU pipeline busy and avoid stalls, without changing what the program actually does.
- We don’t need to deal with that here because our compiler just spits out a plain RISC-V text file that can be assembled and run through the riscv32-unknown-elfgirl toolchain.
- Our NYAC IR already lists everything in a linear order, thus the RISC-V assembly should run correctly (fingers crossed, meow).
- Real RISC-V processors and modern compilers already handle instruction scheduling automatically.
- For this project, our main focus is just getting register allocation, stack setup, and calling conventions right.
- Maybe in advanced compilers, you can teach us how to make an instruction scheduler!

## Installation

### Step 1: Install Zig 0.15.1

I would personally reccomend ZVM to manage zig versions most effortlessly NYAAAAAAAAAAA

#### Step 1.2 – Install ZVM
Install Zig Version Manager:
PLEASE READ AND INSTALL FOR YOUR MACHINE FOR DIRECTIONS LOOK AT WEBSITE BELOW:   
[https://www.zvm.app/](https://www.zvm.app/)

#### Step 1.3 – Switch to Development Branch

```
zvm install 0.15.1
```

To confirm the version of your zig compiler is 0.15.1, use (one can assume most minor versions will be acceptable):

```
which zig
```

If your version of zig is not matched, please run the following command (assuming you installed 0.15.1 with the above steps)

```
zvm use 0.15.1
```


#### Zig Lang Download Page 
https://ziglang.org/download/

### Step 2: Clone the repository

```fish
git clone https://github.com/Ap0ll02/NyxLang_CS660/tree/GP6
```

```fish
cd NyxLang_CS660
```

### Step 3: Executing 

```fish 
cd nyx_src/src
zig build run <filename> [optional flag, -d]
```

#### Flags
| Flags | Description |
| ----- | ----------- |
| -d | Debug Mode Output |

Here is a debug example: `zig build run -- jack.nyx -d`

## Input and Running 
we currently support functions, arthmetic operations, logical operations, variable assignment. you should see an AST generated at the end of your file use or whatever 

### Examples and Runtime Notes

Please ensure you use `Ctrl + d` to send the end of file (EOF) signal. This is the similar kill command to most REPL style programs. (Including some Scheme interpreters!)

Make sure to type valid c code for example 
```int main() { int 5; }```

### README Questions 

#### Regular Question


Additionally, you don't have to write to a specific assembly language/instruction set architecture. This is beneficial for portability of code.

#### Grad Question




![catgirl](../CatGirl&CatBoyPictures/catgirl1.png)
![catboy](../CatGirl&CatBoyPictures/catboy1.jpeg)
