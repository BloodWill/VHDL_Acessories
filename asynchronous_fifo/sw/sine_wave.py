# %%
import numpy as np
from scipy import signal as sg
import matplotlib.pyplot as plt

# %%
freq = 2
amp = 2
time = np.linspace(0, 2, 1000)

# %%
signal1 = amp*np.sin(2*np.pi*freq*time)

# %%
print(signal1)

# %%
plt.plot(time, signal1)
plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
plt.show()


