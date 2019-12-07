#!/usr/bin/env python
# coding: utf-8

# In[1]:


import matplotlib.pyplot as plt
import numpy as np


# In[2]:


#np.random.seed(1000)

no_of_patterns = 4
width = 4
height = 4
max_iterations = 10

#input vectors to train
X = np.zeros((no_of_patterns, width * height)) # rows = 4 & cols = 16
X[0] = [-1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1]
X[1] = [-1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1]
X[2] = [-1, -1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1]
X[3] = [1, 1, -1, -1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, 1, 1]
display(X)


# In[3]:


#The plot of Input patterns

fig, ax = plt.subplots(1, no_of_patterns, figsize=(10, 5))

for i in range(no_of_patterns):
    ax[i].matshow(X[i].reshape((height, width)), cmap='gray')
    ax[i].set_xticks([])
    ax[i].set_yticks([])
    
plt.show()


# In[4]:


#The Learning Part
#------------------#

#initializing the weighted matrix (16X16).... Why?
W = np.zeros((width * height, width * height))
#display(X.shape[1])
for i in range(width * height):
    for j in range(width * height):
        if i == j or W[i, j] != 0.0:
            # Keep the diagonal element as it is and jump to the next iteration.
            continue 
            
        w = 0
        
        for n in range(no_of_patterns):
            w = w + X[n, i] * X[n, j] # P = X[n, i]  &  P' = X[n, j]
        #display(w)
        #display('-----')
        W[i, j] = w 
        #display(W)
        #W[j, i] = W[i, j]


# In[5]:


W


# In[8]:


#Testing Part
#-------------#
x_test = np.array([-1, -1, 1, 1, 1, -1, 1, 1, -1, 1, 1, -1, 1, 1, -1, -1])
A = x_test.copy()
for _ in range(max_iterations):
    for i in range(width * height):
        A[i] = 1.0 if np.dot(W[i], A) > 0 else -1.0 	#np.dot is dot product implementation using numpy.


# In[9]:


# Show corrupted and recovered patterns
fig, ax = plt.subplots(1, 2, figsize=(10, 5))

ax[0].matshow(x_test.reshape(height, width), cmap='gray')
ax[0].set_title('Corrupted pattern')
ax[0].set_xticks([])
ax[0].set_yticks([])

ax[1].matshow(A.reshape(height, width), cmap='gray')
ax[1].set_title('Recovered pattern')
ax[1].set_xticks([])
ax[1].set_yticks([])

plt.show()


# In[ ]:


A


# In[ ]:




