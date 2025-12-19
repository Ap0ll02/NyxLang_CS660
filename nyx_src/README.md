# GP6 - Compiler Back End

## Installation

### Step 1: Install Zig

This project is developed and tested using Zig `0.15.1`.
We strongly recommend using this exact version, as Zig’s API is still evolving and may introduce breaking changes between releases.

You may optionally use ZVM to download and manage Zig versions, though it is not required.

#### Option 1 – Install ZVM

I would personally reccomend ZVM to manage zig versions most effortlessly NYAAAAAAAAAAA

Install Zig Version Manager:
PLEASE READ AND INSTALL FOR YOUR MACHINE FOR DIRECTIONS LOOK AT WEBSITE BELOW:
[https://www.zvm.app/](https://www.zvm.app/)

```fish
zvm install 0.15.1
```

To confirm the version of your zig compiler is 0.15.1, use (one can assume most minor versions will be acceptable):

```fish
which zig
```

If your version of zig is not matched, please run the following command (assuming you installed 0.15.1 with the above steps)

```fish
zvm use 0.15.1
```

#### Option 2: Zig Lang Download Page

[https://ziglang.org/download/](https://ziglang.org/download/)

### Step 2: Clone the repository

```fish
git clone https://github.com/Ap0ll02/NyxLang_CS660/tree/GP6
```

```fish
cd NyxLang_CS660
```

### Step 3: RISC-V 32-bit Toolchain & Spike (Required for Backend Testing)

To assemble and run the generated RISC-V output, you will need:

riscv32-unknown-elf toolchain (assembler + linker)

Spike RISC-V ISA simulator

PK (Proxy Kernel) for running bare-metal RISC-V programs

⚠️ Important:
These tools are not required to be installed system-wide and should not override your normal GCC toolchain.
We strongly recommend installing them in an isolated directory and invoking them explicitly.

#### Option 1: Prebuilt Toolchain (Recommended)

Download the official prebuilt RISC-V GNU toolchain:

Toolchain:

riscv32-unknown-elf-gcc

riscv32-unknown-elf-as

riscv32-unknown-elf-ld

From the official RISC-V toolchain releases:

👉 https://github.com/riscv-collab/riscv-gnu-toolchain/releases

Extract it somewhere safe, for example:

~/riscv/


You should end up with:

~/riscv/bin/riscv32-unknown-elf-gcc
`~/riscv/bin/riscv32-unknown-elf-as`
`~/riscv/bin/riscv32-unknown-elf-ld`


To verify:

`~/riscv/bin/riscv32-unknown-elf-gcc --version`


No PATH changes are required — just call the binaries directly.

Option 2: Build Toolchain from Source (Advanced)

If you prefer building from source:

```
git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
./configure --prefix=$HOME/riscv --with-arch=rv32im --with-abi=ilp32
make newlib
```


This installs everything under:

~/riscv/

Step 5: Install Spike + Proxy Kernel (PK)

Spike is the official RISC-V ISA simulator, and PK is required to run ELF binaries.

Build Spike
```
git clone https://github.com/riscv-software-src/riscv-isa-sim.git
cd riscv-isa-sim
mkdir build && cd build
../configure --prefix=$HOME/riscv
make
make install
```

Build Proxy Kernel (PK)
```
git clone https://github.com/riscv-software-src/riscv-pk.git
cd riscv-pk
mkdir build && cd build
../configure --prefix=$HOME/riscv --host=riscv32-unknown-elf
make
make install
```


This installs:

~/riscv/bin/spike
~/riscv/riscv32-unknown-elf/bin/pk

Step 6: Running Generated RISC-V Code

Once NYAC → RISC-V assembly is enabled:
```
~/riscv/bin/riscv32-unknown-elf-gcc a.s
~/riscv/bin/spike --isa=RV32GC ~/riscv/riscv32-unknown-elf/bin/pk a.out
```

This runs your compiled program inside the Spike simulator.

### Step 4: Compile

#### Compilation Modes

Currently, the compiler produces **3-address code (NYAC)** and it's translation to RISCV assembly is in the works.

```fish
cd nyx_src
zig build run -- src/<filename> [flags]
```

### Step 5: Testing Error Suit 
run ```zig build run -- errortest.nyx```
This should display many of the errors associated with nyx 

### Step 6: Testing Extra Credit 
run ```zig build run -- extracredit.nyx -d```
This will show that structs and our modified c syntax fully works
#### Flags

| Flags | Description |
| ----- | ----------- |
| `-d` | Debug Mode Output |
| `-a` | Transpile 3AC to RISC-V assembly |
| `-ad` | Compile to NYAC with debug output, then transpile to RISC-V |

- Here is a debug example: `zig build run -- jack.nyx -d`

- Here is an assembly example: `zig build run -- jack.nyx -a`

Note that assembly only prints to terminal as its development is still in progress.

The generated NYAC can be found in `a.nyac`

```fish
cat a.nyac
```

<!-- ## Input and Running -->

<!-- 
we currently support functions, arthmetic operations, logical operations, variable assignment. you should see an AST generated at the end of your file use or whatever. -->

<!-- ### Examples and Runtime Notes -->
<!-- 
Please ensure you use `Ctrl + d` to send the end of file (EOF) signal. This is the similar kill command to most REPL style programs. (Including some Scheme interpreters!)

Make sure to type valid c code for example 
```int main() { int 5; }``` -->

## ReadMe Questions

### Undergraduate Questions

#### How do you track when virtual registers are in use? How do you assign physical registers to them?

- Our compiler creates a list of NYAC structs, each representing an instruction and the virtual registers it defines and uses.
- Each NYAC is assigned a unique virtual register, which is incremented for every new temporary or variable reference.
- We perform liveness analysis by scanning the NYAC list backward to determine where each virtual register is live in or live out.
- Using that information, we build an interference graph, where nodes are virtual registers and edges connect registers that are live at the same time.
- Physical registers are then assigned through graph coloring with each color repersenting a real physical register.
- If the number of live registers exceeds the number of available physical registers, we spill excess ones to the stack and reload them when needed.
- This ensures that no two live virtual registers share the same physical register at the same time
- Thank you Dr.Harris for teaching us about this method

#### What needs to happen in each of the 4 phases of a function call? (10 points)

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

### Graduate Questions

#### What is instruction scheduling? Why do we not need to worry about it? (20 points)

- Instruction scheduling is basically the process of reordering instructions to keep the CPU pipeline busy and avoid stalls, without changing what the program actually does.
- We don’t need to deal with that here because our compiler just spits out a plain RISC-V text file that can be assembled and run through the riscv32-unknown-elfgirl toolchain.
- Our NYAC IR already lists everything in a linear order, thus the RISC-V assembly should run correctly (fingers crossed, meow).
- Real RISC-V processors and modern compilers already handle instruction scheduling automatically.
- For this project, our main focus is just getting register allocation, stack setup, and calling conventions right.
- Maybe in advanced compilers, you can teach us how to make an instruction scheduler!

![catgirl](../CatGirl&CatBoyPictures/catgirl1.png)
![catboy](../CatGirl&CatBoyPictures/catboy1.jpeg)

## Acknowledgements

Special thanks to our instructor, **Master Dahl**, for his excellent instruction throughout this compilers course. His expertise and dedication greatly enhanced our understanding of compiler design and directly contributed to the success of this project.
