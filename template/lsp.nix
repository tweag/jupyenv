{
  pkgs,
  config,
  ...
}: {
  jupyterlab = {
    extensions = {
      features = ["lsp" "jupytext"];
      languageServers = {
        python = ps: ps.python-lsp-server;
      };
    };
    notebookConfig = {
      # add your custom language server config here or other notebook config for the jupyterlab_notebook_config.json
      # LanguageServerManager.language_servers.custom-language-servers
      #   "argv" = ["haskell-language-server" "--lsp"];
      #   "languages" = ["haskell"];
      #   "display_name" = "haskell-language-server";
      #   "mimetypes" = ["text/haskell" "text/x-haskell"];
      # };
    };
    runtimePackages = [];
    jupyterlabEnvArgs.extraPackages = ps: ([] ++ ps.python-lsp-server.passthru.optional-dependencies.all);
  };
  kernel.python.minimal = {
    enable = true;
  };
  # FIXME: haskell-language-server is not yet support in jupyterlab-lsp
  kernel.haskell.minimal = {
    enable = true;
    haskellCompiler = "ghc902";
  };
}
