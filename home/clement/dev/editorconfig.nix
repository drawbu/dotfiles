{...}: {
  editorconfig = rec {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_size = 4;
        indent_style = "space";
        insert_final_newline = true;
        max_line_length = 80;
        tab_width = 4;
        trim_trailing_whitespace = true;
      };
      "*.{nix,yml,yaml,asm,s,S,lua,js,ts,jsx,tsx}" = {
        indent_size = 2;
      };
      "Makefile" = {
        indent_style = "tab";
      };
      "*.{mk,go,templ,gd}" = {
        indent_style = "tab";
      };
    };
  };
}
