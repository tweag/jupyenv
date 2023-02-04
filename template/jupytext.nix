{
  pkgs,
  config,
  ...
}: {
  jupyterlab = {
    extensions = {
      features = ["jupytext"];
    };
    notebookConfig = {
      ServerApp.contents_manager_class = "jupytext.TextFileContentsManager";
      ContentsManager.notebook_extensions = "ipynb,Rmd,jl,md,py";
    };
  };
  kernel.python.minimal = {
    enable = true;
  };
}
