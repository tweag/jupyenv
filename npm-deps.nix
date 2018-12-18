{ fetchurl, fetchgit }:
  self:
    super:
      let
        registries = {
          yarn = n:
            v:
              "https://registry.yarnpkg.com/${n}/-/${n}-${v}.tgz";
          npm = n:
            v:
              "https://registry.npmjs.org/${n}/-/${n}-${v}.tgz";
        };
        nodeFilePackage = key:
          version:
            registry:
              sha1:
                deps:
                  super._buildNodePackage {
                    inherit key version;
                    src = fetchurl {
                      url = registry key version;
                      inherit sha1;
                    };
                    nodeBuildInputs = deps;
                  };
        nodeGitPackage = key:
          version:
            url:
              rev:
                sha256:
                  deps:
                    super._buildNodePackage {
                      inherit key version;
                      src = fetchgit {
                        inherit url rev sha256;
                      };
                      nodeBuildInputs = deps;
                    };
        identityRegistry = url:
          _:
            _:
              url;
        scopedName = scope:
          name:
            { inherit scope name; };
        ir = identityRegistry;
        f = nodeFilePackage;
        g = nodeGitPackage;
        n = registries.npm;
        y = registries.yarn;
        sc = scopedName;
        s = self;
      in {
        "@jupyterlab/application-extension@0.19.1" = f (sc "jupyterlab" "application-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/application-extension/-/application-extension-0.19.1.tgz") "5f16c45c01f1e7d8371e937e5ec0fae0f15a451e" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."react@~16.4.2")
        ];
        "@jupyterlab/application-extension@^0.19.1" = s."@jupyterlab/application-extension@0.19.1";
        "@jupyterlab/application@0.19.1" = f (sc "jupyterlab" "application") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/application/-/application-0.19.1.tgz") "2f976a2e140041543f1dcf14a52eb081f7729739" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/application@^1.6.0")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/properties@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/application@^0.19.1" = s."@jupyterlab/application@0.19.1";
        "@jupyterlab/apputils-extension@0.19.1" = f (sc "jupyterlab" "apputils-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/apputils-extension/-/apputils-extension-0.19.1.tgz") "dd44c4dde25b6db5e537f1d7e9b17bb5f0302932" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."es6-promise@~4.1.1")
        ];
        "@jupyterlab/apputils-extension@^0.19.1" = s."@jupyterlab/apputils-extension@0.19.1";
        "@jupyterlab/apputils@0.19.1" = f (sc "jupyterlab" "apputils") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/apputils/-/apputils-0.19.1.tgz") "673f7e8fecc01ba3a98dd75c5c0f9ca354fe0b69" [
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/domutils@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/properties@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/virtualdom@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."@types/react@~16.4.13")
          (s."react@~16.4.2")
          (s."react-dom@~16.4.2")
          (s."sanitize-html@~1.18.2")
        ];
        "@jupyterlab/apputils@^0.19.1" = s."@jupyterlab/apputils@0.19.1";
        "@jupyterlab/attachments@0.19.1" = f (sc "jupyterlab" "attachments") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/attachments/-/attachments-0.19.1.tgz") "4a8dfa0e239022aaadcd03793bfe7babe7fba110" [
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
        ];
        "@jupyterlab/attachments@^0.19.1" = s."@jupyterlab/attachments@0.19.1";
        "@jupyterlab/buildutils@0.11.1" = f (sc "jupyterlab" "buildutils") "0.11.1" (ir "https://registry.yarnpkg.com/@jupyterlab/buildutils/-/buildutils-0.11.1.tgz") "62e512091d9108ada8fadf80678cf96bb1b9017d" [
          (s."@phosphor/coreutils@^1.3.0")
          (s."child_process@~1.0.2")
          (s."commander@~2.18.0")
          (s."fs-extra@~4.0.2")
          (s."glob@~7.1.2")
          (s."inquirer@~3.3.0")
          (s."package-json@~5.0.0")
          (s."path@~0.12.7")
          (s."semver@^5.5.0")
          (s."sort-package-json@~1.7.1")
          (s."typescript@~3.1.1")
        ];
        "@jupyterlab/buildutils@^0.11.1" = s."@jupyterlab/buildutils@0.11.1";
        "@jupyterlab/cells@0.19.1" = f (sc "jupyterlab" "cells") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/cells/-/cells-0.19.1.tgz") "1d9c5f4a583c0bb3f5c5a9f1717e0fdef747206f" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/attachments@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/codemirror@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@jupyterlab/outputarea@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
        ];
        "@jupyterlab/cells@^0.19.1" = s."@jupyterlab/cells@0.19.1";
        "@jupyterlab/codeeditor@0.19.1" = f (sc "jupyterlab" "codeeditor") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/codeeditor/-/codeeditor-0.19.1.tgz") "9b268ed914948bd46d93c391542b24cbaea58adc" [
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
          (s."react-dom@~16.4.2")
        ];
        "@jupyterlab/codeeditor@^0.19.1" = s."@jupyterlab/codeeditor@0.19.1";
        "@jupyterlab/codemirror-extension@0.19.1" = f (sc "jupyterlab" "codemirror-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/codemirror-extension/-/codemirror-extension-0.19.1.tgz") "7fe5c2389801828b73a45ab606c007640846b28b" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/codemirror@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/fileeditor@^0.19.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@phosphor/widgets@^1.6.0")
          (s."codemirror@~5.39.0")
        ];
        "@jupyterlab/codemirror-extension@^0.19.1" = s."@jupyterlab/codemirror-extension@0.19.1";
        "@jupyterlab/codemirror@0.19.1" = f (sc "jupyterlab" "codemirror") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/codemirror/-/codemirror-0.19.1.tgz") "7eaedcfef666feb15ede66207b4f3967c849afb5" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."codemirror@~5.39.0")
        ];
        "@jupyterlab/codemirror@^0.19.1" = s."@jupyterlab/codemirror@0.19.1";
        "@jupyterlab/completer-extension@0.19.1" = f (sc "jupyterlab" "completer-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/completer-extension/-/completer-extension-0.19.1.tgz") "368697752c8cdd70cfc61948bbc2bcabc4e92bd6" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/completer@^0.19.1")
          (s."@jupyterlab/console@^0.19.1")
          (s."@jupyterlab/fileeditor@^0.19.1")
          (s."@jupyterlab/notebook@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/completer-extension@^0.19.1" = s."@jupyterlab/completer-extension@0.19.1";
        "@jupyterlab/completer@0.19.1" = f (sc "jupyterlab" "completer") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/completer/-/completer-0.19.1.tgz") "39dfd671367f881de85574cc715e1a30fa23a897" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/domutils@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/completer@^0.19.1" = s."@jupyterlab/completer@0.19.1";
        "@jupyterlab/console-extension@0.19.1" = f (sc "jupyterlab" "console-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/console-extension/-/console-extension-0.19.1.tgz") "0bad192d2f38571953e592038757aec081daa17f" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/console@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/filebrowser@^0.19.1")
          (s."@jupyterlab/launcher@^0.19.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/console-extension@^0.19.1" = s."@jupyterlab/console-extension@0.19.1";
        "@jupyterlab/console@0.19.1" = f (sc "jupyterlab" "console") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/console/-/console-0.19.1.tgz") "3fe7439f7e202d91c00090beb821662eaf0bd336" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/cells@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/console@^0.19.1" = s."@jupyterlab/console@0.19.1";
        "@jupyterlab/coreutils@2.2.1" = f (sc "jupyterlab" "coreutils") "2.2.1" (ir "https://registry.yarnpkg.com/@jupyterlab/coreutils/-/coreutils-2.2.1.tgz") "c271eaf2f6e468757ba9660f24bd3c3e5d6fe583" [
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."ajv@~5.1.6")
          (s."comment-json@^1.1.3")
          (s."minimist@~1.2.0")
          (s."moment@~2.21.0")
          (s."path-posix@~1.0.0")
          (s."url-parse@~1.4.3")
        ];
        "@jupyterlab/coreutils@^2.2.1" = s."@jupyterlab/coreutils@2.2.1";
        "@jupyterlab/csvviewer-extension@0.19.1" = f (sc "jupyterlab" "csvviewer-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/csvviewer-extension/-/csvviewer-extension-0.19.1.tgz") "a96c7c5e5acf28b5c5abe7018d44782f6ec1b57c" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/csvviewer@^0.19.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@phosphor/datagrid@^0.1.6")
        ];
        "@jupyterlab/csvviewer-extension@^0.19.1" = s."@jupyterlab/csvviewer-extension@0.19.1";
        "@jupyterlab/csvviewer@0.19.1" = f (sc "jupyterlab" "csvviewer") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/csvviewer/-/csvviewer-0.19.1.tgz") "ddae6043f6370b89d716c5a50f79fd5641995cdc" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/datagrid@^0.1.6")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/csvviewer@^0.19.1" = s."@jupyterlab/csvviewer@0.19.1";
        "@jupyterlab/docmanager-extension@0.19.1" = f (sc "jupyterlab" "docmanager-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/docmanager-extension/-/docmanager-extension-0.19.1.tgz") "0f10e57a4fe17c1570149981a52f852252f2b1ee" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docmanager@^0.19.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/docmanager-extension@^0.19.1" = s."@jupyterlab/docmanager-extension@0.19.1";
        "@jupyterlab/docmanager@0.19.1" = f (sc "jupyterlab" "docmanager") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/docmanager/-/docmanager-0.19.1.tgz") "3098b765eebcd17777d82fb19794bbb8a72876b9" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/properties@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/docmanager@^0.19.1" = s."@jupyterlab/docmanager@0.19.1";
        "@jupyterlab/docregistry@0.19.1" = f (sc "jupyterlab" "docregistry") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/docregistry/-/docregistry-0.19.1.tgz") "1a8bcddc3eaf22fb25ce499a1f4c818c0c4cf1a0" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/codemirror@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/docregistry@^0.19.1" = s."@jupyterlab/docregistry@0.19.1";
        "@jupyterlab/extensionmanager-extension@0.19.1" = f (sc "jupyterlab" "extensionmanager-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/extensionmanager-extension/-/extensionmanager-extension-0.19.1.tgz") "2484d2387fd69311e947bc28d4a956b66afb75f7" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/extensionmanager@^0.19.1")
        ];
        "@jupyterlab/extensionmanager-extension@^0.19.1" = s."@jupyterlab/extensionmanager-extension@0.19.1";
        "@jupyterlab/extensionmanager@0.19.1" = f (sc "jupyterlab" "extensionmanager") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/extensionmanager/-/extensionmanager-0.19.1.tgz") "4dd3afc89e1d8bfd5455cc14969fa56d0daf7feb" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/messaging@^1.2.2")
          (s."react@~16.4.2")
          (s."react-paginate@^5.2.3")
          (s."semver@^5.5.0")
        ];
        "@jupyterlab/extensionmanager@^0.19.1" = s."@jupyterlab/extensionmanager@0.19.1";
        "@jupyterlab/faq-extension@0.19.1" = f (sc "jupyterlab" "faq-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/faq-extension/-/faq-extension-0.19.1.tgz") "b74309c30615d3666be51df2a987f639cafefce7" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@phosphor/coreutils@^1.3.0")
        ];
        "@jupyterlab/faq-extension@^0.19.1" = s."@jupyterlab/faq-extension@0.19.1";
        "@jupyterlab/filebrowser-extension@0.19.2" = f (sc "jupyterlab" "filebrowser-extension") "0.19.2" (ir "https://registry.yarnpkg.com/@jupyterlab/filebrowser-extension/-/filebrowser-extension-0.19.2.tgz") "837c8a4fe776697896ce4a1a7d38a7fe12dc973a" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docmanager@^0.19.1")
          (s."@jupyterlab/filebrowser@^0.19.1")
          (s."@jupyterlab/launcher@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/filebrowser-extension@^0.19.2" = s."@jupyterlab/filebrowser-extension@0.19.2";
        "@jupyterlab/filebrowser@0.19.3" = f (sc "jupyterlab" "filebrowser") "0.19.3" (ir "https://registry.yarnpkg.com/@jupyterlab/filebrowser/-/filebrowser-0.19.3.tgz") "1115238f2723bb351eace953de80ccda1c9ab547" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docmanager@^0.19.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/domutils@^1.1.2")
          (s."@phosphor/dragdrop@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/filebrowser@^0.19.1" = s."@jupyterlab/filebrowser@0.19.3";
        "@jupyterlab/filebrowser@^0.19.3" = s."@jupyterlab/filebrowser@0.19.3";
        "@jupyterlab/fileeditor-extension@0.19.1" = f (sc "jupyterlab" "fileeditor-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/fileeditor-extension/-/fileeditor-extension-0.19.1.tgz") "572f953202e42427d7e452d2bc4dde3500e6ee5c" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/console@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/filebrowser@^0.19.1")
          (s."@jupyterlab/fileeditor@^0.19.1")
          (s."@jupyterlab/launcher@^0.19.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/fileeditor-extension@^0.19.1" = s."@jupyterlab/fileeditor-extension@0.19.1";
        "@jupyterlab/fileeditor@0.19.1" = f (sc "jupyterlab" "fileeditor") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/fileeditor/-/fileeditor-0.19.1.tgz") "c980747e97875b1bd1f46e57046a2a00f1131840" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/fileeditor@^0.19.1" = s."@jupyterlab/fileeditor@0.19.1";
        "@jupyterlab/help-extension@0.19.1" = f (sc "jupyterlab" "help-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/help-extension/-/help-extension-0.19.1.tgz") "d103fc251d58487c48259db9aedf8cdfcf87fbc4" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
        ];
        "@jupyterlab/help-extension@^0.19.1" = s."@jupyterlab/help-extension@0.19.1";
        "@jupyterlab/imageviewer-extension@0.19.1" = f (sc "jupyterlab" "imageviewer-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/imageviewer-extension/-/imageviewer-extension-0.19.1.tgz") "379883b08b705c0250b79824993bf7d770ef9d9e" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/imageviewer@^0.19.1")
        ];
        "@jupyterlab/imageviewer-extension@^0.19.1" = s."@jupyterlab/imageviewer-extension@0.19.1";
        "@jupyterlab/imageviewer@0.19.1" = f (sc "jupyterlab" "imageviewer") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/imageviewer/-/imageviewer-0.19.1.tgz") "e4f6ab29132ca3fa9ad050287ad5db948d2734d9" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/imageviewer@^0.19.1" = s."@jupyterlab/imageviewer@0.19.1";
        "@jupyterlab/inspector-extension@0.19.1" = f (sc "jupyterlab" "inspector-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/inspector-extension/-/inspector-extension-0.19.1.tgz") "6e5bdc06e10217ad764bd1c3923b4cac20f69212" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/console@^0.19.1")
          (s."@jupyterlab/inspector@^0.19.1")
          (s."@jupyterlab/notebook@^0.19.1")
          (s."@phosphor/disposable@^1.1.2")
        ];
        "@jupyterlab/inspector-extension@^0.19.1" = s."@jupyterlab/inspector-extension@0.19.1";
        "@jupyterlab/inspector@0.19.1" = f (sc "jupyterlab" "inspector") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/inspector/-/inspector-0.19.1.tgz") "f8fe7cca75e69220e7297f94d4770fcee39a4526" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/inspector@^0.19.1" = s."@jupyterlab/inspector@0.19.1";
        "@jupyterlab/javascript-extension@0.19.1" = f (sc "jupyterlab" "javascript-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/javascript-extension/-/javascript-extension-0.19.1.tgz") "2bb580823becab7603fd7738079896929692b5a3" [
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
        ];
        "@jupyterlab/javascript-extension@^0.19.1" = s."@jupyterlab/javascript-extension@0.19.1";
        "@jupyterlab/json-extension@0.18.1" = f (sc "jupyterlab" "json-extension") "0.18.1" (ir "https://registry.yarnpkg.com/@jupyterlab/json-extension/-/json-extension-0.18.1.tgz") "7f69756c5cbbfbc15e9466ecf21c603b223e13d5" [
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
          (s."react-dom@~16.4.2")
          (s."react-highlighter@^0.4.0")
          (s."react-json-tree@^0.11.0")
        ];
        "@jupyterlab/json-extension@^0.18.1" = s."@jupyterlab/json-extension@0.18.1";
        "@jupyterlab/launcher-extension@0.19.1" = f (sc "jupyterlab" "launcher-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/launcher-extension/-/launcher-extension-0.19.1.tgz") "62bc66e3e4ccbdfe4bb3d9cc996c390d3ff94769" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/launcher@^0.19.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/launcher-extension@^0.19.1" = s."@jupyterlab/launcher-extension@0.19.1";
        "@jupyterlab/launcher@0.19.1" = f (sc "jupyterlab" "launcher") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/launcher/-/launcher-0.19.1.tgz") "cab662ce42b7d0cbe65f9a0da75107677b6f01c7" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/properties@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
        ];
        "@jupyterlab/launcher@^0.19.1" = s."@jupyterlab/launcher@0.19.1";
        "@jupyterlab/mainmenu-extension@0.8.1" = f (sc "jupyterlab" "mainmenu-extension") "0.8.1" (ir "https://registry.yarnpkg.com/@jupyterlab/mainmenu-extension/-/mainmenu-extension-0.8.1.tgz") "3d52423aefb4c681f4f1453e2568541bccc34c1f" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/mainmenu-extension@^0.8.1" = s."@jupyterlab/mainmenu-extension@0.8.1";
        "@jupyterlab/mainmenu@0.8.1" = f (sc "jupyterlab" "mainmenu") "0.8.1" (ir "https://registry.yarnpkg.com/@jupyterlab/mainmenu/-/mainmenu-0.8.1.tgz") "a691fbbf338498d83ec4e0f6e0dc4660291c25af" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/mainmenu@^0.8.1" = s."@jupyterlab/mainmenu@0.8.1";
        "@jupyterlab/markdownviewer-extension@0.19.1" = f (sc "jupyterlab" "markdownviewer-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/markdownviewer-extension/-/markdownviewer-extension-0.19.1.tgz") "1374064847e20828bb78875cffa570eb239e2231" [
          (s."@jupyterlab/rendermime@^0.19.1")
        ];
        "@jupyterlab/markdownviewer-extension@^0.19.1" = s."@jupyterlab/markdownviewer-extension@0.19.1";
        "@jupyterlab/mathjax2-extension@0.7.1" = f (sc "jupyterlab" "mathjax2-extension") "0.7.1" (ir "https://registry.yarnpkg.com/@jupyterlab/mathjax2-extension/-/mathjax2-extension-0.7.1.tgz") "752f42bcf1a4f584474a9cd46e7af54ef4e336cb" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/mathjax2@^0.7.1")
          (s."@jupyterlab/rendermime@^0.19.1")
        ];
        "@jupyterlab/mathjax2-extension@^0.7.1" = s."@jupyterlab/mathjax2-extension@0.7.1";
        "@jupyterlab/mathjax2@0.7.1" = f (sc "jupyterlab" "mathjax2") "0.7.1" (ir "https://registry.yarnpkg.com/@jupyterlab/mathjax2/-/mathjax2-0.7.1.tgz") "7e8a864d42d0fcf6073a95cee24ab1a17546964a" [
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@phosphor/coreutils@^1.3.0")
        ];
        "@jupyterlab/mathjax2@^0.7.1" = s."@jupyterlab/mathjax2@0.7.1";
        "@jupyterlab/notebook-extension@0.19.1" = f (sc "jupyterlab" "notebook-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/notebook-extension/-/notebook-extension-0.19.1.tgz") "8aa5ded14e083c36b63391b154d1d4661c60e42a" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/cells@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/filebrowser@^0.19.1")
          (s."@jupyterlab/launcher@^0.19.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@jupyterlab/notebook@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/notebook-extension@^0.19.1" = s."@jupyterlab/notebook-extension@0.19.1";
        "@jupyterlab/notebook@0.19.2" = f (sc "jupyterlab" "notebook") "0.19.2" (ir "https://registry.yarnpkg.com/@jupyterlab/notebook/-/notebook-0.19.2.tgz") "ede77c45579007583d2bd01e485f3755e5214c07" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/cells@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/domutils@^1.1.2")
          (s."@phosphor/dragdrop@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/properties@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/virtualdom@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
        ];
        "@jupyterlab/notebook@^0.19.1" = s."@jupyterlab/notebook@0.19.2";
        "@jupyterlab/notebook@^0.19.2" = s."@jupyterlab/notebook@0.19.2";
        "@jupyterlab/observables@2.1.1" = f (sc "jupyterlab" "observables") "2.1.1" (ir "https://registry.yarnpkg.com/@jupyterlab/observables/-/observables-2.1.1.tgz") "c5d8ad295c5b0bce914a607a342b0af4550b2187" [
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
        ];
        "@jupyterlab/observables@^2.1.1" = s."@jupyterlab/observables@2.1.1";
        "@jupyterlab/outputarea@0.19.1" = f (sc "jupyterlab" "outputarea") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/outputarea/-/outputarea-0.19.1.tgz") "b2dd06ec7b01d0e0b84523fef8b1b6f73cd2a1c6" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/outputarea@^0.19.1" = s."@jupyterlab/outputarea@0.19.1";
        "@jupyterlab/pdf-extension@0.10.1" = f (sc "jupyterlab" "pdf-extension") "0.10.1" (ir "https://registry.yarnpkg.com/@jupyterlab/pdf-extension/-/pdf-extension-0.10.1.tgz") "bac894a6da13149e620a2f1137cf18cf0ccf38b2" [
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/pdf-extension@^0.10.1" = s."@jupyterlab/pdf-extension@0.10.1";
        "@jupyterlab/rendermime-extension@0.13.1" = f (sc "jupyterlab" "rendermime-extension") "0.13.1" (ir "https://registry.yarnpkg.com/@jupyterlab/rendermime-extension/-/rendermime-extension-0.13.1.tgz") "83190d4ebf6901214b9fffbc627ace498a03bd4b" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/docmanager@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
        ];
        "@jupyterlab/rendermime-extension@^0.13.1" = s."@jupyterlab/rendermime-extension@0.13.1";
        "@jupyterlab/rendermime-interfaces@1.2.1" = f (sc "jupyterlab" "rendermime-interfaces") "1.2.1" (ir "https://registry.yarnpkg.com/@jupyterlab/rendermime-interfaces/-/rendermime-interfaces-1.2.1.tgz") "702155fea6b87b58ba7025f2f267b72f6e7057f3" [
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/rendermime-interfaces@^1.2.1" = s."@jupyterlab/rendermime-interfaces@1.2.1";
        "@jupyterlab/rendermime@0.19.1" = f (sc "jupyterlab" "rendermime") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/rendermime/-/rendermime-0.19.1.tgz") "e5ca8f73cf9f6178ad5e76f18dbacb25c849bb80" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codemirror@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."ansi_up@^3.0.0")
          (s."marked@~0.4.0")
        ];
        "@jupyterlab/rendermime@^0.19.1" = s."@jupyterlab/rendermime@0.19.1";
        "@jupyterlab/running-extension@0.19.1" = f (sc "jupyterlab" "running-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/running-extension/-/running-extension-0.19.1.tgz") "2e2d2fed40e5eab0989861285a3ea2d7b5dc49da" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/running@^0.19.1")
        ];
        "@jupyterlab/running-extension@^0.19.1" = s."@jupyterlab/running-extension@0.19.1";
        "@jupyterlab/running@0.19.1" = f (sc "jupyterlab" "running") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/running/-/running-0.19.1.tgz") "ea2201e071421c948a5e0ce1648864b1e26e67fd" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
          (s."react-dom@~16.4.2")
        ];
        "@jupyterlab/running@^0.19.1" = s."@jupyterlab/running@0.19.1";
        "@jupyterlab/services@3.2.1" = f (sc "jupyterlab" "services") "3.2.1" (ir "https://registry.yarnpkg.com/@jupyterlab/services/-/services-3.2.1.tgz") "e8d9329ed73f794909f786d22c5e94b07beb041b" [
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/observables@^2.1.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
        ];
        "@jupyterlab/services@^3.2.1" = s."@jupyterlab/services@3.2.1";
        "@jupyterlab/settingeditor-extension@0.14.1" = f (sc "jupyterlab" "settingeditor-extension") "0.14.1" (ir "https://registry.yarnpkg.com/@jupyterlab/settingeditor-extension/-/settingeditor-extension-0.14.1.tgz") "aa4bb4eabc1e932f1a7dbda065f1ae30e23b9fcc" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/settingeditor@^0.8.1")
        ];
        "@jupyterlab/settingeditor-extension@^0.14.1" = s."@jupyterlab/settingeditor-extension@0.14.1";
        "@jupyterlab/settingeditor@0.8.1" = f (sc "jupyterlab" "settingeditor") "0.8.1" (ir "https://registry.yarnpkg.com/@jupyterlab/settingeditor/-/settingeditor-0.8.1.tgz") "d0d2cdfcb216386adcf6b9f3ed9e1c9bd53a73b5" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/inspector@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
          (s."react-dom@~16.4.2")
        ];
        "@jupyterlab/settingeditor@^0.8.1" = s."@jupyterlab/settingeditor@0.8.1";
        "@jupyterlab/shortcuts-extension@0.19.3" = f (sc "jupyterlab" "shortcuts-extension") "0.19.3" (ir "https://registry.yarnpkg.com/@jupyterlab/shortcuts-extension/-/shortcuts-extension-0.19.3.tgz") "59669b7fb7b0ec1b46a7a99ddcd858e6f700746b" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@phosphor/commands@^1.6.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
        ];
        "@jupyterlab/shortcuts-extension@^0.19.3" = s."@jupyterlab/shortcuts-extension@0.19.3";
        "@jupyterlab/tabmanager-extension@0.19.1" = f (sc "jupyterlab" "tabmanager-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/tabmanager-extension/-/tabmanager-extension-0.19.1.tgz") "3ed48f8ee59c6949196a33f13af8870f8c3bf920" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/tabmanager-extension@^0.19.1" = s."@jupyterlab/tabmanager-extension@0.19.1";
        "@jupyterlab/terminal-extension@0.19.1" = f (sc "jupyterlab" "terminal-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/terminal-extension/-/terminal-extension-0.19.1.tgz") "3932ccb5f30485045773557a8593c7ad83d1e4ff" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/launcher@^0.19.1")
          (s."@jupyterlab/mainmenu@^0.8.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@jupyterlab/terminal@^0.19.1")
        ];
        "@jupyterlab/terminal-extension@^0.19.1" = s."@jupyterlab/terminal-extension@0.19.1";
        "@jupyterlab/terminal@0.19.1" = f (sc "jupyterlab" "terminal") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/terminal/-/terminal-0.19.1.tgz") "047dbfbfe77e5a685286e83b6b03da7fefe0b7ff" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."xterm@~3.3.0")
        ];
        "@jupyterlab/terminal@^0.19.1" = s."@jupyterlab/terminal@0.19.1";
        "@jupyterlab/theme-dark-extension@0.19.1" = f (sc "jupyterlab" "theme-dark-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/theme-dark-extension/-/theme-dark-extension-0.19.1.tgz") "7575421ca7f2a36db41df8a7b48d84db01056518" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."font-awesome@~4.7.0")
        ];
        "@jupyterlab/theme-dark-extension@^0.19.1" = s."@jupyterlab/theme-dark-extension@0.19.1";
        "@jupyterlab/theme-light-extension@0.19.1" = f (sc "jupyterlab" "theme-light-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/theme-light-extension/-/theme-light-extension-0.19.1.tgz") "6e2712197116041fd385bcd1bd690053f731ddce" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."font-awesome@~4.7.0")
        ];
        "@jupyterlab/theme-light-extension@^0.19.1" = s."@jupyterlab/theme-light-extension@0.19.1";
        "@jupyterlab/toc@0.6.0" = f (sc "jupyterlab" "toc") "0.6.0" (ir ":https://registry.yarnpkg.com/@jupyterlab/toc/-/toc-0.6.0.tgz") "393fe861404fa351ece7c4e326a4ddbd2076a39d" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/cells@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/docmanager@^0.19.1")
          (s."@jupyterlab/docregistry@^0.19.1")
          (s."@jupyterlab/fileeditor@^0.19.1")
          (s."@jupyterlab/notebook@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
          (s."react-dom@~16.4.2")
        ];
        "@jupyterlab/toc@^0.6.0" = s."@jupyterlab/toc@0.6.0";
        "@jupyterlab/tooltip-extension@0.19.1" = f (sc "jupyterlab" "tooltip-extension") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/tooltip-extension/-/tooltip-extension-0.19.1.tgz") "d12d4fec5b6d75a3c0765cb1b21f72f4a79512fb" [
          (s."@jupyterlab/application@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/console@^0.19.1")
          (s."@jupyterlab/coreutils@^2.2.1")
          (s."@jupyterlab/fileeditor@^0.19.1")
          (s."@jupyterlab/notebook@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@jupyterlab/tooltip@^0.19.1")
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/tooltip-extension@^0.19.1" = s."@jupyterlab/tooltip-extension@0.19.1";
        "@jupyterlab/tooltip@0.19.1" = f (sc "jupyterlab" "tooltip") "0.19.1" (ir "https://registry.yarnpkg.com/@jupyterlab/tooltip/-/tooltip-0.19.1.tgz") "cc2ee5bf192a0d1419482ad5103d2016b758fc94" [
          (s."@jupyterlab/apputils@^0.19.1")
          (s."@jupyterlab/codeeditor@^0.19.1")
          (s."@jupyterlab/rendermime@^0.19.1")
          (s."@jupyterlab/services@^3.2.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@jupyterlab/tooltip@^0.19.1" = s."@jupyterlab/tooltip@0.19.1";
        "@jupyterlab/vdom-extension@0.18.1" = f (sc "jupyterlab" "vdom-extension") "0.18.1" (ir "https://registry.yarnpkg.com/@jupyterlab/vdom-extension/-/vdom-extension-0.18.1.tgz") "62235e11ef56cadcce2d4d8f666a579e56e9b416" [
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@nteract/transform-vdom@^1.1.1")
          (s."@phosphor/widgets@^1.6.0")
          (s."react@~16.4.2")
          (s."react-dom@~16.4.2")
        ];
        "@jupyterlab/vdom-extension@^0.18.1" = s."@jupyterlab/vdom-extension@0.18.1";
        "@jupyterlab/vega4-extension@0.18.1" = f (sc "jupyterlab" "vega4-extension") "0.18.1" (ir "https://registry.yarnpkg.com/@jupyterlab/vega4-extension/-/vega4-extension-0.18.1.tgz") "b21bd84ac2c302c4021229cc33725bbf5a0aee09" [
          (s."@jupyterlab/rendermime-interfaces@^1.2.1")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/widgets@^1.6.0")
          (s."vega-embed@3.18.2")
        ];
        "@jupyterlab/vega4-extension@^0.18.1" = s."@jupyterlab/vega4-extension@0.18.1";
        "@nteract/transform-vdom@1.1.1" = f (sc "nteract" "transform-vdom") "1.1.1" (ir "https://registry.yarnpkg.com/@nteract/transform-vdom/-/transform-vdom-1.1.1.tgz") "49258c58a3704c89b20cc42b5be463d7802406fa" [];
        "@nteract/transform-vdom@^1.1.1" = s."@nteract/transform-vdom@1.1.1";
        "@phosphor/algorithm@1.1.2" = f (sc "phosphor" "algorithm") "1.1.2" (ir "https://registry.yarnpkg.com/@phosphor/algorithm/-/algorithm-1.1.2.tgz") "fd1de9104c9a7f34e92864586ddf2e7f2e7779e8" [];
        "@phosphor/algorithm@^1.1.2" = s."@phosphor/algorithm@1.1.2";
        "@phosphor/application@1.6.0" = f (sc "phosphor" "application") "1.6.0" (ir "https://registry.yarnpkg.com/@phosphor/application/-/application-1.6.0.tgz") "e1f1bf300680f982881d222a77b24ba8589d3fa2" [
          (s."@phosphor/commands@^1.5.0")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@phosphor/application@^1.6.0" = s."@phosphor/application@1.6.0";
        "@phosphor/collections@1.1.2" = f (sc "phosphor" "collections") "1.1.2" (ir "https://registry.yarnpkg.com/@phosphor/collections/-/collections-1.1.2.tgz") "c4c0b8b91129905fb36a9f243f2dbbde462dab8d" [
          (s."@phosphor/algorithm@^1.1.2")
        ];
        "@phosphor/collections@^1.1.2" = s."@phosphor/collections@1.1.2";
        "@phosphor/commands@1.6.1" = f (sc "phosphor" "commands") "1.6.1" (ir "https://registry.yarnpkg.com/@phosphor/commands/-/commands-1.6.1.tgz") "6f60c2a3b759316cd1363b426df3b4036bb2c7fd" [
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/domutils@^1.1.2")
          (s."@phosphor/keyboard@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
        ];
        "@phosphor/commands@^1.5.0" = s."@phosphor/commands@1.6.1";
        "@phosphor/commands@^1.6.1" = s."@phosphor/commands@1.6.1";
        "@phosphor/coreutils@1.3.0" = f (sc "phosphor" "coreutils") "1.3.0" (ir "https://registry.yarnpkg.com/@phosphor/coreutils/-/coreutils-1.3.0.tgz") "63292d381c012c5ab0d0196e83ced829b7e04a42" [];
        "@phosphor/coreutils@^1.3.0" = s."@phosphor/coreutils@1.3.0";
        "@phosphor/datagrid@0.1.6" = f (sc "phosphor" "datagrid") "0.1.6" (ir "https://registry.yarnpkg.com/@phosphor/datagrid/-/datagrid-0.1.6.tgz") "c5f6d423c2899b22c137b60f07c9054bbce59004" [
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/domutils@^1.1.2")
          (s."@phosphor/dragdrop@^1.3.0")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/widgets@^1.6.0")
        ];
        "@phosphor/datagrid@^0.1.6" = s."@phosphor/datagrid@0.1.6";
        "@phosphor/disposable@1.1.2" = f (sc "phosphor" "disposable") "1.1.2" (ir "https://registry.yarnpkg.com/@phosphor/disposable/-/disposable-1.1.2.tgz") "a192dd6a2e6c69d5d09d39ecf334dab93778060e" [
          (s."@phosphor/algorithm@^1.1.2")
        ];
        "@phosphor/disposable@^1.1.2" = s."@phosphor/disposable@1.1.2";
        "@phosphor/domutils@1.1.2" = f (sc "phosphor" "domutils") "1.1.2" (ir "https://registry.yarnpkg.com/@phosphor/domutils/-/domutils-1.1.2.tgz") "e2efeb052f398c42b93b89e9bab26af15cc00514" [];
        "@phosphor/domutils@^1.1.2" = s."@phosphor/domutils@1.1.2";
        "@phosphor/dragdrop@1.3.0" = f (sc "phosphor" "dragdrop") "1.3.0" (ir "https://registry.yarnpkg.com/@phosphor/dragdrop/-/dragdrop-1.3.0.tgz") "7ce6ad39d6ca216d62a56f78104d02a77ae67307" [
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
        ];
        "@phosphor/dragdrop@^1.3.0" = s."@phosphor/dragdrop@1.3.0";
        "@phosphor/keyboard@1.1.2" = f (sc "phosphor" "keyboard") "1.1.2" (ir "https://registry.yarnpkg.com/@phosphor/keyboard/-/keyboard-1.1.2.tgz") "3e32234451764240a98e148034d5a8797422dd1f" [];
        "@phosphor/keyboard@^1.1.2" = s."@phosphor/keyboard@1.1.2";
        "@phosphor/messaging@1.2.2" = f (sc "phosphor" "messaging") "1.2.2" (ir "https://registry.yarnpkg.com/@phosphor/messaging/-/messaging-1.2.2.tgz") "7d896ddd3797b94a347708ded13da5783db75c14" [
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/collections@^1.1.2")
        ];
        "@phosphor/messaging@^1.2.2" = s."@phosphor/messaging@1.2.2";
        "@phosphor/properties@1.1.2" = f (sc "phosphor" "properties") "1.1.2" (ir "https://registry.yarnpkg.com/@phosphor/properties/-/properties-1.1.2.tgz") "78cc77eff452839da02255de48e814946cc09a28" [];
        "@phosphor/properties@^1.1.2" = s."@phosphor/properties@1.1.2";
        "@phosphor/signaling@1.2.2" = f (sc "phosphor" "signaling") "1.2.2" (ir "https://registry.yarnpkg.com/@phosphor/signaling/-/signaling-1.2.2.tgz") "3fcf97ca88e38bfb357fe8fe6bf7513347a514a9" [
          (s."@phosphor/algorithm@^1.1.2")
        ];
        "@phosphor/signaling@^1.2.2" = s."@phosphor/signaling@1.2.2";
        "@phosphor/virtualdom@1.1.2" = f (sc "phosphor" "virtualdom") "1.1.2" (ir "https://registry.yarnpkg.com/@phosphor/virtualdom/-/virtualdom-1.1.2.tgz") "ce55c86eef31e5d0e26b1dc96ea32bd684458f41" [
          (s."@phosphor/algorithm@^1.1.2")
        ];
        "@phosphor/virtualdom@^1.1.2" = s."@phosphor/virtualdom@1.1.2";
        "@phosphor/widgets@1.6.0" = f (sc "phosphor" "widgets") "1.6.0" (ir "https://registry.yarnpkg.com/@phosphor/widgets/-/widgets-1.6.0.tgz") "ebba8008b6b13247d03e73e5f3872c90d2c9c78f" [
          (s."@phosphor/algorithm@^1.1.2")
          (s."@phosphor/commands@^1.5.0")
          (s."@phosphor/coreutils@^1.3.0")
          (s."@phosphor/disposable@^1.1.2")
          (s."@phosphor/domutils@^1.1.2")
          (s."@phosphor/dragdrop@^1.3.0")
          (s."@phosphor/keyboard@^1.1.2")
          (s."@phosphor/messaging@^1.2.2")
          (s."@phosphor/properties@^1.1.2")
          (s."@phosphor/signaling@^1.2.2")
          (s."@phosphor/virtualdom@^1.1.2")
        ];
        "@phosphor/widgets@^1.6.0" = s."@phosphor/widgets@1.6.0";
        "@sindresorhus/is@0.7.0" = f (sc "sindresorhus" "is") "0.7.0" (ir "https://registry.yarnpkg.com/@sindresorhus/is/-/is-0.7.0.tgz") "9a06f4f137ee84d7df0460c1fdb1135ffa6c50fd" [];
        "@sindresorhus/is@^0.7.0" = s."@sindresorhus/is@0.7.0";
        "@types/json-stable-stringify@1.0.32" = f (sc "types" "json-stable-stringify") "1.0.32" (ir "https://registry.yarnpkg.com/@types/json-stable-stringify/-/json-stable-stringify-1.0.32.tgz") "121f6917c4389db3923640b2e68de5fa64dda88e" [];
        "@types/json-stable-stringify@^1.0.32" = s."@types/json-stable-stringify@1.0.32";
        "@types/prop-types@*" = s."@types/prop-types@15.5.8";
        "@types/prop-types@15.5.8" = f (sc "types" "prop-types") "15.5.8" (ir "https://registry.yarnpkg.com/@types/prop-types/-/prop-types-15.5.8.tgz") "8ae4e0ea205fe95c3901a5a1df7f66495e3a56ce" [];
        "@types/react@16.4.18" = f (sc "types" "react") "16.4.18" (ir "https://registry.yarnpkg.com/@types/react/-/react-16.4.18.tgz") "2e28a2e7f92d3fa7d6a65f2b73275c3e3138a13d" [
          (s."@types/prop-types@*")
          (s."csstype@^2.2.0")
        ];
        "@types/react@~16.4.13" = s."@types/react@16.4.18";
        "@webassemblyjs/ast@1.5.12" = f (sc "webassemblyjs" "ast") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.5.12.tgz") "a9acbcb3f25333c4edfa1fdf3186b1ccf64e6664" [
          (s."@webassemblyjs/helper-module-context@1.5.12")
          (s."@webassemblyjs/helper-wasm-bytecode@1.5.12")
          (s."@webassemblyjs/wast-parser@1.5.12")
          (s."debug@^3.1.0")
          (s."mamacro@^0.0.3")
        ];
        "@webassemblyjs/floating-point-hex-parser@1.5.12" = f (sc "webassemblyjs" "floating-point-hex-parser") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.5.12.tgz") "0f36044ffe9652468ce7ae5a08716a4eeff9cd9c" [];
        "@webassemblyjs/helper-api-error@1.5.12" = f (sc "webassemblyjs" "helper-api-error") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.5.12.tgz") "05466833ff2f9d8953a1a327746e1d112ea62aaf" [];
        "@webassemblyjs/helper-buffer@1.5.12" = f (sc "webassemblyjs" "helper-buffer") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.5.12.tgz") "1f0de5aaabefef89aec314f7f970009cd159c73d" [
          (s."debug@^3.1.0")
        ];
        "@webassemblyjs/helper-code-frame@1.5.12" = f (sc "webassemblyjs" "helper-code-frame") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/helper-code-frame/-/helper-code-frame-1.5.12.tgz") "3cdc1953093760d1c0f0caf745ccd62bdb6627c7" [
          (s."@webassemblyjs/wast-printer@1.5.12")
        ];
        "@webassemblyjs/helper-fsm@1.5.12" = f (sc "webassemblyjs" "helper-fsm") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/helper-fsm/-/helper-fsm-1.5.12.tgz") "6bc1442b037f8e30f2e57b987cee5c806dd15027" [];
        "@webassemblyjs/helper-module-context@1.5.12" = f (sc "webassemblyjs" "helper-module-context") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/helper-module-context/-/helper-module-context-1.5.12.tgz") "b5588ca78b33b8a0da75f9ab8c769a3707baa861" [
          (s."debug@^3.1.0")
          (s."mamacro@^0.0.3")
        ];
        "@webassemblyjs/helper-wasm-bytecode@1.5.12" = f (sc "webassemblyjs" "helper-wasm-bytecode") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.5.12.tgz") "d12a3859db882a448891a866a05d0be63785b616" [];
        "@webassemblyjs/helper-wasm-section@1.5.12" = f (sc "webassemblyjs" "helper-wasm-section") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.5.12.tgz") "ff9fe1507d368ad437e7969d25e8c1693dac1884" [
          (s."@webassemblyjs/ast@1.5.12")
          (s."@webassemblyjs/helper-buffer@1.5.12")
          (s."@webassemblyjs/helper-wasm-bytecode@1.5.12")
          (s."@webassemblyjs/wasm-gen@1.5.12")
          (s."debug@^3.1.0")
        ];
        "@webassemblyjs/ieee754@1.5.12" = f (sc "webassemblyjs" "ieee754") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.5.12.tgz") "ee9574bc558888f13097ce3e7900dff234ea19a4" [
          (s."ieee754@^1.1.11")
        ];
        "@webassemblyjs/leb128@1.5.12" = f (sc "webassemblyjs" "leb128") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.5.12.tgz") "0308eec652765ee567d8a5fa108b4f0b25b458e1" [
          (s."leb@^0.3.0")
        ];
        "@webassemblyjs/utf8@1.5.12" = f (sc "webassemblyjs" "utf8") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.5.12.tgz") "d5916222ef314bf60d6806ed5ac045989bfd92ce" [];
        "@webassemblyjs/wasm-edit@1.5.12" = f (sc "webassemblyjs" "wasm-edit") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.5.12.tgz") "821c9358e644a166f2c910e5af1b46ce795a17aa" [
          (s."@webassemblyjs/ast@1.5.12")
          (s."@webassemblyjs/helper-buffer@1.5.12")
          (s."@webassemblyjs/helper-wasm-bytecode@1.5.12")
          (s."@webassemblyjs/helper-wasm-section@1.5.12")
          (s."@webassemblyjs/wasm-gen@1.5.12")
          (s."@webassemblyjs/wasm-opt@1.5.12")
          (s."@webassemblyjs/wasm-parser@1.5.12")
          (s."@webassemblyjs/wast-printer@1.5.12")
          (s."debug@^3.1.0")
        ];
        "@webassemblyjs/wasm-gen@1.5.12" = f (sc "webassemblyjs" "wasm-gen") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.5.12.tgz") "0b7ccfdb93dab902cc0251014e2e18bae3139bcb" [
          (s."@webassemblyjs/ast@1.5.12")
          (s."@webassemblyjs/helper-wasm-bytecode@1.5.12")
          (s."@webassemblyjs/ieee754@1.5.12")
          (s."@webassemblyjs/leb128@1.5.12")
          (s."@webassemblyjs/utf8@1.5.12")
        ];
        "@webassemblyjs/wasm-opt@1.5.12" = f (sc "webassemblyjs" "wasm-opt") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.5.12.tgz") "bd758a8bc670f585ff1ae85f84095a9e0229cbc9" [
          (s."@webassemblyjs/ast@1.5.12")
          (s."@webassemblyjs/helper-buffer@1.5.12")
          (s."@webassemblyjs/wasm-gen@1.5.12")
          (s."@webassemblyjs/wasm-parser@1.5.12")
          (s."debug@^3.1.0")
        ];
        "@webassemblyjs/wasm-parser@1.5.12" = f (sc "webassemblyjs" "wasm-parser") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.5.12.tgz") "7b10b4388ecf98bd7a22e702aa62ec2f46d0c75e" [
          (s."@webassemblyjs/ast@1.5.12")
          (s."@webassemblyjs/helper-api-error@1.5.12")
          (s."@webassemblyjs/helper-wasm-bytecode@1.5.12")
          (s."@webassemblyjs/ieee754@1.5.12")
          (s."@webassemblyjs/leb128@1.5.12")
          (s."@webassemblyjs/utf8@1.5.12")
        ];
        "@webassemblyjs/wast-parser@1.5.12" = f (sc "webassemblyjs" "wast-parser") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/wast-parser/-/wast-parser-1.5.12.tgz") "9cf5ae600ecae0640437b5d4de5dd6b6088d0d8b" [
          (s."@webassemblyjs/floating-point-hex-parser@1.5.12")
          (s."@webassemblyjs/helper-api-error@1.5.12")
          (s."@webassemblyjs/helper-code-frame@1.5.12")
          (s."@webassemblyjs/helper-fsm@1.5.12")
          (s."long@^3.2.0")
          (s."mamacro@^0.0.3")
        ];
        "@webassemblyjs/wast-printer@1.5.12" = f (sc "webassemblyjs" "wast-printer") "1.5.12" (ir "https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.5.12.tgz") "563ca4d01b22d21640b2463dc5e3d7f7d9dac520" [
          (s."long@^3.2.0")
        ];
        "abbrev@1" = s."abbrev@1.1.1";
        "abbrev@1.1.1" = f "abbrev" "1.1.1" y "f8f2c887ad10bf67f634f005b6987fed3179aac8" [];
        "acorn-dynamic-import@3.0.0" = f "acorn-dynamic-import" "3.0.0" y "901ceee4c7faaef7e07ad2a47e890675da50a278" [
          (s."acorn@^5.0.0")
        ];
        "acorn-dynamic-import@^3.0.0" = s."acorn-dynamic-import@3.0.0";
        "acorn@5.7.3" = f "acorn" "5.7.3" y "67aa231bf8812974b85235a96771eb6bd07ea279" [];
        "acorn@^5.0.0" = s."acorn@5.7.3";
        "acorn@^5.6.2" = s."acorn@5.7.3";
        "ajv-keywords@3.2.0" = f "ajv-keywords" "3.2.0" y "e86b819c602cf8821ad637413698f1dec021847a" [];
        "ajv-keywords@^3.1.0" = s."ajv-keywords@3.2.0";
        "ajv@5.1.6" = f "ajv" "5.1.6" y "4b2f1a19dece93d57ac216037e3e9791c7dd1564" [
          (s."co@^4.6.0")
          (s."json-schema-traverse@^0.3.0")
          (s."json-stable-stringify@^1.0.1")
        ];
        "ajv@6.6.1" = f "ajv" "6.6.1" y "6360f5ed0d80f232cc2b294c362d5dc2e538dd61" [
          (s."fast-deep-equal@^2.0.1")
          (s."fast-json-stable-stringify@^2.0.0")
          (s."json-schema-traverse@^0.4.1")
          (s."uri-js@^4.2.2")
        ];
        "ajv@^6.1.0" = s."ajv@6.6.1";
        "ajv@~5.1.6" = s."ajv@5.1.6";
        "alphanum-sort@1.0.2" = f "alphanum-sort" "1.0.2" y "97a1119649b211ad33691d9f9f486a8ec9fbe0a3" [];
        "alphanum-sort@^1.0.1" = s."alphanum-sort@1.0.2";
        "alphanum-sort@^1.0.2" = s."alphanum-sort@1.0.2";
        "ansi-escapes@3.1.0" = f "ansi-escapes" "3.1.0" (ir "http://registry.npmjs.org/ansi-escapes/-/ansi-escapes-3.1.0.tgz") "f73207bb81207d75fd6c83f125af26eea378ca30" [];
        "ansi-escapes@^3.0.0" = s."ansi-escapes@3.1.0";
        "ansi-regex@2.1.1" = f "ansi-regex" "2.1.1" y "c3b33ab5ee360d86e0e628f0468ae7ef27d654df" [];
        "ansi-regex@3.0.0" = f "ansi-regex" "3.0.0" y "ed0317c322064f79466c02966bddb605ab37d998" [];
        "ansi-regex@^2.0.0" = s."ansi-regex@2.1.1";
        "ansi-regex@^3.0.0" = s."ansi-regex@3.0.0";
        "ansi-styles@2.2.1" = f "ansi-styles" "2.2.1" y "b432dd3358b634cf75e1e4664368240533c1ddbe" [];
        "ansi-styles@3.2.1" = f "ansi-styles" "3.2.1" y "41fbb20243e50b12be0f04b8dedbf07520ce841d" [
          (s."color-convert@^1.9.0")
        ];
        "ansi-styles@^2.2.1" = s."ansi-styles@2.2.1";
        "ansi-styles@^3.2.1" = s."ansi-styles@3.2.1";
        "ansi_up@3.0.0" = f "ansi_up" "3.0.0" y "27f45d8f457d9ceff59e4ea03c8e6f13c1a303e8" [];
        "ansi_up@^3.0.0" = s."ansi_up@3.0.0";
        "anymatch@2.0.0" = f "anymatch" "2.0.0" y "bcb24b4f37934d9aa7ac17b4adaf89e7c76ef2eb" [
          (s."micromatch@^3.1.4")
          (s."normalize-path@^2.1.1")
        ];
        "anymatch@^2.0.0" = s."anymatch@2.0.0";
        "aproba@1.2.0" = f "aproba" "1.2.0" y "6802e6264efd18c790a1b0d517f0f2627bf2c94a" [];
        "aproba@^1.0.3" = s."aproba@1.2.0";
        "aproba@^1.1.1" = s."aproba@1.2.0";
        "are-we-there-yet@1.1.5" = f "are-we-there-yet" "1.1.5" y "4b35c2944f062a8bfcda66410760350fe9ddfc21" [
          (s."delegates@^1.0.0")
          (s."readable-stream@^2.0.6")
        ];
        "are-we-there-yet@~1.1.2" = s."are-we-there-yet@1.1.5";
        "argparse@1.0.10" = f "argparse" "1.0.10" y "bcd6791ea5ae09725e17e5ad988134cd40b3d911" [
          (s."sprintf-js@~1.0.2")
        ];
        "argparse@^1.0.7" = s."argparse@1.0.10";
        "arr-diff@4.0.0" = f "arr-diff" "4.0.0" y "d6461074febfec71e7e15235761a329a5dc7c520" [];
        "arr-diff@^4.0.0" = s."arr-diff@4.0.0";
        "arr-flatten@1.1.0" = f "arr-flatten" "1.1.0" y "36048bbff4e7b47e136644316c99669ea5ae91f1" [];
        "arr-flatten@^1.1.0" = s."arr-flatten@1.1.0";
        "arr-union@3.1.0" = f "arr-union" "3.1.0" y "e39b09aea9def866a8f206e288af63919bae39c4" [];
        "arr-union@^3.1.0" = s."arr-union@3.1.0";
        "array-uniq@1.0.3" = f "array-uniq" "1.0.3" y "af6ac877a25cc7f74e058894753858dfdb24fdb6" [];
        "array-uniq@^1.0.2" = s."array-uniq@1.0.3";
        "array-unique@0.3.2" = f "array-unique" "0.3.2" y "a894b75d4bc4f6cd679ef3244a9fd8f46ae2d428" [];
        "array-unique@^0.3.2" = s."array-unique@0.3.2";
        "asap@2.0.6" = f "asap" "2.0.6" y "e50347611d7e690943208bbdafebcbc2fb866d46" [];
        "asap@~2.0.3" = s."asap@2.0.6";
        "asn1.js@4.10.1" = f "asn1.js" "4.10.1" y "b9c2bf5805f1e64aadeed6df3a2bfafb5a73f5a0" [
          (s."bn.js@^4.0.0")
          (s."inherits@^2.0.1")
          (s."minimalistic-assert@^1.0.0")
        ];
        "asn1.js@^4.0.0" = s."asn1.js@4.10.1";
        "assert@1.4.1" = f "assert" "1.4.1" y "99912d591836b5a6f5b345c0f07eefc08fc65d91" [
          (s."util@0.10.3")
        ];
        "assert@^1.1.1" = s."assert@1.4.1";
        "assign-symbols@1.0.0" = f "assign-symbols" "1.0.0" y "59667f41fadd4f20ccbc2bb96b8d4f7f78ec0367" [];
        "assign-symbols@^1.0.0" = s."assign-symbols@1.0.0";
        "ast-types@0.9.6" = f "ast-types" "0.9.6" y "102c9e9e9005d3e7e3829bf0c4fa24ee862ee9b9" [];
        "async-each@1.0.1" = f "async-each" "1.0.1" y "19d386a1d9edc6e7c1c85d388aedbcc56d33602d" [];
        "async-each@^1.0.0" = s."async-each@1.0.1";
        "async@2.6.1" = f "async" "2.6.1" y "b245a23ca71930044ec53fa46aa00a3e87c6a610" [
          (s."lodash@^4.17.10")
        ];
        "async@^2.5.0" = s."async@2.6.1";
        "atob@2.1.2" = f "atob" "2.1.2" y "6d9517eb9e030d2436666651e86bd9f6f13533c9" [];
        "atob@^2.1.1" = s."atob@2.1.2";
        "autoprefixer@6.7.7" = f "autoprefixer" "6.7.7" y "1dbd1c835658e35ce3f9984099db00585c782014" [
          (s."browserslist@^1.7.6")
          (s."caniuse-db@^1.0.30000634")
          (s."normalize-range@^0.1.2")
          (s."num2fraction@^1.2.2")
          (s."postcss@^5.2.16")
          (s."postcss-value-parser@^3.2.3")
        ];
        "autoprefixer@^6.3.1" = s."autoprefixer@6.7.7";
        "babel-code-frame@6.26.0" = f "babel-code-frame" "6.26.0" y "63fd43f7dc1e3bb7ce35947db8fe369a3f58c74b" [
          (s."chalk@^1.1.3")
          (s."esutils@^2.0.2")
          (s."js-tokens@^3.0.2")
        ];
        "babel-code-frame@^6.26.0" = s."babel-code-frame@6.26.0";
        "babel-runtime@6.26.0" = f "babel-runtime" "6.26.0" y "965c7058668e82b55d7bfe04ff2337bc8b5647fe" [
          (s."core-js@^2.4.0")
          (s."regenerator-runtime@^0.11.0")
        ];
        "babel-runtime@^6.6.1" = s."babel-runtime@6.26.0";
        "balanced-match@0.4.2" = f "balanced-match" "0.4.2" y "cb3f3e3c732dc0f01ee70b403f302e61d7709838" [];
        "balanced-match@1.0.0" = f "balanced-match" "1.0.0" y "89b4d199ab2bee49de164ea02b89ce462d71b767" [];
        "balanced-match@^0.4.2" = s."balanced-match@0.4.2";
        "balanced-match@^1.0.0" = s."balanced-match@1.0.0";
        "base16@1.0.0" = f "base16" "1.0.0" y "e297f60d7ec1014a7a971a39ebc8a98c0b681e70" [];
        "base16@^1.0.0" = s."base16@1.0.0";
        "base64-js@1.3.0" = f "base64-js" "1.3.0" y "cab1e6118f051095e58b5281aea8c1cd22bfc0e3" [];
        "base64-js@^1.0.2" = s."base64-js@1.3.0";
        "base@0.11.2" = f "base" "0.11.2" y "7bde5ced145b6d551a90db87f83c558b4eb48a8f" [
          (s."cache-base@^1.0.1")
          (s."class-utils@^0.3.5")
          (s."component-emitter@^1.2.1")
          (s."define-property@^1.0.0")
          (s."isobject@^3.0.1")
          (s."mixin-deep@^1.2.0")
          (s."pascalcase@^0.1.1")
        ];
        "base@^0.11.1" = s."base@0.11.2";
        "big.js@3.2.0" = f "big.js" "3.2.0" y "a5fc298b81b9e0dca2e458824784b65c52ba588e" [];
        "big.js@^3.1.3" = s."big.js@3.2.0";
        "binary-extensions@1.12.0" = f "binary-extensions" "1.12.0" y "c2d780f53d45bba8317a8902d4ceeaf3a6385b14" [];
        "binary-extensions@^1.0.0" = s."binary-extensions@1.12.0";
        "blacklist@1.1.4" = f "blacklist" "1.1.4" y "b2dd09d6177625b2caa69835a37b28995fa9a2f2" [];
        "blacklist@^1.1.4" = s."blacklist@1.1.4";
        "bluebird@3.5.3" = f "bluebird" "3.5.3" y "7d01c6f9616c9a51ab0f8c549a79dfe6ec33efa7" [];
        "bluebird@^3.5.1" = s."bluebird@3.5.3";
        "bn.js@4.11.8" = f "bn.js" "4.11.8" y "2cde09eb5ee341f484746bb0309b3253b1b1442f" [];
        "bn.js@^4.0.0" = s."bn.js@4.11.8";
        "bn.js@^4.1.0" = s."bn.js@4.11.8";
        "bn.js@^4.1.1" = s."bn.js@4.11.8";
        "bn.js@^4.4.0" = s."bn.js@4.11.8";
        "boolbase@1.0.0" = f "boolbase" "1.0.0" y "68dff5fbe60c51eb37725ea9e3ed310dcc1e776e" [];
        "boolbase@~1.0.0" = s."boolbase@1.0.0";
        "brace-expansion@1.1.11" = f "brace-expansion" "1.1.11" y "3c7fcbf529d87226f3d2f52b966ff5271eb441dd" [
          (s."balanced-match@^1.0.0")
          (s."concat-map@0.0.1")
        ];
        "brace-expansion@^1.1.7" = s."brace-expansion@1.1.11";
        "braces@2.3.2" = f "braces" "2.3.2" y "5979fd3f14cd531565e5fa2df1abfff1dfaee729" [
          (s."arr-flatten@^1.1.0")
          (s."array-unique@^0.3.2")
          (s."extend-shallow@^2.0.1")
          (s."fill-range@^4.0.0")
          (s."isobject@^3.0.1")
          (s."repeat-element@^1.1.2")
          (s."snapdragon@^0.8.1")
          (s."snapdragon-node@^2.0.1")
          (s."split-string@^3.0.2")
          (s."to-regex@^3.0.1")
        ];
        "braces@^2.3.0" = s."braces@2.3.2";
        "braces@^2.3.1" = s."braces@2.3.2";
        "brorand@1.1.0" = f "brorand" "1.1.0" y "12c25efe40a45e3c323eb8675a0a0ce57b22371f" [];
        "brorand@^1.0.1" = s."brorand@1.1.0";
        "browserify-aes@1.2.0" = f "browserify-aes" "1.2.0" (ir "http://registry.npmjs.org/browserify-aes/-/browserify-aes-1.2.0.tgz") "326734642f403dabc3003209853bb70ad428ef48" [
          (s."buffer-xor@^1.0.3")
          (s."cipher-base@^1.0.0")
          (s."create-hash@^1.1.0")
          (s."evp_bytestokey@^1.0.3")
          (s."inherits@^2.0.1")
          (s."safe-buffer@^5.0.1")
        ];
        "browserify-aes@^1.0.0" = s."browserify-aes@1.2.0";
        "browserify-aes@^1.0.4" = s."browserify-aes@1.2.0";
        "browserify-cipher@1.0.1" = f "browserify-cipher" "1.0.1" y "8d6474c1b870bfdabcd3bcfcc1934a10e94f15f0" [
          (s."browserify-aes@^1.0.4")
          (s."browserify-des@^1.0.0")
          (s."evp_bytestokey@^1.0.0")
        ];
        "browserify-cipher@^1.0.0" = s."browserify-cipher@1.0.1";
        "browserify-des@1.0.2" = f "browserify-des" "1.0.2" y "3af4f1f59839403572f1c66204375f7a7f703e9c" [
          (s."cipher-base@^1.0.1")
          (s."des.js@^1.0.0")
          (s."inherits@^2.0.1")
          (s."safe-buffer@^5.1.2")
        ];
        "browserify-des@^1.0.0" = s."browserify-des@1.0.2";
        "browserify-rsa@4.0.1" = f "browserify-rsa" "4.0.1" (ir "http://registry.npmjs.org/browserify-rsa/-/browserify-rsa-4.0.1.tgz") "21e0abfaf6f2029cf2fafb133567a701d4135524" [
          (s."bn.js@^4.1.0")
          (s."randombytes@^2.0.1")
        ];
        "browserify-rsa@^4.0.0" = s."browserify-rsa@4.0.1";
        "browserify-sign@4.0.4" = f "browserify-sign" "4.0.4" y "aa4eb68e5d7b658baa6bf6a57e630cbd7a93d298" [
          (s."bn.js@^4.1.1")
          (s."browserify-rsa@^4.0.0")
          (s."create-hash@^1.1.0")
          (s."create-hmac@^1.1.2")
          (s."elliptic@^6.0.0")
          (s."inherits@^2.0.1")
          (s."parse-asn1@^5.0.0")
        ];
        "browserify-sign@^4.0.0" = s."browserify-sign@4.0.4";
        "browserify-zlib@0.2.0" = f "browserify-zlib" "0.2.0" y "2869459d9aa3be245fe8fe2ca1f46e2e7f54d73f" [
          (s."pako@~1.0.5")
        ];
        "browserify-zlib@^0.2.0" = s."browserify-zlib@0.2.0";
        "browserslist@1.7.7" = f "browserslist" "1.7.7" y "0bd76704258be829b2398bb50e4b62d1a166b0b9" [
          (s."caniuse-db@^1.0.30000639")
          (s."electron-to-chromium@^1.2.7")
        ];
        "browserslist@^1.3.6" = s."browserslist@1.7.7";
        "browserslist@^1.5.2" = s."browserslist@1.7.7";
        "browserslist@^1.7.6" = s."browserslist@1.7.7";
        "buffer-from@1.1.1" = f "buffer-from" "1.1.1" y "32713bc028f75c02fdb710d7c7bcec1f2c6070ef" [];
        "buffer-from@^1.0.0" = s."buffer-from@1.1.1";
        "buffer-xor@1.0.3" = f "buffer-xor" "1.0.3" y "26e61ed1422fb70dd42e6e36729ed51d855fe8d9" [];
        "buffer-xor@^1.0.3" = s."buffer-xor@1.0.3";
        "buffer@4.9.1" = f "buffer" "4.9.1" (ir "http://registry.npmjs.org/buffer/-/buffer-4.9.1.tgz") "6d1bb601b07a4efced97094132093027c95bc298" [
          (s."base64-js@^1.0.2")
          (s."ieee754@^1.1.4")
          (s."isarray@^1.0.0")
        ];
        "buffer@^4.3.0" = s."buffer@4.9.1";
        "builtin-status-codes@3.0.0" = f "builtin-status-codes" "3.0.0" y "85982878e21b98e1c66425e03d0174788f569ee8" [];
        "builtin-status-codes@^3.0.0" = s."builtin-status-codes@3.0.0";
        "cacache@10.0.4" = f "cacache" "10.0.4" (ir "http://registry.npmjs.org/cacache/-/cacache-10.0.4.tgz") "6452367999eff9d4188aefd9a14e9d7c6a263460" [
          (s."bluebird@^3.5.1")
          (s."chownr@^1.0.1")
          (s."glob@^7.1.2")
          (s."graceful-fs@^4.1.11")
          (s."lru-cache@^4.1.1")
          (s."mississippi@^2.0.0")
          (s."mkdirp@^0.5.1")
          (s."move-concurrently@^1.0.1")
          (s."promise-inflight@^1.0.1")
          (s."rimraf@^2.6.2")
          (s."ssri@^5.2.4")
          (s."unique-filename@^1.1.0")
          (s."y18n@^4.0.0")
        ];
        "cacache@^10.0.4" = s."cacache@10.0.4";
        "cache-base@1.0.1" = f "cache-base" "1.0.1" y "0a7f46416831c8b662ee36fe4e7c59d76f666ab2" [
          (s."collection-visit@^1.0.0")
          (s."component-emitter@^1.2.1")
          (s."get-value@^2.0.6")
          (s."has-value@^1.0.0")
          (s."isobject@^3.0.1")
          (s."set-value@^2.0.0")
          (s."to-object-path@^0.3.0")
          (s."union-value@^1.0.0")
          (s."unset-value@^1.0.0")
        ];
        "cache-base@^1.0.1" = s."cache-base@1.0.1";
        "cacheable-request@2.1.4" = f "cacheable-request" "2.1.4" y "0d808801b6342ad33c91df9d0b44dc09b91e5c3d" [
          (s."clone-response@1.0.2")
          (s."get-stream@3.0.0")
          (s."http-cache-semantics@3.8.1")
          (s."keyv@3.0.0")
          (s."lowercase-keys@1.0.0")
          (s."normalize-url@2.0.1")
          (s."responselike@1.0.2")
        ];
        "cacheable-request@^2.1.1" = s."cacheable-request@2.1.4";
        "camel-case@3.0.0" = f "camel-case" "3.0.0" y "ca3c3688a4e9cf3a4cda777dc4dcbc713249cf73" [
          (s."no-case@^2.2.0")
          (s."upper-case@^1.1.1")
        ];
        "camel-case@3.0.x" = s."camel-case@3.0.0";
        "camelcase@4.1.0" = f "camelcase" "4.1.0" y "d545635be1e33c542649c69173e5de6acfae34dd" [];
        "camelcase@5.0.0" = f "camelcase" "5.0.0" y "03295527d58bd3cd4aa75363f35b2e8d97be2f42" [];
        "camelcase@^4.1.0" = s."camelcase@4.1.0";
        "camelcase@^5.0.0" = s."camelcase@5.0.0";
        "caniuse-api@1.6.1" = f "caniuse-api" "1.6.1" y "b534e7c734c4f81ec5fbe8aca2ad24354b962c6c" [
          (s."browserslist@^1.3.6")
          (s."caniuse-db@^1.0.30000529")
          (s."lodash.memoize@^4.1.2")
          (s."lodash.uniq@^4.5.0")
        ];
        "caniuse-api@^1.5.2" = s."caniuse-api@1.6.1";
        "caniuse-db@1.0.30000921" = f "caniuse-db" "1.0.30000921" y "2aa78193e23539634abcf0248919d5901506c53b" [];
        "caniuse-db@^1.0.30000529" = s."caniuse-db@1.0.30000921";
        "caniuse-db@^1.0.30000634" = s."caniuse-db@1.0.30000921";
        "caniuse-db@^1.0.30000639" = s."caniuse-db@1.0.30000921";
        "chalk@1.1.3" = f "chalk" "1.1.3" (ir "http://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz") "a8115c55e4a702fe4d150abd3872822a7e09fc98" [
          (s."ansi-styles@^2.2.1")
          (s."escape-string-regexp@^1.0.2")
          (s."has-ansi@^2.0.0")
          (s."strip-ansi@^3.0.0")
          (s."supports-color@^2.0.0")
        ];
        "chalk@2.4.1" = f "chalk" "2.4.1" y "18c49ab16a037b6eb0152cc83e3471338215b66e" [
          (s."ansi-styles@^3.2.1")
          (s."escape-string-regexp@^1.0.5")
          (s."supports-color@^5.3.0")
        ];
        "chalk@^1.1.3" = s."chalk@1.1.3";
        "chalk@^2.0.0" = s."chalk@2.4.1";
        "chalk@^2.3.0" = s."chalk@2.4.1";
        "chalk@^2.4.1" = s."chalk@2.4.1";
        "chardet@0.4.2" = f "chardet" "0.4.2" y "b5473b33dc97c424e5d98dc87d55d4d8a29c8bf2" [];
        "chardet@^0.4.0" = s."chardet@0.4.2";
        "child_process@1.0.2" = f "child_process" "1.0.2" y "b1f7e7fc73d25e7fd1d455adc94e143830182b5a" [];
        "child_process@~1.0.2" = s."child_process@1.0.2";
        "chokidar@2.0.4" = f "chokidar" "2.0.4" y "356ff4e2b0e8e43e322d18a372460bbcf3accd26" [
          (s."anymatch@^2.0.0")
          (s."async-each@^1.0.0")
          (s."braces@^2.3.0")
          (s."glob-parent@^3.1.0")
          (s."inherits@^2.0.1")
          (s."is-binary-path@^1.0.0")
          (s."is-glob@^4.0.0")
          (s."lodash.debounce@^4.0.8")
          (s."normalize-path@^2.1.1")
          (s."path-is-absolute@^1.0.0")
          (s."readdirp@^2.0.0")
          (s."upath@^1.0.5")
          (s."fsevents@^1.2.2")
        ];
        "chokidar@^2.0.2" = s."chokidar@2.0.4";
        "chownr@1.1.1" = f "chownr" "1.1.1" y "54726b8b8fff4df053c42187e801fb4412df1494" [];
        "chownr@^1.0.1" = s."chownr@1.1.1";
        "chownr@^1.1.1" = s."chownr@1.1.1";
        "chrome-trace-event@1.0.0" = f "chrome-trace-event" "1.0.0" y "45a91bd2c20c9411f0963b5aaeb9a1b95e09cc48" [
          (s."tslib@^1.9.0")
        ];
        "chrome-trace-event@^1.0.0" = s."chrome-trace-event@1.0.0";
        "cipher-base@1.0.4" = f "cipher-base" "1.0.4" y "8760e4ecc272f4c363532f926d874aae2c1397de" [
          (s."inherits@^2.0.1")
          (s."safe-buffer@^5.0.1")
        ];
        "cipher-base@^1.0.0" = s."cipher-base@1.0.4";
        "cipher-base@^1.0.1" = s."cipher-base@1.0.4";
        "cipher-base@^1.0.3" = s."cipher-base@1.0.4";
        "clap@1.2.3" = f "clap" "1.2.3" y "4f36745b32008492557f46412d66d50cb99bce51" [
          (s."chalk@^1.1.3")
        ];
        "clap@^1.0.9" = s."clap@1.2.3";
        "class-utils@0.3.6" = f "class-utils" "0.3.6" y "f93369ae8b9a7ce02fd41faad0ca83033190c463" [
          (s."arr-union@^3.1.0")
          (s."define-property@^0.2.5")
          (s."isobject@^3.0.0")
          (s."static-extend@^0.1.1")
        ];
        "class-utils@^0.3.5" = s."class-utils@0.3.6";
        "clean-css@4.2.1" = f "clean-css" "4.2.1" y "2d411ef76b8569b6d0c84068dabe85b0aa5e5c17" [
          (s."source-map@~0.6.0")
        ];
        "clean-css@4.2.x" = s."clean-css@4.2.1";
        "cli-cursor@2.1.0" = f "cli-cursor" "2.1.0" y "b35dac376479facc3e94747d41d0d0f5238ffcb5" [
          (s."restore-cursor@^2.0.0")
        ];
        "cli-cursor@^2.1.0" = s."cli-cursor@2.1.0";
        "cli-width@2.2.0" = f "cli-width" "2.2.0" y "ff19ede8a9a5e579324147b0c11f0fbcbabed639" [];
        "cli-width@^2.0.0" = s."cli-width@2.2.0";
        "cliui@4.1.0" = f "cliui" "4.1.0" y "348422dbe82d800b3022eef4f6ac10bf2e4d1b49" [
          (s."string-width@^2.1.1")
          (s."strip-ansi@^4.0.0")
          (s."wrap-ansi@^2.0.0")
        ];
        "cliui@^4.0.0" = s."cliui@4.1.0";
        "clone-response@1.0.2" = f "clone-response" "1.0.2" y "d1dc973920314df67fbeb94223b4ee350239e96b" [
          (s."mimic-response@^1.0.0")
        ];
        "clone@1.0.4" = f "clone" "1.0.4" y "da309cc263df15994c688ca902179ca3c7cd7c7e" [];
        "clone@^1.0.2" = s."clone@1.0.4";
        "co@4.6.0" = f "co" "4.6.0" y "6ea6bdf3d853ae54ccb8e47bfa0bf3f9031fb184" [];
        "co@^4.6.0" = s."co@4.6.0";
        "coa@1.0.4" = f "coa" "1.0.4" y "a9ef153660d6a86a8bdec0289a5c684d217432fd" [
          (s."q@^1.1.2")
        ];
        "coa@~1.0.1" = s."coa@1.0.4";
        "code-point-at@1.1.0" = f "code-point-at" "1.1.0" y "0d070b4d043a5bea33a2f1a40e2edb3d9a4ccf77" [];
        "code-point-at@^1.0.0" = s."code-point-at@1.1.0";
        "codemirror@5.39.2" = f "codemirror" "5.39.2" y "778aa13b55ebf280745c309cb1b148e3fc06f698" [];
        "codemirror@~5.39.0" = s."codemirror@5.39.2";
        "collection-visit@1.0.0" = f "collection-visit" "1.0.0" y "4bc0373c164bc3291b4d368c829cf1a80a59dca0" [
          (s."map-visit@^1.0.0")
          (s."object-visit@^1.0.0")
        ];
        "collection-visit@^1.0.0" = s."collection-visit@1.0.0";
        "color-convert@1.9.3" = f "color-convert" "1.9.3" y "bb71850690e1f136567de629d2d5471deda4c1e8" [
          (s."color-name@1.1.3")
        ];
        "color-convert@^1.3.0" = s."color-convert@1.9.3";
        "color-convert@^1.9.0" = s."color-convert@1.9.3";
        "color-name@1.1.3" = f "color-name" "1.1.3" y "a7d0558bd89c42f795dd42328f740831ca53bc25" [];
        "color-name@1.1.4" = f "color-name" "1.1.4" y "c2a09a87acbde69543de6f63fa3995c826c536a2" [];
        "color-name@^1.0.0" = s."color-name@1.1.4";
        "color-string@0.3.0" = f "color-string" "0.3.0" (ir "http://registry.npmjs.org/color-string/-/color-string-0.3.0.tgz") "27d46fb67025c5c2fa25993bfbf579e47841b991" [
          (s."color-name@^1.0.0")
        ];
        "color-string@^0.3.0" = s."color-string@0.3.0";
        "color@0.11.4" = f "color" "0.11.4" (ir "http://registry.npmjs.org/color/-/color-0.11.4.tgz") "6d7b5c74fb65e841cd48792ad1ed5e07b904d764" [
          (s."clone@^1.0.2")
          (s."color-convert@^1.3.0")
          (s."color-string@^0.3.0")
        ];
        "color@^0.11.0" = s."color@0.11.4";
        "colormin@1.1.2" = f "colormin" "1.1.2" y "ea2f7420a72b96881a38aae59ec124a6f7298133" [
          (s."color@^0.11.0")
          (s."css-color-names@0.0.4")
          (s."has@^1.0.1")
        ];
        "colormin@^1.0.5" = s."colormin@1.1.2";
        "colors@1.1.2" = f "colors" "1.1.2" (ir "http://registry.npmjs.org/colors/-/colors-1.1.2.tgz") "168a4701756b6a7f51a12ce0c97bfa28c084ed63" [];
        "colors@~1.1.2" = s."colors@1.1.2";
        "commander@2" = s."commander@2.19.0";
        "commander@2.13.0" = f "commander" "2.13.0" y "6964bca67685df7c1f1430c584f07d7597885b9c" [];
        "commander@2.17.1" = f "commander" "2.17.1" y "bd77ab7de6de94205ceacc72f1716d29f20a77bf" [];
        "commander@2.17.x" = s."commander@2.17.1";
        "commander@2.18.0" = f "commander" "2.18.0" y "2bf063ddee7c7891176981a2cc798e5754bc6970" [];
        "commander@2.19.0" = f "commander" "2.19.0" y "f6198aa84e5b83c46054b94ddedbfed5ee9ff12a" [];
        "commander@~2.13.0" = s."commander@2.13.0";
        "commander@~2.17.1" = s."commander@2.17.1";
        "commander@~2.18.0" = s."commander@2.18.0";
        "comment-json@1.1.3" = f "comment-json" "1.1.3" y "6986c3330fee0c4c9e00c2398cd61afa5d8f239e" [
          (s."json-parser@^1.0.0")
        ];
        "comment-json@^1.1.3" = s."comment-json@1.1.3";
        "commondir@1.0.1" = f "commondir" "1.0.1" y "ddd800da0c66127393cca5950ea968a3aaf1253b" [];
        "commondir@^1.0.1" = s."commondir@1.0.1";
        "component-emitter@1.2.1" = f "component-emitter" "1.2.1" y "137918d6d78283f7df7a6b7c5a63e140e69425e6" [];
        "component-emitter@^1.2.1" = s."component-emitter@1.2.1";
        "concat-map@0.0.1" = f "concat-map" "0.0.1" y "d8a96bd77fd68df7793a73036a3ba0d5405d477b" [];
        "concat-stream@1.6.2" = f "concat-stream" "1.6.2" y "904bdf194cd3122fc675c77fc4ac3d4ff0fd1a34" [
          (s."buffer-from@^1.0.0")
          (s."inherits@^2.0.3")
          (s."readable-stream@^2.2.2")
          (s."typedarray@^0.0.6")
        ];
        "concat-stream@^1.5.0" = s."concat-stream@1.6.2";
        "console-browserify@1.1.0" = f "console-browserify" "1.1.0" y "f0241c45730a9fc6323b206dbf38edc741d0bb10" [
          (s."date-now@^0.1.4")
        ];
        "console-browserify@^1.1.0" = s."console-browserify@1.1.0";
        "console-control-strings@1.1.0" = f "console-control-strings" "1.1.0" y "3d7cf4464db6446ea644bf4b39507f9851008e8e" [];
        "console-control-strings@^1.0.0" = s."console-control-strings@1.1.0";
        "console-control-strings@~1.1.0" = s."console-control-strings@1.1.0";
        "constants-browserify@1.0.0" = f "constants-browserify" "1.0.0" y "c20b96d8c617748aaf1c16021760cd27fcb8cb75" [];
        "constants-browserify@^1.0.0" = s."constants-browserify@1.0.0";
        "copy-concurrently@1.0.5" = f "copy-concurrently" "1.0.5" y "92297398cae34937fcafd6ec8139c18051f0b5e0" [
          (s."aproba@^1.1.1")
          (s."fs-write-stream-atomic@^1.0.8")
          (s."iferr@^0.1.5")
          (s."mkdirp@^0.5.1")
          (s."rimraf@^2.5.4")
          (s."run-queue@^1.0.0")
        ];
        "copy-concurrently@^1.0.0" = s."copy-concurrently@1.0.5";
        "copy-descriptor@0.1.1" = f "copy-descriptor" "0.1.1" y "676f6eb3c39997c2ee1ac3a924fd6124748f578d" [];
        "copy-descriptor@^0.1.0" = s."copy-descriptor@0.1.1";
        "core-js@1.2.7" = f "core-js" "1.2.7" (ir "http://registry.npmjs.org/core-js/-/core-js-1.2.7.tgz") "652294c14651db28fa93bd2d5ff2983a4f08c636" [];
        "core-js@2.6.0" = f "core-js" "2.6.0" y "1e30793e9ee5782b307e37ffa22da0eacddd84d4" [];
        "core-js@^1.0.0" = s."core-js@1.2.7";
        "core-js@^2.4.0" = s."core-js@2.6.0";
        "core-util-is@1.0.2" = f "core-util-is" "1.0.2" y "b5fd54220aa2bc5ab57aab7140c940754503c1a7" [];
        "core-util-is@~1.0.0" = s."core-util-is@1.0.2";
        "create-ecdh@4.0.3" = f "create-ecdh" "4.0.3" y "c9111b6f33045c4697f144787f9254cdc77c45ff" [
          (s."bn.js@^4.1.0")
          (s."elliptic@^6.0.0")
        ];
        "create-ecdh@^4.0.0" = s."create-ecdh@4.0.3";
        "create-hash@1.2.0" = f "create-hash" "1.2.0" (ir "http://registry.npmjs.org/create-hash/-/create-hash-1.2.0.tgz") "889078af11a63756bcfb59bd221996be3a9ef196" [
          (s."cipher-base@^1.0.1")
          (s."inherits@^2.0.1")
          (s."md5.js@^1.3.4")
          (s."ripemd160@^2.0.1")
          (s."sha.js@^2.4.0")
        ];
        "create-hash@^1.1.0" = s."create-hash@1.2.0";
        "create-hash@^1.1.2" = s."create-hash@1.2.0";
        "create-hmac@1.1.7" = f "create-hmac" "1.1.7" (ir "http://registry.npmjs.org/create-hmac/-/create-hmac-1.1.7.tgz") "69170c78b3ab957147b2b8b04572e47ead2243ff" [
          (s."cipher-base@^1.0.3")
          (s."create-hash@^1.1.0")
          (s."inherits@^2.0.1")
          (s."ripemd160@^2.0.0")
          (s."safe-buffer@^5.0.1")
          (s."sha.js@^2.4.8")
        ];
        "create-hmac@^1.1.0" = s."create-hmac@1.1.7";
        "create-hmac@^1.1.2" = s."create-hmac@1.1.7";
        "create-hmac@^1.1.4" = s."create-hmac@1.1.7";
        "create-react-class@15.6.3" = f "create-react-class" "15.6.3" y "2d73237fb3f970ae6ebe011a9e66f46dbca80036" [
          (s."fbjs@^0.8.9")
          (s."loose-envify@^1.3.1")
          (s."object-assign@^4.1.1")
        ];
        "create-react-class@^15.6.2" = s."create-react-class@15.6.3";
        "cross-spawn@5.1.0" = f "cross-spawn" "5.1.0" y "e8bd0efee58fcff6f8f94510a0a554bbfa235449" [
          (s."lru-cache@^4.0.1")
          (s."shebang-command@^1.2.0")
          (s."which@^1.2.9")
        ];
        "cross-spawn@6.0.5" = f "cross-spawn" "6.0.5" y "4a5ec7c64dfae22c3a14124dbacdee846d80cbc4" [
          (s."nice-try@^1.0.4")
          (s."path-key@^2.0.1")
          (s."semver@^5.5.0")
          (s."shebang-command@^1.2.0")
          (s."which@^1.2.9")
        ];
        "cross-spawn@^5.0.1" = s."cross-spawn@5.1.0";
        "cross-spawn@^6.0.0" = s."cross-spawn@6.0.5";
        "cross-spawn@^6.0.5" = s."cross-spawn@6.0.5";
        "crypto-browserify@3.12.0" = f "crypto-browserify" "3.12.0" y "396cf9f3137f03e4b8e532c58f698254e00f80ec" [
          (s."browserify-cipher@^1.0.0")
          (s."browserify-sign@^4.0.0")
          (s."create-ecdh@^4.0.0")
          (s."create-hash@^1.1.0")
          (s."create-hmac@^1.1.0")
          (s."diffie-hellman@^5.0.0")
          (s."inherits@^2.0.1")
          (s."pbkdf2@^3.0.3")
          (s."public-encrypt@^4.0.0")
          (s."randombytes@^2.0.0")
          (s."randomfill@^1.0.3")
        ];
        "crypto-browserify@^3.11.0" = s."crypto-browserify@3.12.0";
        "css-color-names@0.0.4" = f "css-color-names" "0.0.4" (ir "http://registry.npmjs.org/css-color-names/-/css-color-names-0.0.4.tgz") "808adc2e79cf84738069b646cb20ec27beb629e0" [];
        "css-loader@0.28.11" = f "css-loader" "0.28.11" (ir "http://registry.npmjs.org/css-loader/-/css-loader-0.28.11.tgz") "c3f9864a700be2711bb5a2462b2389b1a392dab7" [
          (s."babel-code-frame@^6.26.0")
          (s."css-selector-tokenizer@^0.7.0")
          (s."cssnano@^3.10.0")
          (s."icss-utils@^2.1.0")
          (s."loader-utils@^1.0.2")
          (s."lodash.camelcase@^4.3.0")
          (s."object-assign@^4.1.1")
          (s."postcss@^5.0.6")
          (s."postcss-modules-extract-imports@^1.2.0")
          (s."postcss-modules-local-by-default@^1.2.0")
          (s."postcss-modules-scope@^1.1.0")
          (s."postcss-modules-values@^1.3.0")
          (s."postcss-value-parser@^3.3.0")
          (s."source-list-map@^2.0.0")
        ];
        "css-loader@~0.28.7" = s."css-loader@0.28.11";
        "css-select@1.2.0" = f "css-select" "1.2.0" (ir "http://registry.npmjs.org/css-select/-/css-select-1.2.0.tgz") "2b3a110539c5355f1cd8d314623e870b121ec858" [
          (s."boolbase@~1.0.0")
          (s."css-what@2.1")
          (s."domutils@1.5.1")
          (s."nth-check@~1.0.1")
        ];
        "css-select@^1.1.0" = s."css-select@1.2.0";
        "css-selector-tokenizer@0.7.1" = f "css-selector-tokenizer" "0.7.1" y "a177271a8bca5019172f4f891fc6eed9cbf68d5d" [
          (s."cssesc@^0.1.0")
          (s."fastparse@^1.1.1")
          (s."regexpu-core@^1.0.0")
        ];
        "css-selector-tokenizer@^0.7.0" = s."css-selector-tokenizer@0.7.1";
        "css-what@2.1" = s."css-what@2.1.2";
        "css-what@2.1.2" = f "css-what" "2.1.2" y "c0876d9d0480927d7d4920dcd72af3595649554d" [];
        "cssesc@0.1.0" = f "cssesc" "0.1.0" y "c814903e45623371a0477b40109aaafbeeaddbb4" [];
        "cssesc@^0.1.0" = s."cssesc@0.1.0";
        "cssnano@3.10.0" = f "cssnano" "3.10.0" (ir "http://registry.npmjs.org/cssnano/-/cssnano-3.10.0.tgz") "4f38f6cea2b9b17fa01490f23f1dc68ea65c1c38" [
          (s."autoprefixer@^6.3.1")
          (s."decamelize@^1.1.2")
          (s."defined@^1.0.0")
          (s."has@^1.0.1")
          (s."object-assign@^4.0.1")
          (s."postcss@^5.0.14")
          (s."postcss-calc@^5.2.0")
          (s."postcss-colormin@^2.1.8")
          (s."postcss-convert-values@^2.3.4")
          (s."postcss-discard-comments@^2.0.4")
          (s."postcss-discard-duplicates@^2.0.1")
          (s."postcss-discard-empty@^2.0.1")
          (s."postcss-discard-overridden@^0.1.1")
          (s."postcss-discard-unused@^2.2.1")
          (s."postcss-filter-plugins@^2.0.0")
          (s."postcss-merge-idents@^2.1.5")
          (s."postcss-merge-longhand@^2.0.1")
          (s."postcss-merge-rules@^2.0.3")
          (s."postcss-minify-font-values@^1.0.2")
          (s."postcss-minify-gradients@^1.0.1")
          (s."postcss-minify-params@^1.0.4")
          (s."postcss-minify-selectors@^2.0.4")
          (s."postcss-normalize-charset@^1.1.0")
          (s."postcss-normalize-url@^3.0.7")
          (s."postcss-ordered-values@^2.1.0")
          (s."postcss-reduce-idents@^2.2.2")
          (s."postcss-reduce-initial@^1.0.0")
          (s."postcss-reduce-transforms@^1.0.3")
          (s."postcss-svgo@^2.1.1")
          (s."postcss-unique-selectors@^2.0.2")
          (s."postcss-value-parser@^3.2.3")
          (s."postcss-zindex@^2.0.1")
        ];
        "cssnano@^3.10.0" = s."cssnano@3.10.0";
        "csso@2.3.2" = f "csso" "2.3.2" y "ddd52c587033f49e94b71fc55569f252e8ff5f85" [
          (s."clap@^1.0.9")
          (s."source-map@^0.5.3")
        ];
        "csso@~2.3.1" = s."csso@2.3.2";
        "csstype@2.5.8" = f "csstype" "2.5.8" y "4ce5aa16ea0d562ef9105fa3ae2676f199586a35" [];
        "csstype@^2.2.0" = s."csstype@2.5.8";
        "cyclist@0.2.2" = f "cyclist" "0.2.2" y "1b33792e11e914a2fd6d6ed6447464444e5fa640" [];
        "cyclist@~0.2.2" = s."cyclist@0.2.2";
        "d3-array@1" = s."d3-array@1.2.4";
        "d3-array@1.2.4" = f "d3-array" "1.2.4" y "635ce4d5eea759f6f605863dbcfc30edc737f71f" [];
        "d3-array@2.0.2" = f "d3-array" "2.0.2" y "c9a8a203b43403c6ced881ee66828edc6e561c61" [];
        "d3-array@^1.1.1" = s."d3-array@1.2.4";
        "d3-array@^1.2.0" = s."d3-array@1.2.4";
        "d3-array@^2.0.2" = s."d3-array@2.0.2";
        "d3-collection@1" = s."d3-collection@1.0.7";
        "d3-collection@1.0.7" = f "d3-collection" "1.0.7" y "349bd2aa9977db071091c13144d5e4f16b5b310e" [];
        "d3-collection@^1.0.7" = s."d3-collection@1.0.7";
        "d3-color@1" = s."d3-color@1.2.3";
        "d3-color@1.2.3" = f "d3-color" "1.2.3" y "6c67bb2af6df3cc8d79efcc4d3a3e83e28c8048f" [];
        "d3-color@^1.2.3" = s."d3-color@1.2.3";
        "d3-contour@1.3.2" = f "d3-contour" "1.3.2" y "652aacd500d2264cb3423cee10db69f6f59bead3" [
          (s."d3-array@^1.1.1")
        ];
        "d3-contour@^1.3.2" = s."d3-contour@1.3.2";
        "d3-dispatch@1" = s."d3-dispatch@1.0.5";
        "d3-dispatch@1.0.5" = f "d3-dispatch" "1.0.5" y "e25c10a186517cd6c82dd19ea018f07e01e39015" [];
        "d3-dsv@1.0.10" = f "d3-dsv" "1.0.10" y "4371c489a2a654a297aca16fcaf605a6f31a6f51" [
          (s."commander@2")
          (s."iconv-lite@0.4")
          (s."rw@1")
        ];
        "d3-dsv@^1.0.10" = s."d3-dsv@1.0.10";
        "d3-force@1.1.2" = f "d3-force" "1.1.2" y "16664d0ac71d8727ef5effe0b374feac8050d6cd" [
          (s."d3-collection@1")
          (s."d3-dispatch@1")
          (s."d3-quadtree@1")
          (s."d3-timer@1")
        ];
        "d3-force@^1.1.0" = s."d3-force@1.1.2";
        "d3-format@1" = s."d3-format@1.3.2";
        "d3-format@1.3.2" = f "d3-format" "1.3.2" y "6a96b5e31bcb98122a30863f7d92365c00603562" [];
        "d3-format@^1.3.2" = s."d3-format@1.3.2";
        "d3-geo@1.11.3" = f "d3-geo" "1.11.3" y "5bb08388f45e4b281491faa72d3abd43215dbd1c" [
          (s."d3-array@1")
        ];
        "d3-geo@^1.10.0" = s."d3-geo@1.11.3";
        "d3-geo@^1.11.3" = s."d3-geo@1.11.3";
        "d3-hierarchy@1.1.8" = f "d3-hierarchy" "1.1.8" y "7a6317bd3ed24e324641b6f1e76e978836b008cc" [];
        "d3-hierarchy@^1.1.8" = s."d3-hierarchy@1.1.8";
        "d3-interpolate@1" = s."d3-interpolate@1.3.2";
        "d3-interpolate@1.3.2" = f "d3-interpolate" "1.3.2" y "417d3ebdeb4bc4efcc8fd4361c55e4040211fd68" [
          (s."d3-color@1")
        ];
        "d3-interpolate@^1.3.2" = s."d3-interpolate@1.3.2";
        "d3-path@1" = s."d3-path@1.0.7";
        "d3-path@1.0.7" = f "d3-path" "1.0.7" y "8de7cd693a75ac0b5480d3abaccd94793e58aae8" [];
        "d3-path@^1.0.7" = s."d3-path@1.0.7";
        "d3-quadtree@1" = s."d3-quadtree@1.0.5";
        "d3-quadtree@1.0.5" = f "d3-quadtree" "1.0.5" y "305394840b01f51a341a0da5008585e837fe7e9b" [];
        "d3-scale-chromatic@1.3.3" = f "d3-scale-chromatic" "1.3.3" y "dad4366f0edcb288f490128979c3c793583ed3c0" [
          (s."d3-color@1")
          (s."d3-interpolate@1")
        ];
        "d3-scale-chromatic@^1.3.3" = s."d3-scale-chromatic@1.3.3";
        "d3-scale@2.1.2" = f "d3-scale" "2.1.2" y "4e932b7b60182aee9073ede8764c98423e5f9a94" [
          (s."d3-array@^1.2.0")
          (s."d3-collection@1")
          (s."d3-format@1")
          (s."d3-interpolate@1")
          (s."d3-time@1")
          (s."d3-time-format@2")
        ];
        "d3-scale@^2.1.2" = s."d3-scale@2.1.2";
        "d3-selection@1.3.2" = f "d3-selection" "1.3.2" y "6e70a9df60801c8af28ac24d10072d82cbfdf652" [];
        "d3-selection@^1.3.0" = s."d3-selection@1.3.2";
        "d3-shape@1.2.2" = f "d3-shape" "1.2.2" y "f9dba3777a5825f9a8ce8bc928da08c17679e9a7" [
          (s."d3-path@1")
        ];
        "d3-shape@^1.2.2" = s."d3-shape@1.2.2";
        "d3-time-format@2" = s."d3-time-format@2.1.3";
        "d3-time-format@2.1.3" = f "d3-time-format" "2.1.3" y "ae06f8e0126a9d60d6364eac5b1533ae1bac826b" [
          (s."d3-time@1")
        ];
        "d3-time-format@^2.1.3" = s."d3-time-format@2.1.3";
        "d3-time@1" = s."d3-time@1.0.10";
        "d3-time@1.0.10" = f "d3-time" "1.0.10" y "8259dd71288d72eeacfd8de281c4bf5c7393053c" [];
        "d3-time@^1.0.10" = s."d3-time@1.0.10";
        "d3-timer@1" = s."d3-timer@1.0.9";
        "d3-timer@1.0.9" = f "d3-timer" "1.0.9" y "f7bb8c0d597d792ff7131e1c24a36dd471a471ba" [];
        "d3-timer@^1.0.9" = s."d3-timer@1.0.9";
        "d3-voronoi@1.1.4" = f "d3-voronoi" "1.1.4" y "dd3c78d7653d2bb359284ae478645d95944c8297" [];
        "d3-voronoi@^1.1.2" = s."d3-voronoi@1.1.4";
        "date-now@0.1.4" = f "date-now" "0.1.4" y "eaf439fd4d4848ad74e5cc7dbef200672b9e345b" [];
        "date-now@^0.1.4" = s."date-now@0.1.4";
        "debug@2.6.9" = f "debug" "2.6.9" y "5d128515df134ff327e90a4c93f4e077a536341f" [
          (s."ms@2.0.0")
        ];
        "debug@3.2.6" = f "debug" "3.2.6" y "e83d17de16d8a7efb7717edbe5fb10135eee629b" [
          (s."ms@^2.1.1")
        ];
        "debug@^2.1.2" = s."debug@2.6.9";
        "debug@^2.2.0" = s."debug@2.6.9";
        "debug@^2.3.3" = s."debug@2.6.9";
        "debug@^3.1.0" = s."debug@3.2.6";
        "decamelize@1.2.0" = f "decamelize" "1.2.0" y "f6534d15148269b20352e7bee26f501f9a191290" [];
        "decamelize@^1.1.1" = s."decamelize@1.2.0";
        "decamelize@^1.1.2" = s."decamelize@1.2.0";
        "decamelize@^1.2.0" = s."decamelize@1.2.0";
        "decode-uri-component@0.2.0" = f "decode-uri-component" "0.2.0" y "eb3913333458775cb84cd1a1fae062106bb87545" [];
        "decode-uri-component@^0.2.0" = s."decode-uri-component@0.2.0";
        "decompress-response@3.3.0" = f "decompress-response" "3.3.0" y "80a4dd323748384bfa248083622aedec982adff3" [
          (s."mimic-response@^1.0.0")
        ];
        "decompress-response@^3.3.0" = s."decompress-response@3.3.0";
        "deep-extend@0.6.0" = f "deep-extend" "0.6.0" y "c4fa7c95404a17a9c3e8ca7e1537312b736330ac" [];
        "deep-extend@^0.6.0" = s."deep-extend@0.6.0";
        "define-properties@1.1.3" = f "define-properties" "1.1.3" y "cf88da6cbee26fe6db7094f61d870cbd84cee9f1" [
          (s."object-keys@^1.0.12")
        ];
        "define-properties@^1.1.2" = s."define-properties@1.1.3";
        "define-property@0.2.5" = f "define-property" "0.2.5" y "c35b1ef918ec3c990f9a5bc57be04aacec5c8116" [
          (s."is-descriptor@^0.1.0")
        ];
        "define-property@1.0.0" = f "define-property" "1.0.0" y "769ebaaf3f4a63aad3af9e8d304c9bbe79bfb0e6" [
          (s."is-descriptor@^1.0.0")
        ];
        "define-property@2.0.2" = f "define-property" "2.0.2" y "d459689e8d654ba77e02a817f8710d702cb16e9d" [
          (s."is-descriptor@^1.0.2")
          (s."isobject@^3.0.1")
        ];
        "define-property@^0.2.5" = s."define-property@0.2.5";
        "define-property@^1.0.0" = s."define-property@1.0.0";
        "define-property@^2.0.2" = s."define-property@2.0.2";
        "defined@1.0.0" = f "defined" "1.0.0" y "c98d9bcef75674188e110969151199e39b1fa693" [];
        "defined@^1.0.0" = s."defined@1.0.0";
        "delegates@1.0.0" = f "delegates" "1.0.0" y "84c6e159b81904fdca59a0ef44cd870d31250f9a" [];
        "delegates@^1.0.0" = s."delegates@1.0.0";
        "des.js@1.0.0" = f "des.js" "1.0.0" y "c074d2e2aa6a8a9a07dbd61f9a15c2cd83ec8ecc" [
          (s."inherits@^2.0.1")
          (s."minimalistic-assert@^1.0.0")
        ];
        "des.js@^1.0.0" = s."des.js@1.0.0";
        "detect-libc@1.0.3" = f "detect-libc" "1.0.3" y "fa137c4bd698edf55cd5cd02ac559f91a4c4ba9b" [];
        "detect-libc@^1.0.2" = s."detect-libc@1.0.3";
        "diffie-hellman@5.0.3" = f "diffie-hellman" "5.0.3" (ir "http://registry.npmjs.org/diffie-hellman/-/diffie-hellman-5.0.3.tgz") "40e8ee98f55a2149607146921c63e1ae5f3d2875" [
          (s."bn.js@^4.1.0")
          (s."miller-rabin@^4.0.0")
          (s."randombytes@^2.0.0")
        ];
        "diffie-hellman@^5.0.0" = s."diffie-hellman@5.0.3";
        "dom-converter@0.2.0" = f "dom-converter" "0.2.0" y "6721a9daee2e293682955b6afe416771627bb768" [
          (s."utila@~0.4")
        ];
        "dom-converter@~0.2" = s."dom-converter@0.2.0";
        "dom-serializer@0" = s."dom-serializer@0.1.0";
        "dom-serializer@0.1.0" = f "dom-serializer" "0.1.0" y "073c697546ce0780ce23be4a28e293e40bc30c82" [
          (s."domelementtype@~1.1.1")
          (s."entities@~1.1.1")
        ];
        "domain-browser@1.2.0" = f "domain-browser" "1.2.0" y "3d31f50191a6749dd1375a7f522e823d42e54eda" [];
        "domain-browser@^1.1.1" = s."domain-browser@1.2.0";
        "domelementtype@1" = s."domelementtype@1.3.1";
        "domelementtype@1.1.3" = f "domelementtype" "1.1.3" (ir "http://registry.npmjs.org/domelementtype/-/domelementtype-1.1.3.tgz") "bd28773e2642881aec51544924299c5cd822185b" [];
        "domelementtype@1.3.1" = f "domelementtype" "1.3.1" y "d048c44b37b0d10a7f2a3d5fee3f4333d790481f" [];
        "domelementtype@^1.3.0" = s."domelementtype@1.3.1";
        "domelementtype@~1.1.1" = s."domelementtype@1.1.3";
        "domhandler@2.1" = s."domhandler@2.1.0";
        "domhandler@2.1.0" = f "domhandler" "2.1.0" y "d2646f5e57f6c3bab11cf6cb05d3c0acf7412594" [
          (s."domelementtype@1")
        ];
        "domhandler@2.4.2" = f "domhandler" "2.4.2" y "8805097e933d65e85546f726d60f5eb88b44f803" [
          (s."domelementtype@1")
        ];
        "domhandler@^2.3.0" = s."domhandler@2.4.2";
        "domutils@1.1" = s."domutils@1.1.6";
        "domutils@1.1.6" = f "domutils" "1.1.6" y "bddc3de099b9a2efacc51c623f28f416ecc57485" [
          (s."domelementtype@1")
        ];
        "domutils@1.5.1" = f "domutils" "1.5.1" y "dcd8488a26f563d61079e48c9f7b7e32373682cf" [
          (s."dom-serializer@0")
          (s."domelementtype@1")
        ];
        "domutils@1.7.0" = f "domutils" "1.7.0" y "56ea341e834e06e6748af7a1cb25da67ea9f8c2a" [
          (s."dom-serializer@0")
          (s."domelementtype@1")
        ];
        "domutils@^1.5.1" = s."domutils@1.7.0";
        "duplexer3@0.1.4" = f "duplexer3" "0.1.4" y "ee01dd1cac0ed3cbc7fdbea37dc0a8f1ce002ce2" [];
        "duplexer3@^0.1.4" = s."duplexer3@0.1.4";
        "duplexify@3.6.1" = f "duplexify" "3.6.1" y "b1a7a29c4abfd639585efaecce80d666b1e34125" [
          (s."end-of-stream@^1.0.0")
          (s."inherits@^2.0.1")
          (s."readable-stream@^2.0.0")
          (s."stream-shift@^1.0.0")
        ];
        "duplexify@^3.4.2" = s."duplexify@3.6.1";
        "duplexify@^3.6.0" = s."duplexify@3.6.1";
        "duplicate-package-checker-webpack-plugin@3.0.0" = f "duplicate-package-checker-webpack-plugin" "3.0.0" y "78bb89e625fa7cf8c2a59c53f62b495fda9ba287" [
          (s."chalk@^2.3.0")
          (s."find-root@^1.0.0")
          (s."lodash@^4.17.4")
          (s."semver@^5.4.1")
        ];
        "duplicate-package-checker-webpack-plugin@^3.0.0" = s."duplicate-package-checker-webpack-plugin@3.0.0";
        "electron-to-chromium@1.3.92" = f "electron-to-chromium" "1.3.92" y "9027b5abaea400045edd652c0e4838675c814399" [];
        "electron-to-chromium@^1.2.7" = s."electron-to-chromium@1.3.92";
        "elliptic@6.4.1" = f "elliptic" "6.4.1" y "c2d0b7776911b86722c632c3c06c60f2f819939a" [
          (s."bn.js@^4.4.0")
          (s."brorand@^1.0.1")
          (s."hash.js@^1.0.0")
          (s."hmac-drbg@^1.0.0")
          (s."inherits@^2.0.1")
          (s."minimalistic-assert@^1.0.0")
          (s."minimalistic-crypto-utils@^1.0.0")
        ];
        "elliptic@^6.0.0" = s."elliptic@6.4.1";
        "emojis-list@2.1.0" = f "emojis-list" "2.1.0" y "4daa4d9db00f9819880c79fa457ae5b09a1fd389" [];
        "emojis-list@^2.0.0" = s."emojis-list@2.1.0";
        "encoding@0.1.12" = f "encoding" "0.1.12" y "538b66f3ee62cd1ab51ec323829d1f9480c74beb" [
          (s."iconv-lite@~0.4.13")
        ];
        "encoding@^0.1.11" = s."encoding@0.1.12";
        "end-of-stream@1.4.1" = f "end-of-stream" "1.4.1" y "ed29634d19baba463b6ce6b80a37213eab71ec43" [
          (s."once@^1.4.0")
        ];
        "end-of-stream@^1.0.0" = s."end-of-stream@1.4.1";
        "end-of-stream@^1.1.0" = s."end-of-stream@1.4.1";
        "enhanced-resolve@4.1.0" = f "enhanced-resolve" "4.1.0" y "41c7e0bfdfe74ac1ffe1e57ad6a5c6c9f3742a7f" [
          (s."graceful-fs@^4.1.2")
          (s."memory-fs@^0.4.0")
          (s."tapable@^1.0.0")
        ];
        "enhanced-resolve@^4.0.0" = s."enhanced-resolve@4.1.0";
        "enhanced-resolve@^4.1.0" = s."enhanced-resolve@4.1.0";
        "entities@1.1.2" = f "entities" "1.1.2" y "bdfa735299664dfafd34529ed4f8522a275fea56" [];
        "entities@^1.1.1" = s."entities@1.1.2";
        "entities@~1.1.1" = s."entities@1.1.2";
        "errno@0.1.7" = f "errno" "0.1.7" y "4684d71779ad39af177e3f007996f7c67c852618" [
          (s."prr@~1.0.1")
        ];
        "errno@^0.1.3" = s."errno@0.1.7";
        "errno@~0.1.7" = s."errno@0.1.7";
        "es-abstract@1.12.0" = f "es-abstract" "1.12.0" y "9dbbdd27c6856f0001421ca18782d786bf8a6165" [
          (s."es-to-primitive@^1.1.1")
          (s."function-bind@^1.1.1")
          (s."has@^1.0.1")
          (s."is-callable@^1.1.3")
          (s."is-regex@^1.0.4")
        ];
        "es-abstract@^1.5.1" = s."es-abstract@1.12.0";
        "es-to-primitive@1.2.0" = f "es-to-primitive" "1.2.0" y "edf72478033456e8dda8ef09e00ad9650707f377" [
          (s."is-callable@^1.1.4")
          (s."is-date-object@^1.0.1")
          (s."is-symbol@^1.0.2")
        ];
        "es-to-primitive@^1.1.1" = s."es-to-primitive@1.2.0";
        "es6-promise@4.1.1" = f "es6-promise" "4.1.1" y "8811e90915d9a0dba36274f0b242dbda78f9c92a" [];
        "es6-promise@~4.1.1" = s."es6-promise@4.1.1";
        "es6-templates@0.2.3" = f "es6-templates" "0.2.3" y "5cb9ac9fb1ded6eb1239342b81d792bbb4078ee4" [
          (s."recast@~0.11.12")
          (s."through@~2.3.6")
        ];
        "es6-templates@^0.2.3" = s."es6-templates@0.2.3";
        "escape-string-regexp@1.0.5" = f "escape-string-regexp" "1.0.5" y "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4" [];
        "escape-string-regexp@^1.0.2" = s."escape-string-regexp@1.0.5";
        "escape-string-regexp@^1.0.5" = s."escape-string-regexp@1.0.5";
        "eslint-scope@3.7.3" = f "eslint-scope" "3.7.3" y "bb507200d3d17f60247636160b4826284b108535" [
          (s."esrecurse@^4.1.0")
          (s."estraverse@^4.1.1")
        ];
        "eslint-scope@^3.7.1" = s."eslint-scope@3.7.3";
        "esprima@2.7.3" = f "esprima" "2.7.3" y "96e3b70d5779f6ad49cd032673d1c312767ba581" [];
        "esprima@3.1.3" = f "esprima" "3.1.3" y "fdca51cee6133895e3c88d535ce49dbff62a4633" [];
        "esprima@^2.6.0" = s."esprima@2.7.3";
        "esprima@^2.7.0" = s."esprima@2.7.3";
        "esprima@~3.1.0" = s."esprima@3.1.3";
        "esrecurse@4.2.1" = f "esrecurse" "4.2.1" y "007a3b9fdbc2b3bb87e4879ea19c92fdbd3942cf" [
          (s."estraverse@^4.1.0")
        ];
        "esrecurse@^4.1.0" = s."esrecurse@4.2.1";
        "estraverse@4.2.0" = f "estraverse" "4.2.0" y "0dee3fed31fcd469618ce7342099fc1afa0bdb13" [];
        "estraverse@^4.1.0" = s."estraverse@4.2.0";
        "estraverse@^4.1.1" = s."estraverse@4.2.0";
        "esutils@2.0.2" = f "esutils" "2.0.2" y "0abf4f1caa5bcb1f7a9d8acc6dea4faaa04bac9b" [];
        "esutils@^2.0.2" = s."esutils@2.0.2";
        "events@1.1.1" = f "events" "1.1.1" (ir "http://registry.npmjs.org/events/-/events-1.1.1.tgz") "9ebdb7635ad099c70dcc4c2a1f5004288e8bd924" [];
        "events@^1.0.0" = s."events@1.1.1";
        "evp_bytestokey@1.0.3" = f "evp_bytestokey" "1.0.3" y "7fcbdb198dc71959432efe13842684e0525acb02" [
          (s."md5.js@^1.3.4")
          (s."safe-buffer@^5.1.1")
        ];
        "evp_bytestokey@^1.0.0" = s."evp_bytestokey@1.0.3";
        "evp_bytestokey@^1.0.3" = s."evp_bytestokey@1.0.3";
        "execa@0.10.0" = f "execa" "0.10.0" y "ff456a8f53f90f8eccc71a96d11bdfc7f082cb50" [
          (s."cross-spawn@^6.0.0")
          (s."get-stream@^3.0.0")
          (s."is-stream@^1.1.0")
          (s."npm-run-path@^2.0.0")
          (s."p-finally@^1.0.0")
          (s."signal-exit@^3.0.0")
          (s."strip-eof@^1.0.0")
        ];
        "execa@0.7.0" = f "execa" "0.7.0" y "944becd34cc41ee32a63a9faf27ad5a65fc59777" [
          (s."cross-spawn@^5.0.1")
          (s."get-stream@^3.0.0")
          (s."is-stream@^1.1.0")
          (s."npm-run-path@^2.0.0")
          (s."p-finally@^1.0.0")
          (s."signal-exit@^3.0.0")
          (s."strip-eof@^1.0.0")
        ];
        "execa@^0.10.0" = s."execa@0.10.0";
        "execa@^0.7.0" = s."execa@0.7.0";
        "expand-brackets@2.1.4" = f "expand-brackets" "2.1.4" y "b77735e315ce30f6b6eff0f83b04151a22449622" [
          (s."debug@^2.3.3")
          (s."define-property@^0.2.5")
          (s."extend-shallow@^2.0.1")
          (s."posix-character-classes@^0.1.0")
          (s."regex-not@^1.0.0")
          (s."snapdragon@^0.8.1")
          (s."to-regex@^3.0.1")
        ];
        "expand-brackets@^2.1.4" = s."expand-brackets@2.1.4";
        "extend-shallow@2.0.1" = f "extend-shallow" "2.0.1" y "51af7d614ad9a9f610ea1bafbb989d6b1c56890f" [
          (s."is-extendable@^0.1.0")
        ];
        "extend-shallow@3.0.2" = f "extend-shallow" "3.0.2" y "26a71aaf073b39fb2127172746131c2704028db8" [
          (s."assign-symbols@^1.0.0")
          (s."is-extendable@^1.0.1")
        ];
        "extend-shallow@^2.0.1" = s."extend-shallow@2.0.1";
        "extend-shallow@^3.0.0" = s."extend-shallow@3.0.2";
        "extend-shallow@^3.0.2" = s."extend-shallow@3.0.2";
        "external-editor@2.2.0" = f "external-editor" "2.2.0" (ir "http://registry.npmjs.org/external-editor/-/external-editor-2.2.0.tgz") "045511cfd8d133f3846673d1047c154e214ad3d5" [
          (s."chardet@^0.4.0")
          (s."iconv-lite@^0.4.17")
          (s."tmp@^0.0.33")
        ];
        "external-editor@^2.0.4" = s."external-editor@2.2.0";
        "extglob@2.0.4" = f "extglob" "2.0.4" y "ad00fe4dc612a9232e8718711dc5cb5ab0285543" [
          (s."array-unique@^0.3.2")
          (s."define-property@^1.0.0")
          (s."expand-brackets@^2.1.4")
          (s."extend-shallow@^2.0.1")
          (s."fragment-cache@^0.2.1")
          (s."regex-not@^1.0.0")
          (s."snapdragon@^0.8.1")
          (s."to-regex@^3.0.1")
        ];
        "extglob@^2.0.4" = s."extglob@2.0.4";
        "fast-deep-equal@2.0.1" = f "fast-deep-equal" "2.0.1" y "7b05218ddf9667bf7f370bf7fdb2cb15fdd0aa49" [];
        "fast-deep-equal@^2.0.1" = s."fast-deep-equal@2.0.1";
        "fast-json-stable-stringify@2.0.0" = f "fast-json-stable-stringify" "2.0.0" y "d5142c0caee6b1189f87d3a76111064f86c8bbf2" [];
        "fast-json-stable-stringify@^2.0.0" = s."fast-json-stable-stringify@2.0.0";
        "fastparse@1.1.2" = f "fastparse" "1.1.2" y "91728c5a5942eced8531283c79441ee4122c35a9" [];
        "fastparse@^1.1.1" = s."fastparse@1.1.2";
        "fbjs@0.8.17" = f "fbjs" "0.8.17" y "c4d598ead6949112653d6588b01a5cdcd9f90fdd" [
          (s."core-js@^1.0.0")
          (s."isomorphic-fetch@^2.1.1")
          (s."loose-envify@^1.0.0")
          (s."object-assign@^4.1.0")
          (s."promise@^7.1.1")
          (s."setimmediate@^1.0.5")
          (s."ua-parser-js@^0.7.18")
        ];
        "fbjs@^0.8.16" = s."fbjs@0.8.17";
        "fbjs@^0.8.9" = s."fbjs@0.8.17";
        "figures@2.0.0" = f "figures" "2.0.0" y "3ab1a2d2a62c8bfb431a0c94cb797a2fce27c962" [
          (s."escape-string-regexp@^1.0.5")
        ];
        "figures@^2.0.0" = s."figures@2.0.0";
        "file-loader@1.1.11" = f "file-loader" "1.1.11" (ir "http://registry.npmjs.org/file-loader/-/file-loader-1.1.11.tgz") "6fe886449b0f2a936e43cabaac0cdbfb369506f8" [
          (s."loader-utils@^1.0.2")
          (s."schema-utils@^0.4.5")
        ];
        "file-loader@~1.1.11" = s."file-loader@1.1.11";
        "fill-range@4.0.0" = f "fill-range" "4.0.0" y "d544811d428f98eb06a63dc402d2403c328c38f7" [
          (s."extend-shallow@^2.0.1")
          (s."is-number@^3.0.0")
          (s."repeat-string@^1.6.1")
          (s."to-regex-range@^2.1.0")
        ];
        "fill-range@^4.0.0" = s."fill-range@4.0.0";
        "find-cache-dir@1.0.0" = f "find-cache-dir" "1.0.0" y "9288e3e9e3cc3748717d39eade17cf71fc30ee6f" [
          (s."commondir@^1.0.1")
          (s."make-dir@^1.0.0")
          (s."pkg-dir@^2.0.0")
        ];
        "find-cache-dir@^1.0.0" = s."find-cache-dir@1.0.0";
        "find-root@1.1.0" = f "find-root" "1.1.0" y "abcfc8ba76f708c42a97b3d685b7e9450bfb9ce4" [];
        "find-root@^1.0.0" = s."find-root@1.1.0";
        "find-up@2.1.0" = f "find-up" "2.1.0" y "45d1b7e506c717ddd482775a2b77920a3c0c57a7" [
          (s."locate-path@^2.0.0")
        ];
        "find-up@3.0.0" = f "find-up" "3.0.0" y "49169f1d7993430646da61ecc5ae355c21c97b73" [
          (s."locate-path@^3.0.0")
        ];
        "find-up@^2.1.0" = s."find-up@2.1.0";
        "find-up@^3.0.0" = s."find-up@3.0.0";
        "flatten@1.0.2" = f "flatten" "1.0.2" y "dae46a9d78fbe25292258cc1e780a41d95c03782" [];
        "flatten@^1.0.2" = s."flatten@1.0.2";
        "flush-write-stream@1.0.3" = f "flush-write-stream" "1.0.3" y "c5d586ef38af6097650b49bc41b55fabb19f35bd" [
          (s."inherits@^2.0.1")
          (s."readable-stream@^2.0.4")
        ];
        "flush-write-stream@^1.0.0" = s."flush-write-stream@1.0.3";
        "font-awesome@4.7.0" = f "font-awesome" "4.7.0" y "8fa8cf0411a1a31afd07b06d2902bb9fc815a133" [];
        "font-awesome@~4.7.0" = s."font-awesome@4.7.0";
        "for-in@1.0.2" = f "for-in" "1.0.2" y "81068d295a8142ec0ac726c6e2200c30fb6d5e80" [];
        "for-in@^1.0.2" = s."for-in@1.0.2";
        "fragment-cache@0.2.1" = f "fragment-cache" "0.2.1" y "4290fad27f13e89be7f33799c6bc5a0abfff0d19" [
          (s."map-cache@^0.2.2")
        ];
        "fragment-cache@^0.2.1" = s."fragment-cache@0.2.1";
        "from2@2.3.0" = f "from2" "2.3.0" y "8bfb5502bde4a4d36cfdeea007fcca21d7e382af" [
          (s."inherits@^2.0.1")
          (s."readable-stream@^2.0.0")
        ];
        "from2@^2.1.0" = s."from2@2.3.0";
        "from2@^2.1.1" = s."from2@2.3.0";
        "fs-extra@4.0.3" = f "fs-extra" "4.0.3" y "0d852122e5bc5beb453fb028e9c0c9bf36340c94" [
          (s."graceful-fs@^4.1.2")
          (s."jsonfile@^4.0.0")
          (s."universalify@^0.1.0")
        ];
        "fs-extra@~4.0.2" = s."fs-extra@4.0.3";
        "fs-minipass@1.2.5" = f "fs-minipass" "1.2.5" y "06c277218454ec288df77ada54a03b8702aacb9d" [
          (s."minipass@^2.2.1")
        ];
        "fs-minipass@^1.2.5" = s."fs-minipass@1.2.5";
        "fs-write-stream-atomic@1.0.10" = f "fs-write-stream-atomic" "1.0.10" y "b47df53493ef911df75731e70a9ded0189db40c9" [
          (s."graceful-fs@^4.1.2")
          (s."iferr@^0.1.5")
          (s."imurmurhash@^0.1.4")
          (s."readable-stream@1 || 2")
        ];
        "fs-write-stream-atomic@^1.0.8" = s."fs-write-stream-atomic@1.0.10";
        "fs.realpath@1.0.0" = f "fs.realpath" "1.0.0" y "1504ad2523158caa40db4a2787cb01411994ea4f" [];
        "fs.realpath@^1.0.0" = s."fs.realpath@1.0.0";
        "fsevents@1.2.4" = f "fsevents" "1.2.4" y "f41dcb1af2582af3692da36fc55cbd8e1041c426" [
          (s."nan@^2.9.2")
          (s."node-pre-gyp@^0.10.0")
        ];
        "fsevents@^1.2.2" = s."fsevents@1.2.4";
        "function-bind@1.1.1" = f "function-bind" "1.1.1" y "a56899d3ea3c9bab874bb9773b7c5ede92f4895d" [];
        "function-bind@^1.1.1" = s."function-bind@1.1.1";
        "gauge@2.7.4" = f "gauge" "2.7.4" y "2c03405c7538c39d7eb37b317022e325fb018bf7" [
          (s."aproba@^1.0.3")
          (s."console-control-strings@^1.0.0")
          (s."has-unicode@^2.0.0")
          (s."object-assign@^4.1.0")
          (s."signal-exit@^3.0.0")
          (s."string-width@^1.0.1")
          (s."strip-ansi@^3.0.1")
          (s."wide-align@^1.1.0")
        ];
        "gauge@~2.7.3" = s."gauge@2.7.4";
        "get-caller-file@1.0.3" = f "get-caller-file" "1.0.3" y "f978fa4c90d1dfe7ff2d6beda2a515e713bdcf4a" [];
        "get-caller-file@^1.0.1" = s."get-caller-file@1.0.3";
        "get-stream@3.0.0" = f "get-stream" "3.0.0" (ir "http://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz") "8e943d1358dc37555054ecbe2edb05aa174ede14" [];
        "get-stream@^3.0.0" = s."get-stream@3.0.0";
        "get-value@2.0.6" = f "get-value" "2.0.6" y "dc15ca1c672387ca76bd37ac0a395ba2042a2c28" [];
        "get-value@^2.0.3" = s."get-value@2.0.6";
        "get-value@^2.0.6" = s."get-value@2.0.6";
        "glob-parent@3.1.0" = f "glob-parent" "3.1.0" y "9e6af6299d8d3bd2bd40430832bd113df906c5ae" [
          (s."is-glob@^3.1.0")
          (s."path-dirname@^1.0.0")
        ];
        "glob-parent@^3.1.0" = s."glob-parent@3.1.0";
        "glob@7.1.3" = f "glob" "7.1.3" y "3960832d3f1574108342dafd3a67b332c0969df1" [
          (s."fs.realpath@^1.0.0")
          (s."inflight@^1.0.4")
          (s."inherits@2")
          (s."minimatch@^3.0.4")
          (s."once@^1.3.0")
          (s."path-is-absolute@^1.0.0")
        ];
        "glob@^7.0.5" = s."glob@7.1.3";
        "glob@^7.1.2" = s."glob@7.1.3";
        "glob@~7.1.2" = s."glob@7.1.3";
        "global-modules-path@2.3.1" = f "global-modules-path" "2.3.1" y "e541f4c800a1a8514a990477b267ac67525b9931" [];
        "global-modules-path@^2.3.0" = s."global-modules-path@2.3.1";
        "got@8.3.2" = f "got" "8.3.2" y "1d23f64390e97f776cac52e5b936e5f514d2e937" [
          (s."@sindresorhus/is@^0.7.0")
          (s."cacheable-request@^2.1.1")
          (s."decompress-response@^3.3.0")
          (s."duplexer3@^0.1.4")
          (s."get-stream@^3.0.0")
          (s."into-stream@^3.1.0")
          (s."is-retry-allowed@^1.1.0")
          (s."isurl@^1.0.0-alpha5")
          (s."lowercase-keys@^1.0.0")
          (s."mimic-response@^1.0.0")
          (s."p-cancelable@^0.4.0")
          (s."p-timeout@^2.0.1")
          (s."pify@^3.0.0")
          (s."safe-buffer@^5.1.1")
          (s."timed-out@^4.0.1")
          (s."url-parse-lax@^3.0.0")
          (s."url-to-options@^1.0.1")
        ];
        "got@^8.3.1" = s."got@8.3.2";
        "graceful-fs@4.1.15" = f "graceful-fs" "4.1.15" y "ffb703e1066e8a0eeaa4c8b80ba9253eeefbfb00" [];
        "graceful-fs@^4.1.11" = s."graceful-fs@4.1.15";
        "graceful-fs@^4.1.2" = s."graceful-fs@4.1.15";
        "graceful-fs@^4.1.6" = s."graceful-fs@4.1.15";
        "handlebars@4.0.12" = f "handlebars" "4.0.12" y "2c15c8a96d46da5e266700518ba8cb8d919d5bc5" [
          (s."async@^2.5.0")
          (s."optimist@^0.6.1")
          (s."source-map@^0.6.1")
          (s."uglify-js@^3.1.4")
        ];
        "handlebars@~4.0.11" = s."handlebars@4.0.12";
        "has-ansi@2.0.0" = f "has-ansi" "2.0.0" y "34f5049ce1ecdf2b0649af3ef24e45ed35416d91" [
          (s."ansi-regex@^2.0.0")
        ];
        "has-ansi@^2.0.0" = s."has-ansi@2.0.0";
        "has-flag@1.0.0" = f "has-flag" "1.0.0" y "9d9e793165ce017a00f00418c43f942a7b1d11fa" [];
        "has-flag@3.0.0" = f "has-flag" "3.0.0" y "b5d454dc2199ae225699f3467e5a07f3b955bafd" [];
        "has-flag@^1.0.0" = s."has-flag@1.0.0";
        "has-flag@^3.0.0" = s."has-flag@3.0.0";
        "has-symbol-support-x@1.4.2" = f "has-symbol-support-x" "1.4.2" y "1409f98bc00247da45da67cee0a36f282ff26455" [];
        "has-symbol-support-x@^1.4.1" = s."has-symbol-support-x@1.4.2";
        "has-symbols@1.0.0" = f "has-symbols" "1.0.0" y "ba1a8f1af2a0fc39650f5c850367704122063b44" [];
        "has-symbols@^1.0.0" = s."has-symbols@1.0.0";
        "has-to-string-tag-x@1.4.1" = f "has-to-string-tag-x" "1.4.1" y "a045ab383d7b4b2012a00148ab0aa5f290044d4d" [
          (s."has-symbol-support-x@^1.4.1")
        ];
        "has-to-string-tag-x@^1.2.0" = s."has-to-string-tag-x@1.4.1";
        "has-unicode@2.0.1" = f "has-unicode" "2.0.1" y "e0e6fe6a28cf51138855e086d1691e771de2a8b9" [];
        "has-unicode@^2.0.0" = s."has-unicode@2.0.1";
        "has-value@0.3.1" = f "has-value" "0.3.1" y "7b1f58bada62ca827ec0a2078025654845995e1f" [
          (s."get-value@^2.0.3")
          (s."has-values@^0.1.4")
          (s."isobject@^2.0.0")
        ];
        "has-value@1.0.0" = f "has-value" "1.0.0" y "18b281da585b1c5c51def24c930ed29a0be6b177" [
          (s."get-value@^2.0.6")
          (s."has-values@^1.0.0")
          (s."isobject@^3.0.0")
        ];
        "has-value@^0.3.1" = s."has-value@0.3.1";
        "has-value@^1.0.0" = s."has-value@1.0.0";
        "has-values@0.1.4" = f "has-values" "0.1.4" y "6d61de95d91dfca9b9a02089ad384bff8f62b771" [];
        "has-values@1.0.0" = f "has-values" "1.0.0" y "95b0b63fec2146619a6fe57fe75628d5a39efe4f" [
          (s."is-number@^3.0.0")
          (s."kind-of@^4.0.0")
        ];
        "has-values@^0.1.4" = s."has-values@0.1.4";
        "has-values@^1.0.0" = s."has-values@1.0.0";
        "has@1.0.3" = f "has" "1.0.3" y "722d7cbfc1f6aa8241f16dd814e011e1f41e8796" [
          (s."function-bind@^1.1.1")
        ];
        "has@^1.0.1" = s."has@1.0.3";
        "hash-base@3.0.4" = f "hash-base" "3.0.4" y "5fc8686847ecd73499403319a6b0a3f3f6ae4918" [
          (s."inherits@^2.0.1")
          (s."safe-buffer@^5.0.1")
        ];
        "hash-base@^3.0.0" = s."hash-base@3.0.4";
        "hash.js@1.1.7" = f "hash.js" "1.1.7" y "0babca538e8d4ee4a0f8988d68866537a003cf42" [
          (s."inherits@^2.0.3")
          (s."minimalistic-assert@^1.0.1")
        ];
        "hash.js@^1.0.0" = s."hash.js@1.1.7";
        "hash.js@^1.0.3" = s."hash.js@1.1.7";
        "he@1.2.0" = f "he" "1.2.0" y "84ae65fa7eafb165fddb61566ae14baf05664f0f" [];
        "he@1.2.x" = s."he@1.2.0";
        "hmac-drbg@1.0.1" = f "hmac-drbg" "1.0.1" y "d2745701025a6c775a6c545793ed502fc0c649a1" [
          (s."hash.js@^1.0.3")
          (s."minimalistic-assert@^1.0.0")
          (s."minimalistic-crypto-utils@^1.0.1")
        ];
        "hmac-drbg@^1.0.0" = s."hmac-drbg@1.0.1";
        "html-comment-regex@1.1.2" = f "html-comment-regex" "1.1.2" y "97d4688aeb5c81886a364faa0cad1dda14d433a7" [];
        "html-comment-regex@^1.1.0" = s."html-comment-regex@1.1.2";
        "html-loader@0.5.5" = f "html-loader" "0.5.5" y "6356dbeb0c49756d8ebd5ca327f16ff06ab5faea" [
          (s."es6-templates@^0.2.3")
          (s."fastparse@^1.1.1")
          (s."html-minifier@^3.5.8")
          (s."loader-utils@^1.1.0")
          (s."object-assign@^4.1.1")
        ];
        "html-loader@^0.5.1" = s."html-loader@0.5.5";
        "html-minifier@3.5.21" = f "html-minifier" "3.5.21" y "d0040e054730e354db008463593194015212d20c" [
          (s."camel-case@3.0.x")
          (s."clean-css@4.2.x")
          (s."commander@2.17.x")
          (s."he@1.2.x")
          (s."param-case@2.1.x")
          (s."relateurl@0.2.x")
          (s."uglify-js@3.4.x")
        ];
        "html-minifier@^3.2.3" = s."html-minifier@3.5.21";
        "html-minifier@^3.5.8" = s."html-minifier@3.5.21";
        "html-webpack-plugin@3.2.0" = f "html-webpack-plugin" "3.2.0" (ir "http://registry.npmjs.org/html-webpack-plugin/-/html-webpack-plugin-3.2.0.tgz") "b01abbd723acaaa7b37b6af4492ebda03d9dd37b" [
          (s."html-minifier@^3.2.3")
          (s."loader-utils@^0.2.16")
          (s."lodash@^4.17.3")
          (s."pretty-error@^2.0.2")
          (s."tapable@^1.0.0")
          (s."toposort@^1.0.0")
          (s."util.promisify@1.0.0")
        ];
        "html-webpack-plugin@~3.2.0" = s."html-webpack-plugin@3.2.0";
        "htmlparser2@3.10.0" = f "htmlparser2" "3.10.0" y "5f5e422dcf6119c0d983ed36260ce9ded0bee464" [
          (s."domelementtype@^1.3.0")
          (s."domhandler@^2.3.0")
          (s."domutils@^1.5.1")
          (s."entities@^1.1.1")
          (s."inherits@^2.0.1")
          (s."readable-stream@^3.0.6")
        ];
        "htmlparser2@3.3.0" = f "htmlparser2" "3.3.0" (ir "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.3.0.tgz") "cc70d05a59f6542e43f0e685c982e14c924a9efe" [
          (s."domelementtype@1")
          (s."domhandler@2.1")
          (s."domutils@1.1")
          (s."readable-stream@1.0")
        ];
        "htmlparser2@^3.9.0" = s."htmlparser2@3.10.0";
        "htmlparser2@~3.3.0" = s."htmlparser2@3.3.0";
        "http-cache-semantics@3.8.1" = f "http-cache-semantics" "3.8.1" y "39b0e16add9b605bf0a9ef3d9daaf4843b4cacd2" [];
        "https-browserify@1.0.0" = f "https-browserify" "1.0.0" y "ec06c10e0a34c0f2faf199f7fd7fc78fffd03c73" [];
        "https-browserify@^1.0.0" = s."https-browserify@1.0.0";
        "iconv-lite@0.4" = s."iconv-lite@0.4.24";
        "iconv-lite@0.4.24" = f "iconv-lite" "0.4.24" y "2022b4b25fbddc21d2f524974a474aafe733908b" [
          (s."safer-buffer@>= 2.1.2 < 3")
        ];
        "iconv-lite@^0.4.17" = s."iconv-lite@0.4.24";
        "iconv-lite@^0.4.4" = s."iconv-lite@0.4.24";
        "iconv-lite@~0.4.13" = s."iconv-lite@0.4.24";
        "icss-replace-symbols@1.1.0" = f "icss-replace-symbols" "1.1.0" y "06ea6f83679a7749e386cfe1fe812ae5db223ded" [];
        "icss-replace-symbols@^1.1.0" = s."icss-replace-symbols@1.1.0";
        "icss-utils@2.1.0" = f "icss-utils" "2.1.0" y "83f0a0ec378bf3246178b6c2ad9136f135b1c962" [
          (s."postcss@^6.0.1")
        ];
        "icss-utils@^2.1.0" = s."icss-utils@2.1.0";
        "ieee754@1.1.12" = f "ieee754" "1.1.12" y "50bf24e5b9c8bb98af4964c941cdb0918da7b60b" [];
        "ieee754@^1.1.11" = s."ieee754@1.1.12";
        "ieee754@^1.1.4" = s."ieee754@1.1.12";
        "iferr@0.1.5" = f "iferr" "0.1.5" y "c60eed69e6d8fdb6b3104a1fcbca1c192dc5b501" [];
        "iferr@^0.1.5" = s."iferr@0.1.5";
        "ignore-walk@3.0.1" = f "ignore-walk" "3.0.1" y "a83e62e7d272ac0e3b551aaa82831a19b69f82f8" [
          (s."minimatch@^3.0.4")
        ];
        "ignore-walk@^3.0.1" = s."ignore-walk@3.0.1";
        "import-local@2.0.0" = f "import-local" "2.0.0" y "55070be38a5993cf18ef6db7e961f5bee5c5a09d" [
          (s."pkg-dir@^3.0.0")
          (s."resolve-cwd@^2.0.0")
        ];
        "import-local@^2.0.0" = s."import-local@2.0.0";
        "imurmurhash@0.1.4" = f "imurmurhash" "0.1.4" y "9218b9b2b928a238b13dc4fb6b6d576f231453ea" [];
        "imurmurhash@^0.1.4" = s."imurmurhash@0.1.4";
        "indexes-of@1.0.1" = f "indexes-of" "1.0.1" y "f30f716c8e2bd346c7b67d3df3915566a7c05607" [];
        "indexes-of@^1.0.1" = s."indexes-of@1.0.1";
        "indexof@0.0.1" = f "indexof" "0.0.1" y "82dc336d232b9062179d05ab3293a66059fd435d" [];
        "inflight@1.0.6" = f "inflight" "1.0.6" y "49bd6331d7d02d0c09bc910a1075ba8165b56df9" [
          (s."once@^1.3.0")
          (s."wrappy@1")
        ];
        "inflight@^1.0.4" = s."inflight@1.0.6";
        "inherits@2" = s."inherits@2.0.3";
        "inherits@2.0.1" = f "inherits" "2.0.1" y "b17d08d326b4423e568eff719f91b0b1cbdf69f1" [];
        "inherits@2.0.3" = f "inherits" "2.0.3" y "633c2c83e3da42a502f52466022480f4208261de" [];
        "inherits@^2.0.1" = s."inherits@2.0.3";
        "inherits@^2.0.3" = s."inherits@2.0.3";
        "inherits@~2.0.1" = s."inherits@2.0.3";
        "inherits@~2.0.3" = s."inherits@2.0.3";
        "ini@1.3.5" = f "ini" "1.3.5" y "eee25f56db1c9ec6085e0c22778083f596abf927" [];
        "ini@~1.3.0" = s."ini@1.3.5";
        "inquirer@3.3.0" = f "inquirer" "3.3.0" y "9dd2f2ad765dcab1ff0443b491442a20ba227dc9" [
          (s."ansi-escapes@^3.0.0")
          (s."chalk@^2.0.0")
          (s."cli-cursor@^2.1.0")
          (s."cli-width@^2.0.0")
          (s."external-editor@^2.0.4")
          (s."figures@^2.0.0")
          (s."lodash@^4.3.0")
          (s."mute-stream@0.0.7")
          (s."run-async@^2.2.0")
          (s."rx-lite@^4.0.8")
          (s."rx-lite-aggregates@^4.0.8")
          (s."string-width@^2.1.0")
          (s."strip-ansi@^4.0.0")
          (s."through@^2.3.6")
        ];
        "inquirer@~3.3.0" = s."inquirer@3.3.0";
        "interpret@1.1.0" = f "interpret" "1.1.0" y "7ed1b1410c6a0e0f78cf95d3b8440c63f78b8614" [];
        "interpret@^1.1.0" = s."interpret@1.1.0";
        "into-stream@3.1.0" = f "into-stream" "3.1.0" (ir "http://registry.npmjs.org/into-stream/-/into-stream-3.1.0.tgz") "96fb0a936c12babd6ff1752a17d05616abd094c6" [
          (s."from2@^2.1.1")
          (s."p-is-promise@^1.1.0")
        ];
        "into-stream@^3.1.0" = s."into-stream@3.1.0";
        "invert-kv@1.0.0" = f "invert-kv" "1.0.0" y "104a8e4aaca6d3d8cd157a8ef8bfab2d7a3ffdb6" [];
        "invert-kv@2.0.0" = f "invert-kv" "2.0.0" y "7393f5afa59ec9ff5f67a27620d11c226e3eec02" [];
        "invert-kv@^1.0.0" = s."invert-kv@1.0.0";
        "invert-kv@^2.0.0" = s."invert-kv@2.0.0";
        "is-absolute-url@2.1.0" = f "is-absolute-url" "2.1.0" y "50530dfb84fcc9aa7dbe7852e83a37b93b9f2aa6" [];
        "is-absolute-url@^2.0.0" = s."is-absolute-url@2.1.0";
        "is-accessor-descriptor@0.1.6" = f "is-accessor-descriptor" "0.1.6" (ir "http://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz") "a9e12cb3ae8d876727eeef3843f8a0897b5c98d6" [
          (s."kind-of@^3.0.2")
        ];
        "is-accessor-descriptor@1.0.0" = f "is-accessor-descriptor" "1.0.0" y "169c2f6d3df1f992618072365c9b0ea1f6878656" [
          (s."kind-of@^6.0.0")
        ];
        "is-accessor-descriptor@^0.1.6" = s."is-accessor-descriptor@0.1.6";
        "is-accessor-descriptor@^1.0.0" = s."is-accessor-descriptor@1.0.0";
        "is-binary-path@1.0.1" = f "is-binary-path" "1.0.1" y "75f16642b480f187a711c814161fd3a4a7655898" [
          (s."binary-extensions@^1.0.0")
        ];
        "is-binary-path@^1.0.0" = s."is-binary-path@1.0.1";
        "is-buffer@1.1.6" = f "is-buffer" "1.1.6" y "efaa2ea9daa0d7ab2ea13a97b2b8ad51fefbe8be" [];
        "is-buffer@^1.1.5" = s."is-buffer@1.1.6";
        "is-callable@1.1.4" = f "is-callable" "1.1.4" y "1e1adf219e1eeb684d691f9d6a05ff0d30a24d75" [];
        "is-callable@^1.1.3" = s."is-callable@1.1.4";
        "is-callable@^1.1.4" = s."is-callable@1.1.4";
        "is-data-descriptor@0.1.4" = f "is-data-descriptor" "0.1.4" (ir "http://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz") "0b5ee648388e2c860282e793f1856fec3f301b56" [
          (s."kind-of@^3.0.2")
        ];
        "is-data-descriptor@1.0.0" = f "is-data-descriptor" "1.0.0" y "d84876321d0e7add03990406abbbbd36ba9268c7" [
          (s."kind-of@^6.0.0")
        ];
        "is-data-descriptor@^0.1.4" = s."is-data-descriptor@0.1.4";
        "is-data-descriptor@^1.0.0" = s."is-data-descriptor@1.0.0";
        "is-date-object@1.0.1" = f "is-date-object" "1.0.1" y "9aa20eb6aeebbff77fbd33e74ca01b33581d3a16" [];
        "is-date-object@^1.0.1" = s."is-date-object@1.0.1";
        "is-descriptor@0.1.6" = f "is-descriptor" "0.1.6" y "366d8240dde487ca51823b1ab9f07a10a78251ca" [
          (s."is-accessor-descriptor@^0.1.6")
          (s."is-data-descriptor@^0.1.4")
          (s."kind-of@^5.0.0")
        ];
        "is-descriptor@1.0.2" = f "is-descriptor" "1.0.2" y "3b159746a66604b04f8c81524ba365c5f14d86ec" [
          (s."is-accessor-descriptor@^1.0.0")
          (s."is-data-descriptor@^1.0.0")
          (s."kind-of@^6.0.2")
        ];
        "is-descriptor@^0.1.0" = s."is-descriptor@0.1.6";
        "is-descriptor@^1.0.0" = s."is-descriptor@1.0.2";
        "is-descriptor@^1.0.2" = s."is-descriptor@1.0.2";
        "is-extendable@0.1.1" = f "is-extendable" "0.1.1" y "62b110e289a471418e3ec36a617d472e301dfc89" [];
        "is-extendable@1.0.1" = f "is-extendable" "1.0.1" y "a7470f9e426733d81bd81e1155264e3a3507cab4" [
          (s."is-plain-object@^2.0.4")
        ];
        "is-extendable@^0.1.0" = s."is-extendable@0.1.1";
        "is-extendable@^0.1.1" = s."is-extendable@0.1.1";
        "is-extendable@^1.0.1" = s."is-extendable@1.0.1";
        "is-extglob@2.1.1" = f "is-extglob" "2.1.1" y "a88c02535791f02ed37c76a1b9ea9773c833f8c2" [];
        "is-extglob@^2.1.0" = s."is-extglob@2.1.1";
        "is-extglob@^2.1.1" = s."is-extglob@2.1.1";
        "is-fullwidth-code-point@1.0.0" = f "is-fullwidth-code-point" "1.0.0" y "ef9e31386f031a7f0d643af82fde50c457ef00cb" [
          (s."number-is-nan@^1.0.0")
        ];
        "is-fullwidth-code-point@2.0.0" = f "is-fullwidth-code-point" "2.0.0" y "a3b30a5c4f199183167aaab93beefae3ddfb654f" [];
        "is-fullwidth-code-point@^1.0.0" = s."is-fullwidth-code-point@1.0.0";
        "is-fullwidth-code-point@^2.0.0" = s."is-fullwidth-code-point@2.0.0";
        "is-glob@3.1.0" = f "is-glob" "3.1.0" y "7ba5ae24217804ac70707b96922567486cc3e84a" [
          (s."is-extglob@^2.1.0")
        ];
        "is-glob@4.0.0" = f "is-glob" "4.0.0" y "9521c76845cc2610a85203ddf080a958c2ffabc0" [
          (s."is-extglob@^2.1.1")
        ];
        "is-glob@^3.1.0" = s."is-glob@3.1.0";
        "is-glob@^4.0.0" = s."is-glob@4.0.0";
        "is-number@3.0.0" = f "is-number" "3.0.0" y "24fd6201a4782cf50561c810276afc7d12d71195" [
          (s."kind-of@^3.0.2")
        ];
        "is-number@^3.0.0" = s."is-number@3.0.0";
        "is-object@1.0.1" = f "is-object" "1.0.1" y "8952688c5ec2ffd6b03ecc85e769e02903083470" [];
        "is-object@^1.0.1" = s."is-object@1.0.1";
        "is-plain-obj@1.1.0" = f "is-plain-obj" "1.1.0" y "71a50c8429dfca773c92a390a4a03b39fcd51d3e" [];
        "is-plain-obj@^1.0.0" = s."is-plain-obj@1.1.0";
        "is-plain-object@2.0.4" = f "is-plain-object" "2.0.4" y "2c163b3fafb1b606d9d17928f05c2a1c38e07677" [
          (s."isobject@^3.0.1")
        ];
        "is-plain-object@^2.0.1" = s."is-plain-object@2.0.4";
        "is-plain-object@^2.0.3" = s."is-plain-object@2.0.4";
        "is-plain-object@^2.0.4" = s."is-plain-object@2.0.4";
        "is-promise@2.1.0" = f "is-promise" "2.1.0" y "79a2a9ece7f096e80f36d2b2f3bc16c1ff4bf3fa" [];
        "is-promise@^2.1.0" = s."is-promise@2.1.0";
        "is-regex@1.0.4" = f "is-regex" "1.0.4" y "5517489b547091b0930e095654ced25ee97e9491" [
          (s."has@^1.0.1")
        ];
        "is-regex@^1.0.4" = s."is-regex@1.0.4";
        "is-retry-allowed@1.1.0" = f "is-retry-allowed" "1.1.0" y "11a060568b67339444033d0125a61a20d564fb34" [];
        "is-retry-allowed@^1.1.0" = s."is-retry-allowed@1.1.0";
        "is-stream@1.1.0" = f "is-stream" "1.1.0" y "12d4a3dd4e68e0b79ceb8dbc84173ae80d91ca44" [];
        "is-stream@^1.0.1" = s."is-stream@1.1.0";
        "is-stream@^1.1.0" = s."is-stream@1.1.0";
        "is-svg@2.1.0" = f "is-svg" "2.1.0" y "cf61090da0d9efbcab8722deba6f032208dbb0e9" [
          (s."html-comment-regex@^1.1.0")
        ];
        "is-svg@^2.0.0" = s."is-svg@2.1.0";
        "is-symbol@1.0.2" = f "is-symbol" "1.0.2" y "a055f6ae57192caee329e7a860118b497a950f38" [
          (s."has-symbols@^1.0.0")
        ];
        "is-symbol@^1.0.2" = s."is-symbol@1.0.2";
        "is-windows@1.0.2" = f "is-windows" "1.0.2" y "d1850eb9791ecd18e6182ce12a30f396634bb19d" [];
        "is-windows@^1.0.2" = s."is-windows@1.0.2";
        "isarray@0.0.1" = f "isarray" "0.0.1" y "8a18acfca9a8f4177e09abfc6038939b05d1eedf" [];
        "isarray@1.0.0" = f "isarray" "1.0.0" y "bb935d48582cba168c06834957a54a3e07124f11" [];
        "isarray@^1.0.0" = s."isarray@1.0.0";
        "isarray@~1.0.0" = s."isarray@1.0.0";
        "isexe@2.0.0" = f "isexe" "2.0.0" y "e8fbf374dc556ff8947a10dcb0572d633f2cfa10" [];
        "isexe@^2.0.0" = s."isexe@2.0.0";
        "isobject@2.1.0" = f "isobject" "2.1.0" y "f065561096a3f1da2ef46272f815c840d87e0c89" [
          (s."isarray@1.0.0")
        ];
        "isobject@3.0.1" = f "isobject" "3.0.1" y "4e431e92b11a9731636aa1f9c8d1ccbcfdab78df" [];
        "isobject@^2.0.0" = s."isobject@2.1.0";
        "isobject@^3.0.0" = s."isobject@3.0.1";
        "isobject@^3.0.1" = s."isobject@3.0.1";
        "isomorphic-fetch@2.2.1" = f "isomorphic-fetch" "2.2.1" y "611ae1acf14f5e81f729507472819fe9733558a9" [
          (s."node-fetch@^1.0.1")
          (s."whatwg-fetch@>=0.10.0")
        ];
        "isomorphic-fetch@^2.1.1" = s."isomorphic-fetch@2.2.1";
        "isurl@1.0.0" = f "isurl" "1.0.0" y "b27f4f49f3cdaa3ea44a0a5b7f3462e6edc39d67" [
          (s."has-to-string-tag-x@^1.2.0")
          (s."is-object@^1.0.1")
        ];
        "isurl@^1.0.0-alpha5" = s."isurl@1.0.0";
        "js-base64@2.4.9" = f "js-base64" "2.4.9" y "748911fb04f48a60c4771b375cac45a80df11c03" [];
        "js-base64@^2.1.9" = s."js-base64@2.4.9";
        "js-tokens@3.0.2" = f "js-tokens" "3.0.2" y "9866df395102130e38f7f996bceb65443209c25b" [];
        "js-tokens@4.0.0" = f "js-tokens" "4.0.0" y "19203fb59991df98e3a287050d4647cdeaf32499" [];
        "js-tokens@^3.0.0 || ^4.0.0" = s."js-tokens@4.0.0";
        "js-tokens@^3.0.2" = s."js-tokens@3.0.2";
        "js-yaml@3.7.0" = f "js-yaml" "3.7.0" y "5c967ddd837a9bfdca5f2de84253abe8a1c03b80" [
          (s."argparse@^1.0.7")
          (s."esprima@^2.6.0")
        ];
        "js-yaml@~3.7.0" = s."js-yaml@3.7.0";
        "jsesc@0.5.0" = f "jsesc" "0.5.0" (ir "http://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz") "e7dee66e35d6fc16f710fe91d5cf69f70f08911d" [];
        "jsesc@~0.5.0" = s."jsesc@0.5.0";
        "json-buffer@3.0.0" = f "json-buffer" "3.0.0" y "5b1f397afc75d677bde8bcfc0e47e1f9a3d9a898" [];
        "json-parse-better-errors@1.0.2" = f "json-parse-better-errors" "1.0.2" y "bb867cfb3450e69107c131d1c514bab3dc8bcaa9" [];
        "json-parse-better-errors@^1.0.2" = s."json-parse-better-errors@1.0.2";
        "json-parser@1.1.5" = f "json-parser" "1.1.5" y "e62ec5261d1a6a5fc20e812a320740c6d9005677" [
          (s."esprima@^2.7.0")
        ];
        "json-parser@^1.0.0" = s."json-parser@1.1.5";
        "json-schema-traverse@0.3.1" = f "json-schema-traverse" "0.3.1" y "349a6d44c53a51de89b40805c5d5e59b417d3340" [];
        "json-schema-traverse@0.4.1" = f "json-schema-traverse" "0.4.1" y "69f6a87d9513ab8bb8fe63bdb0979c448e684660" [];
        "json-schema-traverse@^0.3.0" = s."json-schema-traverse@0.3.1";
        "json-schema-traverse@^0.4.1" = s."json-schema-traverse@0.4.1";
        "json-stable-stringify@1.0.1" = f "json-stable-stringify" "1.0.1" y "9a759d39c5f2ff503fd5300646ed445f88c4f9af" [
          (s."jsonify@~0.0.0")
        ];
        "json-stable-stringify@^1.0.1" = s."json-stable-stringify@1.0.1";
        "json-stringify-pretty-compact@1.2.0" = f "json-stringify-pretty-compact" "1.2.0" y "0bc316b5e6831c07041fc35612487fb4e9ab98b8" [];
        "json-stringify-pretty-compact@^1.2.0" = s."json-stringify-pretty-compact@1.2.0";
        "json5@0.5.1" = f "json5" "0.5.1" (ir "http://registry.npmjs.org/json5/-/json5-0.5.1.tgz") "1eade7acc012034ad84e2396767ead9fa5495821" [];
        "json5@^0.5.0" = s."json5@0.5.1";
        "jsonfile@4.0.0" = f "jsonfile" "4.0.0" y "8771aae0799b64076b76640fca058f9c10e33ecb" [
          (s."graceful-fs@^4.1.6")
        ];
        "jsonfile@^4.0.0" = s."jsonfile@4.0.0";
        "jsonify@0.0.0" = f "jsonify" "0.0.0" y "2c74b6ee41d93ca51b7b5aaee8f503631d252a73" [];
        "jsonify@~0.0.0" = s."jsonify@0.0.0";
        "keyv@3.0.0" = f "keyv" "3.0.0" y "44923ba39e68b12a7cec7df6c3268c031f2ef373" [
          (s."json-buffer@3.0.0")
        ];
        "kind-of@3.2.2" = f "kind-of" "3.2.2" y "31ea21a734bab9bbb0f32466d893aea51e4a3c64" [
          (s."is-buffer@^1.1.5")
        ];
        "kind-of@4.0.0" = f "kind-of" "4.0.0" y "20813df3d712928b207378691a45066fae72dd57" [
          (s."is-buffer@^1.1.5")
        ];
        "kind-of@5.1.0" = f "kind-of" "5.1.0" y "729c91e2d857b7a419a1f9aa65685c4c33f5845d" [];
        "kind-of@6.0.2" = f "kind-of" "6.0.2" y "01146b36a6218e64e58f3a8d66de5d7fc6f6d051" [];
        "kind-of@^3.0.2" = s."kind-of@3.2.2";
        "kind-of@^3.0.3" = s."kind-of@3.2.2";
        "kind-of@^3.2.0" = s."kind-of@3.2.2";
        "kind-of@^4.0.0" = s."kind-of@4.0.0";
        "kind-of@^5.0.0" = s."kind-of@5.1.0";
        "kind-of@^6.0.0" = s."kind-of@6.0.2";
        "kind-of@^6.0.2" = s."kind-of@6.0.2";
        "lcid@1.0.0" = f "lcid" "1.0.0" y "308accafa0bc483a3867b4b6f2b9506251d1b835" [
          (s."invert-kv@^1.0.0")
        ];
        "lcid@2.0.0" = f "lcid" "2.0.0" y "6ef5d2df60e52f82eb228a4c373e8d1f397253cf" [
          (s."invert-kv@^2.0.0")
        ];
        "lcid@^1.0.0" = s."lcid@1.0.0";
        "lcid@^2.0.0" = s."lcid@2.0.0";
        "leb@0.3.0" = f "leb" "0.3.0" y "32bee9fad168328d6aea8522d833f4180eed1da3" [];
        "leb@^0.3.0" = s."leb@0.3.0";
        "loader-runner@2.3.1" = f "loader-runner" "2.3.1" y "026f12fe7c3115992896ac02ba022ba92971b979" [];
        "loader-runner@^2.3.0" = s."loader-runner@2.3.1";
        "loader-utils@0.2.17" = f "loader-utils" "0.2.17" y "f86e6374d43205a6e6c60e9196f17c0299bfb348" [
          (s."big.js@^3.1.3")
          (s."emojis-list@^2.0.0")
          (s."json5@^0.5.0")
          (s."object-assign@^4.0.1")
        ];
        "loader-utils@1.1.0" = f "loader-utils" "1.1.0" y "c98aef488bcceda2ffb5e2de646d6a754429f5cd" [
          (s."big.js@^3.1.3")
          (s."emojis-list@^2.0.0")
          (s."json5@^0.5.0")
        ];
        "loader-utils@^0.2.16" = s."loader-utils@0.2.17";
        "loader-utils@^1.0.2" = s."loader-utils@1.1.0";
        "loader-utils@^1.1.0" = s."loader-utils@1.1.0";
        "locate-path@2.0.0" = f "locate-path" "2.0.0" y "2b568b265eec944c6d9c0de9c3dbbbca0354cd8e" [
          (s."p-locate@^2.0.0")
          (s."path-exists@^3.0.0")
        ];
        "locate-path@3.0.0" = f "locate-path" "3.0.0" y "dbec3b3ab759758071b58fe59fc41871af21400e" [
          (s."p-locate@^3.0.0")
          (s."path-exists@^3.0.0")
        ];
        "locate-path@^2.0.0" = s."locate-path@2.0.0";
        "locate-path@^3.0.0" = s."locate-path@3.0.0";
        "lodash.camelcase@4.3.0" = f "lodash.camelcase" "4.3.0" y "b28aa6288a2b9fc651035c7711f65ab6190331a6" [];
        "lodash.camelcase@^4.3.0" = s."lodash.camelcase@4.3.0";
        "lodash.clonedeep@4.5.0" = f "lodash.clonedeep" "4.5.0" y "e23f3f9c4f8fbdde872529c1071857a086e5ccef" [];
        "lodash.clonedeep@^4.5.0" = s."lodash.clonedeep@4.5.0";
        "lodash.curry@4.1.1" = f "lodash.curry" "4.1.1" y "248e36072ede906501d75966200a86dab8b23170" [];
        "lodash.curry@^4.0.1" = s."lodash.curry@4.1.1";
        "lodash.debounce@4.0.8" = f "lodash.debounce" "4.0.8" y "82d79bff30a67c4005ffd5e2515300ad9ca4d7af" [];
        "lodash.debounce@^4.0.8" = s."lodash.debounce@4.0.8";
        "lodash.escaperegexp@4.1.2" = f "lodash.escaperegexp" "4.1.2" y "64762c48618082518ac3df4ccf5d5886dae20347" [];
        "lodash.escaperegexp@^4.1.2" = s."lodash.escaperegexp@4.1.2";
        "lodash.flow@3.5.0" = f "lodash.flow" "3.5.0" y "87bf40292b8cf83e4e8ce1a3ae4209e20071675a" [];
        "lodash.flow@^3.3.0" = s."lodash.flow@3.5.0";
        "lodash.isplainobject@4.0.6" = f "lodash.isplainobject" "4.0.6" y "7c526a52d89b45c45cc690b88163be0497f550cb" [];
        "lodash.isplainobject@^4.0.6" = s."lodash.isplainobject@4.0.6";
        "lodash.isstring@4.0.1" = f "lodash.isstring" "4.0.1" y "d527dfb5456eca7cc9bb95d5daeaf88ba54a5451" [];
        "lodash.isstring@^4.0.1" = s."lodash.isstring@4.0.1";
        "lodash.memoize@4.1.2" = f "lodash.memoize" "4.1.2" y "bcc6c49a42a2840ed997f323eada5ecd182e0bfe" [];
        "lodash.memoize@^4.1.2" = s."lodash.memoize@4.1.2";
        "lodash.mergewith@4.6.1" = f "lodash.mergewith" "4.6.1" y "639057e726c3afbdb3e7d42741caa8d6e4335927" [];
        "lodash.mergewith@^4.6.0" = s."lodash.mergewith@4.6.1";
        "lodash.uniq@4.5.0" = f "lodash.uniq" "4.5.0" y "d0225373aeb652adc1bc82e4945339a842754773" [];
        "lodash.uniq@^4.5.0" = s."lodash.uniq@4.5.0";
        "lodash@4.17.11" = f "lodash" "4.17.11" y "b39ea6229ef607ecd89e2c8df12536891cac9b8d" [];
        "lodash@^4.17.10" = s."lodash@4.17.11";
        "lodash@^4.17.3" = s."lodash@4.17.11";
        "lodash@^4.17.4" = s."lodash@4.17.11";
        "lodash@^4.17.5" = s."lodash@4.17.11";
        "lodash@^4.3.0" = s."lodash@4.17.11";
        "long@3.2.0" = f "long" "3.2.0" y "d821b7138ca1cb581c172990ef14db200b5c474b" [];
        "long@^3.2.0" = s."long@3.2.0";
        "loose-envify@1.4.0" = f "loose-envify" "1.4.0" y "71ee51fa7be4caec1a63839f7e682d8132d30caf" [
          (s."js-tokens@^3.0.0 || ^4.0.0")
        ];
        "loose-envify@^1.0.0" = s."loose-envify@1.4.0";
        "loose-envify@^1.1.0" = s."loose-envify@1.4.0";
        "loose-envify@^1.3.1" = s."loose-envify@1.4.0";
        "lower-case@1.1.4" = f "lower-case" "1.1.4" y "9a2cabd1b9e8e0ae993a4bf7d5875c39c42e8eac" [];
        "lower-case@^1.1.1" = s."lower-case@1.1.4";
        "lowercase-keys@1.0.0" = f "lowercase-keys" "1.0.0" y "4e3366b39e7f5457e35f1324bdf6f88d0bfc7306" [];
        "lowercase-keys@1.0.1" = f "lowercase-keys" "1.0.1" y "6f9e30b47084d971a7c820ff15a6c5167b74c26f" [];
        "lowercase-keys@^1.0.0" = s."lowercase-keys@1.0.1";
        "lru-cache@4.1.5" = f "lru-cache" "4.1.5" y "8bbe50ea85bed59bc9e33dcab8235ee9bcf443cd" [
          (s."pseudomap@^1.0.2")
          (s."yallist@^2.1.2")
        ];
        "lru-cache@^4.0.1" = s."lru-cache@4.1.5";
        "lru-cache@^4.1.1" = s."lru-cache@4.1.5";
        "make-dir@1.3.0" = f "make-dir" "1.3.0" y "79c1033b80515bd6d24ec9933e860ca75ee27f0c" [
          (s."pify@^3.0.0")
        ];
        "make-dir@^1.0.0" = s."make-dir@1.3.0";
        "mamacro@0.0.3" = f "mamacro" "0.0.3" y "ad2c9576197c9f1abf308d0787865bd975a3f3e4" [];
        "mamacro@^0.0.3" = s."mamacro@0.0.3";
        "map-age-cleaner@0.1.3" = f "map-age-cleaner" "0.1.3" y "7d583a7306434c055fe474b0f45078e6e1b4b92a" [
          (s."p-defer@^1.0.0")
        ];
        "map-age-cleaner@^0.1.1" = s."map-age-cleaner@0.1.3";
        "map-cache@0.2.2" = f "map-cache" "0.2.2" y "c32abd0bd6525d9b051645bb4f26ac5dc98a0dbf" [];
        "map-cache@^0.2.2" = s."map-cache@0.2.2";
        "map-visit@1.0.0" = f "map-visit" "1.0.0" y "ecdca8f13144e660f1b5bd41f12f3479d98dfb8f" [
          (s."object-visit@^1.0.0")
        ];
        "map-visit@^1.0.0" = s."map-visit@1.0.0";
        "marked@0.4.0" = f "marked" "0.4.0" y "9ad2c2a7a1791f10a852e0112f77b571dce10c66" [];
        "marked@~0.4.0" = s."marked@0.4.0";
        "math-expression-evaluator@1.2.17" = f "math-expression-evaluator" "1.2.17" y "de819fdbcd84dccd8fae59c6aeb79615b9d266ac" [];
        "math-expression-evaluator@^1.2.14" = s."math-expression-evaluator@1.2.17";
        "md5.js@1.3.5" = f "md5.js" "1.3.5" y "b5d07b8e3216e3e27cd728d72f70d1e6a342005f" [
          (s."hash-base@^3.0.0")
          (s."inherits@^2.0.1")
          (s."safe-buffer@^5.1.2")
        ];
        "md5.js@^1.3.4" = s."md5.js@1.3.5";
        "mem@1.1.0" = f "mem" "1.1.0" y "5edd52b485ca1d900fe64895505399a0dfa45f76" [
          (s."mimic-fn@^1.0.0")
        ];
        "mem@4.0.0" = f "mem" "4.0.0" y "6437690d9471678f6cc83659c00cbafcd6b0cdaf" [
          (s."map-age-cleaner@^0.1.1")
          (s."mimic-fn@^1.0.0")
          (s."p-is-promise@^1.1.0")
        ];
        "mem@^1.1.0" = s."mem@1.1.0";
        "mem@^4.0.0" = s."mem@4.0.0";
        "memory-fs@0.4.1" = f "memory-fs" "0.4.1" y "3a9a20b8462523e447cfbc7e8bb80ed667bfc552" [
          (s."errno@^0.1.3")
          (s."readable-stream@^2.0.1")
        ];
        "memory-fs@^0.4.0" = s."memory-fs@0.4.1";
        "memory-fs@~0.4.1" = s."memory-fs@0.4.1";
        "micromatch@3.1.10" = f "micromatch" "3.1.10" y "70859bc95c9840952f359a068a3fc49f9ecfac23" [
          (s."arr-diff@^4.0.0")
          (s."array-unique@^0.3.2")
          (s."braces@^2.3.1")
          (s."define-property@^2.0.2")
          (s."extend-shallow@^3.0.2")
          (s."extglob@^2.0.4")
          (s."fragment-cache@^0.2.1")
          (s."kind-of@^6.0.2")
          (s."nanomatch@^1.2.9")
          (s."object.pick@^1.3.0")
          (s."regex-not@^1.0.0")
          (s."snapdragon@^0.8.1")
          (s."to-regex@^3.0.2")
        ];
        "micromatch@^3.1.10" = s."micromatch@3.1.10";
        "micromatch@^3.1.4" = s."micromatch@3.1.10";
        "micromatch@^3.1.8" = s."micromatch@3.1.10";
        "miller-rabin@4.0.1" = f "miller-rabin" "4.0.1" y "f080351c865b0dc562a8462966daa53543c78a4d" [
          (s."bn.js@^4.0.0")
          (s."brorand@^1.0.1")
        ];
        "miller-rabin@^4.0.0" = s."miller-rabin@4.0.1";
        "mime@2.4.0" = f "mime" "2.4.0" y "e051fd881358585f3279df333fe694da0bcffdd6" [];
        "mime@^2.0.3" = s."mime@2.4.0";
        "mimic-fn@1.2.0" = f "mimic-fn" "1.2.0" y "820c86a39334640e99516928bd03fca88057d022" [];
        "mimic-fn@^1.0.0" = s."mimic-fn@1.2.0";
        "mimic-response@1.0.1" = f "mimic-response" "1.0.1" y "4923538878eef42063cb8a3e3b0798781487ab1b" [];
        "mimic-response@^1.0.0" = s."mimic-response@1.0.1";
        "minimalistic-assert@1.0.1" = f "minimalistic-assert" "1.0.1" y "2e194de044626d4a10e7f7fbc00ce73e83e4d5c7" [];
        "minimalistic-assert@^1.0.0" = s."minimalistic-assert@1.0.1";
        "minimalistic-assert@^1.0.1" = s."minimalistic-assert@1.0.1";
        "minimalistic-crypto-utils@1.0.1" = f "minimalistic-crypto-utils" "1.0.1" y "f6c00c1c0b082246e5c4d99dfb8c7c083b2b582a" [];
        "minimalistic-crypto-utils@^1.0.0" = s."minimalistic-crypto-utils@1.0.1";
        "minimalistic-crypto-utils@^1.0.1" = s."minimalistic-crypto-utils@1.0.1";
        "minimatch@3.0.4" = f "minimatch" "3.0.4" y "5166e286457f03306064be5497e8dbb0c3d32083" [
          (s."brace-expansion@^1.1.7")
        ];
        "minimatch@^3.0.4" = s."minimatch@3.0.4";
        "minimist@0.0.10" = f "minimist" "0.0.10" (ir "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz") "de3f98543dbf96082be48ad1a0c7cda836301dcf" [];
        "minimist@0.0.8" = f "minimist" "0.0.8" (ir "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz") "857fcabfc3397d2625b8228262e86aa7a011b05d" [];
        "minimist@1.2.0" = f "minimist" "1.2.0" (ir "http://registry.npmjs.org/minimist/-/minimist-1.2.0.tgz") "a35008b20f41383eec1fb914f4cd5df79a264284" [];
        "minimist@^1.2.0" = s."minimist@1.2.0";
        "minimist@~0.0.1" = s."minimist@0.0.10";
        "minimist@~1.2.0" = s."minimist@1.2.0";
        "minipass@2.3.5" = f "minipass" "2.3.5" y "cacebe492022497f656b0f0f51e2682a9ed2d848" [
          (s."safe-buffer@^5.1.2")
          (s."yallist@^3.0.0")
        ];
        "minipass@^2.2.1" = s."minipass@2.3.5";
        "minipass@^2.3.4" = s."minipass@2.3.5";
        "minizlib@1.2.1" = f "minizlib" "1.2.1" y "dd27ea6136243c7c880684e8672bb3a45fd9b614" [
          (s."minipass@^2.2.1")
        ];
        "minizlib@^1.1.1" = s."minizlib@1.2.1";
        "mississippi@2.0.0" = f "mississippi" "2.0.0" y "3442a508fafc28500486feea99409676e4ee5a6f" [
          (s."concat-stream@^1.5.0")
          (s."duplexify@^3.4.2")
          (s."end-of-stream@^1.1.0")
          (s."flush-write-stream@^1.0.0")
          (s."from2@^2.1.0")
          (s."parallel-transform@^1.1.0")
          (s."pump@^2.0.1")
          (s."pumpify@^1.3.3")
          (s."stream-each@^1.1.0")
          (s."through2@^2.0.0")
        ];
        "mississippi@^2.0.0" = s."mississippi@2.0.0";
        "mixin-deep@1.3.1" = f "mixin-deep" "1.3.1" y "a49e7268dce1a0d9698e45326c5626df3543d0fe" [
          (s."for-in@^1.0.2")
          (s."is-extendable@^1.0.1")
        ];
        "mixin-deep@^1.2.0" = s."mixin-deep@1.3.1";
        "mkdirp@0.5.1" = f "mkdirp" "0.5.1" (ir "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz") "30057438eac6cf7f8c4767f38648d6697d75c903" [
          (s."minimist@0.0.8")
        ];
        "mkdirp@^0.5.0" = s."mkdirp@0.5.1";
        "mkdirp@^0.5.1" = s."mkdirp@0.5.1";
        "mkdirp@~0.5.0" = s."mkdirp@0.5.1";
        "mkdirp@~0.5.1" = s."mkdirp@0.5.1";
        "moment@2.21.0" = f "moment" "2.21.0" (ir "http://registry.npmjs.org/moment/-/moment-2.21.0.tgz") "2a114b51d2a6ec9e6d83cf803f838a878d8a023a" [];
        "moment@~2.21.0" = s."moment@2.21.0";
        "move-concurrently@1.0.1" = f "move-concurrently" "1.0.1" y "be2c005fda32e0b29af1f05d7c4b33214c701f92" [
          (s."aproba@^1.1.1")
          (s."copy-concurrently@^1.0.0")
          (s."fs-write-stream-atomic@^1.0.8")
          (s."mkdirp@^0.5.1")
          (s."rimraf@^2.5.4")
          (s."run-queue@^1.0.3")
        ];
        "move-concurrently@^1.0.1" = s."move-concurrently@1.0.1";
        "ms@2.0.0" = f "ms" "2.0.0" y "5608aeadfc00be6c2901df5f9861788de0d597c8" [];
        "ms@2.1.1" = f "ms" "2.1.1" y "30a5864eb3ebb0a66f2ebe6d727af06a09d86e0a" [];
        "ms@^2.1.1" = s."ms@2.1.1";
        "mute-stream@0.0.7" = f "mute-stream" "0.0.7" y "3075ce93bc21b8fab43e1bc4da7e8115ed1e7bab" [];
        "nan@2.11.1" = f "nan" "2.11.1" y "90e22bccb8ca57ea4cd37cc83d3819b52eea6766" [];
        "nan@^2.9.2" = s."nan@2.11.1";
        "nanomatch@1.2.13" = f "nanomatch" "1.2.13" y "b87a8aa4fc0de8fe6be88895b38983ff265bd119" [
          (s."arr-diff@^4.0.0")
          (s."array-unique@^0.3.2")
          (s."define-property@^2.0.2")
          (s."extend-shallow@^3.0.2")
          (s."fragment-cache@^0.2.1")
          (s."is-windows@^1.0.2")
          (s."kind-of@^6.0.2")
          (s."object.pick@^1.3.0")
          (s."regex-not@^1.0.0")
          (s."snapdragon@^0.8.1")
          (s."to-regex@^3.0.1")
        ];
        "nanomatch@^1.2.9" = s."nanomatch@1.2.13";
        "needle@2.2.4" = f "needle" "2.2.4" y "51931bff82533b1928b7d1d69e01f1b00ffd2a4e" [
          (s."debug@^2.1.2")
          (s."iconv-lite@^0.4.4")
          (s."sax@^1.2.4")
        ];
        "needle@^2.2.1" = s."needle@2.2.4";
        "neo-async@2.6.0" = f "neo-async" "2.6.0" y "b9d15e4d71c6762908654b5183ed38b753340835" [];
        "neo-async@^2.5.0" = s."neo-async@2.6.0";
        "nice-try@1.0.5" = f "nice-try" "1.0.5" y "a3378a7696ce7d223e88fc9b764bd7ef1089e366" [];
        "nice-try@^1.0.4" = s."nice-try@1.0.5";
        "no-case@2.3.2" = f "no-case" "2.3.2" y "60b813396be39b3f1288a4c1ed5d1e7d28b464ac" [
          (s."lower-case@^1.1.1")
        ];
        "no-case@^2.2.0" = s."no-case@2.3.2";
        "node-fetch@1.7.3" = f "node-fetch" "1.7.3" y "980f6f72d85211a5347c6b2bc18c5b84c3eb47ef" [
          (s."encoding@^0.1.11")
          (s."is-stream@^1.0.1")
        ];
        "node-fetch@2.3.0" = f "node-fetch" "2.3.0" y "1a1d940bbfb916a1d3e0219f037e89e71f8c5fa5" [];
        "node-fetch@^1.0.1" = s."node-fetch@1.7.3";
        "node-fetch@^2.3.0" = s."node-fetch@2.3.0";
        "node-libs-browser@2.1.0" = f "node-libs-browser" "2.1.0" y "5f94263d404f6e44767d726901fff05478d600df" [
          (s."assert@^1.1.1")
          (s."browserify-zlib@^0.2.0")
          (s."buffer@^4.3.0")
          (s."console-browserify@^1.1.0")
          (s."constants-browserify@^1.0.0")
          (s."crypto-browserify@^3.11.0")
          (s."domain-browser@^1.1.1")
          (s."events@^1.0.0")
          (s."https-browserify@^1.0.0")
          (s."os-browserify@^0.3.0")
          (s."path-browserify@0.0.0")
          (s."process@^0.11.10")
          (s."punycode@^1.2.4")
          (s."querystring-es3@^0.2.0")
          (s."readable-stream@^2.3.3")
          (s."stream-browserify@^2.0.1")
          (s."stream-http@^2.7.2")
          (s."string_decoder@^1.0.0")
          (s."timers-browserify@^2.0.4")
          (s."tty-browserify@0.0.0")
          (s."url@^0.11.0")
          (s."util@^0.10.3")
          (s."vm-browserify@0.0.4")
        ];
        "node-libs-browser@^2.0.0" = s."node-libs-browser@2.1.0";
        "node-pre-gyp@0.10.3" = f "node-pre-gyp" "0.10.3" y "3070040716afdc778747b61b6887bf78880b80fc" [
          (s."detect-libc@^1.0.2")
          (s."mkdirp@^0.5.1")
          (s."needle@^2.2.1")
          (s."nopt@^4.0.1")
          (s."npm-packlist@^1.1.6")
          (s."npmlog@^4.0.2")
          (s."rc@^1.2.7")
          (s."rimraf@^2.6.1")
          (s."semver@^5.3.0")
          (s."tar@^4")
        ];
        "node-pre-gyp@^0.10.0" = s."node-pre-gyp@0.10.3";
        "nopt@4.0.1" = f "nopt" "4.0.1" y "d0d4685afd5415193c8c7505602d0d17cd64474d" [
          (s."abbrev@1")
          (s."osenv@^0.1.4")
        ];
        "nopt@^4.0.1" = s."nopt@4.0.1";
        "normalize-path@2.1.1" = f "normalize-path" "2.1.1" y "1ab28b556e198363a8c1a6f7e6fa20137fe6aed9" [
          (s."remove-trailing-separator@^1.0.1")
        ];
        "normalize-path@^2.1.1" = s."normalize-path@2.1.1";
        "normalize-range@0.1.2" = f "normalize-range" "0.1.2" y "2d10c06bdfd312ea9777695a4d28439456b75942" [];
        "normalize-range@^0.1.2" = s."normalize-range@0.1.2";
        "normalize-url@1.9.1" = f "normalize-url" "1.9.1" y "2cc0d66b31ea23036458436e3620d85954c66c3c" [
          (s."object-assign@^4.0.1")
          (s."prepend-http@^1.0.0")
          (s."query-string@^4.1.0")
          (s."sort-keys@^1.0.0")
        ];
        "normalize-url@2.0.1" = f "normalize-url" "2.0.1" y "835a9da1551fa26f70e92329069a23aa6574d7e6" [
          (s."prepend-http@^2.0.0")
          (s."query-string@^5.0.1")
          (s."sort-keys@^2.0.0")
        ];
        "normalize-url@^1.4.0" = s."normalize-url@1.9.1";
        "npm-bundled@1.0.5" = f "npm-bundled" "1.0.5" y "3c1732b7ba936b3a10325aef616467c0ccbcc979" [];
        "npm-bundled@^1.0.1" = s."npm-bundled@1.0.5";
        "npm-packlist@1.1.12" = f "npm-packlist" "1.1.12" y "22bde2ebc12e72ca482abd67afc51eb49377243a" [
          (s."ignore-walk@^3.0.1")
          (s."npm-bundled@^1.0.1")
        ];
        "npm-packlist@^1.1.6" = s."npm-packlist@1.1.12";
        "npm-run-path@2.0.2" = f "npm-run-path" "2.0.2" y "35a9232dfa35d7067b4cb2ddf2357b1871536c5f" [
          (s."path-key@^2.0.0")
        ];
        "npm-run-path@^2.0.0" = s."npm-run-path@2.0.2";
        "npmlog@4.1.2" = f "npmlog" "4.1.2" y "08a7f2a8bf734604779a9efa4ad5cc717abb954b" [
          (s."are-we-there-yet@~1.1.2")
          (s."console-control-strings@~1.1.0")
          (s."gauge@~2.7.3")
          (s."set-blocking@~2.0.0")
        ];
        "npmlog@^4.0.2" = s."npmlog@4.1.2";
        "nth-check@1.0.2" = f "nth-check" "1.0.2" y "b2bd295c37e3dd58a3bf0700376663ba4d9cf05c" [
          (s."boolbase@~1.0.0")
        ];
        "nth-check@~1.0.1" = s."nth-check@1.0.2";
        "num2fraction@1.2.2" = f "num2fraction" "1.2.2" y "6f682b6a027a4e9ddfa4564cd2589d1d4e669ede" [];
        "num2fraction@^1.2.2" = s."num2fraction@1.2.2";
        "number-is-nan@1.0.1" = f "number-is-nan" "1.0.1" y "097b602b53422a522c1afb8790318336941a011d" [];
        "number-is-nan@^1.0.0" = s."number-is-nan@1.0.1";
        "object-assign@4.1.1" = f "object-assign" "4.1.1" y "2109adc7965887cfc05cbbd442cac8bfbb360863" [];
        "object-assign@^4.0.1" = s."object-assign@4.1.1";
        "object-assign@^4.1.0" = s."object-assign@4.1.1";
        "object-assign@^4.1.1" = s."object-assign@4.1.1";
        "object-copy@0.1.0" = f "object-copy" "0.1.0" y "7e7d858b781bd7c991a41ba975ed3812754e998c" [
          (s."copy-descriptor@^0.1.0")
          (s."define-property@^0.2.5")
          (s."kind-of@^3.0.3")
        ];
        "object-copy@^0.1.0" = s."object-copy@0.1.0";
        "object-keys@1.0.12" = f "object-keys" "1.0.12" y "09c53855377575310cca62f55bb334abff7b3ed2" [];
        "object-keys@^1.0.12" = s."object-keys@1.0.12";
        "object-visit@1.0.1" = f "object-visit" "1.0.1" y "f79c4493af0c5377b59fe39d395e41042dd045bb" [
          (s."isobject@^3.0.0")
        ];
        "object-visit@^1.0.0" = s."object-visit@1.0.1";
        "object.getownpropertydescriptors@2.0.3" = f "object.getownpropertydescriptors" "2.0.3" y "8758c846f5b407adab0f236e0986f14b051caa16" [
          (s."define-properties@^1.1.2")
          (s."es-abstract@^1.5.1")
        ];
        "object.getownpropertydescriptors@^2.0.3" = s."object.getownpropertydescriptors@2.0.3";
        "object.pick@1.3.0" = f "object.pick" "1.3.0" y "87a10ac4c1694bd2e1cbf53591a66141fb5dd747" [
          (s."isobject@^3.0.1")
        ];
        "object.pick@^1.3.0" = s."object.pick@1.3.0";
        "once@1.4.0" = f "once" "1.4.0" y "583b1aa775961d4b113ac17d9c50baef9dd76bd1" [
          (s."wrappy@1")
        ];
        "once@^1.3.0" = s."once@1.4.0";
        "once@^1.3.1" = s."once@1.4.0";
        "once@^1.4.0" = s."once@1.4.0";
        "onetime@2.0.1" = f "onetime" "2.0.1" y "067428230fd67443b2794b22bba528b6867962d4" [
          (s."mimic-fn@^1.0.0")
        ];
        "onetime@^2.0.0" = s."onetime@2.0.1";
        "optimist@0.6.1" = f "optimist" "0.6.1" y "da3ea74686fa21a19a111c326e90eb15a0196686" [
          (s."minimist@~0.0.1")
          (s."wordwrap@~0.0.2")
        ];
        "optimist@^0.6.1" = s."optimist@0.6.1";
        "os-browserify@0.3.0" = f "os-browserify" "0.3.0" y "854373c7f5c2315914fc9bfc6bd8238fdda1ec27" [];
        "os-browserify@^0.3.0" = s."os-browserify@0.3.0";
        "os-homedir@1.0.2" = f "os-homedir" "1.0.2" (ir "http://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz") "ffbc4988336e0e833de0c168c7ef152121aa7fb3" [];
        "os-homedir@^1.0.0" = s."os-homedir@1.0.2";
        "os-locale@2.1.0" = f "os-locale" "2.1.0" y "42bc2900a6b5b8bd17376c8e882b65afccf24bf2" [
          (s."execa@^0.7.0")
          (s."lcid@^1.0.0")
          (s."mem@^1.1.0")
        ];
        "os-locale@3.0.1" = f "os-locale" "3.0.1" y "3b014fbf01d87f60a1e5348d80fe870dc82c4620" [
          (s."execa@^0.10.0")
          (s."lcid@^2.0.0")
          (s."mem@^4.0.0")
        ];
        "os-locale@^2.0.0" = s."os-locale@2.1.0";
        "os-locale@^3.0.0" = s."os-locale@3.0.1";
        "os-tmpdir@1.0.2" = f "os-tmpdir" "1.0.2" (ir "http://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz") "bbe67406c79aa85c5cfec766fe5734555dfa1274" [];
        "os-tmpdir@^1.0.0" = s."os-tmpdir@1.0.2";
        "os-tmpdir@~1.0.2" = s."os-tmpdir@1.0.2";
        "osenv@0.1.5" = f "osenv" "0.1.5" y "85cdfafaeb28e8677f416e287592b5f3f49ea410" [
          (s."os-homedir@^1.0.0")
          (s."os-tmpdir@^1.0.0")
        ];
        "osenv@^0.1.4" = s."osenv@0.1.5";
        "p-cancelable@0.4.1" = f "p-cancelable" "0.4.1" (ir "http://registry.npmjs.org/p-cancelable/-/p-cancelable-0.4.1.tgz") "35f363d67d52081c8d9585e37bcceb7e0bbcb2a0" [];
        "p-cancelable@^0.4.0" = s."p-cancelable@0.4.1";
        "p-defer@1.0.0" = f "p-defer" "1.0.0" y "9f6eb182f6c9aa8cd743004a7d4f96b196b0fb0c" [];
        "p-defer@^1.0.0" = s."p-defer@1.0.0";
        "p-finally@1.0.0" = f "p-finally" "1.0.0" y "3fbcfb15b899a44123b34b6dcc18b724336a2cae" [];
        "p-finally@^1.0.0" = s."p-finally@1.0.0";
        "p-is-promise@1.1.0" = f "p-is-promise" "1.1.0" (ir "http://registry.npmjs.org/p-is-promise/-/p-is-promise-1.1.0.tgz") "9c9456989e9f6588017b0434d56097675c3da05e" [];
        "p-is-promise@^1.1.0" = s."p-is-promise@1.1.0";
        "p-limit@1.3.0" = f "p-limit" "1.3.0" y "b86bd5f0c25690911c7590fcbfc2010d54b3ccb8" [
          (s."p-try@^1.0.0")
        ];
        "p-limit@2.0.0" = f "p-limit" "2.0.0" y "e624ed54ee8c460a778b3c9f3670496ff8a57aec" [
          (s."p-try@^2.0.0")
        ];
        "p-limit@^1.1.0" = s."p-limit@1.3.0";
        "p-limit@^2.0.0" = s."p-limit@2.0.0";
        "p-locate@2.0.0" = f "p-locate" "2.0.0" y "20a0103b222a70c8fd39cc2e580680f3dde5ec43" [
          (s."p-limit@^1.1.0")
        ];
        "p-locate@3.0.0" = f "p-locate" "3.0.0" y "322d69a05c0264b25997d9f40cd8a891ab0064a4" [
          (s."p-limit@^2.0.0")
        ];
        "p-locate@^2.0.0" = s."p-locate@2.0.0";
        "p-locate@^3.0.0" = s."p-locate@3.0.0";
        "p-timeout@2.0.1" = f "p-timeout" "2.0.1" y "d8dd1979595d2dc0139e1fe46b8b646cb3cdf038" [
          (s."p-finally@^1.0.0")
        ];
        "p-timeout@^2.0.1" = s."p-timeout@2.0.1";
        "p-try@1.0.0" = f "p-try" "1.0.0" y "cbc79cdbaf8fd4228e13f621f2b1a237c1b207b3" [];
        "p-try@2.0.0" = f "p-try" "2.0.0" y "85080bb87c64688fa47996fe8f7dfbe8211760b1" [];
        "p-try@^1.0.0" = s."p-try@1.0.0";
        "p-try@^2.0.0" = s."p-try@2.0.0";
        "package-json@5.0.0" = f "package-json" "5.0.0" y "a7dbe2725edcc7dc9bcee627672275e323882433" [
          (s."got@^8.3.1")
          (s."registry-auth-token@^3.3.2")
          (s."registry-url@^3.1.0")
          (s."semver@^5.5.0")
        ];
        "package-json@~5.0.0" = s."package-json@5.0.0";
        "pako@1.0.7" = f "pako" "1.0.7" y "2473439021b57f1516c82f58be7275ad8ef1bb27" [];
        "pako@~1.0.5" = s."pako@1.0.7";
        "parallel-transform@1.1.0" = f "parallel-transform" "1.1.0" y "d410f065b05da23081fcd10f28854c29bda33b06" [
          (s."cyclist@~0.2.2")
          (s."inherits@^2.0.3")
          (s."readable-stream@^2.1.5")
        ];
        "parallel-transform@^1.1.0" = s."parallel-transform@1.1.0";
        "param-case@2.1.1" = f "param-case" "2.1.1" y "df94fd8cf6531ecf75e6bef9a0858fbc72be2247" [
          (s."no-case@^2.2.0")
        ];
        "param-case@2.1.x" = s."param-case@2.1.1";
        "parse-asn1@5.1.1" = f "parse-asn1" "5.1.1" (ir "http://registry.npmjs.org/parse-asn1/-/parse-asn1-5.1.1.tgz") "f6bf293818332bd0dab54efb16087724745e6ca8" [
          (s."asn1.js@^4.0.0")
          (s."browserify-aes@^1.0.0")
          (s."create-hash@^1.1.0")
          (s."evp_bytestokey@^1.0.0")
          (s."pbkdf2@^3.0.3")
        ];
        "parse-asn1@^5.0.0" = s."parse-asn1@5.1.1";
        "pascalcase@0.1.1" = f "pascalcase" "0.1.1" y "b363e55e8006ca6fe21784d2db22bd15d7917f14" [];
        "pascalcase@^0.1.1" = s."pascalcase@0.1.1";
        "path-browserify@0.0.0" = f "path-browserify" "0.0.0" (ir "http://registry.npmjs.org/path-browserify/-/path-browserify-0.0.0.tgz") "a0b870729aae214005b7d5032ec2cbbb0fb4451a" [];
        "path-dirname@1.0.2" = f "path-dirname" "1.0.2" y "cc33d24d525e099a5388c0336c6e32b9160609e0" [];
        "path-dirname@^1.0.0" = s."path-dirname@1.0.2";
        "path-exists@3.0.0" = f "path-exists" "3.0.0" y "ce0ebeaa5f78cb18925ea7d810d7b59b010fd515" [];
        "path-exists@^3.0.0" = s."path-exists@3.0.0";
        "path-is-absolute@1.0.1" = f "path-is-absolute" "1.0.1" (ir "http://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz") "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f" [];
        "path-is-absolute@^1.0.0" = s."path-is-absolute@1.0.1";
        "path-key@2.0.1" = f "path-key" "2.0.1" y "411cadb574c5a140d3a4b1910d40d80cc9f40b40" [];
        "path-key@^2.0.0" = s."path-key@2.0.1";
        "path-key@^2.0.1" = s."path-key@2.0.1";
        "path-posix@1.0.0" = f "path-posix" "1.0.0" y "06b26113f56beab042545a23bfa88003ccac260f" [];
        "path-posix@~1.0.0" = s."path-posix@1.0.0";
        "path@0.12.7" = f "path" "0.12.7" y "d4dc2a506c4ce2197eb481ebfcd5b36c0140b10f" [
          (s."process@^0.11.1")
          (s."util@^0.10.3")
        ];
        "path@~0.12.7" = s."path@0.12.7";
        "pbkdf2@3.0.17" = f "pbkdf2" "3.0.17" y "976c206530617b14ebb32114239f7b09336e93a6" [
          (s."create-hash@^1.1.2")
          (s."create-hmac@^1.1.4")
          (s."ripemd160@^2.0.1")
          (s."safe-buffer@^5.0.1")
          (s."sha.js@^2.4.8")
        ];
        "pbkdf2@^3.0.3" = s."pbkdf2@3.0.17";
        "pify@3.0.0" = f "pify" "3.0.0" y "e5a4acd2c101fdf3d9a4d07f0dbc4db49dd28176" [];
        "pify@^3.0.0" = s."pify@3.0.0";
        "pkg-dir@2.0.0" = f "pkg-dir" "2.0.0" y "f6d5d1109e19d63edf428e0bd57e12777615334b" [
          (s."find-up@^2.1.0")
        ];
        "pkg-dir@3.0.0" = f "pkg-dir" "3.0.0" y "2749020f239ed990881b1f71210d51eb6523bea3" [
          (s."find-up@^3.0.0")
        ];
        "pkg-dir@^2.0.0" = s."pkg-dir@2.0.0";
        "pkg-dir@^3.0.0" = s."pkg-dir@3.0.0";
        "posix-character-classes@0.1.1" = f "posix-character-classes" "0.1.1" y "01eac0fe3b5af71a2a6c02feabb8c1fef7e00eab" [];
        "posix-character-classes@^0.1.0" = s."posix-character-classes@0.1.1";
        "postcss-calc@5.3.1" = f "postcss-calc" "5.3.1" (ir "http://registry.npmjs.org/postcss-calc/-/postcss-calc-5.3.1.tgz") "77bae7ca928ad85716e2fda42f261bf7c1d65b5e" [
          (s."postcss@^5.0.2")
          (s."postcss-message-helpers@^2.0.0")
          (s."reduce-css-calc@^1.2.6")
        ];
        "postcss-calc@^5.2.0" = s."postcss-calc@5.3.1";
        "postcss-colormin@2.2.2" = f "postcss-colormin" "2.2.2" y "6631417d5f0e909a3d7ec26b24c8a8d1e4f96e4b" [
          (s."colormin@^1.0.5")
          (s."postcss@^5.0.13")
          (s."postcss-value-parser@^3.2.3")
        ];
        "postcss-colormin@^2.1.8" = s."postcss-colormin@2.2.2";
        "postcss-convert-values@2.6.1" = f "postcss-convert-values" "2.6.1" y "bbd8593c5c1fd2e3d1c322bb925dcae8dae4d62d" [
          (s."postcss@^5.0.11")
          (s."postcss-value-parser@^3.1.2")
        ];
        "postcss-convert-values@^2.3.4" = s."postcss-convert-values@2.6.1";
        "postcss-discard-comments@2.0.4" = f "postcss-discard-comments" "2.0.4" (ir "http://registry.npmjs.org/postcss-discard-comments/-/postcss-discard-comments-2.0.4.tgz") "befe89fafd5b3dace5ccce51b76b81514be00e3d" [
          (s."postcss@^5.0.14")
        ];
        "postcss-discard-comments@^2.0.4" = s."postcss-discard-comments@2.0.4";
        "postcss-discard-duplicates@2.1.0" = f "postcss-discard-duplicates" "2.1.0" y "b9abf27b88ac188158a5eb12abcae20263b91932" [
          (s."postcss@^5.0.4")
        ];
        "postcss-discard-duplicates@^2.0.1" = s."postcss-discard-duplicates@2.1.0";
        "postcss-discard-empty@2.1.0" = f "postcss-discard-empty" "2.1.0" (ir "http://registry.npmjs.org/postcss-discard-empty/-/postcss-discard-empty-2.1.0.tgz") "d2b4bd9d5ced5ebd8dcade7640c7d7cd7f4f92b5" [
          (s."postcss@^5.0.14")
        ];
        "postcss-discard-empty@^2.0.1" = s."postcss-discard-empty@2.1.0";
        "postcss-discard-overridden@0.1.1" = f "postcss-discard-overridden" "0.1.1" (ir "http://registry.npmjs.org/postcss-discard-overridden/-/postcss-discard-overridden-0.1.1.tgz") "8b1eaf554f686fb288cd874c55667b0aa3668d58" [
          (s."postcss@^5.0.16")
        ];
        "postcss-discard-overridden@^0.1.1" = s."postcss-discard-overridden@0.1.1";
        "postcss-discard-unused@2.2.3" = f "postcss-discard-unused" "2.2.3" (ir "http://registry.npmjs.org/postcss-discard-unused/-/postcss-discard-unused-2.2.3.tgz") "bce30b2cc591ffc634322b5fb3464b6d934f4433" [
          (s."postcss@^5.0.14")
          (s."uniqs@^2.0.0")
        ];
        "postcss-discard-unused@^2.2.1" = s."postcss-discard-unused@2.2.3";
        "postcss-filter-plugins@2.0.3" = f "postcss-filter-plugins" "2.0.3" y "82245fdf82337041645e477114d8e593aa18b8ec" [
          (s."postcss@^5.0.4")
        ];
        "postcss-filter-plugins@^2.0.0" = s."postcss-filter-plugins@2.0.3";
        "postcss-merge-idents@2.1.7" = f "postcss-merge-idents" "2.1.7" (ir "http://registry.npmjs.org/postcss-merge-idents/-/postcss-merge-idents-2.1.7.tgz") "4c5530313c08e1d5b3bbf3d2bbc747e278eea270" [
          (s."has@^1.0.1")
          (s."postcss@^5.0.10")
          (s."postcss-value-parser@^3.1.1")
        ];
        "postcss-merge-idents@^2.1.5" = s."postcss-merge-idents@2.1.7";
        "postcss-merge-longhand@2.0.2" = f "postcss-merge-longhand" "2.0.2" y "23d90cd127b0a77994915332739034a1a4f3d658" [
          (s."postcss@^5.0.4")
        ];
        "postcss-merge-longhand@^2.0.1" = s."postcss-merge-longhand@2.0.2";
        "postcss-merge-rules@2.1.2" = f "postcss-merge-rules" "2.1.2" y "d1df5dfaa7b1acc3be553f0e9e10e87c61b5f721" [
          (s."browserslist@^1.5.2")
          (s."caniuse-api@^1.5.2")
          (s."postcss@^5.0.4")
          (s."postcss-selector-parser@^2.2.2")
          (s."vendors@^1.0.0")
        ];
        "postcss-merge-rules@^2.0.3" = s."postcss-merge-rules@2.1.2";
        "postcss-message-helpers@2.0.0" = f "postcss-message-helpers" "2.0.0" y "a4f2f4fab6e4fe002f0aed000478cdf52f9ba60e" [];
        "postcss-message-helpers@^2.0.0" = s."postcss-message-helpers@2.0.0";
        "postcss-minify-font-values@1.0.5" = f "postcss-minify-font-values" "1.0.5" (ir "http://registry.npmjs.org/postcss-minify-font-values/-/postcss-minify-font-values-1.0.5.tgz") "4b58edb56641eba7c8474ab3526cafd7bbdecb69" [
          (s."object-assign@^4.0.1")
          (s."postcss@^5.0.4")
          (s."postcss-value-parser@^3.0.2")
        ];
        "postcss-minify-font-values@^1.0.2" = s."postcss-minify-font-values@1.0.5";
        "postcss-minify-gradients@1.0.5" = f "postcss-minify-gradients" "1.0.5" (ir "http://registry.npmjs.org/postcss-minify-gradients/-/postcss-minify-gradients-1.0.5.tgz") "5dbda11373703f83cfb4a3ea3881d8d75ff5e6e1" [
          (s."postcss@^5.0.12")
          (s."postcss-value-parser@^3.3.0")
        ];
        "postcss-minify-gradients@^1.0.1" = s."postcss-minify-gradients@1.0.5";
        "postcss-minify-params@1.2.2" = f "postcss-minify-params" "1.2.2" (ir "http://registry.npmjs.org/postcss-minify-params/-/postcss-minify-params-1.2.2.tgz") "ad2ce071373b943b3d930a3fa59a358c28d6f1f3" [
          (s."alphanum-sort@^1.0.1")
          (s."postcss@^5.0.2")
          (s."postcss-value-parser@^3.0.2")
          (s."uniqs@^2.0.0")
        ];
        "postcss-minify-params@^1.0.4" = s."postcss-minify-params@1.2.2";
        "postcss-minify-selectors@2.1.1" = f "postcss-minify-selectors" "2.1.1" (ir "http://registry.npmjs.org/postcss-minify-selectors/-/postcss-minify-selectors-2.1.1.tgz") "b2c6a98c0072cf91b932d1a496508114311735bf" [
          (s."alphanum-sort@^1.0.2")
          (s."has@^1.0.1")
          (s."postcss@^5.0.14")
          (s."postcss-selector-parser@^2.0.0")
        ];
        "postcss-minify-selectors@^2.0.4" = s."postcss-minify-selectors@2.1.1";
        "postcss-modules-extract-imports@1.2.1" = f "postcss-modules-extract-imports" "1.2.1" y "dc87e34148ec7eab5f791f7cd5849833375b741a" [
          (s."postcss@^6.0.1")
        ];
        "postcss-modules-extract-imports@^1.2.0" = s."postcss-modules-extract-imports@1.2.1";
        "postcss-modules-local-by-default@1.2.0" = f "postcss-modules-local-by-default" "1.2.0" y "f7d80c398c5a393fa7964466bd19500a7d61c069" [
          (s."css-selector-tokenizer@^0.7.0")
          (s."postcss@^6.0.1")
        ];
        "postcss-modules-local-by-default@^1.2.0" = s."postcss-modules-local-by-default@1.2.0";
        "postcss-modules-scope@1.1.0" = f "postcss-modules-scope" "1.1.0" y "d6ea64994c79f97b62a72b426fbe6056a194bb90" [
          (s."css-selector-tokenizer@^0.7.0")
          (s."postcss@^6.0.1")
        ];
        "postcss-modules-scope@^1.1.0" = s."postcss-modules-scope@1.1.0";
        "postcss-modules-values@1.3.0" = f "postcss-modules-values" "1.3.0" y "ecffa9d7e192518389f42ad0e83f72aec456ea20" [
          (s."icss-replace-symbols@^1.1.0")
          (s."postcss@^6.0.1")
        ];
        "postcss-modules-values@^1.3.0" = s."postcss-modules-values@1.3.0";
        "postcss-normalize-charset@1.1.1" = f "postcss-normalize-charset" "1.1.1" (ir "http://registry.npmjs.org/postcss-normalize-charset/-/postcss-normalize-charset-1.1.1.tgz") "ef9ee71212d7fe759c78ed162f61ed62b5cb93f1" [
          (s."postcss@^5.0.5")
        ];
        "postcss-normalize-charset@^1.1.0" = s."postcss-normalize-charset@1.1.1";
        "postcss-normalize-url@3.0.8" = f "postcss-normalize-url" "3.0.8" (ir "http://registry.npmjs.org/postcss-normalize-url/-/postcss-normalize-url-3.0.8.tgz") "108f74b3f2fcdaf891a2ffa3ea4592279fc78222" [
          (s."is-absolute-url@^2.0.0")
          (s."normalize-url@^1.4.0")
          (s."postcss@^5.0.14")
          (s."postcss-value-parser@^3.2.3")
        ];
        "postcss-normalize-url@^3.0.7" = s."postcss-normalize-url@3.0.8";
        "postcss-ordered-values@2.2.3" = f "postcss-ordered-values" "2.2.3" y "eec6c2a67b6c412a8db2042e77fe8da43f95c11d" [
          (s."postcss@^5.0.4")
          (s."postcss-value-parser@^3.0.1")
        ];
        "postcss-ordered-values@^2.1.0" = s."postcss-ordered-values@2.2.3";
        "postcss-reduce-idents@2.4.0" = f "postcss-reduce-idents" "2.4.0" (ir "http://registry.npmjs.org/postcss-reduce-idents/-/postcss-reduce-idents-2.4.0.tgz") "c2c6d20cc958284f6abfbe63f7609bf409059ad3" [
          (s."postcss@^5.0.4")
          (s."postcss-value-parser@^3.0.2")
        ];
        "postcss-reduce-idents@^2.2.2" = s."postcss-reduce-idents@2.4.0";
        "postcss-reduce-initial@1.0.1" = f "postcss-reduce-initial" "1.0.1" (ir "http://registry.npmjs.org/postcss-reduce-initial/-/postcss-reduce-initial-1.0.1.tgz") "68f80695f045d08263a879ad240df8dd64f644ea" [
          (s."postcss@^5.0.4")
        ];
        "postcss-reduce-initial@^1.0.0" = s."postcss-reduce-initial@1.0.1";
        "postcss-reduce-transforms@1.0.4" = f "postcss-reduce-transforms" "1.0.4" (ir "http://registry.npmjs.org/postcss-reduce-transforms/-/postcss-reduce-transforms-1.0.4.tgz") "ff76f4d8212437b31c298a42d2e1444025771ae1" [
          (s."has@^1.0.1")
          (s."postcss@^5.0.8")
          (s."postcss-value-parser@^3.0.1")
        ];
        "postcss-reduce-transforms@^1.0.3" = s."postcss-reduce-transforms@1.0.4";
        "postcss-selector-parser@2.2.3" = f "postcss-selector-parser" "2.2.3" y "f9437788606c3c9acee16ffe8d8b16297f27bb90" [
          (s."flatten@^1.0.2")
          (s."indexes-of@^1.0.1")
          (s."uniq@^1.0.1")
        ];
        "postcss-selector-parser@^2.0.0" = s."postcss-selector-parser@2.2.3";
        "postcss-selector-parser@^2.2.2" = s."postcss-selector-parser@2.2.3";
        "postcss-svgo@2.1.6" = f "postcss-svgo" "2.1.6" (ir "http://registry.npmjs.org/postcss-svgo/-/postcss-svgo-2.1.6.tgz") "b6df18aa613b666e133f08adb5219c2684ac108d" [
          (s."is-svg@^2.0.0")
          (s."postcss@^5.0.14")
          (s."postcss-value-parser@^3.2.3")
          (s."svgo@^0.7.0")
        ];
        "postcss-svgo@^2.1.1" = s."postcss-svgo@2.1.6";
        "postcss-unique-selectors@2.0.2" = f "postcss-unique-selectors" "2.0.2" (ir "http://registry.npmjs.org/postcss-unique-selectors/-/postcss-unique-selectors-2.0.2.tgz") "981d57d29ddcb33e7b1dfe1fd43b8649f933ca1d" [
          (s."alphanum-sort@^1.0.1")
          (s."postcss@^5.0.4")
          (s."uniqs@^2.0.0")
        ];
        "postcss-unique-selectors@^2.0.2" = s."postcss-unique-selectors@2.0.2";
        "postcss-value-parser@3.3.1" = f "postcss-value-parser" "3.3.1" y "9ff822547e2893213cf1c30efa51ac5fd1ba8281" [];
        "postcss-value-parser@^3.0.1" = s."postcss-value-parser@3.3.1";
        "postcss-value-parser@^3.0.2" = s."postcss-value-parser@3.3.1";
        "postcss-value-parser@^3.1.1" = s."postcss-value-parser@3.3.1";
        "postcss-value-parser@^3.1.2" = s."postcss-value-parser@3.3.1";
        "postcss-value-parser@^3.2.3" = s."postcss-value-parser@3.3.1";
        "postcss-value-parser@^3.3.0" = s."postcss-value-parser@3.3.1";
        "postcss-zindex@2.2.0" = f "postcss-zindex" "2.2.0" (ir "http://registry.npmjs.org/postcss-zindex/-/postcss-zindex-2.2.0.tgz") "d2109ddc055b91af67fc4cb3b025946639d2af22" [
          (s."has@^1.0.1")
          (s."postcss@^5.0.4")
          (s."uniqs@^2.0.0")
        ];
        "postcss-zindex@^2.0.1" = s."postcss-zindex@2.2.0";
        "postcss@5.2.18" = f "postcss" "5.2.18" y "badfa1497d46244f6390f58b319830d9107853c5" [
          (s."chalk@^1.1.3")
          (s."js-base64@^2.1.9")
          (s."source-map@^0.5.6")
          (s."supports-color@^3.2.3")
        ];
        "postcss@6.0.23" = f "postcss" "6.0.23" y "61c82cc328ac60e677645f979054eb98bc0e3324" [
          (s."chalk@^2.4.1")
          (s."source-map@^0.6.1")
          (s."supports-color@^5.4.0")
        ];
        "postcss@^5.0.10" = s."postcss@5.2.18";
        "postcss@^5.0.11" = s."postcss@5.2.18";
        "postcss@^5.0.12" = s."postcss@5.2.18";
        "postcss@^5.0.13" = s."postcss@5.2.18";
        "postcss@^5.0.14" = s."postcss@5.2.18";
        "postcss@^5.0.16" = s."postcss@5.2.18";
        "postcss@^5.0.2" = s."postcss@5.2.18";
        "postcss@^5.0.4" = s."postcss@5.2.18";
        "postcss@^5.0.5" = s."postcss@5.2.18";
        "postcss@^5.0.6" = s."postcss@5.2.18";
        "postcss@^5.0.8" = s."postcss@5.2.18";
        "postcss@^5.2.16" = s."postcss@5.2.18";
        "postcss@^6.0.1" = s."postcss@6.0.23";
        "postcss@^6.0.14" = s."postcss@6.0.23";
        "prepend-http@1.0.4" = f "prepend-http" "1.0.4" y "d4f4562b0ce3696e41ac52d0e002e57a635dc6dc" [];
        "prepend-http@2.0.0" = f "prepend-http" "2.0.0" y "e92434bfa5ea8c19f41cdfd401d741a3c819d897" [];
        "prepend-http@^1.0.0" = s."prepend-http@1.0.4";
        "prepend-http@^2.0.0" = s."prepend-http@2.0.0";
        "pretty-error@2.1.1" = f "pretty-error" "2.1.1" y "5f4f87c8f91e5ae3f3ba87ab4cf5e03b1a17f1a3" [
          (s."renderkid@^2.0.1")
          (s."utila@~0.4")
        ];
        "pretty-error@^2.0.2" = s."pretty-error@2.1.1";
        "private@0.1.8" = f "private" "0.1.8" y "2381edb3689f7a53d653190060fcf822d2f368ff" [];
        "private@~0.1.5" = s."private@0.1.8";
        "process-nextick-args@2.0.0" = f "process-nextick-args" "2.0.0" y "a37d732f4271b4ab1ad070d35508e8290788ffaa" [];
        "process-nextick-args@~2.0.0" = s."process-nextick-args@2.0.0";
        "process@0.11.10" = f "process" "0.11.10" y "7332300e840161bda3e69a1d1d91a7d4bc16f182" [];
        "process@^0.11.1" = s."process@0.11.10";
        "process@^0.11.10" = s."process@0.11.10";
        "promise-inflight@1.0.1" = f "promise-inflight" "1.0.1" y "98472870bf228132fcbdd868129bad12c3c029e3" [];
        "promise-inflight@^1.0.1" = s."promise-inflight@1.0.1";
        "promise@7.3.1" = f "promise" "7.3.1" y "064b72602b18f90f29192b8b1bc418ffd1ebd3bf" [
          (s."asap@~2.0.3")
        ];
        "promise@^7.1.1" = s."promise@7.3.1";
        "prop-types@15.6.2" = f "prop-types" "15.6.2" y "05d5ca77b4453e985d60fc7ff8c859094a497102" [
          (s."loose-envify@^1.3.1")
          (s."object-assign@^4.1.1")
        ];
        "prop-types@^15.5.8" = s."prop-types@15.6.2";
        "prop-types@^15.6.0" = s."prop-types@15.6.2";
        "prop-types@^15.6.1" = s."prop-types@15.6.2";
        "prr@1.0.1" = f "prr" "1.0.1" y "d3fc114ba06995a45ec6893f484ceb1d78f5f476" [];
        "prr@~1.0.1" = s."prr@1.0.1";
        "pseudomap@1.0.2" = f "pseudomap" "1.0.2" y "f052a28da70e618917ef0a8ac34c1ae5a68286b3" [];
        "pseudomap@^1.0.2" = s."pseudomap@1.0.2";
        "public-encrypt@4.0.3" = f "public-encrypt" "4.0.3" y "4fcc9d77a07e48ba7527e7cbe0de33d0701331e0" [
          (s."bn.js@^4.1.0")
          (s."browserify-rsa@^4.0.0")
          (s."create-hash@^1.1.0")
          (s."parse-asn1@^5.0.0")
          (s."randombytes@^2.0.1")
          (s."safe-buffer@^5.1.2")
        ];
        "public-encrypt@^4.0.0" = s."public-encrypt@4.0.3";
        "pump@2.0.1" = f "pump" "2.0.1" y "12399add6e4cf7526d973cbc8b5ce2e2908b3909" [
          (s."end-of-stream@^1.1.0")
          (s."once@^1.3.1")
        ];
        "pump@^2.0.0" = s."pump@2.0.1";
        "pump@^2.0.1" = s."pump@2.0.1";
        "pumpify@1.5.1" = f "pumpify" "1.5.1" y "36513be246ab27570b1a374a5ce278bfd74370ce" [
          (s."duplexify@^3.6.0")
          (s."inherits@^2.0.3")
          (s."pump@^2.0.0")
        ];
        "pumpify@^1.3.3" = s."pumpify@1.5.1";
        "punycode@1.3.2" = f "punycode" "1.3.2" y "9653a036fb7c1ee42342f2325cceefea3926c48d" [];
        "punycode@1.4.1" = f "punycode" "1.4.1" y "c0d5a63b2718800ad8e1eb0fa5269c84dd41845e" [];
        "punycode@2.1.1" = f "punycode" "2.1.1" y "b58b010ac40c22c5657616c8d2c2c02c7bf479ec" [];
        "punycode@^1.2.4" = s."punycode@1.4.1";
        "punycode@^2.1.0" = s."punycode@2.1.1";
        "pure-color@1.3.0" = f "pure-color" "1.3.0" y "1fe064fb0ac851f0de61320a8bf796836422f33e" [];
        "pure-color@^1.2.0" = s."pure-color@1.3.0";
        "q@1.5.1" = f "q" "1.5.1" y "7e32f75b41381291d04611f1bf14109ac00651d7" [];
        "q@^1.1.2" = s."q@1.5.1";
        "query-string@4.3.4" = f "query-string" "4.3.4" y "bbb693b9ca915c232515b228b1a02b609043dbeb" [
          (s."object-assign@^4.1.0")
          (s."strict-uri-encode@^1.0.0")
        ];
        "query-string@5.1.1" = f "query-string" "5.1.1" (ir "http://registry.npmjs.org/query-string/-/query-string-5.1.1.tgz") "a78c012b71c17e05f2e3fa2319dd330682efb3cb" [
          (s."decode-uri-component@^0.2.0")
          (s."object-assign@^4.1.0")
          (s."strict-uri-encode@^1.0.0")
        ];
        "query-string@^4.1.0" = s."query-string@4.3.4";
        "query-string@^5.0.1" = s."query-string@5.1.1";
        "querystring-es3@0.2.1" = f "querystring-es3" "0.2.1" y "9ec61f79049875707d69414596fd907a4d711e73" [];
        "querystring-es3@^0.2.0" = s."querystring-es3@0.2.1";
        "querystring@0.2.0" = f "querystring" "0.2.0" y "b209849203bb25df820da756e747005878521620" [];
        "querystringify@2.1.0" = f "querystringify" "2.1.0" y "7ded8dfbf7879dcc60d0a644ac6754b283ad17ef" [];
        "querystringify@^2.0.0" = s."querystringify@2.1.0";
        "randombytes@2.0.6" = f "randombytes" "2.0.6" y "d302c522948588848a8d300c932b44c24231da80" [
          (s."safe-buffer@^5.1.0")
        ];
        "randombytes@^2.0.0" = s."randombytes@2.0.6";
        "randombytes@^2.0.1" = s."randombytes@2.0.6";
        "randombytes@^2.0.5" = s."randombytes@2.0.6";
        "randomfill@1.0.4" = f "randomfill" "1.0.4" y "c92196fc86ab42be983f1bf31778224931d61458" [
          (s."randombytes@^2.0.5")
          (s."safe-buffer@^5.1.0")
        ];
        "randomfill@^1.0.3" = s."randomfill@1.0.4";
        "raw-loader@0.5.1" = f "raw-loader" "0.5.1" (ir "http://registry.npmjs.org/raw-loader/-/raw-loader-0.5.1.tgz") "0c3d0beaed8a01c966d9787bf778281252a979aa" [];
        "raw-loader@~0.5.1" = s."raw-loader@0.5.1";
        "rc@1.2.8" = f "rc" "1.2.8" y "cd924bf5200a075b83c188cd6b9e211b7fc0d3ed" [
          (s."deep-extend@^0.6.0")
          (s."ini@~1.3.0")
          (s."minimist@^1.2.0")
          (s."strip-json-comments@~2.0.1")
        ];
        "rc@^1.0.1" = s."rc@1.2.8";
        "rc@^1.1.6" = s."rc@1.2.8";
        "rc@^1.2.7" = s."rc@1.2.8";
        "react-base16-styling@0.5.3" = f "react-base16-styling" "0.5.3" y "3858f24e9c4dd8cbd3f702f3f74d581ca2917269" [
          (s."base16@^1.0.0")
          (s."lodash.curry@^4.0.1")
          (s."lodash.flow@^3.3.0")
          (s."pure-color@^1.2.0")
        ];
        "react-base16-styling@^0.5.1" = s."react-base16-styling@0.5.3";
        "react-dom@16.4.2" = f "react-dom" "16.4.2" y "4afed569689f2c561d2b8da0b819669c38a0bda4" [
          (s."fbjs@^0.8.16")
          (s."loose-envify@^1.1.0")
          (s."object-assign@^4.1.1")
          (s."prop-types@^15.6.0")
        ];
        "react-dom@~16.4.2" = s."react-dom@16.4.2";
        "react-highlighter@0.4.3" = f "react-highlighter" "0.4.3" y "e32c84d053259c30ca72c615aa759036d0d23048" [
          (s."blacklist@^1.1.4")
          (s."create-react-class@^15.6.2")
          (s."escape-string-regexp@^1.0.5")
          (s."prop-types@^15.6.0")
        ];
        "react-highlighter@^0.4.0" = s."react-highlighter@0.4.3";
        "react-json-tree@0.11.0" = f "react-json-tree" "0.11.0" y "f5b17e83329a9c76ae38be5c04fda3a7fd684a35" [
          (s."babel-runtime@^6.6.1")
          (s."prop-types@^15.5.8")
          (s."react-base16-styling@^0.5.1")
        ];
        "react-json-tree@^0.11.0" = s."react-json-tree@0.11.0";
        "react-paginate@5.3.1" = f "react-paginate" "5.3.1" y "bb8da341774e154c89b9e091ccb74ab1efa28ac2" [
          (s."prop-types@^15.6.1")
        ];
        "react-paginate@^5.2.3" = s."react-paginate@5.3.1";
        "react@16.4.2" = f "react" "16.4.2" y "2cd90154e3a9d9dd8da2991149fdca3c260e129f" [
          (s."fbjs@^0.8.16")
          (s."loose-envify@^1.1.0")
          (s."object-assign@^4.1.1")
          (s."prop-types@^15.6.0")
        ];
        "react@~16.4.2" = s."react@16.4.2";
        "readable-stream@1 || 2" = s."readable-stream@2.3.6";
        "readable-stream@1.0" = s."readable-stream@1.0.34";
        "readable-stream@1.0.34" = f "readable-stream" "1.0.34" (ir "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.34.tgz") "125820e34bc842d2f2aaafafe4c2916ee32c157c" [
          (s."core-util-is@~1.0.0")
          (s."inherits@~2.0.1")
          (s."isarray@0.0.1")
          (s."string_decoder@~0.10.x")
        ];
        "readable-stream@2.3.6" = f "readable-stream" "2.3.6" (ir "http://registry.npmjs.org/readable-stream/-/readable-stream-2.3.6.tgz") "b11c27d88b8ff1fbe070643cf94b0c79ae1b0aaf" [
          (s."core-util-is@~1.0.0")
          (s."inherits@~2.0.3")
          (s."isarray@~1.0.0")
          (s."process-nextick-args@~2.0.0")
          (s."safe-buffer@~5.1.1")
          (s."string_decoder@~1.1.1")
          (s."util-deprecate@~1.0.1")
        ];
        "readable-stream@3.0.6" = f "readable-stream" "3.0.6" y "351302e4c68b5abd6a2ed55376a7f9a25be3057a" [
          (s."inherits@^2.0.3")
          (s."string_decoder@^1.1.1")
          (s."util-deprecate@^1.0.1")
        ];
        "readable-stream@^2.0.0" = s."readable-stream@2.3.6";
        "readable-stream@^2.0.1" = s."readable-stream@2.3.6";
        "readable-stream@^2.0.2" = s."readable-stream@2.3.6";
        "readable-stream@^2.0.4" = s."readable-stream@2.3.6";
        "readable-stream@^2.0.6" = s."readable-stream@2.3.6";
        "readable-stream@^2.1.5" = s."readable-stream@2.3.6";
        "readable-stream@^2.2.2" = s."readable-stream@2.3.6";
        "readable-stream@^2.3.3" = s."readable-stream@2.3.6";
        "readable-stream@^2.3.6" = s."readable-stream@2.3.6";
        "readable-stream@^3.0.6" = s."readable-stream@3.0.6";
        "readable-stream@~2.3.6" = s."readable-stream@2.3.6";
        "readdirp@2.2.1" = f "readdirp" "2.2.1" y "0e87622a3325aa33e892285caf8b4e846529a525" [
          (s."graceful-fs@^4.1.11")
          (s."micromatch@^3.1.10")
          (s."readable-stream@^2.0.2")
        ];
        "readdirp@^2.0.0" = s."readdirp@2.2.1";
        "recast@0.11.23" = f "recast" "0.11.23" y "451fd3004ab1e4df9b4e4b66376b2a21912462d3" [
          (s."ast-types@0.9.6")
          (s."esprima@~3.1.0")
          (s."private@~0.1.5")
          (s."source-map@~0.5.0")
        ];
        "recast@~0.11.12" = s."recast@0.11.23";
        "reduce-css-calc@1.3.0" = f "reduce-css-calc" "1.3.0" (ir "http://registry.npmjs.org/reduce-css-calc/-/reduce-css-calc-1.3.0.tgz") "747c914e049614a4c9cfbba629871ad1d2927716" [
          (s."balanced-match@^0.4.2")
          (s."math-expression-evaluator@^1.2.14")
          (s."reduce-function-call@^1.0.1")
        ];
        "reduce-css-calc@^1.2.6" = s."reduce-css-calc@1.3.0";
        "reduce-function-call@1.0.2" = f "reduce-function-call" "1.0.2" y "5a200bf92e0e37751752fe45b0ab330fd4b6be99" [
          (s."balanced-match@^0.4.2")
        ];
        "reduce-function-call@^1.0.1" = s."reduce-function-call@1.0.2";
        "regenerate@1.4.0" = f "regenerate" "1.4.0" y "4a856ec4b56e4077c557589cae85e7a4c8869a11" [];
        "regenerate@^1.2.1" = s."regenerate@1.4.0";
        "regenerator-runtime@0.11.1" = f "regenerator-runtime" "0.11.1" y "be05ad7f9bf7d22e056f9726cee5017fbf19e2e9" [];
        "regenerator-runtime@^0.11.0" = s."regenerator-runtime@0.11.1";
        "regex-not@1.0.2" = f "regex-not" "1.0.2" y "1f4ece27e00b0b65e0247a6810e6a85d83a5752c" [
          (s."extend-shallow@^3.0.2")
          (s."safe-regex@^1.1.0")
        ];
        "regex-not@^1.0.0" = s."regex-not@1.0.2";
        "regex-not@^1.0.2" = s."regex-not@1.0.2";
        "regexpu-core@1.0.0" = f "regexpu-core" "1.0.0" (ir "http://registry.npmjs.org/regexpu-core/-/regexpu-core-1.0.0.tgz") "86a763f58ee4d7c2f6b102e4764050de7ed90c6b" [
          (s."regenerate@^1.2.1")
          (s."regjsgen@^0.2.0")
          (s."regjsparser@^0.1.4")
        ];
        "regexpu-core@^1.0.0" = s."regexpu-core@1.0.0";
        "registry-auth-token@3.3.2" = f "registry-auth-token" "3.3.2" y "851fd49038eecb586911115af845260eec983f20" [
          (s."rc@^1.1.6")
          (s."safe-buffer@^5.0.1")
        ];
        "registry-auth-token@^3.3.2" = s."registry-auth-token@3.3.2";
        "registry-url@3.1.0" = f "registry-url" "3.1.0" y "3d4ef870f73dde1d77f0cf9a381432444e174942" [
          (s."rc@^1.0.1")
        ];
        "registry-url@^3.1.0" = s."registry-url@3.1.0";
        "regjsgen@0.2.0" = f "regjsgen" "0.2.0" (ir "http://registry.npmjs.org/regjsgen/-/regjsgen-0.2.0.tgz") "6c016adeac554f75823fe37ac05b92d5a4edb1f7" [];
        "regjsgen@^0.2.0" = s."regjsgen@0.2.0";
        "regjsparser@0.1.5" = f "regjsparser" "0.1.5" (ir "http://registry.npmjs.org/regjsparser/-/regjsparser-0.1.5.tgz") "7ee8f84dc6fa792d3fd0ae228d24bd949ead205c" [
          (s."jsesc@~0.5.0")
        ];
        "regjsparser@^0.1.4" = s."regjsparser@0.1.5";
        "relateurl@0.2.7" = f "relateurl" "0.2.7" y "54dbf377e51440aca90a4cd274600d3ff2d888a9" [];
        "relateurl@0.2.x" = s."relateurl@0.2.7";
        "remove-trailing-separator@1.1.0" = f "remove-trailing-separator" "1.1.0" y "c24bce2a283adad5bc3f58e0d48249b92379d8ef" [];
        "remove-trailing-separator@^1.0.1" = s."remove-trailing-separator@1.1.0";
        "renderkid@2.0.2" = f "renderkid" "2.0.2" y "12d310f255360c07ad8fde253f6c9e9de372d2aa" [
          (s."css-select@^1.1.0")
          (s."dom-converter@~0.2")
          (s."htmlparser2@~3.3.0")
          (s."strip-ansi@^3.0.0")
          (s."utila@^0.4.0")
        ];
        "renderkid@^2.0.1" = s."renderkid@2.0.2";
        "repeat-element@1.1.3" = f "repeat-element" "1.1.3" y "782e0d825c0c5a3bb39731f84efee6b742e6b1ce" [];
        "repeat-element@^1.1.2" = s."repeat-element@1.1.3";
        "repeat-string@1.6.1" = f "repeat-string" "1.6.1" y "8dcae470e1c88abc2d600fff4a776286da75e637" [];
        "repeat-string@^1.6.1" = s."repeat-string@1.6.1";
        "require-directory@2.1.1" = f "require-directory" "2.1.1" y "8c64ad5fd30dab1c976e2344ffe7f792a6a6df42" [];
        "require-directory@^2.1.1" = s."require-directory@2.1.1";
        "require-main-filename@1.0.1" = f "require-main-filename" "1.0.1" y "97f717b69d48784f5f526a6c5aa8ffdda055a4d1" [];
        "require-main-filename@^1.0.1" = s."require-main-filename@1.0.1";
        "requires-port@1.0.0" = f "requires-port" "1.0.0" y "925d2601d39ac485e091cf0da5c6e694dc3dcaff" [];
        "requires-port@^1.0.0" = s."requires-port@1.0.0";
        "resolve-cwd@2.0.0" = f "resolve-cwd" "2.0.0" y "00a9f7387556e27038eae232caa372a6a59b665a" [
          (s."resolve-from@^3.0.0")
        ];
        "resolve-cwd@^2.0.0" = s."resolve-cwd@2.0.0";
        "resolve-from@3.0.0" = f "resolve-from" "3.0.0" y "b22c7af7d9d6881bc8b6e653335eebcb0a188748" [];
        "resolve-from@^3.0.0" = s."resolve-from@3.0.0";
        "resolve-url@0.2.1" = f "resolve-url" "0.2.1" y "2c637fe77c893afd2a663fe21aa9080068e2052a" [];
        "resolve-url@^0.2.1" = s."resolve-url@0.2.1";
        "responselike@1.0.2" = f "responselike" "1.0.2" y "918720ef3b631c5642be068f15ade5a46f4ba1e7" [
          (s."lowercase-keys@^1.0.0")
        ];
        "restore-cursor@2.0.0" = f "restore-cursor" "2.0.0" y "9f7ee287f82fd326d4fd162923d62129eee0dfaf" [
          (s."onetime@^2.0.0")
          (s."signal-exit@^3.0.2")
        ];
        "restore-cursor@^2.0.0" = s."restore-cursor@2.0.0";
        "ret@0.1.15" = f "ret" "0.1.15" y "b8a4825d5bdb1fc3f6f53c2bc33f81388681c7bc" [];
        "ret@~0.1.10" = s."ret@0.1.15";
        "rimraf@2.6.2" = f "rimraf" "2.6.2" y "2ed8150d24a16ea8651e6d6ef0f47c4158ce7a36" [
          (s."glob@^7.0.5")
        ];
        "rimraf@^2.5.4" = s."rimraf@2.6.2";
        "rimraf@^2.6.1" = s."rimraf@2.6.2";
        "rimraf@^2.6.2" = s."rimraf@2.6.2";
        "rimraf@~2.6.2" = s."rimraf@2.6.2";
        "ripemd160@2.0.2" = f "ripemd160" "2.0.2" y "a1c1a6f624751577ba5d07914cbc92850585890c" [
          (s."hash-base@^3.0.0")
          (s."inherits@^2.0.1")
        ];
        "ripemd160@^2.0.0" = s."ripemd160@2.0.2";
        "ripemd160@^2.0.1" = s."ripemd160@2.0.2";
        "run-async@2.3.0" = f "run-async" "2.3.0" y "0371ab4ae0bdd720d4166d7dfda64ff7a445a6c0" [
          (s."is-promise@^2.1.0")
        ];
        "run-async@^2.2.0" = s."run-async@2.3.0";
        "run-queue@1.0.3" = f "run-queue" "1.0.3" y "e848396f057d223f24386924618e25694161ec47" [
          (s."aproba@^1.1.1")
        ];
        "run-queue@^1.0.0" = s."run-queue@1.0.3";
        "run-queue@^1.0.3" = s."run-queue@1.0.3";
        "rw@1" = s."rw@1.3.3";
        "rw@1.3.3" = f "rw" "1.3.3" y "3f862dfa91ab766b14885ef4d01124bfda074fb4" [];
        "rx-lite-aggregates@4.0.8" = f "rx-lite-aggregates" "4.0.8" y "753b87a89a11c95467c4ac1626c4efc4e05c67be" [
          (s."rx-lite@*")
        ];
        "rx-lite-aggregates@^4.0.8" = s."rx-lite-aggregates@4.0.8";
        "rx-lite@*" = s."rx-lite@4.0.8";
        "rx-lite@4.0.8" = f "rx-lite" "4.0.8" y "0b1e11af8bc44836f04a6407e92da42467b79444" [];
        "rx-lite@^4.0.8" = s."rx-lite@4.0.8";
        "safe-buffer@5.1.2" = f "safe-buffer" "5.1.2" y "991ec69d296e0313747d59bdfd2b745c35f8828d" [];
        "safe-buffer@^5.0.1" = s."safe-buffer@5.1.2";
        "safe-buffer@^5.1.0" = s."safe-buffer@5.1.2";
        "safe-buffer@^5.1.1" = s."safe-buffer@5.1.2";
        "safe-buffer@^5.1.2" = s."safe-buffer@5.1.2";
        "safe-buffer@~5.1.0" = s."safe-buffer@5.1.2";
        "safe-buffer@~5.1.1" = s."safe-buffer@5.1.2";
        "safe-regex@1.1.0" = f "safe-regex" "1.1.0" (ir "http://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz") "40a3669f3b077d1e943d44629e157dd48023bf2e" [
          (s."ret@~0.1.10")
        ];
        "safe-regex@^1.1.0" = s."safe-regex@1.1.0";
        "safer-buffer@2.1.2" = f "safer-buffer" "2.1.2" y "44fa161b0187b9549dd84bb91802f9bd8385cd6a" [];
        "safer-buffer@>= 2.1.2 < 3" = s."safer-buffer@2.1.2";
        "sanitize-html@1.18.5" = f "sanitize-html" "1.18.5" y "350013d95d17f851ef8b178dfd9ca155acf2d7a0" [
          (s."chalk@^2.3.0")
          (s."htmlparser2@^3.9.0")
          (s."lodash.clonedeep@^4.5.0")
          (s."lodash.escaperegexp@^4.1.2")
          (s."lodash.isplainobject@^4.0.6")
          (s."lodash.isstring@^4.0.1")
          (s."lodash.mergewith@^4.6.0")
          (s."postcss@^6.0.14")
          (s."srcset@^1.0.0")
          (s."xtend@^4.0.0")
        ];
        "sanitize-html@~1.18.2" = s."sanitize-html@1.18.5";
        "sax@1.2.4" = f "sax" "1.2.4" y "2816234e2378bddc4e5354fab5caa895df7100d9" [];
        "sax@^1.2.4" = s."sax@1.2.4";
        "sax@~1.2.1" = s."sax@1.2.4";
        "schema-utils@0.4.7" = f "schema-utils" "0.4.7" y "ba74f597d2be2ea880131746ee17d0a093c68187" [
          (s."ajv@^6.1.0")
          (s."ajv-keywords@^3.1.0")
        ];
        "schema-utils@^0.4.3" = s."schema-utils@0.4.7";
        "schema-utils@^0.4.4" = s."schema-utils@0.4.7";
        "schema-utils@^0.4.5" = s."schema-utils@0.4.7";
        "semver@5.6.0" = f "semver" "5.6.0" y "7e74256fbaa49c75aa7c7a205cc22799cac80004" [];
        "semver@^5.3.0" = s."semver@5.6.0";
        "semver@^5.4.1" = s."semver@5.6.0";
        "semver@^5.5.0" = s."semver@5.6.0";
        "serialize-javascript@1.5.0" = f "serialize-javascript" "1.5.0" y "1aa336162c88a890ddad5384baebc93a655161fe" [];
        "serialize-javascript@^1.4.0" = s."serialize-javascript@1.5.0";
        "set-blocking@2.0.0" = f "set-blocking" "2.0.0" y "045f9782d011ae9a6803ddd382b24392b3d890f7" [];
        "set-blocking@^2.0.0" = s."set-blocking@2.0.0";
        "set-blocking@~2.0.0" = s."set-blocking@2.0.0";
        "set-value@0.4.3" = f "set-value" "0.4.3" y "7db08f9d3d22dc7f78e53af3c3bf4666ecdfccf1" [
          (s."extend-shallow@^2.0.1")
          (s."is-extendable@^0.1.1")
          (s."is-plain-object@^2.0.1")
          (s."to-object-path@^0.3.0")
        ];
        "set-value@2.0.0" = f "set-value" "2.0.0" y "71ae4a88f0feefbbf52d1ea604f3fb315ebb6274" [
          (s."extend-shallow@^2.0.1")
          (s."is-extendable@^0.1.1")
          (s."is-plain-object@^2.0.3")
          (s."split-string@^3.0.1")
        ];
        "set-value@^0.4.3" = s."set-value@0.4.3";
        "set-value@^2.0.0" = s."set-value@2.0.0";
        "setimmediate@1.0.5" = f "setimmediate" "1.0.5" y "290cbb232e306942d7d7ea9b83732ab7856f8285" [];
        "setimmediate@^1.0.4" = s."setimmediate@1.0.5";
        "setimmediate@^1.0.5" = s."setimmediate@1.0.5";
        "sha.js@2.4.11" = f "sha.js" "2.4.11" (ir "http://registry.npmjs.org/sha.js/-/sha.js-2.4.11.tgz") "37a5cf0b81ecbc6943de109ba2960d1b26584ae7" [
          (s."inherits@^2.0.1")
          (s."safe-buffer@^5.0.1")
        ];
        "sha.js@^2.4.0" = s."sha.js@2.4.11";
        "sha.js@^2.4.8" = s."sha.js@2.4.11";
        "shebang-command@1.2.0" = f "shebang-command" "1.2.0" y "44aac65b695b03398968c39f363fee5deafdf1ea" [
          (s."shebang-regex@^1.0.0")
        ];
        "shebang-command@^1.2.0" = s."shebang-command@1.2.0";
        "shebang-regex@1.0.0" = f "shebang-regex" "1.0.0" y "da42f49740c0b42db2ca9728571cb190c98efea3" [];
        "shebang-regex@^1.0.0" = s."shebang-regex@1.0.0";
        "signal-exit@3.0.2" = f "signal-exit" "3.0.2" y "b5fdc08f1287ea1178628e415e25132b73646c6d" [];
        "signal-exit@^3.0.0" = s."signal-exit@3.0.2";
        "signal-exit@^3.0.2" = s."signal-exit@3.0.2";
        "snapdragon-node@2.1.1" = f "snapdragon-node" "2.1.1" y "6c175f86ff14bdb0724563e8f3c1b021a286853b" [
          (s."define-property@^1.0.0")
          (s."isobject@^3.0.0")
          (s."snapdragon-util@^3.0.1")
        ];
        "snapdragon-node@^2.0.1" = s."snapdragon-node@2.1.1";
        "snapdragon-util@3.0.1" = f "snapdragon-util" "3.0.1" y "f956479486f2acd79700693f6f7b805e45ab56e2" [
          (s."kind-of@^3.2.0")
        ];
        "snapdragon-util@^3.0.1" = s."snapdragon-util@3.0.1";
        "snapdragon@0.8.2" = f "snapdragon" "0.8.2" y "64922e7c565b0e14204ba1aa7d6964278d25182d" [
          (s."base@^0.11.1")
          (s."debug@^2.2.0")
          (s."define-property@^0.2.5")
          (s."extend-shallow@^2.0.1")
          (s."map-cache@^0.2.2")
          (s."source-map@^0.5.6")
          (s."source-map-resolve@^0.5.0")
          (s."use@^3.1.0")
        ];
        "snapdragon@^0.8.1" = s."snapdragon@0.8.2";
        "sort-keys@1.1.2" = f "sort-keys" "1.1.2" y "441b6d4d346798f1b4e49e8920adfba0e543f9ad" [
          (s."is-plain-obj@^1.0.0")
        ];
        "sort-keys@2.0.0" = f "sort-keys" "2.0.0" y "658535584861ec97d730d6cf41822e1f56684128" [
          (s."is-plain-obj@^1.0.0")
        ];
        "sort-keys@^1.0.0" = s."sort-keys@1.1.2";
        "sort-keys@^2.0.0" = s."sort-keys@2.0.0";
        "sort-object-keys@1.1.2" = f "sort-object-keys" "1.1.2" y "d3a6c48dc2ac97e6bc94367696e03f6d09d37952" [];
        "sort-object-keys@^1.1.1" = s."sort-object-keys@1.1.2";
        "sort-package-json@1.7.1" = f "sort-package-json" "1.7.1" y "f2e5fbffe8420cc1bb04485f4509f05e73b4c0f2" [
          (s."sort-object-keys@^1.1.1")
        ];
        "sort-package-json@~1.7.1" = s."sort-package-json@1.7.1";
        "source-list-map@2.0.1" = f "source-list-map" "2.0.1" y "3993bd873bfc48479cca9ea3a547835c7c154b34" [];
        "source-list-map@^2.0.0" = s."source-list-map@2.0.1";
        "source-map-loader@0.2.4" = f "source-map-loader" "0.2.4" y "c18b0dc6e23bf66f6792437557c569a11e072271" [
          (s."async@^2.5.0")
          (s."loader-utils@^1.1.0")
        ];
        "source-map-loader@~0.2.1" = s."source-map-loader@0.2.4";
        "source-map-resolve@0.5.2" = f "source-map-resolve" "0.5.2" y "72e2cc34095543e43b2c62b2c4c10d4a9054f259" [
          (s."atob@^2.1.1")
          (s."decode-uri-component@^0.2.0")
          (s."resolve-url@^0.2.1")
          (s."source-map-url@^0.4.0")
          (s."urix@^0.1.0")
        ];
        "source-map-resolve@^0.5.0" = s."source-map-resolve@0.5.2";
        "source-map-url@0.4.0" = f "source-map-url" "0.4.0" y "3e935d7ddd73631b97659956d55128e87b5084a3" [];
        "source-map-url@^0.4.0" = s."source-map-url@0.4.0";
        "source-map@0.5.7" = f "source-map" "0.5.7" y "8a039d2d1021d22d1ea14c80d8ea468ba2ef3fcc" [];
        "source-map@0.6.1" = f "source-map" "0.6.1" y "74722af32e9614e9c287a8d0bbde48b5e2f1a263" [];
        "source-map@^0.5.3" = s."source-map@0.5.7";
        "source-map@^0.5.6" = s."source-map@0.5.7";
        "source-map@^0.6.1" = s."source-map@0.6.1";
        "source-map@~0.5.0" = s."source-map@0.5.7";
        "source-map@~0.6.0" = s."source-map@0.6.1";
        "source-map@~0.6.1" = s."source-map@0.6.1";
        "split-string@3.1.0" = f "split-string" "3.1.0" y "7cb09dda3a86585705c64b39a6466038682e8fe2" [
          (s."extend-shallow@^3.0.0")
        ];
        "split-string@^3.0.1" = s."split-string@3.1.0";
        "split-string@^3.0.2" = s."split-string@3.1.0";
        "sprintf-js@1.0.3" = f "sprintf-js" "1.0.3" (ir "http://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz") "04e6926f662895354f3dd015203633b857297e2c" [];
        "sprintf-js@~1.0.2" = s."sprintf-js@1.0.3";
        "srcset@1.0.0" = f "srcset" "1.0.0" y "a5669de12b42f3b1d5e83ed03c71046fc48f41ef" [
          (s."array-uniq@^1.0.2")
          (s."number-is-nan@^1.0.0")
        ];
        "srcset@^1.0.0" = s."srcset@1.0.0";
        "ssri@5.3.0" = f "ssri" "5.3.0" y "ba3872c9c6d33a0704a7d71ff045e5ec48999d06" [
          (s."safe-buffer@^5.1.1")
        ];
        "ssri@^5.2.4" = s."ssri@5.3.0";
        "static-extend@0.1.2" = f "static-extend" "0.1.2" y "60809c39cbff55337226fd5e0b520f341f1fb5c6" [
          (s."define-property@^0.2.5")
          (s."object-copy@^0.1.0")
        ];
        "static-extend@^0.1.1" = s."static-extend@0.1.2";
        "stream-browserify@2.0.1" = f "stream-browserify" "2.0.1" (ir "http://registry.npmjs.org/stream-browserify/-/stream-browserify-2.0.1.tgz") "66266ee5f9bdb9940a4e4514cafb43bb71e5c9db" [
          (s."inherits@~2.0.1")
          (s."readable-stream@^2.0.2")
        ];
        "stream-browserify@^2.0.1" = s."stream-browserify@2.0.1";
        "stream-each@1.2.3" = f "stream-each" "1.2.3" y "ebe27a0c389b04fbcc233642952e10731afa9bae" [
          (s."end-of-stream@^1.1.0")
          (s."stream-shift@^1.0.0")
        ];
        "stream-each@^1.1.0" = s."stream-each@1.2.3";
        "stream-http@2.8.3" = f "stream-http" "2.8.3" y "b2d242469288a5a27ec4fe8933acf623de6514fc" [
          (s."builtin-status-codes@^3.0.0")
          (s."inherits@^2.0.1")
          (s."readable-stream@^2.3.6")
          (s."to-arraybuffer@^1.0.0")
          (s."xtend@^4.0.0")
        ];
        "stream-http@^2.7.2" = s."stream-http@2.8.3";
        "stream-shift@1.0.0" = f "stream-shift" "1.0.0" y "d5c752825e5367e786f78e18e445ea223a155952" [];
        "stream-shift@^1.0.0" = s."stream-shift@1.0.0";
        "strict-uri-encode@1.1.0" = f "strict-uri-encode" "1.1.0" y "279b225df1d582b1f54e65addd4352e18faa0713" [];
        "strict-uri-encode@^1.0.0" = s."strict-uri-encode@1.1.0";
        "string-width@1.0.2" = f "string-width" "1.0.2" (ir "http://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz") "118bdf5b8cdc51a2a7e70d211e07e2b0b9b107d3" [
          (s."code-point-at@^1.0.0")
          (s."is-fullwidth-code-point@^1.0.0")
          (s."strip-ansi@^3.0.0")
        ];
        "string-width@2.1.1" = f "string-width" "2.1.1" y "ab93f27a8dc13d28cac815c462143a6d9012ae9e" [
          (s."is-fullwidth-code-point@^2.0.0")
          (s."strip-ansi@^4.0.0")
        ];
        "string-width@^1.0.1" = s."string-width@1.0.2";
        "string-width@^1.0.2 || 2" = s."string-width@2.1.1";
        "string-width@^2.0.0" = s."string-width@2.1.1";
        "string-width@^2.1.0" = s."string-width@2.1.1";
        "string-width@^2.1.1" = s."string-width@2.1.1";
        "string_decoder@0.10.31" = f "string_decoder" "0.10.31" (ir "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz") "62e203bc41766c6c28c9fc84301dab1c5310fa94" [];
        "string_decoder@1.1.1" = f "string_decoder" "1.1.1" (ir "http://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz") "9cf1611ba62685d7030ae9e4ba34149c3af03fc8" [
          (s."safe-buffer@~5.1.0")
        ];
        "string_decoder@1.2.0" = f "string_decoder" "1.2.0" y "fe86e738b19544afe70469243b2a1ee9240eae8d" [
          (s."safe-buffer@~5.1.0")
        ];
        "string_decoder@^1.0.0" = s."string_decoder@1.2.0";
        "string_decoder@^1.1.1" = s."string_decoder@1.2.0";
        "string_decoder@~0.10.x" = s."string_decoder@0.10.31";
        "string_decoder@~1.1.1" = s."string_decoder@1.1.1";
        "strip-ansi@3.0.1" = f "strip-ansi" "3.0.1" (ir "http://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz") "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf" [
          (s."ansi-regex@^2.0.0")
        ];
        "strip-ansi@4.0.0" = f "strip-ansi" "4.0.0" y "a8479022eb1ac368a871389b635262c505ee368f" [
          (s."ansi-regex@^3.0.0")
        ];
        "strip-ansi@^3.0.0" = s."strip-ansi@3.0.1";
        "strip-ansi@^3.0.1" = s."strip-ansi@3.0.1";
        "strip-ansi@^4.0.0" = s."strip-ansi@4.0.0";
        "strip-eof@1.0.0" = f "strip-eof" "1.0.0" (ir "http://registry.npmjs.org/strip-eof/-/strip-eof-1.0.0.tgz") "bb43ff5598a6eb05d89b59fcd129c983313606bf" [];
        "strip-eof@^1.0.0" = s."strip-eof@1.0.0";
        "strip-json-comments@2.0.1" = f "strip-json-comments" "2.0.1" y "3c531942e908c2697c0ec344858c286c7ca0a60a" [];
        "strip-json-comments@~2.0.1" = s."strip-json-comments@2.0.1";
        "style-loader@0.21.0" = f "style-loader" "0.21.0" y "68c52e5eb2afc9ca92b6274be277ee59aea3a852" [
          (s."loader-utils@^1.1.0")
          (s."schema-utils@^0.4.5")
        ];
        "style-loader@~0.21.0" = s."style-loader@0.21.0";
        "supports-color@2.0.0" = f "supports-color" "2.0.0" y "535d045ce6b6363fa40117084629995e9df324c7" [];
        "supports-color@3.2.3" = f "supports-color" "3.2.3" y "65ac0504b3954171d8a64946b2ae3cbb8a5f54f6" [
          (s."has-flag@^1.0.0")
        ];
        "supports-color@5.5.0" = f "supports-color" "5.5.0" y "e2e69a44ac8772f78a1ec0b35b689df6530efc8f" [
          (s."has-flag@^3.0.0")
        ];
        "supports-color@^2.0.0" = s."supports-color@2.0.0";
        "supports-color@^3.2.3" = s."supports-color@3.2.3";
        "supports-color@^5.3.0" = s."supports-color@5.5.0";
        "supports-color@^5.4.0" = s."supports-color@5.5.0";
        "supports-color@^5.5.0" = s."supports-color@5.5.0";
        "svgo@0.7.2" = f "svgo" "0.7.2" y "9f5772413952135c6fefbf40afe6a4faa88b4bb5" [
          (s."coa@~1.0.1")
          (s."colors@~1.1.2")
          (s."csso@~2.3.1")
          (s."js-yaml@~3.7.0")
          (s."mkdirp@~0.5.1")
          (s."sax@~1.2.1")
          (s."whet.extend@~0.9.9")
        ];
        "svgo@^0.7.0" = s."svgo@0.7.2";
        "tapable@1.1.1" = f "tapable" "1.1.1" y "4d297923c5a72a42360de2ab52dadfaaec00018e" [];
        "tapable@^1.0.0" = s."tapable@1.1.1";
        "tar@4.4.8" = f "tar" "4.4.8" y "b19eec3fde2a96e64666df9fdb40c5ca1bc3747d" [
          (s."chownr@^1.1.1")
          (s."fs-minipass@^1.2.5")
          (s."minipass@^2.3.4")
          (s."minizlib@^1.1.1")
          (s."mkdirp@^0.5.0")
          (s."safe-buffer@^5.1.2")
          (s."yallist@^3.0.2")
        ];
        "tar@^4" = s."tar@4.4.8";
        "through2@2.0.5" = f "through2" "2.0.5" y "01c1e39eb31d07cb7d03a96a70823260b23132cd" [
          (s."readable-stream@~2.3.6")
          (s."xtend@~4.0.1")
        ];
        "through2@^2.0.0" = s."through2@2.0.5";
        "through@2.3.8" = f "through" "2.3.8" (ir "http://registry.npmjs.org/through/-/through-2.3.8.tgz") "0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5" [];
        "through@^2.3.6" = s."through@2.3.8";
        "through@~2.3.6" = s."through@2.3.8";
        "timed-out@4.0.1" = f "timed-out" "4.0.1" y "f32eacac5a175bea25d7fab565ab3ed8741ef56f" [];
        "timed-out@^4.0.1" = s."timed-out@4.0.1";
        "timers-browserify@2.0.10" = f "timers-browserify" "2.0.10" y "1d28e3d2aadf1d5a5996c4e9f95601cd053480ae" [
          (s."setimmediate@^1.0.4")
        ];
        "timers-browserify@^2.0.4" = s."timers-browserify@2.0.10";
        "tmp@0.0.33" = f "tmp" "0.0.33" y "6d34335889768d21b2bcda0aa277ced3b1bfadf9" [
          (s."os-tmpdir@~1.0.2")
        ];
        "tmp@^0.0.33" = s."tmp@0.0.33";
        "to-arraybuffer@1.0.1" = f "to-arraybuffer" "1.0.1" y "7d229b1fcc637e466ca081180836a7aabff83f43" [];
        "to-arraybuffer@^1.0.0" = s."to-arraybuffer@1.0.1";
        "to-object-path@0.3.0" = f "to-object-path" "0.3.0" y "297588b7b0e7e0ac08e04e672f85c1f4999e17af" [
          (s."kind-of@^3.0.2")
        ];
        "to-object-path@^0.3.0" = s."to-object-path@0.3.0";
        "to-regex-range@2.1.1" = f "to-regex-range" "2.1.1" y "7c80c17b9dfebe599e27367e0d4dd5590141db38" [
          (s."is-number@^3.0.0")
          (s."repeat-string@^1.6.1")
        ];
        "to-regex-range@^2.1.0" = s."to-regex-range@2.1.1";
        "to-regex@3.0.2" = f "to-regex" "3.0.2" y "13cfdd9b336552f30b51f33a8ae1b42a7a7599ce" [
          (s."define-property@^2.0.2")
          (s."extend-shallow@^3.0.2")
          (s."regex-not@^1.0.2")
          (s."safe-regex@^1.1.0")
        ];
        "to-regex@^3.0.1" = s."to-regex@3.0.2";
        "to-regex@^3.0.2" = s."to-regex@3.0.2";
        "topojson-client@3.0.0" = f "topojson-client" "3.0.0" y "1f99293a77ef42a448d032a81aa982b73f360d2f" [
          (s."commander@2")
        ];
        "topojson-client@^3.0.0" = s."topojson-client@3.0.0";
        "toposort@1.0.7" = f "toposort" "1.0.7" y "2e68442d9f64ec720b8cc89e6443ac6caa950029" [];
        "toposort@^1.0.0" = s."toposort@1.0.7";
        "tslib@1.9.3" = f "tslib" "1.9.3" y "d7e4dd79245d85428c4d7e4822a79917954ca286" [];
        "tslib@^1.9.0" = s."tslib@1.9.3";
        "tslib@^1.9.2" = s."tslib@1.9.3";
        "tty-browserify@0.0.0" = f "tty-browserify" "0.0.0" (ir "http://registry.npmjs.org/tty-browserify/-/tty-browserify-0.0.0.tgz") "a157ba402da24e9bf957f9aa69d524eed42901a6" [];
        "typedarray@0.0.6" = f "typedarray" "0.0.6" y "867ac74e3864187b1d3d47d996a78ec5c8830777" [];
        "typedarray@^0.0.6" = s."typedarray@0.0.6";
        "typescript@3.1.6" = f "typescript" "3.1.6" y "b6543a83cfc8c2befb3f4c8fba6896f5b0c9be68" [];
        "typescript@~3.1.1" = s."typescript@3.1.6";
        "ua-parser-js@0.7.19" = f "ua-parser-js" "0.7.19" y "94151be4c0a7fb1d001af7022fdaca4642659e4b" [];
        "ua-parser-js@^0.7.18" = s."ua-parser-js@0.7.19";
        "uglify-es@3.3.9" = f "uglify-es" "3.3.9" y "0c1c4f0700bed8dbc124cdb304d2592ca203e677" [
          (s."commander@~2.13.0")
          (s."source-map@~0.6.1")
        ];
        "uglify-es@^3.3.4" = s."uglify-es@3.3.9";
        "uglify-js@3.4.9" = f "uglify-js" "3.4.9" y "af02f180c1207d76432e473ed24a28f4a782bae3" [
          (s."commander@~2.17.1")
          (s."source-map@~0.6.1")
        ];
        "uglify-js@3.4.x" = s."uglify-js@3.4.9";
        "uglify-js@^3.1.4" = s."uglify-js@3.4.9";
        "uglifyjs-webpack-plugin@1.2.7" = f "uglifyjs-webpack-plugin" "1.2.7" y "57638dd99c853a1ebfe9d97b42160a8a507f9d00" [
          (s."cacache@^10.0.4")
          (s."find-cache-dir@^1.0.0")
          (s."schema-utils@^0.4.5")
          (s."serialize-javascript@^1.4.0")
          (s."source-map@^0.6.1")
          (s."uglify-es@^3.3.4")
          (s."webpack-sources@^1.1.0")
          (s."worker-farm@^1.5.2")
        ];
        "uglifyjs-webpack-plugin@1.3.0" = f "uglifyjs-webpack-plugin" "1.3.0" y "75f548160858163a08643e086d5fefe18a5d67de" [
          (s."cacache@^10.0.4")
          (s."find-cache-dir@^1.0.0")
          (s."schema-utils@^0.4.5")
          (s."serialize-javascript@^1.4.0")
          (s."source-map@^0.6.1")
          (s."uglify-es@^3.3.4")
          (s."webpack-sources@^1.1.0")
          (s."worker-farm@^1.5.2")
        ];
        "uglifyjs-webpack-plugin@^1.2.4" = s."uglifyjs-webpack-plugin@1.3.0";
        "uglifyjs-webpack-plugin@~1.2.5" = s."uglifyjs-webpack-plugin@1.2.7";
        "union-value@1.0.0" = f "union-value" "1.0.0" y "5c71c34cb5bad5dcebe3ea0cd08207ba5aa1aea4" [
          (s."arr-union@^3.1.0")
          (s."get-value@^2.0.6")
          (s."is-extendable@^0.1.1")
          (s."set-value@^0.4.3")
        ];
        "union-value@^1.0.0" = s."union-value@1.0.0";
        "uniq@1.0.1" = f "uniq" "1.0.1" y "b31c5ae8254844a3a8281541ce2b04b865a734ff" [];
        "uniq@^1.0.1" = s."uniq@1.0.1";
        "uniqs@2.0.0" = f "uniqs" "2.0.0" y "ffede4b36b25290696e6e165d4a59edb998e6b02" [];
        "uniqs@^2.0.0" = s."uniqs@2.0.0";
        "unique-filename@1.1.1" = f "unique-filename" "1.1.1" y "1d69769369ada0583103a1e6ae87681b56573230" [
          (s."unique-slug@^2.0.0")
        ];
        "unique-filename@^1.1.0" = s."unique-filename@1.1.1";
        "unique-slug@2.0.1" = f "unique-slug" "2.0.1" y "5e9edc6d1ce8fb264db18a507ef9bd8544451ca6" [
          (s."imurmurhash@^0.1.4")
        ];
        "unique-slug@^2.0.0" = s."unique-slug@2.0.1";
        "universalify@0.1.2" = f "universalify" "0.1.2" y "b646f69be3942dabcecc9d6639c80dc105efaa66" [];
        "universalify@^0.1.0" = s."universalify@0.1.2";
        "unset-value@1.0.0" = f "unset-value" "1.0.0" y "8376873f7d2335179ffb1e6fc3a8ed0dfc8ab559" [
          (s."has-value@^0.3.1")
          (s."isobject@^3.0.0")
        ];
        "unset-value@^1.0.0" = s."unset-value@1.0.0";
        "upath@1.1.0" = f "upath" "1.1.0" y "35256597e46a581db4793d0ce47fa9aebfc9fabd" [];
        "upath@^1.0.5" = s."upath@1.1.0";
        "upper-case@1.1.3" = f "upper-case" "1.1.3" y "f6b4501c2ec4cdd26ba78be7222961de77621598" [];
        "upper-case@^1.1.1" = s."upper-case@1.1.3";
        "uri-js@4.2.2" = f "uri-js" "4.2.2" y "94c540e1ff772956e2299507c010aea6c8838eb0" [
          (s."punycode@^2.1.0")
        ];
        "uri-js@^4.2.2" = s."uri-js@4.2.2";
        "urix@0.1.0" = f "urix" "0.1.0" y "da937f7a62e21fec1fd18d49b35c2935067a6c72" [];
        "urix@^0.1.0" = s."urix@0.1.0";
        "url-loader@1.0.1" = f "url-loader" "1.0.1" (ir "http://registry.npmjs.org/url-loader/-/url-loader-1.0.1.tgz") "61bc53f1f184d7343da2728a1289ef8722ea45ee" [
          (s."loader-utils@^1.1.0")
          (s."mime@^2.0.3")
          (s."schema-utils@^0.4.3")
        ];
        "url-loader@~1.0.1" = s."url-loader@1.0.1";
        "url-parse-lax@3.0.0" = f "url-parse-lax" "3.0.0" y "16b5cafc07dbe3676c1b1999177823d6503acb0c" [
          (s."prepend-http@^2.0.0")
        ];
        "url-parse-lax@^3.0.0" = s."url-parse-lax@3.0.0";
        "url-parse@1.4.4" = f "url-parse" "1.4.4" y "cac1556e95faa0303691fec5cf9d5a1bc34648f8" [
          (s."querystringify@^2.0.0")
          (s."requires-port@^1.0.0")
        ];
        "url-parse@~1.4.3" = s."url-parse@1.4.4";
        "url-to-options@1.0.1" = f "url-to-options" "1.0.1" y "1505a03a289a48cbd7a434efbaeec5055f5633a9" [];
        "url-to-options@^1.0.1" = s."url-to-options@1.0.1";
        "url@0.11.0" = f "url" "0.11.0" y "3838e97cfc60521eb73c525a8e55bfdd9e2e28f1" [
          (s."punycode@1.3.2")
          (s."querystring@0.2.0")
        ];
        "url@^0.11.0" = s."url@0.11.0";
        "use@3.1.1" = f "use" "3.1.1" y "d50c8cac79a19fbc20f2911f56eb973f4e10070f" [];
        "use@^3.1.0" = s."use@3.1.1";
        "util-deprecate@1.0.2" = f "util-deprecate" "1.0.2" y "450d4dc9fa70de732762fbd2d4a28981419a0ccf" [];
        "util-deprecate@^1.0.1" = s."util-deprecate@1.0.2";
        "util-deprecate@~1.0.1" = s."util-deprecate@1.0.2";
        "util.promisify@1.0.0" = f "util.promisify" "1.0.0" y "440f7165a459c9a16dc145eb8e72f35687097030" [
          (s."define-properties@^1.1.2")
          (s."object.getownpropertydescriptors@^2.0.3")
        ];
        "util@0.10.3" = f "util" "0.10.3" (ir "http://registry.npmjs.org/util/-/util-0.10.3.tgz") "7afb1afe50805246489e3db7fe0ed379336ac0f9" [
          (s."inherits@2.0.1")
        ];
        "util@0.10.4" = f "util" "0.10.4" y "3aa0125bfe668a4672de58857d3ace27ecb76901" [
          (s."inherits@2.0.3")
        ];
        "util@^0.10.3" = s."util@0.10.4";
        "utila@0.4.0" = f "utila" "0.4.0" y "8a16a05d445657a3aea5eecc5b12a4fa5379772c" [];
        "utila@^0.4.0" = s."utila@0.4.0";
        "utila@~0.4" = s."utila@0.4.0";
        "v8-compile-cache@2.0.2" = f "v8-compile-cache" "2.0.2" y "a428b28bb26790734c4fc8bc9fa106fccebf6a6c" [];
        "v8-compile-cache@^2.0.2" = s."v8-compile-cache@2.0.2";
        "vega-canvas@1.1.0" = f "vega-canvas" "1.1.0" y "99ce74d4510a46fc9ed1a8721014da725898ec9f" [];
        "vega-canvas@^1.0.1" = s."vega-canvas@1.1.0";
        "vega-canvas@^1.1.0" = s."vega-canvas@1.1.0";
        "vega-crossfilter@3.0.1" = f "vega-crossfilter" "3.0.1" y "8b4394fb5e354e5c6f79ca9f491531a292c04209" [
          (s."d3-array@^2.0.2")
          (s."vega-dataflow@^4.1.0")
          (s."vega-util@^1.7.0")
        ];
        "vega-crossfilter@^3.0.1" = s."vega-crossfilter@3.0.1";
        "vega-dataflow@4.1.0" = f "vega-dataflow" "4.1.0" y "c63abee8502eedf42a972ad5d3a2ce7475aab7d8" [
          (s."vega-loader@^3.1.0")
          (s."vega-util@^1.7.0")
        ];
        "vega-dataflow@^4.0.0" = s."vega-dataflow@4.1.0";
        "vega-dataflow@^4.0.4" = s."vega-dataflow@4.1.0";
        "vega-dataflow@^4.1.0" = s."vega-dataflow@4.1.0";
        "vega-embed@3.18.2" = f "vega-embed" "3.18.2" y "296fec71455bfcaff19a2adb56bf1155851a50ae" [
          (s."d3-selection@^1.3.0")
          (s."json-stringify-pretty-compact@^1.2.0")
          (s."semver@^5.5.0")
          (s."vega-lib@^4.0.0 || ^3.3.0")
          (s."vega-lite@^2.6.0")
          (s."vega-schema-url-parser@^1.1.0")
          (s."vega-themes@^2.1.1")
          (s."vega-tooltip@^0.12.0")
        ];
        "vega-encode@3.2.2" = f "vega-encode" "3.2.2" y "b7bdee200629b1d54de8267b1b8aafef9f1be8b7" [
          (s."d3-array@^2.0.2")
          (s."d3-format@^1.3.2")
          (s."d3-interpolate@^1.3.2")
          (s."vega-dataflow@^4.1.0")
          (s."vega-scale@^2.5.0")
          (s."vega-util@^1.7.0")
        ];
        "vega-encode@^3.2.2" = s."vega-encode@3.2.2";
        "vega-event-selector@2.0.0" = f "vega-event-selector" "2.0.0" y "6af8dc7345217017ceed74e9155b8d33bad05d42" [];
        "vega-event-selector@^2.0.0" = s."vega-event-selector@2.0.0";
        "vega-expression@2.4.0" = f "vega-expression" "2.4.0" y "02eb789623bf24c959b7b8756bf2cacb10bd54a6" [
          (s."vega-util@^1.7.0")
        ];
        "vega-expression@^2.4.0" = s."vega-expression@2.4.0";
        "vega-force@3.0.0" = f "vega-force" "3.0.0" y "f5d10bb0a49e41c47f2d83441e407510948eb89a" [
          (s."d3-force@^1.1.0")
          (s."vega-dataflow@^4.0.0")
          (s."vega-util@^1.7.0")
        ];
        "vega-force@^3.0.0" = s."vega-force@3.0.0";
        "vega-geo@3.1.1" = f "vega-geo" "3.1.1" y "5ff84061dea93d89a453e1b56b3444a6031810f6" [
          (s."d3-array@^2.0.2")
          (s."d3-contour@^1.3.2")
          (s."d3-geo@^1.11.3")
          (s."vega-dataflow@^4.1.0")
          (s."vega-projection@^1.2.0")
          (s."vega-util@^1.7.0")
        ];
        "vega-geo@^3.1.1" = s."vega-geo@3.1.1";
        "vega-hierarchy@3.1.0" = f "vega-hierarchy" "3.1.0" y "ce3df9ab09b3324144df9273d650391f082696ec" [
          (s."d3-collection@^1.0.7")
          (s."d3-hierarchy@^1.1.8")
          (s."vega-dataflow@^4.0.4")
          (s."vega-util@^1.7.0")
        ];
        "vega-hierarchy@^3.1.0" = s."vega-hierarchy@3.1.0";
        "vega-lib@4.4.0" = f "vega-lib" "4.4.0" y "37d99514c5496a0ce001033bdacb504361ef6880" [
          (s."vega-crossfilter@^3.0.1")
          (s."vega-dataflow@^4.1.0")
          (s."vega-encode@^3.2.2")
          (s."vega-event-selector@^2.0.0")
          (s."vega-expression@^2.4.0")
          (s."vega-force@^3.0.0")
          (s."vega-geo@^3.1.1")
          (s."vega-hierarchy@^3.1.0")
          (s."vega-loader@^3.1.0")
          (s."vega-parser@^3.9.0")
          (s."vega-projection@^1.2.0")
          (s."vega-runtime@^3.2.0")
          (s."vega-scale@^2.5.1")
          (s."vega-scenegraph@^3.2.3")
          (s."vega-statistics@^1.2.3")
          (s."vega-transforms@^2.3.1")
          (s."vega-typings@*")
          (s."vega-util@^1.7.0")
          (s."vega-view@^3.4.1")
          (s."vega-view-transforms@^2.0.3")
          (s."vega-voronoi@^3.0.0")
          (s."vega-wordcloud@^3.0.0")
        ];
        "vega-lib@^4.0.0 || ^3.3.0" = s."vega-lib@4.4.0";
        "vega-lite@2.6.0" = f "vega-lite" "2.6.0" y "ce79c2db0311b0b920afdf2cd7384556a334e2f0" [
          (s."@types/json-stable-stringify@^1.0.32")
          (s."json-stable-stringify@^1.0.1")
          (s."tslib@^1.9.2")
          (s."vega-event-selector@^2.0.0")
          (s."vega-typings@^0.3.17")
          (s."vega-util@^1.7.0")
          (s."yargs@^11.0.0")
        ];
        "vega-lite@^2.6.0" = s."vega-lite@2.6.0";
        "vega-loader@3.1.0" = f "vega-loader" "3.1.0" y "21caa0e78e158a676eafd0e7cb5bae4c18996c5a" [
          (s."d3-dsv@^1.0.10")
          (s."d3-time-format@^2.1.3")
          (s."node-fetch@^2.3.0")
          (s."topojson-client@^3.0.0")
          (s."vega-util@^1.7.0")
        ];
        "vega-loader@^3.0.1" = s."vega-loader@3.1.0";
        "vega-loader@^3.1.0" = s."vega-loader@3.1.0";
        "vega-parser@3.9.0" = f "vega-parser" "3.9.0" y "a7bbe380c5ae70ddd501163302a948f25aadd686" [
          (s."d3-array@^2.0.2")
          (s."d3-color@^1.2.3")
          (s."d3-format@^1.3.2")
          (s."d3-geo@^1.11.3")
          (s."d3-time-format@^2.1.3")
          (s."vega-dataflow@^4.1.0")
          (s."vega-event-selector@^2.0.0")
          (s."vega-expression@^2.4.0")
          (s."vega-scale@^2.5.1")
          (s."vega-scenegraph@^3.2.3")
          (s."vega-statistics@^1.2.3")
          (s."vega-util@^1.7.0")
        ];
        "vega-parser@^3.9.0" = s."vega-parser@3.9.0";
        "vega-projection@1.2.0" = f "vega-projection" "1.2.0" y "812c955251dab495fda83d9406ba72d9833a2014" [
          (s."d3-geo@^1.10.0")
        ];
        "vega-projection@^1.2.0" = s."vega-projection@1.2.0";
        "vega-runtime@3.2.0" = f "vega-runtime" "3.2.0" y "ad4152079989058db90ce1993f16b3876f628d8b" [
          (s."vega-dataflow@^4.1.0")
          (s."vega-util@^1.7.0")
        ];
        "vega-runtime@^3.2.0" = s."vega-runtime@3.2.0";
        "vega-scale@2.5.1" = f "vega-scale" "2.5.1" y "5b5ce7752e904c17077db9a924418dabd6ffb991" [
          (s."d3-array@^2.0.2")
          (s."d3-interpolate@^1.3.2")
          (s."d3-scale@^2.1.2")
          (s."d3-scale-chromatic@^1.3.3")
          (s."d3-time@^1.0.10")
          (s."vega-util@^1.7.0")
        ];
        "vega-scale@^2.1.1" = s."vega-scale@2.5.1";
        "vega-scale@^2.5.0" = s."vega-scale@2.5.1";
        "vega-scale@^2.5.1" = s."vega-scale@2.5.1";
        "vega-scenegraph@3.2.3" = f "vega-scenegraph" "3.2.3" y "72060c7f3b0e4421c4317a2f7a9a901870920a25" [
          (s."d3-path@^1.0.7")
          (s."d3-shape@^1.2.2")
          (s."vega-canvas@^1.1.0")
          (s."vega-loader@^3.0.1")
          (s."vega-util@^1.7.0")
        ];
        "vega-scenegraph@^3.2.3" = s."vega-scenegraph@3.2.3";
        "vega-schema-url-parser@1.1.0" = f "vega-schema-url-parser" "1.1.0" y "39168ec04e5468ce278a06c16ec0d126035a85b5" [];
        "vega-schema-url-parser@^1.1.0" = s."vega-schema-url-parser@1.1.0";
        "vega-statistics@1.2.3" = f "vega-statistics" "1.2.3" y "4a7ca4c5fd9cc00c3700cb9cde336995439a55fa" [
          (s."d3-array@^2.0.2")
        ];
        "vega-statistics@^1.2.1" = s."vega-statistics@1.2.3";
        "vega-statistics@^1.2.3" = s."vega-statistics@1.2.3";
        "vega-themes@2.2.0" = f "vega-themes" "2.2.0" y "03e3406fab2a5e05b6c258a8cc52c02e54370d84" [
          (s."vega-typings@^0.3.51")
        ];
        "vega-themes@^2.1.1" = s."vega-themes@2.2.0";
        "vega-tooltip@0.12.0" = f "vega-tooltip" "0.12.0" y "014b21b08ea5fe14eb59c9b6643614c77a3b3e47" [
          (s."vega-util@^1.7.0")
        ];
        "vega-tooltip@^0.12.0" = s."vega-tooltip@0.12.0";
        "vega-transforms@2.3.1" = f "vega-transforms" "2.3.1" y "a31a1ff8086c6909384ddfcc973bd58d53d801ae" [
          (s."d3-array@^2.0.2")
          (s."vega-dataflow@^4.1.0")
          (s."vega-statistics@^1.2.3")
          (s."vega-util@^1.7.0")
        ];
        "vega-transforms@^2.3.1" = s."vega-transforms@2.3.1";
        "vega-typings@*" = s."vega-typings@0.3.51";
        "vega-typings@0.3.51" = f "vega-typings" "0.3.51" y "1e7a84ae3af4fcc0784b80d50a3e1df432b18141" [
          (s."vega-util@^1.7.0")
        ];
        "vega-typings@^0.3.17" = s."vega-typings@0.3.51";
        "vega-typings@^0.3.51" = s."vega-typings@0.3.51";
        "vega-util@1.7.0" = f "vega-util" "1.7.0" y "0ca0512bb8dcc6541165c34663d115d0712e0cf1" [];
        "vega-util@^1.7.0" = s."vega-util@1.7.0";
        "vega-view-transforms@2.0.3" = f "vega-view-transforms" "2.0.3" y "9999f83301efbe65ed1971018f538f5aeb62a16e" [
          (s."vega-dataflow@^4.0.4")
          (s."vega-scenegraph@^3.2.3")
          (s."vega-util@^1.7.0")
        ];
        "vega-view-transforms@^2.0.3" = s."vega-view-transforms@2.0.3";
        "vega-view@3.4.1" = f "vega-view" "3.4.1" y "8f36fea88792b3b1ee3a535c5322dc7ecd975532" [
          (s."d3-array@^2.0.2")
          (s."d3-timer@^1.0.9")
          (s."vega-dataflow@^4.1.0")
          (s."vega-parser@^3.9.0")
          (s."vega-runtime@^3.2.0")
          (s."vega-scenegraph@^3.2.3")
          (s."vega-util@^1.7.0")
        ];
        "vega-view@^3.4.1" = s."vega-view@3.4.1";
        "vega-voronoi@3.0.0" = f "vega-voronoi" "3.0.0" y "e83d014c0d8d083592d5246122e3a9d4af0ce434" [
          (s."d3-voronoi@^1.1.2")
          (s."vega-dataflow@^4.0.0")
          (s."vega-util@^1.7.0")
        ];
        "vega-voronoi@^3.0.0" = s."vega-voronoi@3.0.0";
        "vega-wordcloud@3.0.0" = f "vega-wordcloud" "3.0.0" y "3843d5233673a36a93f78c849d3c7568c1cdc2ce" [
          (s."vega-canvas@^1.0.1")
          (s."vega-dataflow@^4.0.0")
          (s."vega-scale@^2.1.1")
          (s."vega-statistics@^1.2.1")
          (s."vega-util@^1.7.0")
        ];
        "vega-wordcloud@^3.0.0" = s."vega-wordcloud@3.0.0";
        "vendors@1.0.2" = f "vendors" "1.0.2" y "7fcb5eef9f5623b156bcea89ec37d63676f21801" [];
        "vendors@^1.0.0" = s."vendors@1.0.2";
        "vm-browserify@0.0.4" = f "vm-browserify" "0.0.4" (ir "http://registry.npmjs.org/vm-browserify/-/vm-browserify-0.0.4.tgz") "5d7ea45bbef9e4a6ff65f95438e0a87c357d5a73" [
          (s."indexof@0.0.1")
        ];
        "watchpack@1.6.0" = f "watchpack" "1.6.0" y "4bc12c2ebe8aa277a71f1d3f14d685c7b446cd00" [
          (s."chokidar@^2.0.2")
          (s."graceful-fs@^4.1.2")
          (s."neo-async@^2.5.0")
        ];
        "watchpack@^1.5.0" = s."watchpack@1.6.0";
        "webpack-cli@3.1.2" = f "webpack-cli" "3.1.2" y "17d7e01b77f89f884a2bbf9db545f0f6a648e746" [
          (s."chalk@^2.4.1")
          (s."cross-spawn@^6.0.5")
          (s."enhanced-resolve@^4.1.0")
          (s."global-modules-path@^2.3.0")
          (s."import-local@^2.0.0")
          (s."interpret@^1.1.0")
          (s."loader-utils@^1.1.0")
          (s."supports-color@^5.5.0")
          (s."v8-compile-cache@^2.0.2")
          (s."yargs@^12.0.2")
        ];
        "webpack-cli@^3.0.3" = s."webpack-cli@3.1.2";
        "webpack-merge@4.1.5" = f "webpack-merge" "4.1.5" y "2be31e846c20767d1bef56bdca64c328a681190a" [
          (s."lodash@^4.17.5")
        ];
        "webpack-merge@^4.1.1" = s."webpack-merge@4.1.5";
        "webpack-sources@1.3.0" = f "webpack-sources" "1.3.0" y "2a28dcb9f1f45fe960d8f1493252b5ee6530fa85" [
          (s."source-list-map@^2.0.0")
          (s."source-map@~0.6.1")
        ];
        "webpack-sources@^1.0.1" = s."webpack-sources@1.3.0";
        "webpack-sources@^1.1.0" = s."webpack-sources@1.3.0";
        "webpack@4.12.2" = f "webpack" "4.12.2" y "d2b8418eb40cedcbf2c1f5905d23a99546011ce9" [
          (s."@webassemblyjs/ast@1.5.12")
          (s."@webassemblyjs/helper-module-context@1.5.12")
          (s."@webassemblyjs/wasm-edit@1.5.12")
          (s."@webassemblyjs/wasm-opt@1.5.12")
          (s."@webassemblyjs/wasm-parser@1.5.12")
          (s."acorn@^5.6.2")
          (s."acorn-dynamic-import@^3.0.0")
          (s."ajv@^6.1.0")
          (s."ajv-keywords@^3.1.0")
          (s."chrome-trace-event@^1.0.0")
          (s."enhanced-resolve@^4.0.0")
          (s."eslint-scope@^3.7.1")
          (s."json-parse-better-errors@^1.0.2")
          (s."loader-runner@^2.3.0")
          (s."loader-utils@^1.1.0")
          (s."memory-fs@~0.4.1")
          (s."micromatch@^3.1.8")
          (s."mkdirp@~0.5.0")
          (s."neo-async@^2.5.0")
          (s."node-libs-browser@^2.0.0")
          (s."schema-utils@^0.4.4")
          (s."tapable@^1.0.0")
          (s."uglifyjs-webpack-plugin@^1.2.4")
          (s."watchpack@^1.5.0")
          (s."webpack-sources@^1.0.1")
        ];
        "webpack@~4.12.0" = s."webpack@4.12.2";
        "whatwg-fetch@3.0.0" = f "whatwg-fetch" "3.0.0" y "fc804e458cc460009b1a2b966bc8817d2578aefb" [];
        "whatwg-fetch@>=0.10.0" = s."whatwg-fetch@3.0.0";
        "whet.extend@0.9.9" = f "whet.extend" "0.9.9" y "f877d5bf648c97e5aa542fadc16d6a259b9c11a1" [];
        "whet.extend@~0.9.9" = s."whet.extend@0.9.9";
        "which-module@2.0.0" = f "which-module" "2.0.0" y "d9ef07dce77b9902b8a3a8fa4b31c3e3f7e6e87a" [];
        "which-module@^2.0.0" = s."which-module@2.0.0";
        "which@1.3.1" = f "which" "1.3.1" y "a45043d54f5805316da8d62f9f50918d3da70b0a" [
          (s."isexe@^2.0.0")
        ];
        "which@^1.2.9" = s."which@1.3.1";
        "wide-align@1.1.3" = f "wide-align" "1.1.3" y "ae074e6bdc0c14a431e804e624549c633b000457" [
          (s."string-width@^1.0.2 || 2")
        ];
        "wide-align@^1.1.0" = s."wide-align@1.1.3";
        "wordwrap@0.0.3" = f "wordwrap" "0.0.3" y "a3d5da6cd5c0bc0008d37234bbaf1bed63059107" [];
        "wordwrap@~0.0.2" = s."wordwrap@0.0.3";
        "worker-farm@1.6.0" = f "worker-farm" "1.6.0" y "aecc405976fab5a95526180846f0dba288f3a4a0" [
          (s."errno@~0.1.7")
        ];
        "worker-farm@^1.5.2" = s."worker-farm@1.6.0";
        "wrap-ansi@2.1.0" = f "wrap-ansi" "2.1.0" (ir "http://registry.npmjs.org/wrap-ansi/-/wrap-ansi-2.1.0.tgz") "d8fc3d284dd05794fe84973caecdd1cf824fdd85" [
          (s."string-width@^1.0.1")
          (s."strip-ansi@^3.0.1")
        ];
        "wrap-ansi@^2.0.0" = s."wrap-ansi@2.1.0";
        "wrappy@1" = s."wrappy@1.0.2";
        "wrappy@1.0.2" = f "wrappy" "1.0.2" y "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f" [];
        "xtend@4.0.1" = f "xtend" "4.0.1" y "a5c6d532be656e23db820efb943a1f04998d63af" [];
        "xtend@^4.0.0" = s."xtend@4.0.1";
        "xtend@~4.0.1" = s."xtend@4.0.1";
        "xterm@3.3.0" = f "xterm" "3.3.0" (ir "http://registry.npmjs.org/xterm/-/xterm-3.3.0.tgz") "b09a19fc2cd5decd21112e5c9dab0b61991f6cf3" [];
        "xterm@~3.3.0" = s."xterm@3.3.0";
        "y18n@3.2.1" = f "y18n" "3.2.1" y "6d15fba884c08679c0d77e88e7759e811e07fa41" [];
        "y18n@4.0.0" = f "y18n" "4.0.0" y "95ef94f85ecc81d007c264e190a120f0a3c8566b" [];
        "y18n@^3.2.1" = s."y18n@3.2.1";
        "y18n@^3.2.1 || ^4.0.0" = s."y18n@4.0.0";
        "y18n@^4.0.0" = s."y18n@4.0.0";
        "yallist@2.1.2" = f "yallist" "2.1.2" y "1c11f9218f076089a47dd512f93c6699a6a81d52" [];
        "yallist@3.0.3" = f "yallist" "3.0.3" y "b4b049e314be545e3ce802236d6cd22cd91c3de9" [];
        "yallist@^2.1.2" = s."yallist@2.1.2";
        "yallist@^3.0.0" = s."yallist@3.0.3";
        "yallist@^3.0.2" = s."yallist@3.0.3";
        "yargs-parser@11.1.1" = f "yargs-parser" "11.1.1" y "879a0865973bca9f6bab5cbdf3b1c67ec7d3bcf4" [
          (s."camelcase@^5.0.0")
          (s."decamelize@^1.2.0")
        ];
        "yargs-parser@9.0.2" = f "yargs-parser" "9.0.2" y "9ccf6a43460fe4ed40a9bb68f48d43b8a68cc077" [
          (s."camelcase@^4.1.0")
        ];
        "yargs-parser@^11.1.1" = s."yargs-parser@11.1.1";
        "yargs-parser@^9.0.2" = s."yargs-parser@9.0.2";
        "yargs@11.1.0" = f "yargs" "11.1.0" (ir "http://registry.npmjs.org/yargs/-/yargs-11.1.0.tgz") "90b869934ed6e871115ea2ff58b03f4724ed2d77" [
          (s."cliui@^4.0.0")
          (s."decamelize@^1.1.1")
          (s."find-up@^2.1.0")
          (s."get-caller-file@^1.0.1")
          (s."os-locale@^2.0.0")
          (s."require-directory@^2.1.1")
          (s."require-main-filename@^1.0.1")
          (s."set-blocking@^2.0.0")
          (s."string-width@^2.0.0")
          (s."which-module@^2.0.0")
          (s."y18n@^3.2.1")
          (s."yargs-parser@^9.0.2")
        ];
        "yargs@12.0.5" = f "yargs" "12.0.5" y "05f5997b609647b64f66b81e3b4b10a368e7ad13" [
          (s."cliui@^4.0.0")
          (s."decamelize@^1.2.0")
          (s."find-up@^3.0.0")
          (s."get-caller-file@^1.0.1")
          (s."os-locale@^3.0.0")
          (s."require-directory@^2.1.1")
          (s."require-main-filename@^1.0.1")
          (s."set-blocking@^2.0.0")
          (s."string-width@^2.0.0")
          (s."which-module@^2.0.0")
          (s."y18n@^3.2.1 || ^4.0.0")
          (s."yargs-parser@^11.1.1")
        ];
        "yargs@^11.0.0" = s."yargs@11.1.0";
        "yargs@^12.0.2" = s."yargs@12.0.5";
      }