{ ... }: {
  environment.shellAliases = {
    todo = /* sh */ ''rg "todo|fixme" --colors match:fg:yellow --colors match:style:bold'';
    todos = /* sh */ "nvim ~/todo.md";
  };

  home-manager.sharedModules = [{
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--line-number"
        "--smart-case"
      ];
    };
  }];
}
