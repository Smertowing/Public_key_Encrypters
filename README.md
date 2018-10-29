# Public_key_Encrypters
RSA Algorithm, for now

#### BSUIR, Laboratory work on the Theory of Information


Currently the best and most popular cryptographic
the public key algorithm is RSA, whose name is obtained
by the names of its creators: Rivest, Shamir and Adelman.
The most important part of the RSA algorithm, like other algorithms with
public key, is the process of creating a pair of open / secret
the keys. In RSA, it consists of the following `steps`:

***1. Randomly select two secret prime numbers p and q
such that p ≈ q.***

***2. Calculate their product r = p * q.***

***3. Calculate the Euler function for r. Euler function for
arbitrary x is the number of mutually simple x with smaller numbers,
than x. For a simple x φ (x) = x – 1, and for the number that represents
the product of two primes x = p * q: φ (x) = (p – 1) * (q – 1).***

***4. Select the integer value of the open exponent e such that 1 <e <φ (r)
and (e, φ (r)) = 1.***

***5. Calculates the value of the secret exponent d, which should
satisfy the condition (e * d) mod φ (r) = 1 (i.e., d is multiplicative
inverse modulo φ (r) for e).***

The cryptographic strength of the RSA algorithm is based on two mathematical
difficult problems for which there is no effective way
their solutions. The first one is that it is impossible to calculate
source code from ciphertex, since for this it is necessary to extract the root of degree
e modulo the number r (find the discrete logarithm). This task is currently
time cannot be solved in polynomial time. On the other hand
It’s almost impossible to find the secret key knowing the public key, since
this is necessary to solve the comparison e * d ≡ 1 (mod φ (r)). To solve it you need
know the divisors of the integer r, i.e. decompose the number r into factors.

Theoretical part by [Alexey Lyapeshkin](https://github.com/AlexeyLyapeshkin)
