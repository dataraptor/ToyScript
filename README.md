Table of contents
=================

<!--ts-->
   * [Introduction](#introduction)
   * [The Parser](#the-parser)
   * [The Scanner](#the-scanner)
   * [Commandline Usage](#commandline-Usage)
   * [Simple Hello World Program](#hello-world-using-toy)
   * [Features](#usage)
      * [STDIN](#stdin)
      * [Local files](#local-files)
      * [Remote files](#remote-files)
      * [Multiple files](#multiple-files)
      * [Combo](#combo)
      * [Auto insert and update TOC](#auto-insert-and-update-toc)
      * [GitHub token](#github-token)
      * [TOC generation with Github Actions](#toc-generation-with-github-actions)
   * [Tests](#tests)
   * [Dependency](#dependency)
   * [Docker](#docker)
     * [Local](#local)
     * [Public](#public)
<!--te-->


Introduction
============
The Toy Language is an easy to use and easy to learn general purpose high level programming language. It is developed using flex and bison and has basic features to solve basic and mid level problems.


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

## Variables
In toy currently there is no support for local variable, all variables are global. Local variable support may be available in future revision.
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

## Operators
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



<br>

## Comment
Syntax for the single line comment is:
```python
# comment
```
Multiline comment is not supported yet



<br>

## Decision making
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
  
## Loop
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
  
## Examples of Toy program
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
