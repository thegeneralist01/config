{ ... }:
let
  hyperModifiers = [
    "left_command"
    "left_control"
    "left_option"
    "left_shift"
  ];

  openGhostty = "open -na Ghostty.app";
  openCmux = "open -na cmux.app";
  openHelium = "open -na Helium.app";
  openHeliumNotifications = "open -na Helium.app --args https://x.com/i/notifications";
  openHeliumT3Chat = "open -na Helium.app --args https://t3.chat/";
  openHeliumExaSearch = "open -na Helium.app --args https://exa.ai/search";
  openChatGPT = "open -na Helium.app --args https://chatgpt.com/";
  openClaude = "open -na Helium.app --args https://claude.ai/new";

  numbers = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "0"
  ];

  number_to_symbol = num: {
    type = "basic";
    from = {
      key_code = num;
      modifiers = {
        optional = [ "caps_lock" ];
      };
    };
    to = [
      {
        key_code = num;
        modifiers = [ "left_shift" ];
      }
    ];
  };

  symbol_to_number = num: {
    type = "basic";
    from = {
      key_code = num;
      modifiers = {
        mandatory = [ "left_shift" ];
        optional = [ "caps_lock" ];
      };
    };
    to = [
      {
        key_code = num;
      }
    ];
  };

  manipulators = builtins.concatLists (
    map (n: [
      (number_to_symbol n)
      (symbol_to_number n)
    ]) numbers
  );

  simple_modifications = [
    {
      from.apple_vendor_top_case_key_code = "keyboard_fn";
      to = [ { key_code = "left_control"; } ];
    }
    {
      from.key_code = "left_control";
      to = [ { apple_vendor_top_case_key_code = "keyboard_fn"; } ];
    }
  ];

  complex_modifications = {
    name = "Complex Modifications";
    rules = [
      # {
      #   description = "Change numbers to symbols and vice versa";
      #   manipulators = manipulators;
      # }
      {
        description = "Caps Lock to Escape";
        manipulators = [
          {
            from = {
              key_code = "caps_lock";
              modifiers = { optional = [ "any" ]; };
            };
            to = [
              {
                key_code = "escape";
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Escape to Hyperkey";
        manipulators = [
          {
            from = {
              key_code = "escape";
              modifiers = { optional = [ "any" ]; };
            };
            to = [
              {
                key_code = "left_shift";
                modifiers = [
                  "left_option"
                  "left_command"
                  "left_control"
                ];
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+Return opens cmux";
        manipulators = [
          {
            from = {
              key_code = "return_or_enter";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openCmux;
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+B opens Helium";
        manipulators = [
          {
            from = {
              key_code = "b";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openHelium;
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+N opens X Notifications";
        manipulators = [
          {
            from = {
              key_code = "n";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openHeliumNotifications;
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+T opens T3 Chat";
        manipulators = [
          {
            from = {
              key_code = "t";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openHeliumT3Chat;
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+E opens Exa Search";
        manipulators = [
          {
            from = {
              key_code = "e";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openHeliumExaSearch;
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Toggle Focus Mode with F6";
        manipulators = [
          {
            from = {
              "key_code" = "f6";
            };
            to = [ { "shell_command" = "shortcuts run 'Reduced Interruptions'"; } ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+Q runs Add Quote shortcut";
        manipulators = [
          {
            from = {
              key_code = "q";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = "shortcuts run 'Add Quote'";
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+G runs Shades of Gray shortcut";
        manipulators = [
          {
            from = {
              key_code = "g";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = "shortcuts run 'Shades of Gray'";
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+C opens ChatGPT";
        manipulators = [
          {
            from = {
              key_code = "c";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openChatGPT;
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+L opens Claude";
        manipulators = [
          {
            from = {
              key_code = "l";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openClaude;
              }
            ];
            type = "basic";
          }
        ];
      }
    ];
  };

  config = builtins.toJSON {
    global.show_in_menu_bar = false;

    profiles = [
      {
        name = "default";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        inherit simple_modifications;
        inherit complex_modifications;

        devices = [
          {
            identifiers.is_keyboard = true;
          }
        ];
      }
    ];
  };
in
{
  home-manager.sharedModules = [
    {
      home.file.".config/karabiner/karabiner.json" = {
        force = true;
        text = config;
      };
    }
  ];
}
