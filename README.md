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
