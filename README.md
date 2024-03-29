ToyScript: Developing an Interpreter from Scratch
================
ToyScript is a simple and easy-to-learn programming language developed as a fun project. The main goal of ToyScript is to provide a beginner-friendly programming language that closely resembles the English language, making it accessible and intuitive for beginners to learn programming concepts.

The ToyScript compiler is built using flex and bison, which are powerful tools for lexical analysis and parsing. It generates tokens from ToyScript programs and matches them with predefined context-free grammars to create an Abstract Syntax Tree (AST). The AST can then be executed using an interpreter.

ToyScript supports basic programming features such as variable declaration, arithmetic and logical operators, decision making (if-else statements, switch-case statements), loops (for, while, do-while), and printing output on the screen. It also provides simple examples and documentation to help users get started quickly.

This project is ideal for students and programming enthusiasts who want to explore the fundamentals of programming languages and gain hands-on experience. Feel free to contribute to the project and experiment with the language to add more functionality and features.

To compile and run ToyScript programs, use the provided command-line usage guide. The project also includes a scanner and parser implementation, enabling you to understand the underlying process of lexical analysis and parsing in programming languages.

Explore ToyScript, have fun coding, and let your creativity flow!

![](images/toy.jpg?raw=true)

Table of contents
=================

<!--ts-->
   * [Introduction](#introduction)
   * [Commandline Usage](#commandline-usage)
   * [The Parser](#the-parser)
   * [The Scanner](#the-scanner)
   * [Project Overview](#project-overview)
   * [Token Generation](#token-generation)
   * [Simple Hello World Program](#hello-world-using-toy)
   * [Language Documentation](#documentation)
      * [Variable Declaration](#variable-declaration)
      * [Operators](#operators)
      * [Printing on Screen](#printing-on-screen)
      * [Decision Making](#decision-making)
      * [Loop](#loop)
      * [Examples](#example-programs)
   * [References](#references)
<!--te-->

<br>

Introduction
============
In this project a simple toy programming language has been developed. The Language is an easy to use and easy to learn general purpose high level programming language. It is developed using flex and bison and has basic features to solve basic and mid level problems.


<br>

Commandline Usage
=================
The following command was used to build the compiler 
```
bison -d toy.y && flex toy.l && gcc toy.tab.c lex.yy.c -lm -o toy
```
Use the following command to compile and run a program with Toy Compiler
```
./toy prog.toy
```


<br>

The Scanner
===========
Scanning, lexing or tokenization is the process of converting a sequence of characters (such as in a computer program or web page) into a sequence of tokens (strings with an assigned and thus identified meaning). A program that performs lexical analysis may be termed a scanner, lexer, tokenizer. In this project FLEX(fast lexical analyzer generator) is used as lexical analyzer.


<br>

The Parser
==========
Parser is a program that is used to break the data into smaller elements coming from lexical analysis phase. A parser takes input in the form of sequence of tokens and produces output in the form of parse tree. In this project Bison is used as the parser. Bison reads a specification of a context-free language, warns about any parsing ambiguities, and generates a parser (either in C, C++, or Java) that reads sequences of tokens and decides whether the sequence conforms to the syntax specified by the grammar. The generated parsers are portable: they do not require any specific compilers.


<br>

Project Overview
================
In this project a fully functional toy programming language has been developed. The main gole of this project is to make programming language as simple as possible. The syntax of toy is much closer to English language so anyone can easily understand programs written in toy language. Toy programs are easy to read and write. This would be very useful for students who wants to learn programming.  
The Toy compiler first take a Toy Program and it creates a sequence of tokens then these tokens are matched with predefined context free grammers and creates and Abstract Syntax Tree(AST). AST is the tree based representation of a program and can be executed like normal program. An interpreter has been implemented to execute the AST.



<br>

Token Generation
================
The following flex rules has been used to generate tokens from a toy program.
```c
"if"     return TOKEN_IF;
"else"	 return TOKEN_ELSE;
"while"  return TOKEN_WHILE;
"begin"  return TOKEN_BEGIN;
"end"    return TOKEN_END;
"do"     return TOKEN_DO;
"for"    return TOKEN_FOR;
"switch" return TOKEN_SWITCH;
"case"   return TOKEN_CASE;
"break"	 return TOKEN_BREAK;
"print"	 return TOKEN_PRINT;
"endl"	 return TOKEN_ENDLINE;

"and" 	 {yylval.op = '&'; return TOKEN_OPERATOR;}
"or"     {yylval.op = '|'; return TOKEN_OPERATOR;}
">="     {yylval.op = '@'; return TOKEN_OPERATOR;}
"<="     {yylval.op = '#'; return TOKEN_OPERATOR;}
"=="     {yylval.op = '$'; return TOKEN_OPERATOR;}
"!="     {yylval.op = 'n'; return TOKEN_OPERATOR;}

"++"     {yylval.op = 'p'; return TOKEN_UNARY_OPERATOR;}
"--"     {yylval.op = 'm'; return TOKEN_UNARY_OPERATOR;}
"not"    {yylval.op = 'n'; return TOKEN_UNARY_OPERATOR;}

"default" return TOKEN_DEFAULT;
[\n]      return TOKEN_NEWLINE;


\'(\\.|[^'\\])*\' {
  int len = strlen(yytext);   // 10
  yytext[len-1] = 0;
	
  yylval.name = strdup(yytext+1);
  return TOKEN_STRING;
}


[a-zA-Z_][a-zA-Z0-9_]* {yylval.name = strdup(yytext); return TOKEN_ID;}
[0-9]+     {yylval.val = atoi(yytext); return TOKEN_NUMBER;}
[()=:;]    {return *yytext;}
[*/+-<>^%] {yylval.op = *yytext; return TOKEN_OPERATOR;}
[ \t\n]    { }
#.*        {/* one-line comment */}

```


<br>

Hello World using Toy
=====================
```python
# helloworld.toy

begin 	# Hello World program using toy
  # my first program in Toy
  print 'Hello World' endl
  
end
```


<br>

Variable Declaration
====================
In toy all variables are global. Local variable support may be available in future revision.
The syntax for variable declaration in Toy programming is:
```python
varname = value
```
##### Example:
```python
var1 = 12
print var1

var1 = 12+2
print var1

var2 = var1+2
print var2
```
##### Output:
```
12
14
16
```

<br>

Operators
=========
#### Arithmetic Operators
The following table shows all the arithmetic operators supported by the Toy.  
Assume variable A holds 10 and variable B holds 20 then
Operator|Description|Example
------- | --------- | ------
+|Adds two operands.|A + B = 30
−|Subtracts second operand from the first.|A − B = -10
*|Multiplies both operands.|A * B = 200
/|Divides numerator by de-numerator.|B / A = 2
%|Modulus Operator and remainder of after an integer division.|B % A = 0
^|Power Operator|2 ^ 4 = 16

#### Relational Operators
The following table shows all the relational operators supported by Toy.  
Assume variable A holds 10 and variable B holds 20 then
Operator|Description|Example
------- | --------- | ------
==|Checks if the values of two operands are equal or not. If yes, then the condition becomes true.|(A == B) is not true.
!=|Checks if the values of two operands are equal or not. If the values are not equal, then the condition becomes true.|(A != B) is true.
\> |Checks if the value of left operand is greater than the value of right operand. If yes, then the condition becomes true.|(A \> B) is not true.
< |Checks if the value of left operand is less than the value of right operand. If yes, then the condition becomes true.|(A < B) is true.
\>=|Checks if the value of left operand is greater than or equal to the value of right operand. If yes, then the condition becomes true.|(A \>= B) is not true.
<=|Checks if the value of left operand is less than or equal to the value of right operand. If yes, then the condition becomes true.|(A <= B) is true.

#### Logical Operators
Following table shows all the logical operators supported by Toy.  
Assume variable A holds 1 and variable B holds 0, then
Operator|Description|Example
------- | --------- | ------
and|Called Logical AND operator. If both the operands are non-zero, then the condition becomes true.|(A and B) is false.
or |Called Logical OR Operator. If any of the two operands is non-zero, then the condition becomes true.|(A or B) is true.
not|Called Logical Not Operator. It inverts the logical value.|not A is false

#### Unary Operators
Following table shows all the unary operators supported by Toy.  
Assume variable A holds 4 and variable B holds 6, then
Operator|Description|Example
------- | --------- | ------
A++|++ as a postfix operator will return A's value first, then increments A's value by one.|B=A++, then B=4, A=5.
A--|-- as a postfix operator will return A's value first, then decrements A's value by one.|B=A--, then B=4, A=3.
++A|++ as a prefix operator will increments A's value by one, then returns A's value.|B=++A, then B=5, A=5.
--A|-- as a prefix operator will increments A's value by one, then returns A's value.|B=--A, then B=3, A=3.



<br>

Printing on Screen
==================
#### Printing a variable's value on screen
```python
var1 = 12
print var1
```
##### Output
```
12
```

#### Printing formatted string on screen
```python
var1 = 34
print 'Hello World %d' var1
```
##### Output
```
Hello World 34
```

#### Printing New Line on screen
```python
print 'Hello' endl
print 'World'
print endl endl
print 'Test'
```
##### Output
```
Hello
World

Test
```


<br>

Comment
=======
Syntax for the single line comment is:
```python
# comment
```



<br>

Decision Making
===============
The if-else statement is used to perform the operations based on some specific condition. The operations specified in if block are executed if and only if the given condition is true.  
There are the following variants of if statement in Toy language.
1. If statement
1. If-else statement
1. If else-if ladder
1. Nested if  

#### If Statement
The syntax of the if statement in Toy programming is:
```python
if expression do
  # Code
end
```
#### If...Else Statement
The syntax of the if...else statement in Toy programming is:
```python
if expression do
  # Code
else do
  # Code
end
```
#### If...Else If...Else Statement
The syntax of the if...else if...else statement in Toy programming is:
```python
if expression do
  # Code
else if expression do
  # Code
else do
  # Code
end
```
##### Example:
```python
begin   # Basic if else statement
  var = 6
  if var == 5 do
    print 'Five'
  else if var == 6 do
    print 'Eight'
  else if var == 7 do
    print 'Nine'
  else do
    print 'Unknown'
  end
end
```
##### Output:
```
Six
```
#### Nested If...Else
Example of nested if...else statement:
```python
begin 	# Nested if...else example
  
  var1 = 12
  var2 = 14
  
  if var1 == var2 do
    print 'var1 is equal to var2'
  else do
    print 'var1 is not equal to var2' endl
    if var1 > var2 do
      print 'var1 is greater than var2' endl
    else do
      print 'var2 is greater than var1' endl
    end
  end
  
end
```
##### Output:
```
var1 is not equal to var2
var2 is greater than var1
```

#### Switch Statement
The switch statement allows us to execute one or more code blocks among many alternatives.  
The syntax of the switch statement in Toy programming is:
```python
switch expression
  case constant1
    # statements
    break
	
  case constant1
    # statements
    break
  .
  .
  .
  default
    # default statements
end
```
##### Example:
```python
x = 4
switch x
  case 3
    print 'Three' endl
  case 4
    print 'Four' endl
  case 5
    print 'Five' endl
  case 6
    print 'Six' endl
    break
  case 7
    print 'Seven' endl
  case 8
    print 'Eight' endl
  default
    print 'Zero' endl
end
```
##### Output:
```
Four
Five
Six
```


<br>
  
Loop
====
In programming, a loop is used to repeat a block of code until the specified condition is met.  
Toy Language has three types of loops:
1. for loop
1. while loop
1. do...while loop

#### For loop
The syntax of the for loop in Toy programming is:
```python
for initializationStatement; testExpression; updateStatement do
  # statements inside the body of loop
end
```
##### Example:
```python
for x=20; x > 0; x=x-1 do
  print '%d ' x
end
```

#### While loop
The syntax of the while loop in Toy programming is:
```python
while testExpression do 
    # the body of the loop 
end
```
##### Example
```python
x = 0
while x <= 20 do
  print '%d ' x
  x = x + 1
end
```

#### Do While loop
The syntax of the do while loop in Toy programming is:
```python
do 
  # the body of the loop 
while testExpression
```
##### Example:
```python
x = 20
do
  print '%d ' x
  x = x - 1
while x >= 0
```


<br>
  
Example Programs
================
The following Toy program was compiled using Toy Compiler and the output was copied from the terminal after successfull execution of the program
#### Example 1: Draw arrow in screen
```python
# arrow.toy
begin  # Draw an arrow on screen
  n = 8
		
  for i=1; i<=n; i=i+1 do
    for j=1; j<=n-i; j=j+1 do
      print ' '
    end
    for k=0; k <= n-i; k=k+1 do
      print '*'
    end
    print endl
  end
		
  for i=1; i<n; i=i+1 do
    for j=1; j<i+1; j=j+1 do
      print ' '
    end
    for k=1; k<i+2; k=k+1 do
      print '*'
    end
    print endl
  end
		
end
```
##### Output:

```
       ********
      *******
     ******
    *****
   ****
  ***
 **
*
 **
  ***
   ****
    *****
     ******
      *******
       *******
```

#### Example 2: Find all prime factors of a given number
```python
# primes.toy
begin   # Prime number calculation Example

  n = 315
  print 'Prime factors of %d: ' n endl
    
  while 0 == n % 2 do
    print '%d ' 2
    n = n / 2
  end
    
  for i = 3; i <= sqrt(n); i=i+2 do
    while 0 == n % i do
      print '%d ' i
      n = n/i
    end
  end
    
  if n > 2 do
    print '%d ' n
  end
end
```
##### Output: 
```
Prime factors of 315: 
3 3 5 7
```

#### Example 3: Find all prime numbers within a given range
```python
# primes.toy
begin   # Prime number calculation Example
  n = 50
  print 'Prime numbers from 0 to %d: ' n endl
    
  for i = 0; i < n; i=i+1 do
    flag = 0
    for j = 2; j <= i/2; j=j+1 do
      if 0 == i%j do
        flag = 1
      end
    end
      
    if flag==0 do
      print '%d ' i
    end
  end
end
```
##### Output:
```
Prime numbers from 0 to 50: 
0 1 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
```


#### Example 4: Print Fibonacci series
```python
# fibo.toy
begin  # example of fibbonacci

  cnt = 20
		
  n1 = 0
  n2 = 1
  print '%d ' n1
  print '%d ' n2


  for i = 1; i < cnt-1; i=i+1 do
    n3 = n1 + n2
    print '%d ' n3
    n1 = n2
    n2 = n3
  end

end
```
##### Output:
```
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181
```

#### Example 5: Draw a diamond on screen
```python
# diamond.toy
begin  # Draw a diamond on screen
  
  n = 17
  spaces = n-1
  stars = 1
  for i=1; i<=n; i=i+1 do
    for j=1; j<=spaces; j=j+1 do
      print ' '
    end
    for k=1; k<=stars; k=k+1 do
      print '*'
    end
    if spaces>i do
      spaces = spaces-1
      stars = stars+2
    end
    if spaces<i do
      spaces = spaces+1
      stars = stars-2
    end
    print endl
  end
      
end   
```
##### Output:
```
                *
               ***
              *****
             *******
            *********
           ***********
          *************
         ***************
        *****************
         ***************
          *************
           ***********
            *********
             *******
              *****
               ***
                *
```


<br>

License
==========
Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)


References
==========
1. https://en.wikipedia.org/wiki/Lexical_analysis
2. https://en.wikipedia.org/wiki/Flex_(lexical_analyser_generator)
3. https://www.javatpoint.com/parser
4. https://en.wikipedia.org/wiki/GNU_Bison
6. https://stackoverflow.com/questions/11894326/what-is-an-abstract-syntax-tree-is-it-needed
7. https://softwareengineering.stackexchange.com/questions/254074/how-exactly-is-an-abstract-syntax-tree-created
8. https://github.com/AkshayGogeri/If-Else-Compiler-in-C
9. https://stackoverflow.com/questions/2644597/how-do-i-implement-if-statement-in-flex-bison
