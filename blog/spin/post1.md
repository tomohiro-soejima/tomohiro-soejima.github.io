@def title = "How to create transverse field Ising model Hamiltonian"
@def hascode = true
@def published = Date(2020, 11, 11)
@def rss = "This post explains how to create transverse field Ising model"
@def author="Tomohiro Soejima"

@def tags = ["syntax", "code"]

This is a short note explaining how to construct the sparse representation of the transverse-field Ising model. It is intended as a reading material for [Berkeley Physics DRP](https://berkeleyphysicsdrp.wixsite.com/physicsberkeleydrp), but I figured this might be useful for broader audience as well.

The article assumes knowledge of quantum mechanics (especially familiarity with spin-1/2 and Pauli matrices) and some familiarity with coding. All the code exmaples are provides in [Julia](https://julialang.org/), but you can more or less treat them as pseudocodes if you are unfamiliar with the language.

@def maxtoclevel=3
\toc

## Transverse-field Ising model
Transverse filed Ising model(TFIM) with open boundary condition is given by the following Hamiltonian:

$$ H = -J \sum_{i=1}^{N-1} S_i^x S_{i+1}^x + h \sum_{i=1}^N S_i^z$$
where $S^\mu$ are Pauli spin matrices for spin-1/2. We hope to represent this as a matrix, so that we can diagonalize it to find the ground state.

### Choice of basis states

We first need to figure out how to represent our basis states. Following convention, we map spin-up and spin-down spin to 0 and 1:

$$ |z; +1\rangle \rightarrow |0\rangle, |z; -1\rangle \rightarrow |1\rangle. $$

A state with $N$-spins can then be represented by a string of $N$ $0$'s and $1$'s. For example, a state with $N$ spin-down's is $|111\cdots 111>$. Such a string can be interepreted as a binary number.  Therefore, we will label our basis states by integer in range $[0, 2^N-1]$ such that the binary representation of the index corresponds to the state's spin configuration. The function for extracting spin configuration is straightforward:

```!
N = 4
index = 3
configuration = string(index, base=2, pad=N)
@show configuration
```

### Sparcity of the matrix
A Hamiltonian for $N$ spin-1/2 spins is a $2^N \times 2^N$ dimensional matrix. In order to store it densely, we would store $4^N$ entries. This quickly becomes impractical: the size of the matrix goes past 1 TB at mere 18 spins.

However, the matrix is in fact very sparse. Let's look at the action of $S^x S^x$ on the basis states. $S^x$ flips spin, so its action is:

$$ S^x_i S^x_{i+1} |\cdots 01 \cdots \rangle = |\cdots 10 \cdots \rangle. $$

Crucially, acting with $S^x S^x$ creates another basis state. Therefore, for given $S_i^x S_{i+1}^x$, **there is at most one basis state $k$ for each basis state $\ell$ such that $ \langle k | S^x_i S^x{i+1} |\ell\rangle$ is nonzero**. Using this counting for all $i$ and $\ell$, we conclude that there are at most $N 2^N$ nonzero metrix elements of H coming from $S^x S^x$ terms. Similar counting argument tells us there are at most $2^N$ terms from $S^z$ terms.

Therefore, the sparcity(the number of nonzero entries divided by the size) of this matrix is at most 

$$ \frac{(N+1) 2^N}{ 4^N} = \frac{N+1}{2^N}.$$

As $N$ increases, the matrix becomes very sparse.

### Sparse representation

There are different ways to represent a sparse matrix, each suitable for different purposes. For sparse matrix construction, we use the [**coordinate list (COO)** representation](https://en.wikipedia.org/wiki/Sparse_matrix#Coordinate_list_(COO)). The representation stores a list of row indices `I`, a list of column indices `J`, and a list of values `V`, such that the `n`th nonzero value has row index `I[n]`, column index `J[n]`, and value `V[n]`.

For our problem, we first fix the column index `column_index`, and a particular term in the Hamiltonian $S_i^x S_{i+1}^x$. Then, we can calculate the unique `row_index` such that `value=` $\langle\texttt{row\_index} | S_i^x S_{i+1}^x | \texttt{column\_index} \rangle$ is nonzero. We repeat this for all column indices and $S_i^x S_{i+1}^x$ terms. Here is a Julia code for doing this:

```julia
"""
A version that only does Sx terms. Generalizing this to include Sz terms is straightforward.
"""
function create_sparse_TFIM(N, J)
    I = Int[]
    J = Int[]
    V = ComplexF64[]
    for column_index in 1:2^N-1, i in 1:N-1
        row_index = get_unique_row_index(column_index, i, N)
        push!(I, row_index)
        push!(J, column_index)
        push!(V, J)
    end
    return I, J, V
end
```



#### How to get the unique `row_index`

It is a fun exercise to think about how to implement `get_unique_row_index` function. You should think about this yourself! Read on once you come up with your own implementation.

Here is one implementation:

```julia
function get_unique_row_index(column_index, i, N)
    reference_bits = 3 << (N + i - 3)
    return column_index ⊻ reference_bits
end
```
Where `<<` is the left [bitwise shift operator](https://stackoverflow.com/questions/141525/what-are-bitwise-shift-bit-shift-operators-and-how-do-they-work) and `⊻` is the XOR operator. Why does this work? To see this, notice that spin flip can be implemented via XOR operation:

$$ (\cdots 10 \cdots) \oplus (\cdots 11 \cdots) = (\cdots 01 \cdots)  $$

The bit shift operator adjusts the location of $11$ depending on the operator location $i$.

### Diagonalization

Once we are done creating the COO representation, we can transform that to other formats that are more suitable for linear algebra. Julia provides a builtin [**compressed sparse row(CSC) representation**](https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_column_(CSC_or_CCS)), which can be created as follows:

```julia
using SparseArrays
I, J, V = create_sparse_TFIM(N, J)
H = sparse(I, J, V)
```

Now you can use standard sparse eigensolvers. Julia provides a binding to `arpack`, which we can call like this:

```julia
using Arpack
vals, vecs = eigs(H, nev=3)
```

Other scientific languages (Python, R, Matlab, etc.) have their own libraries for sparse matrix linear algebra.