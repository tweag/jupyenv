{ directory, kernels, extraPackages
, jupyterlab, environment, path
}:

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jupyterWith;

  notebookConfig = pkgs.writeText "jupyter_config.py" ''
    ${cfg.notebookConfig}
    c.NotebookApp.password = ${cfg.password}
  '';

in {

  options.services.jupyterWith = {
    enable = mkEnableOption "Jupyter development server";

    ip = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        IP address Jupyter will be listening on.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8888;
      description = ''
        Port number Jupyter will be listening on.
      '';
    };

    notebookDir = mkOption {
      type = types.str;
      default = "~/";
      description = ''
        Root directory for notebooks.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "jupyter";
      description = ''
        Name of the user used to run the jupyter service.
        For security reason, jupyter should really not be run as root.
        If not set (jupyter), the service will create a jupyter user with appropriate settings.
      '';
      example = "aborsu";
    };

    group = mkOption {
      type = types.str;
      default = "jupyter";
      description = ''
        Name of the group used to run the jupyter service.
        Use this if you want to create a group of users that are able to view the notebook directory's content.
      '';
      example = "users";
    };

    password = mkOption {
      type = types.str;
      description = ''
        Password to use with notebook.
        Can be generated using:
          In [1]: from notebook.auth import passwd
          In [2]: passwd('test')
          Out[2]: 'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'
          NOTE: you need to keep the single quote inside the nix string.
        Or you can use a python oneliner:
          "open('/path/secret_file', 'r', encoding='utf8').read().strip()"
        It will be interpreted at the end of the notebookConfig.
      '';
      example = [
        "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'"
        "open('/path/secret_file', 'r', encoding='utf8').read().strip()"
      ];
    };

    notebookConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Raw jupyter config.
      '';
    };

  };

  config = mkMerge [
    (mkIf cfg.enable  {
      systemd.services.jupyterWith = {
        description = "Jupyter development server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = environment;

        serviceConfig = {
          Restart = "always";
          ExecStart = ''${jupyterlab}/bin/jupyter-lab \
            --no-browser \
            --ip=${cfg.ip} \
            --port=${toString cfg.port} --port-retries 0 \
            --notebook-dir=${cfg.notebookDir} \
            --NotebookApp.config_file=${notebookConfig}
          '';
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "~";
        };
      };
    })
    (mkIf (cfg.enable && (cfg.group == "jupyter")) {
      users.groups.jupyter = {};
    })
    (mkIf (cfg.enable && (cfg.user == "jupyter")) {
      users.extraUsers.jupyter = {
        extraGroups = [ cfg.group ];
        home = "/var/lib/jupyter";
        createHome = true;
        useDefaultShell = true; # needed so that the user can start a terminal.
      };
    })
  ];
}
