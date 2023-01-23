{inputs, latest-nixpkgs}: final: prev:
let

  emacs = prev.emacs;

  inherit (inputs) daml-mode;

  emacsWithPackages =
    ((prev.emacsPackagesFor emacs).overrideScope' daml-mode.overlays.default).emacsWithPackages;

in {

  emacs-kczulko = emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
  ]) ++ (with epkgs.melpaPackages; [
    ace-window
    ag
    avy
    bazel
    company
    docker
    dockerfile-mode
    eno
    envrc
    flycheck
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
    nix-mode
    projectile
    s
    sbt-mode
    smartparens
    solidity-mode
    string-inflection
    terraform-mode
    use-package
    use-package-chords
    visual-regexp-steroids
    yaml-mode
    yasnippet
  ]) ++ (with epkgs.elpaPackages; [
    tramp
    undo-tree
    # auctex         # ; LaTeX mode
    # beacon         # ; highlight my cursor when scrolling
    # nameless       # ; hide current package name everywhere in elisp code
  ]) ++ [
    epkgs.daml-mode
  ]);
}
