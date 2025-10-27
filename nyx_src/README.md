# GP2 - Compiler Front End

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
cd gp2/src
zig build run <filename> [optional flag, -d]
```

Here is a debug example: `zig build run test.nyx -d`

## Input and Running 
we currently support functions, arthmetic operations, logical operations, variable assignment. you should see an AST generated at the end of your file use or whatever 

### Examples and Runtime Notes

Please ensure you use `Ctrl + d` to send the end of file (EOF) signal. This is the similar kill command to most REPL style programs. (Including some Scheme interpreters!)

Make sure to type valid c code for example 
```int main() { int 5;}```
![catgirl](../CatGirl&CatBoyPictures/catgirl1.png)
![catboy](../CatGirl&CatBoyPictures/catboy1.jpeg)
