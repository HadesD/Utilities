for branch in `git branch -a | grep remotes | grep -v HEAD `; do
   git branch --track ${branch#remotes/origin/} $branch
done
