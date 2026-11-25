"""Verify the Eulerian candidate with a clique joined to a cycle at one vertex."""
from collections import deque
from fractions import Fraction
from itertools import combinations


def test(length):
    clique = list(range(5))
    rim = [0] + list(range(5, 4 + length))
    edges = {tuple(sorted(edge)) for edge in combinations(clique, 2)}
    edges.update(tuple(sorted((rim[i], rim[(i + 1) % length]))) for i in range(length))
    n = length + 4
    adj = [set() for _ in range(n)]
    for u, v in edges:
        assert u != v
        adj[u].add(v)
        adj[v].add(u)
    seen = {0}
    q = deque([0])
    while q:
        for v in adj[q.popleft()] - seen:
            seen.add(v)
            q.append(v)
    assert len(seen) == n
    degree = [len(row) for row in adj]
    assert all(d % 2 == 0 for d in degree)
    assert all(v in adj[u] for u, v in combinations(clique, 2))
    coloring = list(range(5)) + [1 + (i % 2) for i in range(length - 1)]
    assert all(coloring[u] != coloring[v] for u, v in edges)
    chromatic = len(set(coloring))
    assert chromatic == len(clique)
    average = Fraction(sum(degree), n)
    bound = Fraction(3, 2) * average
    assert (chromatic <= bound) == (length <= 5)
    return n, len(edges), average, bound


def test_at_three(C):
    """Attach four-cycles to vertex 0 of a clique and check the degree budget."""
    r = 2 * C + 5
    t = r * (r - 4)
    neighbors = [set() for _ in range(r + 3 * t)]

    def join(u, v):
        assert u != v
        neighbors[u].add(v)
        neighbors[v].add(u)

    for u, v in combinations(range(r), 2):
        join(u, v)
    for i in range(t):
        a = r + 3 * i
        for u, v in [(0, a), (a, a + 1), (a + 1, a + 2), (a + 2, 0)]:
            join(u, v)

    seen = {0}
    queue = deque([0])
    while queue:
        for v in neighbors[queue.popleft()] - seen:
            seen.add(v)
            queue.append(v)
    assert len(seen) == len(neighbors)
    degrees = list(map(len, neighbors))
    assert all(d % 2 == 0 for d in degrees)
    assert Fraction(sum(degrees), len(neighbors)) == 3
    assert all(v in neighbors[u] for u, v in combinations(range(r), 2))
    assert C < r
    return r, t, len(neighbors)


if __name__ == '__main__':
    for length in range(3, 13):
        n, m, avg, bound = test(length)
        print(f'C{length}: vertices={n} edges={m} Eulerian=True colors=5 '
              f'average={avg} proposed_bound={bound} holds={5 <= bound}')
    for C in range(9):
        r, t, n = test_at_three(C)
        print(f'C={C} clique={r} four-cycles={t} vertices={n} Eulerian=True average=3 colors>={r}')
