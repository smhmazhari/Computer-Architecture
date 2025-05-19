
# Import numpy
import numpy as np

# Create a 1D NumPy array
arr = np.array([4,7,2,9,12,16,19])
print("Original array:", arr)

# Get the index of largest value
arr1 = np.argmax(arr[4])
print("Index of the maximum value:", arr1)

# Get the largest value in the array
arr2 = arr[arr1]
print("Largest value in the array:", arr2)