# Review of the Chern-Simons theory

Let us first review basics of the Chern-Simons theory. The theory is useful for describing 2+1D quantum Hall phases. For a good treatment of Chern-Simons theory, check out [David Tong's lecture notes](https://www.damtp.cam.ac.uk/user/tong/qhe.html).

# Chern-Simons Field theory

Let us first consider the field theory of external (or background) gauge-field $A_\mu$. It turns out this will correspond to integer Quantum Hall effect. The Chern-Simons Lagrangian is givn by

$$
\mathcal{L} = \frac{k}{4\pi} \epsilon^{\mu\nu\rho} A_\mu \partial_\nu A_\rho.
$$

Here, $\epsilon^{\mu\nu\rho}$ is the antisymemtric Levi-Civita symbol, and $k$ is a coefficient to be determined later. For concreteness, we consider the theory on a 2D spatial torus. The Lagrangian does not look manifestly gauge invariant, as $A_\mu \to A_\mu + \partial_\mu \omega$ leads the Lagrangian to change

$$
\delta \mathcal{L} = \frac{k}{4\pi} \epsilon^{\mu\nu\rho} (\partial_\mu \omega \partial_\nu A_\rho +  A_\mu \partial_\nu \partial_\rho \omega) = \frac{k}{4\pi} \epsilon^{\mu\nu\rho} (\partial_\mu \omega \partial_\nu A_\rho),
$$

where the second term  dropped from the antisymmetry of the Levi-Civita symbol. Let's integrate this on a torus to get the change in Lagrangian

$$
\delta L = \frac{k}{4\pi} \int_{T^2} d^2 x \epsilon^{\mu\nu\rho} \partial_\mu \omega \partial_\nu A_\rho = \frac{k}{4\pi} \int_{T^2} d^2 x \partial_\mu [\epsilon^{\mu\nu\rho}\omega \partial_\nu A_\rho]
$$

This boundary term does not vanish, because $\omega$, being the function that generated gauge transformation, can be multivalued. This actually has an important consequence for quantization of $k$.

## Quantization of Chern-Simons level

We will follow David Tong's argument here. Consider Wick rotating the Chern-Simons term. We have $dt \to id\tau$, which picks up one factor of $i$. However, we also get a factor of $i$ for every temporal component of the vector. The Levi-Civita symbol ensures we have exactly one temporal component. The $i$'s therefore cancel, and the Chern-Simons term is invariant (up to maybe a minus sign?) upon Wick rotation. (See [this](https://physics.stackexchange.com/questions/812107/chern-simons-theory-connection-between-thermal-and-quantum-partition-function) stack exchange answer as well).

We can now impose periodic boundary condition in the time direction to compute finite temperature path integral. Utilizing Dirac quantization of the $U(1)$ gauge, we will put a monopole in the middle of the torus. We choose a unit in which $e =\hbar = 1$, so the Aharanov-Bohm phase around a loop $C$ is given by $e^{i\int_C A\cdot dx}$. By demanding this quantitiy to be single valued regardless of choice of chart, we get the Dirac quantization condition

$$
\int_{S^2} F_{12} = 2\pi. 
$$

We will now consider the path integral at finite temperature $\beta$. The time direction is compactified with circumference $\beta$. Since the periodic time direction has nontrivial fundamental group, we can perform a nontrivial gauge transformation given by

$$
\omega = 2\pi \frac{\tau}{\beta},
$$

which transforms the gauge field as

$$
A_0 \to A_0 + \frac{2\pi}{\beta}
$$

Let us now compute the change in path integral under this gauge transformation. First, we will explicitly write the integrand as

$$
\frac{k}{4\pi} \epsilon^{\mu\nu\rho} A_\mu \partial_\nu A_\rho = \frac{k}{4\pi}(A_0 F_{12} + A_1 F_{20} + A_2 F_{01}).
$$

We set a configuration of $A$ such that $F_{20}, F_{01}$ are zero, so we can drop the second and third terms.

> **Note**: David Tong's lecture notes warn against dropping these two terms, and says instead we need to integrate by parts to get an additional contribution. This indeed gives the correct answer for **integer** quantization of $k$, but I couldn't convince myself that procedure is legitimate. Instead, we will just keep track of the first term in the following to show **even** integer quantization.
To the best of my knowledge, resolving this requires so-called spin structure of a manifold. This is mathematics I am yet to understand.

The change in the path integral is then given by

$$
\delta S_{CS} = \frac{k}{4\pi} \int_0^\beta d\tau \frac{2\pi}{\beta} \int_{S_1} d^2 x  F_{12} = \frac{k}{4\pi}(2\pi)^2 = \pi k
$$

We demand $e^{i\delta S_{CS}} = 1$, so $k$ must be an even integer.

> **Note**: The following are some keywords I have been told in order to understand what is going on. $k$ = odd implies the existence of a fermion in the system, which in turn implies the manifold must be able to admit a spin structure. This spin structure contrains(?) allowed forms of gauge transformation, resulting in a looser quantization condition. Also, regarding 2+1D CS theory as being defined on the boundary of 4D theory makes it easier to understand some of these subtleties. Tong's gauge theory lecture notes, as well as Sec. 2.5 of [Greg Moore's lecture notes](https://www.physics.rutgers.edu/~gmoore/TASI-ChernSimons-StudentNotes.pdf) contains some more details.

## Equations of motion of Chern-Simons theory

The equation of motion is easy to evaluate. From evaluating both sides of the Euler-Lagrange equation, we get

$$
\epsilon^{\mu\nu\rho} \partial_{\nu} A_\rho = \partial_{\eta} \epsilon^{\nu\eta\mu} A_\nu \implies \epsilon^{\mu\nu\rho}  \partial_{\nu} A_\rho = 0
$$

TODO: Add Maxwell term
