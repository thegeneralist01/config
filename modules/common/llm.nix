{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) getExe;

  # OpenAI-compatible extras:
  # - Factory/local proxy on :8317
  # - LM Studio on :1234
  extraOpenAiModels = ''
    - model_id: sonnet
      model_name: claude-sonnet-5
      api_base: "http://127.0.0.1:8317/v1"

    - model_id: gpt
      model_name: gpt-5.6-terra
      api_base: "http://127.0.0.1:8317/v1"

    - model_id: gpt-mini
      model_name: gpt-5.4-mini
      api_base: "http://127.0.0.1:8317/v1"

    - model_id: gemini
      model_name: gemini-2.5-flash
      api_base: "http://127.0.0.1:8317/v1"

    - model_id: lmstudio-qwen
      model_name: qwen/qwen3.5-9b
      api_base: "http://127.0.0.1:1234/v1"
  '';

  # Datasette LLM user config dir (platform default).
  llmUserRelPath =
    if config.isDarwin then
      "Library/Application Support/io.datasette.llm"
    else
      ".config/io.datasette.llm";

  uvBin = getExe pkgs.uv;
in
{
  # uv itself lives in neovim.nix home.packages; keep this module focused on the tool.

  # Module must be a function so home-manager injects its `lib` (with `lib.hm.dag`).
  home-manager.sharedModules = [
    (
      { lib, ... }:
      {
        # uv tool install puts shims here
        home.sessionPath = [ "$HOME/.local/bin" ];

        home.file."${llmUserRelPath}/extra-openai-models.yaml" = {
          text = extraOpenAiModels;
          force = true;
        };

        # Same pattern as Volta activation: Nix declares intent, tool manager installs.
        home.activation.uvToolLlm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          export PATH="${pkgs.uv}/bin:$HOME/.local/bin:$PATH"

          if [ -n "''${DRY_RUN:-}" ]; then
            echo "${uvBin} tool install llm"
          else
            # Idempotent: installs or refreshes the uv-managed tool env + ~/.local/bin/llm
            ${uvBin} tool install llm
          fi
        '';
      }
    )
  ];
}
