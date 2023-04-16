# Git Workshop: Tim and the waves

## Bibliography

https://www.atlassian.com/git/tutorials/learn-git-with-bitbucket-cloud

## Introduction

Alice and Bob are writers who are collaborating on a new book. They've decided to use Git as their tool for collaborative edition, and a very ancient computer with a [model M keyboard](https://en.wikipedia.org/wiki/Model_M_keyboard) attached to it.

To get started, they'll need to set up a Git repository for the book. This will allow them to track changes to the book over time, collaborate on the book together, and easily merge their changes into a single version of the book.

*Note: this tutorial assumes you have access to both `git` and `ed` commands. If it is not true, feel free to install them:

```bash
sudo apt update
sudo apt install -y git ed
```

## Alice: repo initialization

* Alice is going to create his own workspace:

```bash
mkdir -p alice/book
cd alice/book
```

* After doing it, she starts writing the story

```bash
cat << EOF > chapter-01.md
## Tim and the waves

Being a young boy, Tim had always been fascinated with the ocean. He would spend hours at the beach, watching the waves crash against the shore, imagining all the creatures that lived beneath the surface. One day, he decided to go for a swim, but before he knew it, he was caught in a strong current and dragged out to sea.

As the waves tossed him around, Tim struggled to stay afloat. Just when he thought he couldn't hold on any longer, a strong hand grabbed his wrist and pulled him to safety. It was a kind stranger who had noticed him struggling from the shore.

From that day forward, Tim's love for the ocean only grew stronger. But he never forgot the lesson he had learned - that sometimes, even the strongest of us need help from others to make it through the rough waters of life.
EOF

ls
```

* Alice wants to enhance the description of the protagonist, but she is afraid of not being satisfied with the result. Because of that, she decides to work on a copy of the original content:

```bash
cp chapter-01.md  chapter-01v2.md
ed chapter-01v2.md << EOF
2i

Tim is a lean and athletic young man with short brown hair and piercing blue eyes. He has a strong jawline and a sun-kissed complexion from spending so much time at the beach. His body is toned and muscular from his active lifestyle, and he exudes a sense of energy and enthusiasm for life.
.
w
q
EOF

ls
cat chapter-01v2.md
```

* She quickly realizes that this tactic isn't practical at all. Luckily, Alice main job is developing software, so she is well versed on `git` and knows how to apply the tool to her other profession. First, she removes the copy:

```bash
rm chapter-01v2.md
```

* And she initializes the `git` database with

```bash
git config --global init.defaultBranch main
git init
ls -a
ls .git
```

* After that, Alice configures the database with her identity

```bash
git config user.name Alice
git config user.email alice@example.com
git config --list

cat .git/config
```

## Alice: first commits

* Time to add the current version of the chapter

```bash
git status
git add chapter-01.md
git commit -m "Initial draft of the first chapter"
```

* She wants to check that everything is being tracked as expected:

```bash
git log
cat .git/HEAD
cat .git/refs/heads/main     # Whole sha-1 HEAD
git rev-parse --short HEAD   # Short sha-1 of the current HEAD
```

**Checkpoint snap01**

* Now she can safely apply the new paragraph to the text

```bash
git status

ed chapter-01.md << EOF
2i

Tim is a lean and athletic young man with short brown hair and piercing blue eyes. He has a strong jawline and a sun-kissed complexion from spending so much time at the beach. His body is toned and muscular from his active lifestyle, and he exudes a sense of energy and enthusiasm for life.
.
w
q
EOF
```

* Good. Let's see what are the differences against the commited version

```bash
git status
git diff chapter-01.md
```

* Looks good, so Alice puts the changes in the `git` database

```bash
git add chapter-01.md
git commit -m "Added description of Tim"
git status
git log
```

* After taking a break and having her breakfast, our writer wants to refresh how was the first version of the story

