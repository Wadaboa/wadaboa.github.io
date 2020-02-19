---
title: The Euler number in blob analysis
tags: [Computer Vision]
style: fill
color: secondary
description: "An in-depth look at the Euler number computation, along with a simple Python implementation, used to count the number of holes in a connected component."
---

{% include lib/mathjax.html %}

### Introduction

Blob analysis is the process whereby features are extracted from **Binary Large OBjects (BLOBs)**, where a BLOB is just a connected component inside a _binary image_ and a blob's feature could be its shape, position or orientation, for example.
The blobs analysis step is usually performed after _image binarization_ and _connected components labeling_, where each blob gets assigned a unique label (a number which is not related to gray-level values).
The features that we observe on a blob could be related to its _contour_ (e.g. the area of the blob), or they could be related to the _whole region_ (e.g. the perimeter of the blob).

### Euler number

When we refer to the Euler number in computer vision, more often than not we are not talking about the famous value

$$
e=\lim_{n\to+\infty} (1 + \frac{1}{n})^{n},
$$

but rather we are mentioning a **topological feature** related to blob analysis, which is invariant to the so-called _rubber-sheet transformations_, hence it is also similarity (rotation, translation and scale) invariant.
So, the **Euler number** is actually defined as follows:

$$
E = C - H,
$$

where $C$ is the number of connected components in our image and $H$ is the total number of **holes** in our blobs.
Usually, this blob feature is used to count the number of holes inside each connected component: to do so, you obviously need to set $C = 1$ and you also need a way to actually compute the Euler number.
It can be shown that, based on the chosen distance used to represent neighborhoods in our analysis, the Euler number can be easily computed by sliding some $2\times2$ binary patterns, named **bit quads**, across the image to count the number of occurrences of each pattern:

$$
E_{4} = \frac{1}{4} [n(Q_{1}) - n(Q_{3}) + 2n(Q_{D})],
E_{8} = \frac{1}{4} [n(Q_{1}) - n(Q_{3}) - 2n(Q_{D})],
$$

where $n(Q_{i})$ indicates the **number of matches** of the patterns $Q_{i}$ on our image, the subscrips indicate the chosen **distance** (i.e. 4 for city-block and 8 for chessboard distance) and the bit quads $Q_{i}$ are given by:

$$
Q_{1} =
\begin{bmatrix}
1 & 0 \\
0 & 0
\end{bmatrix}
%
\begin{bmatrix}
0 & 1 \\
0 & 0
\end{bmatrix}
%
\begin{bmatrix}
0 & 0 \\
1 & 0
\end{bmatrix}
%
\begin{bmatrix}
0 & 0 \\
0 & 1
\end{bmatrix}
$$

$$
Q_{3} =
\begin{bmatrix}
0 & 1 \\
1 & 1
\end{bmatrix}
%
\begin{bmatrix}
1 & 0 \\
1 & 1
\end{bmatrix}
%
\begin{bmatrix}
1 & 1 \\
0 & 1
\end{bmatrix}
%
\begin{bmatrix}
1 & 1 \\
1 & 0
\end{bmatrix}
$$

$$
Q_{D} =
\begin{bmatrix}
1 & 0 \\
0 & 1
\end{bmatrix}
%
\begin{bmatrix}
0 & 1 \\
1 & 0
\end{bmatrix}
$$

One thing to keep in mind is that when you compute the Euler number with the goal of counting the number of holes in a single blob, you should run the bit quads processing on an image which just contains the blob under analysis.

### Python implementation

In this section I will present my personal implementation of the computation of the Euler number and on how to count the number of holes in each connected component in our image. The following scripts will use the open-source libraries `opencv` and `numpy`, without explicitely importing them.
First of all, we have to define the bit quads as a _global dictionary_:

