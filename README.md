# SwiftFuck
An experimental REPL interpreter for Brainfuck, written in Swift 🧠

### Language
This interpreter uses standard Brainfuck. There are 30 000 data cells by default, each holding one byte of data which can be read as single Unicode characters. The data pointer starts out with the leftmost cell, and all cells are initialized with 0. There are only 8 instructions:
- `>` Move the data pointer to the right.
- `<` Move the data pointer to the left.
- `+` Increment the data at the data pointer cell by one.
- `-` Decrement the data at the data pointer cell by one.
- `[` Start a loop closure that runs the enclosed code while the data isn't 0.
- `]` End a loop closure.
- `,` Read one byte of data (Unicode character) and store at the data pointer.
- `.` Write the data at the pointer (as a Unicode character).

The interpreter also supports using the input delimiter `!`, as a separator between source code and input.

### How to use
For now, just build the project and run the executable (which should be in `DerivedData` when built under `debug` in XCode). It can also be run in the XCode console, using schemes to supply parameters.

The executable can be run with the following options:
- `-e "<program>"` evaluates and executes the given string as a program.
- `-i "<program>!<input>"` the same as `-e` but uses everything after the `!` as an input queue.
- `-n <integer>` use the given number of data cells.
- `-l` print outputs on the same line.
- `-u` interpret data as unsigned bytes.

#### REPL
The program can be run without arguments, which opens the REPL:
```
Running Brainfuck REPL (30000 cells). Enter 'q' to quit.
[0]
→ 
```
Here commands can be entered and evaluated one by one. After every input, a pretty print of the data cells will be made, where each cell's value is printed as a signed integer, and the data pointer's current cell will be bracketed.
```
[0]
→ +>++>+++
1 2 [3]
→ 
```
When inputting a line of instructions containing `,` the REPL will ask for input and store the first character as a raw byte:
```
[0]
→ ,
Input byte:
A
[65]
→ 
```
When printing data with `.` the bytes will be printed as Unicode characters on new lines:
```
[65]
→ ++.
C
[67]
→
```

#### Executing programs
If the executable is run with the `-e` flag it will evaluate a given string of instructions:
```
$ swiftfuck -e ",>,>,<<.>.>."
Running Brainfuck program (30000 cells)…
Input byte:
A
Input byte:
B
Input byte:
C
A
B
C
$
```
Use the `-i` will also evaluate a program, but will also accept input after the `!` delimiter:
```
$ swiftfuck -i "+++[>,.<-]!ABC"
Running Brainfuck program (30000 cells)…
A
B
C
$
```

#### Options
Use the `-l` flag to print all output on the same line:
```
$ swiftfuck -l -e "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
Running Brainfuck program (30000 cells)…
Hello World!
$
```
Use the `-n` flag to set the total number of data cells (default is 30 000):
```
$ swiftfuck -l -n 2 -i "+++[>,.<-]!ABC"
Running Brainfuck program (2 cells)…
ABC
$
```
The `-u` flag renders data as wrapped, unsigned integers:
```
$ swiftfuck
Running Brainfuck REPL (30000 cells). Enter 'q' to quit.
[0]
→ -.
ÿ
[-1]
→ 
```
```
$ swiftfuck -u
Running Brainfuck REPL (30000 cells). Enter 'q' to quit.
[0]
→ -.
ÿ
[255]
→ 
```
Stepping outside the data cells will produce an error print-out, but won't crash.

```
$ swiftfuck -n 1
Running Brainfuck REPL (1 cell). Enter 'q' to quit.
[0]
→ <
Pointer out of bounds.
[0]
→ >
Pointer out of bounds.
[0]
→
```

### To do
- Verbose option
- Running program from file
- Writing output to file
