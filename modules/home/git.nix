# Ported from the chezmoi dotfiles (private_dot_config/git/config.tmpl and ignore).
{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    ignores = [
      ".*.sw*"
      "*.pyc"
      ".DS_Store"
      ".Python"
      # .envrc is committed now (it just says `use flake`); direnv's cache dir isn't.
      ".direnv"
      ".idea"
      ".pc"
      ".svn"
      ".vscode"
      "/tmp"
    ];

    settings = {
      user = {
        name = "Chris Sykes";
        email = "chris@chillincool.net";
      };
      advice = {
        addEmptyPathspec = false;
        pushNonFastForward = false;
        statusHints = false;
      };
      alias = {
        a = "add";
        ap = "add -p";
        amc = "am --continue";
        b = "branch";
        bm = "branch --merged";
        bnm = "branch --no-merged";
        c = "clone";
        ca = "commit --amend";
        cane = "commit --amend --no-edit";
        cf = "commit --fixup";
        cm = "commit --message";
        co = "checkout";
        cob = "checkout -b";
        com = "checkout master";
        cp = "cherry-pick";
        d = "diff";
        dc = "diff --cached";
        dom = "diff origin/master";
        fo = "fetch origin";
        fu = "!git log -n 16 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
        g = "grep --line-number";
        mbhom = "merge-base HEAD origin/master";
        mff = "merge --ff-only";
        ol = "log --pretty=oneline";
        l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        p = "push";
        pf = "push --force-with-lease";
        prb = "pull --rebase";
        r = "restore";
        ra = "rebase --abort";
        rc = "rebase --continue";
        ri = "rebase --interactive";
        rl = "reflog";
        riom = "rebase --interactive origin/master";
        rpo = "remote prune origin";
        s = "status -sb";
        sh = "!git log -n 16 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git show";
        ss = "commit --message 'chore: snapshot' --no-gpg-sign";
        su = "submodule update";
        wd = "diff --patience --word-diff";
        # https://golang.org/doc/contribute.html
        change = "codereview change";
        gofmt = "codereview gofmt";
        mail = "codereview mail";
        pending = "codereview pending";
        submit = "codereview submit";
        sync = "codereview sync";
      };
      color.ui = "auto";
      core.whitespace = "trailing-space,space-before-tab";
      diff = {
        algorithm = "histogram";
        renamelimit = 8192;
        renames = "copies";
      };
      fetch = {
        fsckobjects = false;
        prune = true;
      };
      gitget.root = "~/src";
      init.defaultBranch = "master";
      pager = {
        branch = false;
        grep = false;
      };
      push.default = "current";
      rebase = {
        autosquash = true;
        autostash = true;
      };
      receive.fsckobjects = true;
      status.submoduleSummary = true;
      transfer.fsckobjects = true;
      trim.bases = "master,gh-pages";
      url."git@github.com:chezmoi/".insteadOf = "https://github.com/chezmoi/";
      url."git@github.com:twpayne/".insteadOf = "https://github.com/twpayne/";
    };
  };

  # Sets core.pager and interactive.diffFilter, like the old config.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options.navigate = true;
  };

  # `gh auth login` once per machine; gh also acts as git's credential helper for github.com.
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