```python
BIT_QUADS = {
    '1': [
        np.array((
            [1, 0],
            [0, 0]),
            dtype="int"
        ),
        np.array((
            [0, 1],
            [0, 0]),
            dtype="int"
        ),
        np.array((
            [0, 0],
            [1, 0]),
            dtype="int"
        ),
        np.array((
            [0, 0],
            [0, 1]),
            dtype="int"
        )
    ],
    '3': [
        np.array((
            [0, 1],
            [1, 1]),
            dtype="int"
        ),
        np.array((
            [1, 0],
            [1, 1]),
            dtype="int"
        ),
        np.array((
            [1, 1],
            [0, 1]),
            dtype="int"
        ),
        np.array((
            [1, 1],
            [1, 0]),
            dtype="int"
        )
    ],
    'D': [
        np.array((
            [1, 0],
            [0, 1]),
            dtype="int"
        ),
        np.array((
            [0, 1],
            [1, 0]),
            dtype="int"
        )
    ]
}
```

Then, we need a way to _extract_ a single connected component from our labeled image. To do so, we can define a function which takes the _labeled image_ and the label of our target blob and returns a mask with just that specific region:

```python
def get_connected_component(labels, label):
    '''
    Return a specific connected component on a new image
    '''
    mask = np.zeros_like(labels, dtype=np.uint8)
    mask[labels == label] = 255
    return mask
```

The next step is the core of the operation, where we actually compute the Euler number of the mask extracted with the above defined method:

```python
def euler_number(comp, connectivity=8):
    '''
    Compute the Euler number of the given image,
    containing a single connected component
    '''
    matches = {'1': 0, '3': 0, 'D': 0}
    patches = get_strides((comp.copy() / 255), window_size=2)
    for quad_type, kernels in BIT_QUADS.items():
        for kernel in kernels:
            for roi in patches:
                res = roi - kernel
                if cv2.countNonZero(res) == 0:
                    matches[quad_type] += 1
    euler = matches['1'] - matches['3']
    euler = (
        euler + 2 * matches['D'] if connectivity == 4
        else euler - 2 * matches['D']
    )
    return int(euler / 4)
```

The function `get_strides` is used here to compute a matrix containing every possible $2\times2$ window of our image, so that we can just iterate over the pre-computed _strides_, rather than twist our head around indices in the Euler number computation function. The `get_strides` function is defined by:

```python
def get_strides(img, window_size):
    '''
    Return a new matrix, which is the set of sliding windows
    on the original image, of the given size
    '''
    shape = (
        img.shape[0] - window_size + 1,
        img.shape[1] - window_size + 1,
        window_size, window_size
    )
    strides = 2 * img.strides
    patches = np.lib.stride_tricks.as_strided(
        img, shape=shape, strides=strides
    )
    patches = patches.reshape(-1, window_size, window_size)
    return patches
```

Finally, we can deploy what we built up to now to **count the number of holes** in each blob:

```python
def holes_number(labels, num_labels, connectivity=8):
    '''
    Compute the number of holes for each connected component,
    excluding the background
    '''
    n_holes = [None] * num_labels
    for i in range(1, num_labels):
        comp = get_connected_component(labels, i)
        holes = 1 - euler_number(comp, connectivity)
        n_holes[i] = holes
    return n_holes
```

The `holes_number` function calls the `get_connected_component` function and, for each mask image, computes the number of holes as $H = 1 - E$, where $E$ is the value returned by `euler_number` by matching the bit quads across the mask image. Finally, a list indexed by the blob's label number is returned by the function, where each position contains the number of holes in that specific region.
If you don't know how to compute the **connected components** in your image, the `opencv` library has the following method available:

```python
num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(
    img, connectivity=8
)
```

### Final considerations

If you have any kind of issue or doubt, feel free to comment [my project on Github](https://github.com/Wadaboa/cv-con-rod-inspection), which is where I actually implemented the provided Python source code.
Anyway, I know that my way of computing the Euler number is not the fastest, so I'm looking on new ways to try and improve it. I think that the bottleneck may be _strides_ related.
