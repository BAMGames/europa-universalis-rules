Memento about using git

# Branching and remoting

## Creating a local copy of a remote branch

    git pull origin
    git checkout -b branchname origin/branchname

## Pushing a local-only branch to remote

    git push origin branchname
    git branch --set-upstream branchname origin/branchname # Git 1.7
    git branch -u origin/branchname # Git 1.8

## Deleting a remote branch

    git push origin :branchname
    git branch -d branchname
    git gc # or git prune origin ?
