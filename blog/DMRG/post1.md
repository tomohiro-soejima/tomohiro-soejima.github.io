@def title = "Infinite size density matrix renormalization group, revisited, revisited"
@def hascode = true
@def published = Date(2026, 2, ??)
@def rss = "This post explains how infinite DMRG works"
@def author="Tomohiro Soejima"

@def tags = ["syntax", "code"]

Density matrix renormalization group (DMRG) was introduced by Steve White to solve for the ground state of 1D spin chain. In its early instantiation motivated by numerical renormalization group (NRG), the DMRG algorithm optimized the wavefunction on an increasing large system size with the goal of approaching the infintie system size limit. This is the so-called iDMRG method. However, the early version of this algorithm was apparently hobbled with convergence issues, and it was abondoned in favor of finite DMRG.

Fast forward a couple of decades, iDMRG is the method of choice for finding translationally invariant ground state of quantum systems. To the best of my knowledge, this change in status is due to algorithmic improvements that made iDMRG easier to converge. One very important contribution in this direction was made by Ian McCulloch's "Infinite size density matrix renormalizationg group, revisited". In this short blog post, I will review the algorithm proposed in this paper.

@def maxtoclevel=3
\toc**

# Defining the central problem: How to grow the system
iDMRG is a variational method whose goal is to approximate the infinite-system size ground state of a translationally invariant Hamiltonian by a translationally invariant Matrix Product state (MPS).

A key ingredient of the iDMRG algorithm is that it is an iterative algorithm. We start from a small system size, and iteratively increase the size of the system, while modifying the "bulk" part of the system. The idea is that this will eventually result in a converged bulk, from which we can recover the translationally invariant ground state.

The tricky step in this whole process is how to write down an ansatz for an increased system size. We somehow need to patch together information from smaller system sizes to get an ansatz for a larger system size.

In the following, I will present how this can be done using the language of MPS.

## Quick review of MPS
I assume the readers are familiar with MPS. For background, you can read [Efficient numerical simulations with Tensor Networks: Tensor Network Python (TeNPy)
](https://arxiv.org/abs/1805.00055) or [The density-matrix renormalization group in the age of matrix product states
](https://arxiv.org/abs/1008.3477).

Here, we review some basic facts about MPS to set the notation.

We will use $[A]_{\alpha\beta}^i$ to denote left canonical MPS. It satisfies

$$
\sum_{\alpha, i} [A]_{\alpha\beta}^i [\bar A]_{\alpha\beta'}^i = \delta_{\beta\beta'}.
$$

We will use $[B]^i_{\alpha\beta}$ to denote right canonical MPS. It satisfies

$$
\sum_{\beta, i} [B]_{\alpha\beta}^i [\bar B]_{\alpha'\beta}^i = \delta_{\alpha\alpha'}.
$$

Later, we will suppress both the physical and virtual indices. For example, the left canonical tensor on $i$-th site will be denoted simply as $A_i$. It is convenient to index $A$ tensors from left, and $B$ tensors from right. 
We use $\Lambda_i$ to denote the gauge matrix that can transform between left and right canonical tensors. They (approximately) satisfy

$$
A_i \Lambda_i = \Lambda_{i-1} B_{?},
$$
where the subscript of $B$ depends on the system size, since we count from right.

## The growth algorithm: Two-site update example
Let us first review the growth algorithm for a two-site unit cell. As the base of the iterative procedure, we demand
1. State $\ket{\Psi_1} =  A_1 \Lambda_1 B_1.
2. State $\ket{\Psi_2} = A_1 \tilde A_2 \tilde \Lambda_2 \tilde B_2 A_1.

Given $\ket{\Psi_{n-2}}$ and $\ket{\Psi_{n-1}}$, the algorithm goes as follows.
1. Starting with the initial state $\tilde \theta_n = \tilde A_n \tilde \Lambda_n \tilde B_n$, solve for the lowest energy state of the effective Hamiltonian to obtain $\theta_n = A_n \Lambda_n B_n$.
2. By performing QR decomposition, rewrite $\Lambda_n B_n = \tilde A_{n+1} \Lambda_{n+1}^L$, $A_n \Lambda_n = \Lambda_{n+1}^R \tilde B_{n+1}$.
3. Define $\tilde \Lambda_{n+1} = \Lambda_{n+1}^L (\Lambda_{n-1})^{-1} \Lambda_{n+1}^R$
4. Create a new state $\ket{\Psi_{n+1}} = \ldots A_n \tilde A_{n+1} \tilde \Lambda_{n+1} \tilde B_{n+1} B_n \ldots$.
5. Go back to step 1.

Let us understand the choice made in steps 2-4. The first thing to check is gauge compatibility. We know the following three pairs are compatible:
1. $B_n$ and $B_{n-1}$
2. $A_{n-1} \Lambda_{n-1}$ and $B_{n-1}$
3. $A_{n-1}$ and $A_{n}$.

Combining these together, we indeed see $B_n (\Lambda_{n-1})^{-1} A_n$ is a gauge-compatible multiplication.

We can also confirm that the choice of initial state gives us a stationary solution.  