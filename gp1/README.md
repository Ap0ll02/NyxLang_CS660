# GP1 - Bison/Flex Calculator

## Installation

### Step 1: Install Zig 0.15.1

I would personally reccomend ZVM to manage zig versions most effortlessly.

#### Step 1.2 – Install ZVM
Install Zig Version Manager:
PLEASE READ AND INSTALL FOR YOUR MACHINE FOR DIRECTIONS LOOK AT WEBSITE BELOW:   
[https://www.zvm.app/](https://www.zvm.app/)

#### Step 1.3 – Switch to Development Branch

`zvm install 0.15.1`

To confirm the version of your zig compiler is 0.15.1, use (one can assume most minor versions will be acceptable):

```which zig```

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
cd gp1
zig build run
```

## Input and Running 

Please note, that the zig library works in a curious way. We have made it so you can use a semicolon to end your line/code. 

An example of input can be seen below

### Examples 

```zig
45 * 54;
```

```zig
var_name = 50;
```

```zig
50 + var_name;
```

```zig
var_name++;
```
