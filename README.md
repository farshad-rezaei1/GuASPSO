# FR1
The repository contains the source codes of a set of projects presenting several novel single- and multi-objective optimization algorithms.

The first project presents the source codes of a novel meta-heuristic optimization algorithm named Guided Adaptive Search-based Particle Swarm Optimization (GuASPSO) algorithm.
In this algorithm, the personal best particles are all divided into a linearly decreasing number of clusters. Then, the unique global best guide of a given particle located at
a cluster is obtained as the weighted average calculated over other clusters’ best particles. Since the clustered particles are being well distributed over the whole search space
in the clustering process, two desirable goals are fulfilled during the optimization process: (1) there would be a moderate distance between each particle and its unique
global best guide, contributing the particles neither to be trapped in local optima nor engaged in a drift leading to lose diversity in the search space; and (2) all regions in 
the serach space are recognized, whether these regions are more-densely populated regions or less-densely populated regions for each of which a representative particle is defined
and located to guide the other particles to better maintain the diversity of the particles in the search space. This ability is endowed to GuASPSO to cover the major shortcoming
of the PSO or other meta-heuristics to truely and toughly keep diversity among the search agents, especially in the large-scale optimization problems. In this approach, the
number of clusters is high at the early iterations and is gradually decreased by lapse of iterations to less stress the diversity factor and further stress the fitness role to
cause the particles to better converge to the optimal point. Holding this balance between global and personal bests’ role to attract the particles, on the one hand and between
convergence and diversity, on the other hand, can hold a better exploration–exploitation balance in the proposed algorithm.
