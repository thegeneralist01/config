let
  numbers = [
    "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
  ];

  number_to_symbol = num: {
    type = "basic";
    from = {
      key_code = num;
      modifiers = { optional = [ "caps_lock" ]; };
    };
    to = [{
      key_code = num;
      modifiers = ["left_shift"];
    }];
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
    to = [{
      key_code = num;
    }];
  };

  manipulators = builtins.concatLists (map (n: [
    (number_to_symbol n)
    (symbol_to_number n)
  ]) numbers);

  simple_modifications = [
    {
      from.apple_vendor_top_case_key_code = "keyboard_fn";
      to = [{ key_code = "left_control"; }];
    }
    {
      from.key_code = "left_control";
      to = [{ apple_vendor_top_case_key_code = "keyboard_fn"; }];
    }
  ];

  complex_modifications = {
    name = "Complex Modifications";
    rules = [{
      description = "Change numbers to symbols and vice versa";
      manipulators = manipulators;
    }];
  };

  config = builtins.toJSON {
    global.show_in_menu_bar = false;

    profiles = [{
      name     = "default";
      selected = true;
      virtual_hid_keyboard.keyboard_type_v2 = "ansi";
      inherit simple_modifications;
      inherit complex_modifications;

      devices = [{
        identifiers.is_keyboard = true;
      }];
    }];
  };
in {
  home-manager.sharedModules = [{
    home.file.".config/karabiner/karabiner.json" = {
      force = true;
      text = config;
    };
  }];
}