```bash
git rev-list --all     # list revisions
git rev-parse HEAD     # get the current sha-1
git rev-parse HEAD~1   # get the previous sha-1
PREV_REVISION=$(git rev-parse HEAD~1)
echo The previous revision was $PREV_REVISION
git show $PREV_REVISION:chapter-01.md
git show HEAD~1:chapter-01.md
```

## Alice: diff configuration

* She decides that a more fancy diff tool would provide better feedback, so she configures `delta`

```bash
wget -P /tmp https://github.com/dandavison/delta/releases/download/0.15.1/git-delta_0.15.1_amd64.deb
sudo dpkg -i /tmp/git-delta_0.15.1_amd64.deb
delta --version

git config core.pager delta
git config interactive.diffFilter "delta --color-only"
git config delta.navigate true
git config delta.light false  # or true!
git config delta.side-by-side true
git config delta.line-numbers true
git config merge.conflictstyle diff3
git config diff.colorMoved default

git show
```

* Alice thinks that maybe it would be more interesting to leave the description of Tim to the imaganation of the reader, so he goes back in time to the previous revision

```bash
cat .git/HEAD
cat .git/refs/heads/main
git checkout $PREV_REVISION
cat chapter-01.md
git log
cat .git/HEAD                  # Dettached!
cat .git/refs/heads/main       # main is in the future
```

* Nah, it was not a good idea: Tim  has to have a particular appearance for this story to work. So Alice reverses the timetravelling:

```bash
git switch -
git log
cat chapter-01.md
cat .git/HEAD
```

## Alice: basic branching

* Reading the chapter again, Alice understands she has to enhance the vocabulary of the chapter. But she also wants to keep developing the story, so she creates a *branch* to undertake that task:

```bash
git checkout -b vocabulary-chapter-01
git status
git branch
cat .git/HEAD
cat .git/refs/heads/main
cat .git/refs/heads/vocabulary-chapter-01  # right now, it is the same than main
```

* Alice will replace one of the appearence of the word *beach*

```bash
cat chapter-01.md | grep beach
sed -z -i 's/beach/soar/2' chapter-01.md
cat chapter-01.md | grep -e soar -e beach
git add chapter-01.md
git commit -m "Replacing repetitive words"
git log
```

**Checkpoint snap02**

* Probably she will also change other words, but right now she wants to modify an important point of the story. So she moves `HEAD` to the main branch

```bash
git checkout main
cat chapter-01.md
cat chapter-01.md | grep -e soar -e beach
git log
```

* The saviour of Tim has actually an interesting profession, much more evocative than a simple *kind stranger*

```bash
sed -i 's/a kind stranger/the likehouse keeper/' chapter-01.md
cat chapter-01.md
git add chapter-01.md
git commit -m "Introducing the lighthouse keeper"
git log
```

## Alice: merging without conflicts

* Alice knows that branches must be integrated often to avoid problems, so she *merges* the vocabulary branch with the main one

```bash
git branch                                   # check current branch
git diff main vocabulary-chapter-01 | cat -  # diff without using delta
git diff main vocabulary-chapter-01          # diff with delta (it doesn't understand the different time of the commits)
git merge vocabulary-chapter-01 -m "Merged vocabulary" ## ORT strategy
cat chapter-01.md
git log --oneline
git log --graph --decorate --oneline
```

## Alice: merging with conflict resolution

* Alice will keep working hard in increasing the tension of the story

```bash
git status    # on main
sed -i 's/afloat/afloat, fighting the waves/' chapter-01.md
git diff chapter-01.md
git add chapter-01.md
git commit -m "Enhanced paragraph"
```

* At the same time, she also keeps pushing for a richer use of language

```bash
git checkout vocabulary-chapter-01
cat chapter-01.md  | grep strug
sed -i  's/struggling/floundering/' chapter-01.md
git diff chapter-01.md
git add chapter-01.md
git commit -m "Replaced struggling"
```

**Checkpoint snap03!**

* Time to *merge* both branches again, but in this case we have a more complex situation

