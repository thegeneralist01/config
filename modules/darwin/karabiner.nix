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
  openChatGPTIncognito = "open -na Helium.app --args https://chatgpt.com/?temporary-chat=true";
  openClaude = "open -na Helium.app --args https://claude.ai/new";
  openClaudeIncognito = "open -na Helium.app --args https://claude.ai/new?incognito=";
  openHeliumTelegram = "open -na Helium.app --args https://web.telegram.org/k/";

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

  # Swap Fn/Globe and left Control only on the built-in keyboard.
  builtinKeyboardSimpleModifications = [
    {
      from.apple_vendor_top_case_key_code = "keyboard_fn";
      to = [ { key_code = "left_control"; } ];
    }
    {
      from.key_code = "left_control";
      to = [ { apple_vendor_top_case_key_code = "keyboard_fn"; } ];
    }
  ];

  logitechG213Identifiers = {
    vendor_id = 1133;
    product_id = 49974;
    is_keyboard = true;
  };

  # Swap the G213's Windows/Alt modifiers and map Application to Fn.
  logitechG213SimpleModifications = [
    {
      from.key_code = "left_command";
      to = [ { key_code = "left_option"; } ];
    }
    {
      from.key_code = "left_option";
      to = [ { key_code = "left_command"; } ];
    }
    {
      from.key_code = "right_command";
      to = [ { key_code = "right_option"; } ];
    }
    {
      from.key_code = "right_option";
      to = [ { key_code = "right_command"; } ];
    }
    {
      from.key_code = "application";
      to = [ { apple_vendor_top_case_key_code = "keyboard_fn"; } ];
    }
  ];

  logitechMouseIdentifiers = {
    vendor_id = 1133;
    product_id = 50503;
    is_pointing_device = true;
  };

  # Side buttons navigate back and forward.
  logitechMouseSimpleModifications = [
    {
      from.pointing_button = "button4";
      to = [
        {
          key_code = "open_bracket";
          modifiers = [ "left_command" ];
        }
      ];
    }
    {
      from.pointing_button = "button5";
      to = [
        {
          key_code = "close_bracket";
          modifiers = [ "left_command" ];
        }
      ];
    }
  ];

  complex_modifications = {
    name = "Complex Modifications";
    rules = [
      {
        description = "Logitech mouse Button3 sends Fn, or middle click with Hyper, Shift, Button1, or Button2";
        manipulators = [
          # Keep the forwarded button as the only `to` event so Karabiner
          # preserves its down state. A variable in the same `to` sequence
          # either releases the button immediately or resets too early, so
          # detect Button3 through `to_if_other_key_pressed` instead.
          {
            from.pointing_button = "button1";
            to = [ { from_event = true; } ];
            to_if_other_key_pressed = [
              {
                other_keys = [
                  {
                    pointing_button = "button3";
                    modifiers.optional = [ "any" ];
                  }
                ];
                to = [
                  {
                    set_variable = {
                      name = "logitech_mouse_button1_held";
                      value = 1;
                    };
                  }
                ];
              }
            ];
            to_after_key_up = [
              {
                set_variable = {
                  name = "logitech_mouse_button1_held";
                  value = 0;
                };
              }
            ];
            conditions = [
              {
                type = "device_if";
                identifiers = [ logitechMouseIdentifiers ];
              }
            ];
            type = "basic";
          }
          {
            from.pointing_button = "button2";
            to = [ { from_event = true; } ];
            to_if_other_key_pressed = [
              {
                other_keys = [
                  {
                    pointing_button = "button3";
                    modifiers.optional = [ "any" ];
                  }
                ];
                to = [
                  {
                    set_variable = {
                      name = "logitech_mouse_button2_held";
                      value = 1;
                    };
                  }
                ];
              }
            ];
            to_after_key_up = [
              {
                set_variable = {
                  name = "logitech_mouse_button2_held";
                  value = 0;
                };
              }
            ];
            conditions = [
              {
                type = "device_if";
                identifiers = [ logitechMouseIdentifiers ];
              }
            ];
            type = "basic";
          }
          {
            from = {
              pointing_button = "button3";
              modifiers.optional = [ "any" ];
            };
            to = [ { pointing_button = "button3"; } ];
            conditions = [
              {
                type = "device_if";
                identifiers = [ logitechMouseIdentifiers ];
              }
              {
                type = "variable_if";
                name = "logitech_mouse_button1_held";
                value = 1;
              }
            ];
            type = "basic";
          }
          {
            from = {
              pointing_button = "button3";
              modifiers.mandatory = hyperModifiers;
            };
            to = [ { pointing_button = "button3"; } ];
            conditions = [
              {
                type = "device_if";
                identifiers = [ logitechMouseIdentifiers ];
              }
            ];
            type = "basic";
          }
          {
            from = {
              pointing_button = "button3";
              modifiers = {
                mandatory = [ "shift" ];
                optional = [ "any" ];
              };
            };
            to = [ { pointing_button = "button3"; } ];
            conditions = [
              {
                type = "device_if";
                identifiers = [ logitechMouseIdentifiers ];
              }
            ];
            type = "basic";
          }
          {
            from = {
              pointing_button = "button3";
              modifiers.optional = [ "any" ];
            };
            to = [ { pointing_button = "button3"; } ];
            conditions = [
              {
                type = "device_if";
                identifiers = [ logitechMouseIdentifiers ];
              }
              {
                type = "variable_if";
                name = "logitech_mouse_button2_held";
                value = 1;
              }
            ];
            type = "basic";
          }
          {
            from = {
              pointing_button = "button3";
              modifiers.optional = [ "any" ];
            };
            to = [ { apple_vendor_top_case_key_code = "keyboard_fn"; } ];
            conditions = [
              {
                type = "device_if";
                identifiers = [ logitechMouseIdentifiers ];
              }
            ];
            type = "basic";
          }
        ];
      }
      # {
      #   description = "Change numbers to symbols and vice versa";
      #   manipulators = manipulators;
      # }
      {
        description = "Caps Lock to Hyperkey";
        manipulators = [
          {
            from = {
              key_code = "caps_lock";
              modifiers = {
                optional = [ "any" ];
              };
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
        description = "Hyper+W opens Telegram";
        manipulators = [
          {
            from = {
              key_code = "w";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openHeliumTelegram;
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
        description = "Hyper+V opens ChatGPT (incognito)";
        manipulators = [
          {
            from = {
              key_code = "v";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openChatGPTIncognito;
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
      {
        description = "Hyper+; opens Claude (incognito)";
        manipulators = [
          {
            from = {
              key_code = "semicolon";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = openClaudeIncognito;
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+0 copies a rephrase prompt into the clipboard";
        manipulators = [
          {
            from = {
              key_code = "0";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = "printf '%s' 'rephrase the tweet on the screen in a more humanly-understandable way' | pbcopy";
              }
            ];
            type = "basic";
          }
        ];
      }
      {
        description = "Hyper+9 copies an orchestrate prompt into the clipboard";
        manipulators = [
          {
            from = {
              key_code = "9";
              modifiers = {
                mandatory = hyperModifiers;
              };
            };
            to = [
              {
                shell_command = "printf '%s' $'/goal set\\n\\nI had this on my today\\'s agenda regarding archivr feat impl\\'s or bug fixes:\\n...\\n\\nThis is going to be a PR. I like atomic commits. (I reckon you won\\'t be needing many commits for this, since it\\'s a small task, I assume.)\\n\\nIf you have any questions before you start (i.e. to decide on something), then shoot!\\n\\nOtherwise, you\\'re allowed to Orchestrate and delegate if/when necessary.\\nUse agents and/or skills for suited tasks (design/planning/tests/etc.), if needed.' | pbcopy";
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
        inherit complex_modifications;

        devices = [
          {
            identifiers = {
              is_keyboard = true;
              is_built_in_keyboard = true;
            };
            simple_modifications = builtinKeyboardSimpleModifications;
          }
          {
            identifiers = logitechG213Identifiers;
            simple_modifications = logitechG213SimpleModifications;
          }
          {
            identifiers = logitechMouseIdentifiers;
            ignore = false;
            simple_modifications = logitechMouseSimpleModifications;
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
