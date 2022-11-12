{inputs, latest-nixpkgs}: final: prev:
let

  emacs = prev.emacs;

  inherit (inputs) daml-mode;

  emacsWithPackages =
    ((prev.emacsPackagesFor emacs).overrideScope' daml-mode.overlays.default).emacsWithPackages;

in {

  emacs-kczulko = emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
  ]) ++ (with epkgs.melpaPackages; [
    # TODO nixify daml mode
    # pkgs.emacsPackages.trivialBuild
    ace-window
    ag
    avy
    bazel
    company
    dockerfile-mode
    eno
    envrc
    go-mode
    goto-chg
    haskell-mode
    helm
    helm-ag
    helm-lsp
    helm-projectile
    highlight-symbol
    hydra
    key-chord
    lsp-haskell
    lsp-metals
    lsp-mode
    lsp-ui
    magit
    markdown-mode
    monokai-theme
    multiple-cursors
    projectile
    smartparens
    solidity-mode
    string-edit
    string-inflection
    terraform-mode
    use-package
    visual-regexp-steroids
    yaml-mode
    yasnippet
    sbt-mode
    flycheck
    # CAUTION! Do not take nix-mode from melpaStablePackages (1.4.5)
    # It suffers from following error:
    # Eager macro-expansion failure: (wrong-number-of-arguments (3 . 4) 2) [2 times]
    # define-obsolete-function-alias: Wrong number of arguments: (3 . 4), 2
    nix-mode
  ]) ++ (with epkgs.elpaPackages; [
    undo-tree
    # auctex         # ; LaTeX mode
    # beacon         # ; highlight my cursor when scrolling
    # nameless       # ; hide current package name everywhere in elisp code
  ]) ++ [
    epkgs.daml-mode
  ]);
}