- all commits that your branch have that are not yet in master
   ```
   git log master..<HERE_COMES_YOUR_BRANCH_NAME>
   ```

- setting up a character used for comments 
   ```
   git config core.commentchar <HERE_COMES_YOUR_COMMENT_CHAR>
   ```

- fixing `fatal: Could not parse object` after unsuccessful revert
   ```
   git revert --quit
   ```

- view diff with inline changes 
   ```
   git diff --word-diff=plain master
   ```

- view quick stat of a diff 
   ```
   git diff --shortstat master
   git diff --numstat master
   git diff --dirstat master
   ```

- undo last just made commit
   ```
   git reset HEAD~
   ```

- list last 20 hashes in reverse 
   ```
   git log --format="%p..%h %cd %<(17)%an %s" --date=format:"%a %m/%d %H:%M" --reverse -n 20
   ```
   
- list commits between dates
   ```
   git log --format="%p..%h %cd %<(17)%an %s" --date=format:"%a %m/%d %H:%M" --reverse --after=2016-11-09T00:00:00-05:00 --before=2016-11-10T00:00:00-05:00
   ```

- try a new output for diffing
   ```
   git diff --compaction-heuristic ...
             --color-words ...
   ```

- enable more thorough comparison
   ```
   git config --global diff.algorithm patience
   ```

- restoring a file from a certain commit relative to the latest
   ```
   git checkout HEAD~<NUMBER> -- <RELATIVE_PATH_TO_FILE>
   ```

- restoring a file from a certain commit relative to the given commit
   ```
   git checkout <COMMIT_HASH>~<NUMBER> -- <RELATIVE_PATH_TO_FILE>
   ```

- restoring a file from a certain commit
   ```
   git checkout <COMMIT_HASH> -- <RELATIVE_PATH_TO_FILE>
   ```

- creating a diff file from unstaged changes for a **specific folder**
   ```
   git diff -- <RELATIVE_PATH_TO_FOLDER> changes.diff
   ```
   
- applying a diff file
   - go to the root directory of your repository
   - run:
      ```
      git apply changes.diff
      ```

- show differences between last commit and currrent changes:
   ```
   git difftool -d
   ```

- referring to:
   - last commits `... HEAD~1 ...`
   - last 3 commits `... HEAD~3 ...`

- show the history of changes of a file
   ```
   git log -p -- ./Scripts/Libs/select2.js
   ```

- ignoring whitespaces
   ```
   git rebase --ignore-whitespace <BRANCH_NAME>
   ```

- pulling for fast-forward only (eliminating a chance for unintended merging)
   ```
   git pull --ff-only
   ```
   

- list of all tags
   ```
   git fetch
   git tag -l
   ```
   
- archive a branch using tags
   ```
   git tag <TAG_NAME> <BRANCH_NAME>
   git push origin --tags
   ```
   you can delete your branch now
   
- get a tagged branch
   ```
   git checkout -b <BRANCH_NAME> <TAG_NAME>
   ```

- list of all branches that haven't been merged to master
   ```
   git branch --no-merge master
   ```
   
- enable more elaborate diff algorithm by default
   ```
   git config --global diff.algorithm histogram
   ```

- list of all developers
   ```
   git shortlog -s -n -e
   ```
   
- display graph of branches
   ```
   git log --decorate --graph --all --date=relative
   ```
   or
   ```
   git log --decorate --graph --all --oneline 
   ```

- remembering the password
   ```
   git config --global credential.helper store
   git fetch
   ```
   the first command tells git to remember the credentials that you are going to provide for the second command

- path to the global config  
   ```   
   C:\Users\Bykov\.gitconfig
   ```
- example of a global config  

   ```
   [user]
       email = *****
       name = Aleksey Bykov
       password = *****
   [merge]
       tool = p4merge
   [mergetool "p4merge"]
       cmd = p4merge.exe \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
       path = \"C:/Program Files/Perforce\"
       trustExitCode = false
   [push]
       default = simple
   [diff]
       tool = meld
       compactionHeuristic = true
   [difftool "p4merge"]
       cmd = p4merge.exe \"$LOCAL\" \"$REMOTE\"
       path = C:/Program Files/Perforce/p4merge.exe
   [difftool "meld"]
       cmd = \"C:/Program Files (x86)/Meld/Meld.exe\" \"$LOCAL\" \"$REMOTE\"
       path = C:/Program Files (x86)/Meld/Meld.exe
   ```

- viewing differences between current and other branch  
   ```
   git difftool -d BRANCH_NAME
   ```

- viewing differences between current and stash  
   ``` 
   git difftool -d stash
   ```

- viewing differences between several commits in a diff tool  
   ```
   git difftool -d HEAD@{2}...HEAD@{0}
   ```

- view all global settings  
   ```
   git config --global -l
   ```
- delete tag 
   ```
   git tag -d my-tag
   git push origin :refs/tags/my-tag
   ```
   
- pushing tags 
   ```
   git push --tags
   ```

- checking the history of a file or a folder  
   ```
   git log -- <FILE_OR_FOLDER>
   ```

- disabling the scroller  
   ```
   git --no-pager <...>
   ```

- who pushed last which branch  
   ```
   git for-each-ref --format="%(committerdate) %09 %(refname) %09 %(authorname)"
   ```

- deleting remote branch  
   ```
   git push origin :<BRANCH_NAME>
   ```

