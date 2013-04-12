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

## Pushing only the current branch

    git push origin branchname

    git config --global push.default upstream

By default, git pushes (to remote) all branches. So if one works on
master, then on branchname, the issues git push origin, it will try
to push on master and branchname. However, if no work is done on master
(but a local branch tracking master exists, which is often the case),
and work is done on branchname, the push (while in branchname) will also
try to push the local master (which, being late with respect to the
remote master, creates an exception, even if it is only a fast-forward).
