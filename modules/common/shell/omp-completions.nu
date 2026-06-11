# omp nushell completions

def omp-subcommands [] {
  [
    [value description];
    ["acp"          "Run Oh My Pi as an ACP server over stdio"]
    ["agents"       "Manage bundled task agents"]
    ["auth-broker"  "Manage the omp auth-broker (credential vault)"]
    ["auth-gateway" "Run an auth-gateway forward proxy backed by the configured broker"]
    ["commit"       "Generate a commit message and update changelogs"]
    ["completions"  "Print a shell completion script (bash, zsh, or fish)"]
    ["config"       "Manage configuration settings"]
    ["grievances"   "View, clean, or push reported tool issues"]
    ["install"      "Install or link an extension package"]
    ["plugin"       "Manage plugins (install, uninstall, list, etc.)"]
    ["read"         "Show what the read tool will return for a path or URL"]
    ["search"       "Test web search providers"]
    ["setup"        "Run onboarding setup or install dependencies"]
    ["shell"        "Interactive shell console"]
    ["ssh"          "Manage SSH host configurations"]
    ["stats"        "View usage statistics"]
    ["tiny-models"  "Download tiny local models"]
    ["update"       "Check for and install updates"]
    ["usage"        "Show provider usage limits for every authenticated account"]
    ["worktree"     "List or clear agent-managed git worktrees"]
  ]
}

export extern "omp" [
  ...messages: string                         # Messages to send (prefix files with @)
  --model: string                             # Model to use
  --smol: string                              # Smol/fast model
  --slow: string                              # Slow/reasoning model
  --plan: string                              # Plan model
  --provider: string                          # Provider to use
  --api-key: string                           # API key
  --system-prompt: string                     # System prompt
  --append-system-prompt: string              # Append to system prompt
  --allow-home                                # Allow starting in ~ without auto-switching
  --cwd: string                               # Directory to start in
  --mode: string@omp-complete-mode            # Output mode
  --config: string                            # Load an extra config overlay
  --print(-p)                                 # Non-interactive: process and exit
  --continue(-c)                              # Continue previous session
  --resume(-r): string                        # Resume a session
  --session-dir: string                       # Directory for session storage
  --no-session                                # Don't save session
  --models: string                            # Comma-separated models for cycling
  --no-tools                                  # Disable all built-in tools
  --no-lsp                                    # Disable LSP tools
  --no-pty                                    # Disable PTY-based bash execution
  --tools: string                             # Tools to enable
  --thinking: string@omp-complete-thinking    # Thinking level
  --hide-thinking                             # Hide thinking blocks
  --hook: string                              # Load a hook/extension file
  --extension(-e): string                     # Load an extension file
  --no-extensions                             # Disable extension discovery
  --no-skills                                 # Disable skills discovery
  --skills: string                            # Glob patterns to filter skills
  --no-rules                                  # Disable rules discovery
  --export: string                            # Export session to HTML and exit
  --list-models: string                       # List available models
  --no-title                                  # Disable title auto-generation
  --auto-approve                              # Auto-approve all tool calls
  --approval-mode: string@omp-complete-approval-mode # Override approval mode
]

def omp-complete-mode [] { ["text" "json" "rpc" "rpc-ui"] }
def omp-complete-thinking [] { ["minimal" "low" "medium" "high" "xhigh"] }
def omp-complete-approval-mode [] { ["always-ask" "write" "yolo"] }

# --- subcommands ---

export extern "omp agents" [
  action?: string@omp-complete-agents-action
  --force(-f)
  --json
  --dir: string
  --user
  --project
]
def omp-complete-agents-action [] { ["unpack"] }

export extern "omp auth-broker" [
  action?: string@omp-complete-auth-broker-action
  source?: string
  --json
  --bind(-b): string
  --regenerate
  --via: string
  --provider: string
  --include-disabled
  --from-local
  --include-env
  --include-oauth
  --dry-run
]
def omp-complete-auth-broker-action [] { ["serve" "token" "login" "logout" "import" "migrate" "status" "list"] }

export extern "omp auth-gateway" [
  action?: string@omp-complete-auth-gateway-action
  --json
  --bind(-b): string
  --regenerate
  --no-auth
  --strict
]
def omp-complete-auth-gateway-action [] { ["serve" "token" "status" "check"] }

export extern "omp commit" [
  --push
  --dry-run
  --no-changelog
  --legacy
  --context(-c): string
  --model(-m): string
]

export extern "omp completions" [
  shell?: string@omp-complete-shells
]
def omp-complete-shells [] { ["bash" "zsh" "fish"] }

export extern "omp config" [
  action?: string@omp-complete-config-action
  key?: string
  value?: string
  --json
]
def omp-complete-config-action [] { ["list" "get" "set" "reset" "path" "init-xdg"] }

export extern "omp grievances" [
  action?: string@omp-complete-grievances-action
  --limit(-n): int
  --tool(-t): string
  --json(-j)
  --id: int
  --all
]
def omp-complete-grievances-action [] { ["list" "clean" "push"] }

export extern "omp install" [
  ...targets: string
  --json
  --force
  --dry-run
  --scope: string@omp-complete-scope
]

export extern "omp plugin" [
  action?: string@omp-complete-plugin-action
  ...targets: string
  --json
  --fix
  --force
  --dry-run
  --local(-l)
  --enable: string
  --disable: string
  --set: string
  --scope: string@omp-complete-scope
]
def omp-complete-plugin-action [] { ["install" "uninstall" "list" "link" "doctor" "features" "config" "enable" "disable" "marketplace" "discover" "upgrade"] }
def omp-complete-scope [] { ["user" "project"] }

export extern "omp read" [
  path?: string
]

export extern "omp search" [
  query?: string
  --provider: string
  --recency: string
  --limit(-l): int
  --compact
]

export extern "omp setup" [
  component?: string@omp-complete-setup-component
  --check(-c)
  --json
]
def omp-complete-setup-component [] { ["python" "stt"] }

export extern "omp shell" [
  --cwd(-C): string
  --timeout(-t): int
  --no-snapshot
]

export extern "omp ssh" [
  action?: string@omp-complete-ssh-action
  ...targets: string
  --json
  --host: string
  --user: string
  --port: string
  --key: string
  --desc: string
  --compat
  --scope: string@omp-complete-scope
]
def omp-complete-ssh-action [] { ["add" "remove" "list"] }

export extern "omp stats" [
  --port(-p): int
  --json(-j)
  --summary(-s)
]

export extern "omp tiny-models" [
  action?: string@omp-complete-tiny-models-action
  model?: string
  --json
]
def omp-complete-tiny-models-action [] { ["download" "list"] }

export extern "omp update" [
  --force(-f)
  --check(-c)
]

export extern "omp usage" [
  --json(-j)
  --provider(-p): string
  --redact(-r)
]

export extern "omp worktree" [
  action?: string@omp-complete-worktree-action
  --all
  --dry-run(-n)
  --json(-j)
]
def omp-complete-worktree-action [] { ["list" "clear"] }
