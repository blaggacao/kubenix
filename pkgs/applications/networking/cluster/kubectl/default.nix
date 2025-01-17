{ stdenv, kubernetes, installShellFiles }:

stdenv.mkDerivation {
  name = "kubectl-${kubernetes.version}";

  # kubectl is currently part of the main distribution but will eventially be
  # split out (see homepage)
  dontUnpack = true;

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "man" ];

  installPhase = ''
    install -D ${kubernetes}/bin/kubectl -t $out/bin

    installManPage "${kubernetes.man}/share/man/man1"/kubectl*

    for shell in bash zsh; do
      $out/bin/kubectl completion $shell > kubectl.$shell
      installShellCompletion kubectl.$shell
    done
  '';

  meta = kubernetes.meta // {
    description = "Kubernetes CLI";
    homepage = "https://github.com/kubernetes/kubectl";
  };
}
