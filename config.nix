{
  lib,
  options ? {},
}: let
  inherit (lib) mkOption mkOptionType types;
in {
  options = rec {
    Application = {
      log_datefmt = mkOption {
        type = types.str;
        default = "%Y-%m-%d %H:%M:%S";
        description = "The date format used by logging formatters for %(asctime)s.";
      };

      log_format = mkOption {
        type = types.str;
        default = "[%(name)s]%(highlevel)s %(message)s";
        description = "The Logging format template.";
      };

      log_level = mkOption {
        type = types.enum [0 10 20 30 40 50 "DEBUG" "INFO" "WARN" "ERROR" "CRITICAL"];
        default = 30;
        description = ''
          Set the log level by value or name.
          Choices: any of [0, 10, 20, 30, 40, 50, 'DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL']
        '';
      };

      logging_config = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Configure additional log handlers.
          For more information see:
          https://jupyter-notebook.readthedocs.io/en/stable/config.html
          https://docs.python.org/3/library/logging.config.html#logging-config-dictschema
        '';
        example = {
          handlers = {
            file = {
              class = "logging.FileHandler";
              level = "DEBUG";
              filename = "<path/to/file>";
            };
          };
          loggers = {
            app-name = {
              level = "DEBUG";
              # NOTE: if you don't list the default "console"
              # handler here then it will be disabled
              handlers = ["console" "file"];
            };
          };
        };
      };

      show_config = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Instead of starting the Application, dump configuration to stdout.
        '';
      };

      show_config_json = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Instead of starting the Application, dump configuration to stdout
          (as JSON).
        '';
      };
    };

    JupyterApp = {
      answer_yes = mkOption {
        type = types.bool;
        default = false;
        description = "Answer yes to any prompts.";
      };
      config_file = mkOption {
        type = types.path;
        default = "";
        description = "Full path of a config file.";
      };
      config_file_name = mkOption {
        type = types.str;
        default = "";
        description = "Specify a config file to load.";
      };
      generate_config = mkOption {
        type = types.bool;
        default = false;
        description = "Generate default config file.";
      };
      log_datefmt = Application.log_datefmt;
      log_format = Application.log_format;
      log_level = Application.log_level;
      logging_config = Application.logging_config;
      show_config = Application.show_config;
      show_config_json = Application.show_config_json;
    };

    NotebookApp = {
      allow_credentials = mkOption {
        type = types.bool;
        default = false;
        description = "Set the Access-Control-Allow-Credentials: true header";
      };

      allow_origin = mkOption {
        types = types.str;
        default = "";
        description = ''
          Set the Access-Control-Allow-Origin header.
          Use ‘*’ to allow any origin to access your server.
          Takes precedence over allow_origin_pat.
        '';
      };

      allow_origin_pat = mkOption {
        type = types.str;
        default = "";
        description = ''
          Use a regular expression for the Access-Control-Allow-Origin header.
          Requests from an origin matching the expression will get replies with:

            Access-Control-Allow-Origin: origin

          where origin is the origin of the request.
          Ignored if allow_origin is set.
        '';
      };

      allow_password_change = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Allow password to be changed at login for the notebook server.

          While logging in with a token, the notebook server UI will give the
          opportunity to the user to enter a new password at the same time
          that will replace the token login mechanism.

          This can be set to false to prevent changing password from the UI/API.
        '';
      };

      allow_remote_access = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allow requests where the Host header doesn’t point to a local server.

          By default, requests get a 403 forbidden response if the ‘Host’
          header shows that the browser thinks it’s on a non-local domain.
          Setting this option to True disables this check.

          This protects against ‘DNS rebinding’ attacks, where a remote web
          server serves you a page and then changes its DNS to send later
          requests to a local IP, bypassing same-origin checks.

          Local IP addresses (such as 127.0.0.1 and ::1) are allowed as local,
          along with hostnames configured in local_hostnames.
        '';
      };

      allow_root = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to allow the user to run the notebook as root.";
      };

      answer_yes = JupyterApp.answer_yes;

      authenticate_prometheus = mkOption {
        type = types.bool;
        default = true;
        description = "Require authentication to access prometheus metrics.";
      };

      autoreload = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Reload the webapp when changes are made to any Python src files.
        '';
      };

      base_url = mkOption {
        type = types.str;
        default = "/";
        description = ''
          The base URL for the notebook server.

          Leading and trailing slashes can be omitted, and will automatically
          be added.
        '';
      };

      browser = mkOption {
        type = types.str;
        default = "";
        description = ''
          Specify what command to use to invoke a web browser when opening the
          notebook. If not specified, the default browser will be determined by
          the webbrowser standard library module, which allows setting of the
          BROWSER environment variable to override it.
        '';
      };

      certfile = mkOption {
        type = types.str;
        default = "";
        description = "The full path to an SSL/TLS certificate file.";
      };

      client_ca = mkOption {
        type = types.str;
        default = "";
        description = ''
          The full path to a certificate authority certificate for SSL/TLS
          client authentication.
        '';
      };

      config_file = JupyterApp.config_file;

      config_file_name = JupyterApp.config_file_name;

      config_manager_class = mkOption {
        type = types.str;
        default = "notebook.services.config.manager.ConfigManager";
        description = "The config manager class to use.";
      };

      contents_manager_class = mkOption {
        type = types.str;
        default = "notebook.services.contents.largefilemanager.LargeFileManager";
        description = "The notebook manager class to use.";
      };

      cookie_options = mkOption {
        type = types.attrs;
        default = {};
        descripion = ''
          Extra keyword arguments to pass to set_secure_cookie. See tornado’s
          set_secure_cookie docs for details.
        '';
      };

      # TODO - figure out how to properly implement byte strings
      #cookie_secret = null;

      cookie_secret_file = mkOption {
        type = types.str;
        default = "";
        description = "The file where the cookie secret is stored.";
      };

      custom_display_url = mkOption {
        type = types.str;
        default = "";
        description = ''
          Override URL shown to users.

          Replace actual URL, including protocol, address, port and base URL,
          with the given value when displaying URL to the users. Do not change
          the actual connection URL. If authentication token is enabled, the
          token is added to the custom URL automatically.

          This option is intended to be used when the URL to display to the
          user cannot be determined reliably by the Jupyter notebook server
          (proxified or containerized setups for example).
        '';
      };

      default_url = mkOption {
        type = types.str;
        default = "/tree";
        description = "The default URL to redirect to from /";
      };
    };
  };
}
