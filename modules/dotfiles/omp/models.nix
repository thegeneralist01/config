let
  modelRoles = {
    default = "openai-codex/gpt-6.1-sol:high";
    smol = "google-antigravity/gemini-3.8-flash:medium";
    slow = "anthropic/claude-opus-5-5:high";
    plan = "anthropic/claude-opus-5-5:high";
    task = "google-antigravity/gemini-3.8-flash:medium";
    commit = "google-antigravity/gemini-3.8-flash:minimal";
    advisor = "openai-codex/gpt-5.5:xhigh";
    tiny = "openai-codex/gpt-5.4-mini:medium";
    web = "web/exa";
    speech = "xai-oauth/grok-tts";
  };

  preset = overrides: {
    modelRoles = modelRoles // overrides;
    defaultThinkingLevel = "auto";
  };
in
{
  inherit modelRoles;

  task.agentModelOverrides = {
    l-worker = "openai-codex/gpt-6.1-sol";
    l-reviewer = "openai-codex/gpt-6.1-sol:high";
    l-planner = "@plan:high";
    reviewer = "openai-codex/gpt-6.1-sol:high";
  };

  # Presets share the task/plan roles so switching the main model cannot undo them.
  modelPresets = {
    gemmysolopus = preset { };
    haikugemmyopus = preset {
      smol = "anthropic/claude-haiku-4-5:medium";
      default = "google-antigravity/gemini-3.8-flash";
    };
    aura = preset {
      default = "anthropic/claude-opus-5-5:high";
    };
  };
}
