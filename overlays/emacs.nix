{ inputs, latest-nixpkgs }: final: prev:
let

  # due to emacs tramp bug, temporary solution
  # is to use some trunk emacs version greater than 29.1
  # https://lists.gnu.org/r/bug-gnu-emacs/2023-08/msg00317.html
  emacs = prev.emacs29;
    # .overrideAttrs (finalAttrs: prevAttrs:
  #   {
  #     version = "29.2";
  #     src = prev.fetchurl {
  #       url = "https://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-dc9d02f8a01d86ac8ff3fb004bb2f22cf211dcef.tar.gz";
  #       sha256 = "sha256-1cNwQ4DgxiA5KA+Zxsr3zASvH1xEi3w/JzjkUUmhS7U=";
  #     };
  #   }
  # );

  emacsWithPackages = (prev.emacsPackagesFor emacs).emacsWithPackages;

in
{

  emacs-kczulko = emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
  ]) ++ (with epkgs.melpaPackages; [
    ace-window
    ag
    avy
    bazel
    company
    daml-mode
    daml-lsp
    docker
    dockerfile-mode
    drag-stuff
    elm-mode
    eno
    envrc
    flycheck
    go-mode
    goto-chg
    groovy-mode
    haskell-mode
    helm
    helm-ag
    helm-lsp
    helm-projectile
    highlight-symbol
    hydra
    key-chord
    kubel
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
  ]);
}
