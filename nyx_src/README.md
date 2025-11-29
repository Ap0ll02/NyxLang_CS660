# GP5 - Compiler Back End

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
git clone https://github.com/Ap0ll02/NyxLang_CS660/tree/GP5
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

The benefits of having some IR instead of direct assembly is for easier cognitive load, and better optimization passes.
If you have the AST converted into an IR like 3ac, it might be easier than converting the AST into assembly for the programmer.
Then, with this abstraction between AST and assembly, the 3ac or IR might be more straightforwardly ported into Assembly.
This is brought to mind by having unlimited registers, and not having to worry about hardware limits quite yet, as AST -> Assembly is quite a task.
It can also be useful to have IR for optimization passes... or even Rust like borrow checking.

#### Grad Question

Other IR's useful to optimize programs include CFG's. They are very useful for dead code elimination optimizations.
This helps see the flow of code, more importantly, we see when program scopes are entered and exited which is key for dead code analysis.
Another IR that is useful is Rust's MLIR (mid-level intermediate representation). IT is mainly used for borrow checking, which is not *necessarily* a performance optimization,
but I think it could still be considered an optimization.


![catgirl](../CatGirl&CatBoyPictures/catgirl1.png)
![catboy](../CatGirl&CatBoyPictures/catboy1.jpeg)
