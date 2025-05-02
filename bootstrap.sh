#!/usr/bin/env bash
set -e

echo "Bootstrapping cs-to-prod-playbook…"

# 1. Folders
mkdir -p algorithms systems stack devops meta

# 2. README
cat > README.md << 'DOC'
# CS-to-Prod Playbook 🛠️

> Mission: Open-sourcing every lesson from my CS Master’s as runnable, production-ready patterns.

| Roadmap (May 2025 → Sep 2026)       | Status |
|------------------------------------|:------:|
| Linked List + Tests                | ☐      |
| Dynamic Array + Benchmarks         | ☐      |
| BFS / DFS Maze Solver              | ☐      |
| Tiny HTTP 1.1 Server               | ☐      |
| CRUD “Twitter-Lite” (Next.js/Node) | ☐      |

Each module lives in its own folder + comes with tests, a README & CI.
DOC

# 3. First module: linked-list
mkdir -p algorithms/linked-list
cat > algorithms/linked-list/linked_list.py << 'PY'
class Node:
    def __init__(self, data, nxt=None):
        self.data, self.next = data, nxt

class LinkedList:
    def __init__(self):
        self.head = None

    def prepend(self, data):
        self.head = Node(data, self.head)

    def __iter__(self):
        cur = self.head
        while cur:
            yield cur.data
            cur = cur.next
PY

cat > algorithms/linked-list/test_linked_list.py << 'PY'
from linked_list import LinkedList

def test_prepend():
    ll = LinkedList()
    ll.prepend(3)
    ll.prepend(2)
    ll.prepend(1)
    assert list(ll) == [1, 2, 3]
PY

echo "pytest" > algorithms/linked-list/requirements.txt

# 4. CI workflow
mkdir -p .github/workflows
cat > .github/workflows/python.yml << 'YAML'
name: linked-list-tests
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: |
          pip install -r algorithms/linked-list/requirements.txt || true
          pytest algorithms/linked-list
YAML

echo "✅ Bootstrap complete."