- deleting remote branch localy  
   ```
   git branch -r -D <BRANCH_NAME>
   ```
   or to sync with the remote
   ```
   git fetch --all --prune
   ```

- deleting local branch  
   ```
   git branch -d <BRANCH_NAME>
   ```

- list **actual** remote branchs 
   ```
   git ls-remote --heads origin
   ```

- list all remote (fetched) branches 
   ```
   git branch -r
   ```

- list all local branches 
   ```
   git branch -l
   ```

- find to which branch a given commit belongs  
   ```
   git branch --contains <COMMIT>
   ```


- updating from a forked repository 
   ```
   git remote add upstream https://github.com/Microsoft/TypeScript.git
   git fetch upstream
   git rebase upstream/master
   ```

### misc tricks

#### The "I can never remember that alias I set" Trick

```
[alias]
	aliases = !git config --get-regexp 'alias.*' | colrm 1 6 | sed 's/[ ]/ = /' | sort
```

Gitignore

```
$ git config --global core.excludesfile ${HOME}/.gitignore
```

Then create a `~/.gitignore.`, `.gitignore` follows glob syntax

#### The "I forgot something in my last commit" Trick

```
git add file-you-modified
git commit --amend
git push -f
```
alternatively

```
# first: stage the changes you want incorporated in the previous commit
 
# use -C to reuse the previous commit message in the HEAD
$ git commit --amend -C HEAD
# or use -m to make a new message
$ git commit --amend -m 'add some stuff and the other stuff i forgot before'
```

#### The "Oh crap I didn't mean to commit yet" Trick

```
# undo last commit and bring changes back into staging (i.e. reset to the commit one before HEAD)
$ git reset --soft HEAD^
The "That commit sucked!  Start over!" Trick
# undo last commit and destroy those awful changes you made (i.e. reset to the commit one before HEAD)
$ git reset --hard HEAD^
```

#### The "Oh no I should have been working in a branch" Trick

```
# takes staged changes and 'stashes' them for later, and reverts to HEAD. 
$ git stash
 
# creates new branch and switches to it, then takes the stashed changes and stages them in the new branch.   fancy!
$ git stash branch new-branch-name 	
```

#### The "OK, which commit broke the build!?" Trick

```
# Made lots of local commits and haven't run any tests...
$ [unittest runner of choice]
# Failures... now unclear where it was broken.

# git bisect to rescue. 
$ git bisect start # to initiate a bisect
$ git bisect bad   # to tell bisect that the current rev is the first spot you know was broken.
$ git bisect good <some tag or rev that you knew was working>
$ git bisect run [unittest runner of choice]
# Some runs.
# BLAMO -- git shows you the commit that broke
$ git bisect reset #to exit and put code back to state before git bisect start
# Fix code. Run tests. Commit working code. Make the world a better place.
```

#### The "I have merge conflicts, but I know that one version is the correct one" Trick, a.k.a. "Ours vs. Theirs"

```
# in master
$ git merge a_branch
CONFLICT (content): Merge conflict in conflict.txt
Automatic merge failed; fix conflicts and then commit.
$ git status -s
UU conflict.txt
 
# we know the version of the file from the branch is the version we want.
$ git checkout --theirs conflict.txt
$ git add conflict.txt
$ git commit
 
# Sometimes during a merge you want to take a file from one side wholesale.
# The following aliases expose the ours and theirs commands which let you
# pick a file(s) from the current branch or the merged branch respectively.
#
# N.b. the function is there as hack to get $@ doing
# what you would expect it to as a shell user.
# Add the below to your .gitconfig for easy ours/theirs aliases. 
#    ours   = "!f() { git checkout --ours $@ && git add $@; }; f"
#    theirs = "!f() { git checkout --theirs $@ && git add $@; }; f"
```

#### Split a subdirectory into a new repository/project

```
$ git clone ssh://stash/proj/mcplugins.git
$ cd mcplugins
$ git checkout origin/master -b mylib
$ git filter-branch --prune-empty --subdirectory-filter plugins/mylib mylib
$ git push ssh://stash/proj/mylib.git mylib:master
``` 

#### Local Branch Cleanup

```
# Delete local branches that have been merged into HEAD
$ git branch --merged | grep -v '\\*\\|master\\|develop' | xargs -n 1 git branch -d

# Delete local branches that have been merged into origin/master
$ git branch --merged origin/master | grep -v '\\*\\|master\\|develop' | xargs -n 1 git branch -d

# Show what local branches haven't been merged to HEAD
$ git branch --no-merged | grep -v '\\*\\|master\\|develop'
```

### Update a fork to latest upstream

add the remote, call it "upstream":

    git remote add upstream https://github.com/whoever/whatever.git

Fetch all the branches of that remote into remote-tracking branches,
such as upstream/master:

    git fetch upstream

Make sure that you're on your master branch:

    git checkout master

Rewrite your master branch so that any commits of yours that
aren't already in upstream/master are replayed on top of that
other branch:

    git rebase upstream/master

### tricks

```
git checkout -

git merge -
```

See the little minus symbol at the end? That basically tells GIT you want to checkout the previous branch, or merge the previous branch. This will also work with rebasing and any other command which uses branches.

Say you were in master branch and wanted to switch to that new PR request your colleague has submitted, you would do something like this...

```
git checkout new-feature
```

You look at the code and test and all looks good, so you want to switch back to master and then merge in the new feature, this will be super easy and you won't need to remember the branch names...

Switch back to master branch `git checkout -` then merge that new feature in `git merge -`. 
