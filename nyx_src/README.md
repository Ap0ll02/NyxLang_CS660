# GP3 - Compiler Semantic Analysis

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
git clone https://github.com/Ap0ll02/NyxLang_CS660
```

```fish
cd NyxLang_CS660
```

### Step 3: Executing 

```fish 
cd nyx_src/src
zig build run <filename> [optional flag, -d]
```

Here is a debug example: `zig build run -- test.nyx -d`

## Input and Running 
You simply pass in the file as a flag, example above, with a .nyx file

### Examples and Runtime Notes

Please ensure you use `Ctrl + d` to send the end of file (EOF) signal. This is the similar kill command to most REPL style programs. (Including some Scheme interpreters!)

Make sure to type valid c code for example 
```int main() { int 5;}```

### README Questions

#### Regular Question

Nyaa~! For functions, I store a wefewence to their function node, nya, which wet me access detaiws wike their weturn type and pawametews when vewifying function cawws, meow~! For vawiabwes, I keep their decwawation node so I can ensuwe they'we defined befowe use and maintain consistency in type usage, purr~! For types, I wecowd their type node, which incwudes impowtant attwibutes wike whethew the type is signed ow const, its quawifiews, decwawatow, size, and awignment, nyaa~!

<!-- For functions, I store a reference to their function node, which allows me to access details such as their return type and parameters when verifying function calls. For variables, I keep their declaration node so I can ensure they are defined before use and maintain consistency in type usage. For types, I record their type node, which includes important attributes like whether the type is signed or const, its qualifiers, declarator, size, and alignment.  -->


#### Grad Question

Compiler diagnostics are really important, and I think having location, 
a description and a hint when applicable is really important. Extra good diagnostics
like in Rust, involve squiggly lines ~~~~ and arrows ^ to help show where to insert hints
and where to focus your attention in a line. Having the offending section of code is great.
Bad ones do not contain an easy way to identify where the error is taking place. Bad diagnostics
do not have good descriptions of an error, while good diagnostics have detailed error descriptions.


![catgirl](../CatGirl&CatBoyPictures/catgirl1.png)
![catboy](../CatGirl&CatBoyPictures/catboy1.jpeg)
