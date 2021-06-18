import subprocess
import numpy as np
from matplotlib import pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

def ideal(x=1, y=None, steps=100, ls=':', color='black', linewidth=.5, ax=None, **kwargs):
    if ax is None:
        ax = plt.gca()
    l_x = np.linspace(0, x, steps)
    if y is None:
        l_y = l_x
    else:
        l_y = np.linspace(0, y, steps)
    ax.plot(l_x, l_y, ls=ls, color=color, linewidth=linewidth, **kwargs)

def make_pdf(tag):
    filename = tag + '.pdf'
    pp = PdfPages(filename)
    pp.savefig()
    pp.close()
    subprocess.run(['pdfcrop', filename, filename])