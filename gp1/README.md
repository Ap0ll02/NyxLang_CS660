# GP1

## Bison/Flex Calculator

## Installation

### Step 1: Install Zig 0.15.1

Please ensure you install zig, you can find instructions [here](https://ziglang.org/) at ziglang.org 

*Note: I use [zvm](https://github.com/tristanisham/zvm) (zig version manager), I find it really helpful for version managing* 

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
