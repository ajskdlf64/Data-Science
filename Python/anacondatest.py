# Library
import numpy as np
import math
from matplotlib import pyplot as plt 
# Error Check
print("Hello Anaconda!")

# Sine Graph for matplotlib
n = 100
sintheta =  [ math.sin(theta) for theta in np.random.uniform(0, np.pi, n)] 
pplot = plt.plot(sintheta)
plt.axhline(y=0.5, color='r')
plt.title("Sin Values of Uniform Random Number")
plt.ylabel('Value')
plt.xlabel('Number of Trials')
plt.grid(True)
plt.show()