```bash
git status
git branch
git checkout main
git diff vocabulary-chapter-01
git merge vocabulary-chapter-01 -m "Merged vocabulary" # Conflict!!
git status
git diff --name-only --diff-filter=U --relative        # List conflicting files
cat chapter-01.md
git diff
```

* No problem: Alice manually merges both changes and submits the new *commit*

```
L0=$(grep -n "<<<<<<<" chapter-01.md | cut -f1 -d:)
LF=$(grep -n ">>>>>>>" chapter-01.md | cut -f1 -d:)

echo Replacing from $L0 to $LF.

ed chapter-01.md << EOF
${L0},${LF}d
7i
As the waves tossed him around, Tim struggled to stay afloat, fighting the waves. Just when he thought he couldn't hold on any longer, a strong hand grabbed his wrist and pulled him to safety. It was the lighthouse keeper who had noticed him floundering from the shore.
.
w
q
EOF

cat chapter-01.md
```

* She double checks everything is as intended to be, and commits the new version:

```bash
git status
git add chapter-01.md
git commit -m "Solved conflict, merged keeper and floundering."
git log --graph --decorate --oneline
```

## Alice: tagging

* Our writer decides she has a good enough first chapter, so she proceeds to delete the vocabulary branch

```bash
git branch -d vocabulary-chapter-01
git branch
git log --graph --decorate --oneline # Commits don't belong to the deleted branch anymore
```

**Checkpoint snap04!**

* Finally, Alice marks this commit as the first version of the book with a tag

```bash
git tag v1
git log --oneline
ls .git/refs/tags
cat .git/refs/tags/v1
cat .git/refs/heads/main  # points to the same object that the tag
```

* Ouch: Alice realizes that she used a lightweight tag, but she would like to set a comment. So she deletes the tag an creates an annotated one

```bash
git tag -d v1
ls .git/refs/tags
git tag -a v1 -m "First chapter is ready to be reviewed!"
ls .git/refs/tags
cat .git/refs/heads/main
cat .git/refs/tags/v1      # the tag ref points to a tag object, so doesn't match the last commit
```

* Alice is very proud of her work, and closes the laptop to get some fresh air and inspiration

```bash
cd ../../
```

**Checkpoint snap05!**

## Bob: cloning repositories

* Bob collaborates with Alice in writing the book. Both of them use the same old PC, as they find easier to focus in a very constrained environment. But Bob is wise enough to know he should not mess with the work of Alice, so he creates his own directory

```bash
mkdir bob
cd bob
```

* Alice has explained Bob how to use `git`, so he knows how to get a copy of the database

```bash
git clone ../alice/book
ls
cd book
ls
git log --oneline
```

* As the copy of the book has been created using the `clone` command, the repository keeps a reference to its origin

```bash
git remote
git remote get-url origin
```

* Bob updates the configuration of his repo

```bash
git config user.name Bob
git config user.email bob@example.com
```

**Checkpoint snap06!**

## Bob: pushing to origin

* And, imbued with the creativity provided by a good cup of coffee, Bob writes his part of the book and commits the changes **on his own repository**

```bash
cat << EOF > chapter-02.md
Tim couldn't believe his luck. The stranger had saved his life, and he was filled with gratitude. "Thank you so much," he said, still panting from the ordeal. "I thought I was going to drown out there."

The lighthouse keeper smiled kindly at him. "You're welcome," he said. "But you should be more careful. The ocean can be dangerous, especially when there's a strong current like today."

Tim nodded, his heart still racing. He realized that he had underestimated the power of the ocean, and he felt humbled by the experience. From that moment on, he made a vow to always respect the sea and to never take its power for granted.

As they made their way back to the shore, the lighthouse keeper introduced himself as John, and they struck up a conversation. Tim learned that John had spent his life guiding ships safely through the treacherous waters of the coast. He was now enjoying his retirement in the nearby town, where he relished fishing and spending time with his grandchildren.

As they said their goodbyes, John turned to Tim with a twinkle in his eye. "Have you ever heard of the mermaids?" he asked, his voice filled with mystery
EOF

ls
git add chapter-02.md
git commit -m "Added chapter 2."
git log --oneline
```

