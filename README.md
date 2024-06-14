# CSOC'24 Flutter

CSOC'24 Project in App Dev track using Flutter.

## Setting up the development environment

### Pre-requisites

1. Git installed in system
2. Flutter installed

If any of the above is missing, please follow these links: [Installing Git](https://github.com/git-guides/install-git) and [Setting up flutter guide](https://www.notion.so/CSOC-24-Flutter-b407f567205540f0984f54b1c02bd1e6#5a8bdb1ba80d4901ab8fd4f0e811587a).

### Steps

1. Fork this repo.
2. Clone the forked repo into your local system with this command:

   ```bash
   git clone <your_forked_repo_url>
   ```

3. Open the cloned repo in VS Code terminal.
4. Check whether upstream is set successfully by running:
   ```bash
   git remote
   ```
5. If upstream is not found, add upstream with this command:

   ```bash
   git remote add upstream https://github.com/Varun-Kolanu/csoc_flutter.git
   ```

6. Fetch the code from remote:

   ```bash
   git fetch --all
   ```

7. Add the `debug.keystore` file provided to you (if not, ask a maintainer) in android folder i.e., as `/android/debug.keystore`

8. Run the following command to install dependencies:

   ```bash
   flutter pub get
   ```

9. Run this to start running the app in Physical device or Android emulator:

   ```bash
   flutter run
   ```

10. Do `git fetch --all` and `git rebase upstream/main` frequently to update the local repository.

## Contributing

Contributions to this app are welcome.
If you're looking to get into COPS, this is one of the projects we are considering. Irrespective of the result, you'll get a hands on experience in flutter and a wonderful experience contributing to an open source project.

### Picking an issue to work on

- To find possible issues to work on, see the [issues tab](https://github.com/Varun-Kolanu/csoc_flutter/issues). If it was not opened by a maintainer, choose those which has label 'approved' (Maintainers for this repo are [Varun Kolanu](https://github.com/Varun-Kolanu/), [Shashank Kumar](https://github.com/shashankiitbhu), [Prithvi Dutta](https://github.com/prithvihehe) )
- Choose according to your interests, complexity of the issue. Judgement depends on the complexity of issue, code cleanliness, commit discipline, solution developed and guidelines followed.
- After choosing an issue, comment `@csoc-bot claim` to get the issue assigned. Only after getting an issue assigned, start working on it.
- The first contributor who asked will get the assignment of issue.
- One contributor can only work on one issue at a time. If you have done most of the work, raised a PR and waiting for a maintainer review, you can reach out a maintainer to assign a new issue or abandon the previous issue.

### Opening an issue

If you see any bug or want to suggest a new feature, open an issue by filling the issue template in issue tab.

### Making a Pull request

After completing an issue, commit them and make a pull request. The commit messages should follow commit guidelines.

- Before making a commit or before making a PR, always fetch the current remote repo from github into local machine so that any code changes by other contributors are reflected:
  ```bash
  git fetch --all
  ```
- Before making a PR rebase your repo with upstream with the following command and solve any merge conflicts if exist: (To know more about rebase refer to this [video](https://youtu.be/4aIazhclURE?feature=shared) ).

  ```bash
  git rebase upstream/main
  ```

- The PR message should contain any of the following keywords and should contain the issue number it is solving so that it gets linked in that issue:

  ```bash
  close, closes, closed, fix, fixes, fixed, resolve, resolves, resolved
  ```

  Example PR message:

  ```bash
  This PR does this...
  fixes #1
  ```

- Then make a PR to the upstream/main branch and check whether all tests from GitHub actions got passed.
- If you don't make any contributions in 3 days after getting issue assigned, your assignment will be removed.

### Commiting Guidelines

1. Each commit message should convey a single change.
2. If a change is suggested in a commit, don't do a new commit, rather undo the last commit and edit it. Use this command for this:

   ```bash
   git commit --amend -m "<your_commit_message>"
   ```

   This will replace the last commit fully with the new changes (including commit message and code changes)

3. _Important_: When you have edited the last commit, don't push it to the remote repo directly. Rather, use the following command:

   ```bash
   git push -f

   ```

4. Every commit message should follow a fixed format:

```bash
type(scope?): subject   #scope is optional
```

Example commit messages:

```bash
feat(blog): add comment section

fix: some message
```

Valid types:

![image](https://github.com/Varun-Kolanu/csoc_flutter/assets/112728411/98bd81a3-9f21-49c0-adac-2ea850ccf952)

Examples of scopes: server, ui, services etc

4. Before making a commit, always fetch using the command:

```bash
git fetch --all
```

## Folder Structure:

```
.
├── assets
│   ├── images
│   ├── icons
│   ├── videos
|   └── attendance_data.json
├── ...
└── lib
    ├── cubit
    │   ├── feature_cubit.dart
    │   ├── feature_state.dart
    │   └── ...
    ├── models
    │   ├── feature_model.dart
    │   └── ...
    ├── repository
    │   ├── feature_repository.dart
    │   └── ...
    ├── services
    │   ├── feature_service.dart
    │   └── ...
    ├── ui
    │   ├── screens
    │   │   ├── feature_screen.dart
    │   │   └── ...
    │   └── widgets
    │       ├── feature_widget.dart
    │       └── ...
    └── utils
        ├── colors.dart
        ├── constants.dart
        └── ...
```

1. `assets` have three folders images, icons and videos.
2. `cubit`: For managing the state. You'll reach out to the functions in cubit for any work. These emit states, which are listened by UI.
3. `repositories`: Cubit functions call repositories. These have functions which call APIs, acts a bridge between backend and flutter.
4. `models`: Used by repositories or when JSONs are needed. Used to serialize or deserialize in JSONs (like changing data to JSON for API calls)
5. `services`: Any function to be used by UI or cubit or literally any part of application. All the functions reside here
6. `ui`: Has two folders for `screens` and `widgets`. Only UI and no functions in these. cubit and serices are present for that. Use BlocBuilder to update UI when states are emitted from cubit.
7. `utils`: General folder for colors, constants, image paths etc

## Important tools for making your life easier

1. Getting the commit hashes of all the previous commits:

   ```bash
   git log
   ```

2. Check a previous commit without resetting:

   ```bash
   git checkout <commit-hash>
   ```

3. Go to a commit by undoing all the next commits (For eg., go to commit 2 while undoing 3rd, 4th commits):

   ```bash
   git reset --hard <commit-hash>
   ```

4. Undo the last commit and keep the changes in local repo so that you can change them and recommit later:

   ```
   git reset --soft HEAD~1
   ```

5. For `git commit --amend` and `git rebase`, always use `git push -f` instead of simple `git push`
6. Update your repo in intervals using `git fetch --all` and `git rebase upstream/main`.
7. To edit a particular commit use Interactive rebase: `git rebase --interactive <commit-hash>~` and follow the commands.

   For example, to edit a commit message of a particular commit:

   1. Run git log
   2. Copy the commit hash of the commit you want to edit
   3. Run git rebase -i <commit_hash>~ for eg., git rebase -i 9824....7552~
   4. A vim editor will be opened
   5. Press the keyboard key "i"
   6. You can see footer as "--INSERT--"
   7. Now you can see some lines with format "keyword commit_hash commit message" and also can see some commands given below
   8. For eg., "pick ... Added attendance page"
   9. Edit that line to "reword ... Added attendance page" (reword refers to changing commit message)
   10. Press "Esc"
   11. Press ":wq" and Enter
   12. A new editor will be opened in which you can see the commit message
   13. Press i
   14. Edit the commit message
   15. Press Esc and ":wq" to save
   16. At last, git push -f
