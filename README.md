# Toy-Interpreter

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
### Output:

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
### Output: 
```
Prime factors of 315: 
3 3 5 7
```

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
### Output:
```
Prime numbers from 0 to 50: 
0 1 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
```

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
### Output:
```
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181
```

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
### Output:
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