* Satisfied with his masterpiece, he tries to synchronize his repository with the one owned by Alice

```bash
git status             # Branch ahead of origin/main
git push origin main   # Error! This action would mess with Alice's content
```

* Oh, ok: looks like `git` refuses to mess up with the current working copy of Alice's repository. So Bob creates a new branch and runs the `push` command again

```bash
git checkout -b wip-chapter-02
git status
git push origin wip-chapter-02
```

* Finally, he closes his workspace

```bash
cd ../../
```

**Checkpoint snap07!**

## Alice: merging (from the branch created by Bob's push)

* Our preferred writer is back, and having read Bob's message she decides to merge his work

```bash
cd alice/book
git status
ls
git branch
git merge wip-chapter-02
ls
git log --graph --oneline
```

* Alice don't want to get her repo populated by many branches created by Bob, so she deletes the new one

```bash
git branch -d wip-chapter-02
git branch
```

* She decides it will be easier if their respective repositories don't interact directly between each other, so she leaves her workspace to create a solution to this problem

```bash
cd ../../
```

**Checkpoint snap08!**

## Alice: centralized repository creation

* Alice is going to create a repository intended to have only the data, without any working content. This way, both Alice and Bob will be able to work against a common *integration branch*

```bash
mkdir central
cd central
git init --bare --shared
ls
```

* Our main writer will need to synchronize the content of both repositories, from his own content

```bash
cd ../alice/book
git status
git remote add origin ../../central/
git push origin main   # No problem, as it is a barebone repo
git push origin v1     # Annotated tags are usually pushed, too
```

### Alice: preparing new content

* Happy to see how everything is under control, she writes a new chapter and synchronizes everything

```bash
cat << EOF > chapter-03.md
Tim woke up with a start, his heart racing and his body drenched in sweat; it took him a few moments to realize that he had been dreaming about the mermaids again. He had been having the same dream for weeks now - the mermaids would appear out of nowhere, their beautiful faces twisted into a sinister snarl as they dragged him under the water.

He knew it was silly to be afraid of something that didn't exist, but he couldn't shake the feeling that there was some truth to his dreams. The sea was full of mysteries and he had heard stories of sailors who had encountered strange creatures on their voyages. Perhaps there was more to his dreams than just his imagination.

As he lay in bed, trying to calm his racing thoughts, Tim made a decision. He would set out to learn as much as he could about the sea and the creatures that dwelled within it. If there was any truth to his dreams, he wanted to be prepared. And he knew where to start his investigation.
EOF

ls
git add chapter-03.md
git commit -m "New chapter"
git push origin main
```

* Wow, Alice has done a tone of work. She now leaves her workspace

```bash
cd ../..
```

**Checkpoint snap09!**

### Bob: pulling

* Bob doesn't want to write today, but he is interested in reading what Alice has added to the story. First, he will check his own repository

```bash
cd bob/book
git status
git checkout main
```

* Now, he will update the configuration of the repository, setting his *origin* pointing to the centralized one

```
git remote
git remote get-url origin
git remote rename origin alice
git remote add origin ../../central/
git remote
```

* Not being completely sure of how to proceed, Bob wants to check the content of the central repo before merging it with its own

```bash
git fetch origin main    # Doesn't affect working tree
git diff FETCH_HEAD      # Diff against the fetched data
```

* Ok, doesn't seems dangerous: a new file will note trigger a conflict, so Bob merges the content of the remote branch

```bash
git pull origin main     # Or git merge FETCH_HEAD
git log --graph --decorate --online
```

* Another fantastic job, Bob thinks. And he leaves the workspace

```bash
cd ../..
```

**Checkpoint snap10!**
